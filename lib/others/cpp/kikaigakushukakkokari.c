#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "MT.h"

 double *Q;
 double **W;
 double *s;
 int **data;
 
 int i,j,k,l;
 int N=37,a;					//NはAgentに許される行動数（アトラクション数に一致）、a=0, ..., N-1
 int kaisu=100;					//kaisuは一日のデータからの学習回数
 int wat=0;
 int to,tc,te,t;
 int dayid,dayidl;
 int d,d2;
 int nar=0;
 double r;
 double Qmax;
 double *wait_ave;
 int rc=0;
 double rsum=0;
 double neut=200.0;
 char st[256];
 char s1[]=",";
 char s2[30];
 char s3[30];
 char *abs_path;
 char *abs_path2;

void check(void *y)
{
 if (y==NULL) {
  printf("Not enough memory.\n");
  exit(1);
 }
 return;
}

void Qnow()					//Q[d]の更新
{
 Q[d]=0.0;//+b[d]は未実装
 for (j=0;j<2*N;j++){
  Q[d]+=W[d][j]*s[j]/neut;
 }
 return;
}

void Qmaxnew()					//Qmaxを計算（状態ベクトルsは固定）
{
 Qmax=-9999999999;
 d2=0;
 for (a=0;a<N;a++){
  double Qtemp=0.0;
  if (((t+te)/60)-(t/60)!=0||d==-1) {
   for (j=0;j<2*N;j++){
    if (j!=d&&j<N) {
     Qtemp+=W[a][j]*data[j][((t+te)/60)-7]/neut;
    } else {
     if (j==d) {
      Qtemp+=W[a][j]*(s[j]-te)/neut;
     } else {					//ここにあとで書くかも
      Qtemp+=W[a][j]*s[j]/neut;
     }
    }
   }
  } else {
  
   if (a!=d) {
    for (j=0;j<2*N;j++){
     if (j==d){
      Qtemp+=W[a][j]*data[j][((t+te)/60)-7]/neut;
     } else {
      Qtemp+=W[a][j]*s[j]/neut;
     }
    }
   } else {
    for (j=0;j<2*N;j++){
     if (j!=a){
      Qtemp+=W[a][j]*(s[j]-te)/neut;
     } else {
      Qtemp+=W[a][j]*s[j]/neut;
     }
    }
   }
  
  }
  if (Qtemp>Qmax){
   Qmax=0.0+Qtemp;
   d2=0+a;					//Qを最大にするa
  }
 }
 //printf("%d %d\n",t ,d2);
 return;
}

void reward()
{
 if (wat==-1) {
  wat=0;
  r=-0.5;
 }
 else if (s[d]<0&&s[N+d]==0) {
  t+=te;
  s[N+d]=0.5;
  r=wait_ave[d]+te;
  wat=-te;
 }
 else if (s[d]<0&&s[N+d]>0) {
  t+=te;
  s[N+d]+=0.5;
  r=-0.5;
  wat=-te;
 } else {
  r=0.0;
 }
 //if (dayid<1470) return;
 rc+=1;
 rsum+=r;
 if (dayid==1&&rc>10000) {
  rsum/=rc;
  rc=0;
  //printf("%f\n",rsum);
  rsum=0;
 }
 return;
}

void wread()
{
 FILE *fp;
 if ((fp = fopen("w.txt", "r")) == NULL) {	//w.txtは学習用のプログラムにより作成
  printf("file open error!!\n");
  exit(EXIT_FAILURE);
 }
 l=0;						//行が何番目か
 while (fgets(st, 256, fp) != NULL) {
  i=0;						//st[i]を読む
  j=0;						//前に読んだi+1
  k=0;						//行の中で何番目の数値か
  while(1){
   if (st[i]==0||st[i]==' ') {
    strncpy(s2,st+j,i-j);
    char *s2s;
    char *s3s;
    s2s=s2;
    W[l][k]=0.0+strtod(s2s,&s3s);
    //printf("%f ",W[l][k]);
    j=1+i;
    k++;
   }
   i++;
   if (st[i]==0) break;
  }
  //printf(":%d\n",l);
  l++;
  if (l>N-1) break;
 }
 fclose(fp);
 return;
}

void readdata()
{
 data=(int **)malloc((N+1)*sizeof(int *));		//アトラクション番号
 check(data);
 for (i=0;i<(N+1);i++){
  data[i]=(int *)malloc(16*sizeof(int));		//時刻
  check(data[i]);
  for (j=1;j<16;j++){
   data[i][j]=200;
  }
 }
 
 FILE *fp;
 char str[] = "input/pred_wait_time.csv";
 strcat(abs_path2,str);
 if ((fp = fopen(abs_path2, "r")) == NULL) {
  printf("file open error!!\n");
  exit(EXIT_FAILURE);
 }
 l=-1;						//行が何番目か
 int tt=0;
 while (fgets(st, 256, fp) != NULL) {
  i=0;						//st[i]を読む
  j=0;						//前に読んだi+1
  k=0;					//行の中で何番目の数値か
  int id=-1;
  while(1){
   if (st[i]==0||st[i]==',') {
    strncpy(s2,st+j,i-j);
    s2[i-j]='\0';
    if (l==-1) {
     if (k==1) {
      tt=atoi(s2)-8;
      break;
     }
     j=1+i;
     k++;
     i++;
     continue;
    }
    if (k==0){
     id=atoi(s2);
    } else {
     if (j!=i) {
      data[id][k+tt]=0+atoi(s2);
     }
     //printf("%d(%d,%d,%d) ",data[id][k+tt],id,k,tt);
    }
    j=1+i;
    k++;
   }
   if (st[i]==0) break;
   i++;
  }
  //printf(":%d\n",l);
  if (l>N-1) break;
  l++;
 }
 fclose(fp);
 
 //printf("\nデータ読み込み完了（このメッセージはあとで消す）\n");
 return;
}

void writeroute()
{//routeを出力する
 FILE *outputfile;
 char str[] = "output/route_output.json";
 strcat(abs_path,str);
 outputfile=fopen(abs_path,"w");
 if (outputfile==NULL){
  printf("cannot open");
  exit(1);
 }
 fprintf(outputfile, "{\"candidates\":[");
 for(i = 0; i < 3; i++){	//候補の数=3
  fprintf(outputfile, "{\"attraction\":[");
   for(j = 0; j < 10; j++){	//アトラクションの数=10
    fprintf(outputfile, "{\"ID\":0,\"arrive\":\"08:20\",\"duration\":0,\"end\":\"08:20\",\"flag\":1,\"move\":5,\"ride\":\"10:10\",\"wait\":65}");
    if(j != 9){
    	fprintf(outputfile, ",");
    }
   }
  fprintf(outputfile, "],");
  fprintf(outputfile, "\"discription\":0,");
  fprintf(outputfile, "\"start\":{ \"place\":12, \"time\": \"08:20\"}}");
  if(i != 2){
   fprintf(outputfile, ",");
  }
 }
 fprintf(outputfile,"]}");
 fclose(outputfile);
 return;
}

void datafree()
{
 for (i=0; i<1800; i++) {
  for (j=0; j<N+1; j++) {
   free(data[i][j]);
  }
  free(data[i]);
 }
 free(data);
 free(Q);
 for (i=0; i<N+1; i++) {
  free(W[i]);
 }
 free(W);
 free(s);
 free(wait_ave);
 return;
}

int main(int argc,char **argv)
{
 for(i = 1;i < argc; i++){
  abs_path = argv[i];
  abs_path2 = argv[i];
 }
 
 init_genrand(10);
 //各変数malloc
 Q=(double *)malloc((N+1)*sizeof(double));
 check(Q);
 W=(double **)malloc((N+1)*sizeof(double *));
 check(W);
 for (a=0;a<(N+1);a++){
  W[a]=(double *)malloc((2*N+1)*sizeof(double));
  check(W[a]);
  for (j=0;j<(2*N+1);j++){
   W[a][j]=0.0;
  }
 }
 s=(double *)malloc((2*N+1)*sizeof(double));
 check(s);
 for (j=0;j<(2*N+1);j++){
  s[j]=0.0;
 }
 wait_ave=(double *)malloc((N+1)*sizeof(double));
 check(wait_ave);
 for (i=0; i<N+1; i++) {
  wait_ave[i]=0.0;
 }
 //mallocここまで
 
 double alpha=0.001;
 double gamma=0.8;
 
 readdata();					//ここで予想待ち時間を得る
 wread();
 
 to=540;					//開園時刻(hour*60+min)
 tc=1320;					//閉園時刻(hour*60+min)1320
 te=10;						//単位時間(min)
 t=0+to;

 d=-1;
 for (a=0;a<N;a++){
  s[a]=data[a][(t/60)-7];			//dataは3つ目のパラメータが1で8時台として、+7時台に対応
 }
 
 while(t<tc){
  
  Qmaxnew();					//d2が選択されて返ってくる
  d=0+d2;
  //printf("%d",d);
  if (nar!=d) {				//アトラクションの変更があった場合、状態ベクトルのN+1成分目を変更
   wat=-1;
   s[nar]=data[nar][(t/60)-7];
   nar=0+d;					//アトラクションの変更があった場合の元のアトラクション
  } else {
   s[d]-=te;
  }
  if ((t/60)-((t-te)/60)!=0) {			//状態ベクトルを更新（hourが変わった時だけ）
   for (a=0;a<N;a++){
    if (a!=d) s[a]=data[a][(t/60)-7];			//dataは3つ目のパラメータが1で8時台として、+7時台に対応
   }
  }
  
  t+=te;
  wat+=te;
 }
 
 writeroute();
 datafree();
 
 return 0;
}




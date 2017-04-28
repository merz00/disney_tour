# coding: utf-8

import pandas as pd
import sys
from numpy.random import rand

def main(date, hour, weather):
    """
    引数は増やすかも

    date : str  8桁の整数文字列 (20170401的な)
    hour : int  8 ~ 22の整数 (現在時刻のhour + 1 現在時刻が13:35だとしたら14)
    weather : int 0=晴れ 1=曇り 2=雨みたいな(適当)

    """
    df = pd.read_csv('アトラクションID_ランド_v2.csv')
    hour = int(hour)
    while hour <= 22:
        df[str(hour)+':00'] = map(int, rand(len(df)) * 60)
        hour += 1
    del df['site_id']
    del df['name']
    df.to_csv('pred_wait_time.csv', index=False)


if __name__ == '__main__':
    _, date, hour, weather = sys.argv

    main(date, hour, weather)

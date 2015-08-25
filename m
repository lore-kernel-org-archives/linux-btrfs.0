Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from portkey.s.itsis.si ([78.47.12.76]:56746 "EHLO
	portkey.s.itsis.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbHYRwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:52:46 -0400
Received: by iodt126 with SMTP id t126so196661261iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:52:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEp_DRBA=591kp3Tpgu0fWCkAJ8+xi7TPBM1nx=UFCgOQ9oLPw@mail.gmail.com>
References: <CAEp_DRAR5yjYNm-26jfVmajGqoSt3C9P1L5kS+C9s6g=zZhynQ@mail.gmail.com>
	<pan$3cda0$8efee9f8$3720f4b$2571ee17@cox.net>
	<CAEp_DRBA=591kp3Tpgu0fWCkAJ8+xi7TPBM1nx=UFCgOQ9oLPw@mail.gmail.com>
Date: Tue, 25 Aug 2015 19:52:38 +0200
Message-ID: <CAEp_DRCwVhWGr8L3=jJ5MH1PTU_VBoN-ieSU1CzRG+-Wbw=g-g@mail.gmail.com>
Subject: Re: Chunk fullness distribution
From: Bostjan Skufca <bostjan@a2o.si>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could please someone comment on this, especially whether I am on
somewhat correct course, or did I completely miss the interpretation
of btrfs-debug-tree output values? :)

Thank you very much in advance,
b.

On 21 August 2015 at 23:18, Bostjan Skufca <bostjan@a2o.si> wrote:
> Hi Duncan,
>
> tnx for info. You are quite right about my intentions: do automatic
> balance if IO load would be short, notify admin otherwise).
>
> I see the values, but they are quite cryptic without looking at source
> code. It seems that free space goes up to 16383, am I right?
>
> I presumed so, and went to chart that. It can be seen that there was a
> recent balance effort up to 50% :)
> I suppose this distribution is normal for heavy subvolume/snapshot usage.
>
> ---------------------------------------
> cat btrfs-data | grep -Eo 'free space [^ ]+' | cut -d' ' -f3 | sort -n
> | awk '{ norm = int((16383 - $1) / 164) ; print norm}' |
> /usr/local/python/bin/histogram.py -p
>
> # NumSamples = 6806; Min = 1.00; Max = 99.00
> # Mean = 72.911108; Variance = 511.231740; SD = 22.610434; Median 75.000000
> # each = represents a count of 31
>     1.0000 -    10.8000 [    17]:  (0.25%)
>    10.8000 -    20.6000 [    95]: === (1.40%)
>    20.6000 -    30.4000 [   126]: ==== (1.85%)
>    30.4000 -    40.2000 [   247]: ======= (3.63%)
>    40.2000 -    50.0000 [   889]: ============================ (13.06%)
>    50.0000 -    59.8000 [   942]: ============================== (13.84%)
>    59.8000 -    69.6000 [   713]: ======================= (10.48%)
>    69.6000 -    79.4000 [   702]: ====================== (10.31%)
>    79.4000 -    89.2000 [   722]: ======================= (10.61%)
>    89.2000 -    99.0000 [  2353]:
> ===========================================================================
> (34.57%)
>
>
> This somewhat adds up to what user tools provide (well, not df, for
> obvious reasons).
>
>
> # btrfs fi show /var/backup
> Label: none  uuid: 32711353-d3c4-4df6-a3e9-aa18849cad58
> Total devices 1 FS bytes used 1.23TiB
> devid    1 size 1.46TiB used 1.29TiB path /dev/mapper/vg_gringott-lv_backup
>
> # df -h /var/backup
> Filesystem                         Size  Used Avail Use% Mounted on
> /dev/mapper/vg_gringott-lv_backup  1.5T  1.3T  189G  88% /var/backup
>
>
>
> b.
>
>
>
> Sample btrfs-debug-tree output:
> --------------------------------
> leaf 2840333205504 items 78 free space 4037 generation 520881 owner 2
> fs uuid 32711353-d3c4-4df6-a3e9-aa18849cad58
> chunk uuid 76dc1f0e-4a69-45b0-9c82-c2c0eab69991
>         item 0 key (29949952 EXTENT_ITEM 16384) itemoff 16151 itemsize 132
>                 ...
>         item 1 key ...
>         item 2 key ...
> ...(up to 77)
> --------------------------------
>
> On 21 August 2015 at 20:18, Duncan <1i5t5.duncan@cox.net> wrote:
>> Bostjan Skufca posted on Fri, 21 Aug 2015 17:49:01 +0200 as excerpted:
>>
>>> is there a way to get information about how much space is occupied in
>>> each chunk?
>>>
>>> In the end, a simple ascii chart of usage distribution should be
>>> preferable, but I can work towards that if there is a way to get
>>> information about individual chunks.
>>>
>>> I know that "btrfs fi show" displays aggregate info, but having
>>> distribution chart enables one to predict how much time "btrfs
>>> rebalance" operation will take for various X values in "dusage=X"
>>> filter.
>>
>> AFAIK, no admin-level-user tool to get that information, no.  But doing a
>> successive balances while incrementing the -dusage= -musage= counts
>> should get you a rough idea (tho it looks like that's what you're trying
>> to avoid by asking for the report in the first place), and I believe it's
>> findable with the lower-level developer tools, I'd guess btrfs-debug-tree.
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

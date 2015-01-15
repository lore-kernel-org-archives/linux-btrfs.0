Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:45207 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbbAONcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 08:32:35 -0500
Received: by mail-yk0-f179.google.com with SMTP id 19so6832653ykq.10
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 05:32:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B9FB0052-C5D5-4463-B2EB-78056506E351@gmail.com>
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
	<B9FB0052-C5D5-4463-B2EB-78056506E351@gmail.com>
Date: Thu, 15 Jan 2015 14:32:33 +0100
Message-ID: <CABdHLQ75YskzRje8T75=MKmwDKeaar2JfyTwq0LnUBEOL4KfyQ@mail.gmail.com>
Subject: Re: btrfs performance - ssd array
From: "P. Remek" <p.remek1@googlemail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>
> Could you check how many extents with BTRFS and Ext4:
> # filefrag test1

So my findings are odd:

On BTRFS when I run fio with a single worker thread (target file is
12GB large,and its 100% random write of 4kb blocks), then number of
extents reported by filefrag is around 3.
However when I do the same with 4 worker threads, I get some crazy
number of extents - "test1: 3141866 extents found". Also when running
with 4 threads when I check CPU, the sys% utilization takes 80% of CPU
( in the top output I see that all is consumed by kworker processes).

On the EXT4 I get only 13 extents even when running with 4 worker
threads. (note that I created RAID10 using mdadm before setting up
ext4 there in order to get comparable "storage solution" to what we
test with  BTRFS).

Another odd thing is, that it takes very long time for the filefrag
utility to return the result on the BTRFS and not only for the case
where I got 3 milions of extents but also for the first case where I
ran single worker and the number of extents was only 3. Filefrag on
EXT4 returns immediately.


> To see if this is because bad fragments for BTRFS. I am still not
> sure how fio will test randwrite here, so here is possibilities:
>
> case1:
>      if fio don’t repeat write same position for several time, i think
>      you could add --overite=0, and retest to see if it helps.

Not sure  what parameter do you mean here.

> case2:
>     if fio randwrite did write same position for several time, i think
>     you could use ‘-o nodatacow’ mount option to verify if this is because
>     BTRFS COW caused serious fragments.
>

It seems that mounting it with this option does have some effect but
not very significant and it is not very deterministic. The IOPs are
slightly higher at the beginning (~25 000 IOPs) but IOPs perfromance
is very spiky and I can still see that CPU sys% is very high. As soon
as the kworker threads start consuming CPU, the IOPs performance goes
down again to some ~15 000 IOPs.

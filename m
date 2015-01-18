Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48798 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbARFMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Jan 2015 00:12:03 -0500
Received: by mail-pd0-f182.google.com with SMTP id y10so18845143pdj.13
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jan 2015 21:12:02 -0800 (PST)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: btrfs performance - ssd array
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CABdHLQ75YskzRje8T75=MKmwDKeaar2JfyTwq0LnUBEOL4KfyQ@mail.gmail.com>
Date: Sun, 18 Jan 2015 13:11:57 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <0C538A62-948F-47DF-A94E-B18C0E2D36FF@gmail.com>
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com> <B9FB0052-C5D5-4463-B2EB-78056506E351@gmail.com> <CABdHLQ75YskzRje8T75=MKmwDKeaar2JfyTwq0LnUBEOL4KfyQ@mail.gmail.com>
To: "P. Remek" <p.remek1@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> Hello,
> 
>> 
>> Could you check how many extents with BTRFS and Ext4:
>> # filefrag test1
> 
> So my findings are odd:
> 
> On BTRFS when I run fio with a single worker thread (target file is
> 12GB large,and its 100% random write of 4kb blocks), then number of
> extents reported by filefrag is around 3.
> However when I do the same with 4 worker threads, I get some crazy
> number of extents - "test1: 3141866 extents found". Also when running
> with 4 threads when I check CPU, the sys% utilization takes 80% of CPU
> ( in the top output I see that all is consumed by kworker processes).
> 
> On the EXT4 I get only 13 extents even when running with 4 worker
> threads. (note that I created RAID10 using mdadm before setting up
> ext4 there in order to get comparable "storage solution" to what we
> test with  BTRFS).
> 
> Another odd thing is, that it takes very long time for the filefrag
> utility to return the result on the BTRFS and not only for the case
> where I got 3 milions of extents but also for the first case where I
> ran single worker and the number of extents was only 3. Filefrag on
> EXT4 returns immediately.

So looks like Btrfs lock contention problem.

Take a look at look btrfs_drop_extents(), even for nodatacow
, there will be still many items removal for FS tree.

Unfortunately, btrfs lock contention problems seem very sensible
to item removal operations.

And, here Your SSD is very fast? hm, i am not very sensible to
Your IOPS number.

You could verify this problem by reduing threads number for example
compare 1 thread results. aslo i guess btrfs seq write formace should
be less serious here¡­
> 
> 
>> To see if this is because bad fragments for BTRFS. I am still not
>> sure how fio will test randwrite here, so here is possibilities:
>> 
>> case1:
>>     if fio don¡¯t repeat write same position for several time, i think
>>     you could add --overite=0, and retest to see if it helps.
> 
> Not sure  what parameter do you mean here.


I mean ¡®--overwrite' is an option for fio.

> 
>> case2:
>>    if fio randwrite did write same position for several time, i think
>>    you could use ¡®-o nodatacow¡¯ mount option to verify if this is because
>>    BTRFS COW caused serious fragments.
>> 
> 
> It seems that mounting it with this option does have some effect but
> not very significant and it is not very deterministic. The IOPs are
> slightly higher at the beginning (~25 000 IOPs) but IOPs perfromance
> is very spiky and I can still see that CPU sys% is very high. As soon
> as the kworker threads start consuming CPU, the IOPs performance goes
> down again to some ~15 000 IOPs.

Best Regards,
Wang Shilong


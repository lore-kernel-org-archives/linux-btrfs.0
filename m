Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64985 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbAMD7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 22:59:52 -0500
Received: by mail-pd0-f172.google.com with SMTP id y13so1013038pdi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 19:59:51 -0800 (PST)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: btrfs performance - ssd array
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
Date: Tue, 13 Jan 2015 11:59:46 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B9FB0052-C5D5-4463-B2EB-78056506E351@gmail.com>
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
To: "P. Remek" <p.remek1@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Hello,
> 
> we are currently investigating possiblities and performance limits of
> the Btrfs filesystem. Now it seems we are getting pretty poor
> performance for the writes and I would like to ask, if our results
> makes sense and if it is a result of some well known performance
> bottleneck.
> 
> Our setup:
> 
> Server:
>   CPU: dual socket: E5-2630 v2
>   RAM: 32 GB ram
>   OS: Ubuntu server 14.10
>   Kernel: 3.19.0-031900rc2-generic
>   btrfs tools: Btrfs v3.14.1
>   2x LSI 9300 HBAs - SAS3 12/Gbs
>   8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
> 
> Both HBAs see all 8 disks and we have set up multipathing using
> multipath command and device mapper. Then we using this command to
> create the filesystem:
> 
> mkfs.btrfs -f -d raid10 /dev/mapper/prm-0 /dev/mapper/prm-1
> /dev/mapper/prm-2 /dev/mapper/prm-3 /dev/mapper/prm-4
> /dev/mapper/prm-5 /dev/mapper/prm-6 /dev/mapper/prm-7
> 
> 
> We run performance test using following command:
> 
> fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
> --name=test1 --filename=test1 --bs=4k --iodepth=32 --size=12G
> --numjobs=24 --readwrite=randwrite

Could you check how many extents with BTRFS and Ext4:
# filefrag test1

To see if this is because bad fragments for BTRFS. I am still not
sure how fio will test randwrite here, so here is possibilities:

case1:
     if fio don¡¯t repeat write same position for several time, i think
     you could add --overite=0, and retest to see if it helps.

case2:
    if fio randwrite did write same position for several time, i think
    you could use ¡®-o nodatacow¡¯ mount option to verify if this is because
    BTRFS COW caused serious fragments.

> 
> 
> The results for the random read are more or less comparable with the
> performance of EXT4 filesystem, we get approximately 300 000 IOPs for
> random read.
> 
> For random write however, we are getting only about 15 000 IOPs, which
> is much lower than for ESX4 (~200 000 IOPs for RAID10).
> 
> 
> Regards,
> Premek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong


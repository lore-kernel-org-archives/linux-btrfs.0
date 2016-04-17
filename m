Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35718 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcDQXSe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 19:18:34 -0400
Received: by mail-wm0-f46.google.com with SMTP id a140so97160457wma.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 16:18:34 -0700 (PDT)
Received: from [192.168.1.85] (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.googlemail.com with ESMTPSA id gr4sm25431741wjd.23.2016.04.17.16.18.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 17 Apr 2016 16:18:31 -0700 (PDT)
Subject: Re: Kernel crash if both devices in raid1 are failing
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <570FFDFE.3050305@gmail.com>
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Message-ID: <571419C7.6070709@gmail.com>
Date: Mon, 18 Apr 2016 01:18:31 +0200
MIME-Version: 1.0
In-Reply-To: <570FFDFE.3050305@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-14 22:30, Dmitry Katsubo wrote:
> Dear btrfs community,
> 
> I have the following setup:
> 
> # btrfs fi show /home
> Label: none  uuid: 865f8cf9-27be-41a0-85a4-6cb4d1658ce3
> 	Total devices 3 FS bytes used 55.68GiB
> 	devid    1 size 52.91GiB used 0.00B path /dev/sdd2
> 	devid    2 size 232.89GiB used 59.03GiB path /dev/sda
> 	devid    3 size 111.79GiB used 59.03GiB path /dev/sdc1
> 
> btrfs volume was created in raid1 mode both for data and metadata and mounted
> with compress=lzo option.
> 
> Unfortunately, two drives (sda and sdc1) started to fail at the same time. This
> leads to system crash if I start the system in runlevel 3 (see crash1.log).
> 
> After I have started the system in single mode, volume can be mounted in rw
> mode and I can write some data into it. Unfortunately when I tried to read
> a certain file, the system crashed (see crash2.log).
> 
> I have started scrub on the volume and here is the report:
> 
> # btrfs scrub status /home
> scrub status for 865f8cf9-27be-41a0-85a4-6cb4d1658ce3
> 	scrub started at Tue Apr 12 20:39:20 2016 and finished after 02:40:09
> 	total bytes scrubbed: 55.68GiB with 1767 errors
> 	error details: verify=175 csum=1592
> 	corrected errors: 1110, uncorrectable errors: 657, unverified errors: 0
> 
> Obviously, some data is lost. However due to above crash, I cannot just copy
> the data from the volume. I would assume that I still can access the data, but
> the files for which data is lost, should result I/O error (I would then recover
> them from my backup).
> 
> I have decided to attach another drive and remove failing devices one-by-one.
> However that does not work:
> 
> # btrfs dev delete /dev/sda /home
> [  168.680057] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  168.684236] ata3.00: BMDMA stat 0x25
> [  168.688464] ata3.00: failed command: READ DMA
> [  168.692681] ata3.00: cmd c8/00:08:68:4b:84/00:00:00:00:00/e7 tag 0 dma 4096 in
> [  168.692681]          res 51/40:08:68:4b:84/40:08:07:00:00/e7 Emask 0x9 (media error)
> [  168.701281] ata3.00: status: { DRDY ERR }
> [  168.705600] ata3.00: error: { UNC }
> [  168.724446] blk_update_request: I/O error, dev sda, sector 126110568
> [  168.728860] BTRFS error (device sdc1): bdev /dev/sda errs: wr 0, rd 43, flush 0, corrupt 0, gen 0
> [  172.824043] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  172.828651] ata3.00: BMDMA stat 0x25
> [  172.833281] ata3.00: failed command: READ DMA
> [  172.837876] ata3.00: cmd c8/00:08:50:4b:84/00:00:00:00:00/e7 tag 0 dma 4096 in
> [  172.837876]          res 51/40:08:50:4b:84/40:08:07:00:00/e7 Emask 0x9 (media error)
> [  172.847296] ata3.00: status: { DRDY ERR }
> [  172.852054] ata3.00: error: { UNC }
> [  172.872404] blk_update_request: I/O error, dev sda, sector 126110544
> [  172.877241] BTRFS error (device sdc1): bdev /dev/sda errs: wr 0, rd 44, flush 0, corrupt 0, gen 0
> ERROR: error removing device '/dev/sda': Input/output error
> 
> The same happens when I try to delete /dev/sdc1 from the volume. Is there any
> btrfs "force" option so that btrfs balances only chunks that are accessible? I
> can potentially physically disconnect /dev/sda, but the loss will be greater
> I believe.
> 
> How can I proceed except btrfs restore?
> 
> During scrub operation the following was recorded in the logs:
> 
> [Tue Apr 12 23:10:20 2016] BTRFS warning (device sdc1): checksum error at logical 126952947712 on dev /dev/sdc1, sector 126150176, root 258, inode 879324, offset 308256768, length 4096, links 1 (path: lib/mysql/ibdata1)
> 
> If I collect all the messages like this, will it give a full picture of damaged files?
> 
> Many thanks in advance.
> 
> P.S. Linux kernel v4.4.2, btrfs-progs v4.4.

I have decided to try "btrfs restore". Actually I have discovered two usability
points about it:

1. I cannot run this utility as following:

btrfs -i restore /dev/sda /mnt/usb &> log

because this command is interactive and may read something from the terminal.
It would be nice if there is a flag -y (answer "yes" to all questions) so that
no input is required from user. The example of the question is:

We seem to be looping a lot on ..., do you want to keep going on? [y/N/a]

In general this question puzzles me. What does it mean? As far as I understood
it prevents btrfs restore from looping forever. Should I consider those files
as lost? I have also hit the same problem as discussed in [1]: answer
"a" (always) still causes the questions to be asked.

2. btrfs restore does not print a final statistics: how many files are
successfully restored, and how many have failed.

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36458.html

-- 
With best regards,
Dmitry

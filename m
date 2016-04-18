Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37343 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbcDRAT3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 20:19:29 -0400
Received: by mail-ig0-f176.google.com with SMTP id g8so67671212igr.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 17:19:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570FFDFE.3050305@gmail.com>
References: <570FFDFE.3050305@gmail.com>
Date: Sun, 17 Apr 2016 18:19:27 -0600
Message-ID: <CAJCQCtSDUVDVZ=JfkhOhwn-OTM3iA=cNXc9w=zLcsEatA4xU5Q@mail.gmail.com>
Subject: Re: Kernel crash if both devices in raid1 are failing
From: Chris Murphy <lists@colorremedies.com>
To: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 2:30 PM, Dmitry Katsubo
<dmitry.katsubo@gmail.com> wrote:
> Dear btrfs community,
>
> I have the following setup:
>
> # btrfs fi show /home
> Label: none  uuid: 865f8cf9-27be-41a0-85a4-6cb4d1658ce3
>         Total devices 3 FS bytes used 55.68GiB
>         devid    1 size 52.91GiB used 0.00B path /dev/sdd2
>         devid    2 size 232.89GiB used 59.03GiB path /dev/sda
>         devid    3 size 111.79GiB used 59.03GiB path /dev/sdc1
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
>         scrub started at Tue Apr 12 20:39:20 2016 and finished after 02:40:09
>         total bytes scrubbed: 55.68GiB with 1767 errors
>         error details: verify=175 csum=1592
>         corrected errors: 1110, uncorrectable errors: 657, unverified errors: 0
>
> Obviously, some data is lost. However due to above crash, I cannot just copy
> the data from the volume. I would assume that I still can access the data, but
> the files for which data is lost, should result I/O error (I would then recover
> them from my backup).

With two device failure on raid1 volume, the file system is actually
broken. There's a big hole in the metadata, not just missing data,
because there are only two copies of metadata, distributed across
three drives.

btrfs restore might be able to scrape off some files, but I don't
expect it'll get very far. If there were n-way raid1, where every
drive has a complete copy of 100% of the filesystem metadata, what you
suggest would be possible.



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

OK probably the worst thing you can do if you're trying to recover
data from a degraded volume where a 2nd device is also having
problems, is to mount it rw let alone write anything to it. *shrug*
That's just going to make things much worse and more difficult to
recover, assuming anything can be recovered at all. The least number
of changes you make to such a volume, the better.


-- 
Chris Murphy

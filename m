Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:33467 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456AbcCKD3d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 22:29:33 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C0AF2AC0332
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 12:29:28 +0900 (JST)
Subject: Re: How to move a btrfs volume to a smaller disk
To: Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56E099A1.8040506@friedels.name>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E23B91.9080203@jp.fujitsu.com>
Date: Fri, 11 Mar 2016 12:29:21 +0900
MIME-Version: 1.0
In-Reply-To: <56E099A1.8040506@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/10 6:46, Hendrik Friedel wrote:
> Hello,
>
> I intend to move this subvolume to a new device.
> btrfs fi show /mnt2/Data_Store/
> Label: 'Data_Store'  uuid: 0ccc1e24-090d-42e2-9e61-d0a1b3101f93
>          Total devices 1 FS bytes used 47.93GiB
>          devid    1 size 102.94GiB used 76.03GiB path /dev/sdb4
>
> (fi usage at the bottom of this message)
>
> The new device (sda4) is 8G smaller unfortunately.
> sda       8:0    0 111.8G  0 disk
> └─sda4    8:4    0 103.5G  0 part
> sdb       8:16   0 119.2G  0 disk
> └─sdb4    8:20   0   111G  0 part  /mnt2/Data_Store
>
> Thus, btrfs replace does not work
>
> What would you suggest now to move the FS (it does contain many subvolumes)?
>
> I tried btrfs send /mnt2/Data_Store/read_only_snapshot/ | btrfs receive /mnt/sda4/
> but this only created an empty subvolume /mnt/sda4/read_only_snapshot/

I suspect that you captured snapshot as

   ==========================
   btrfs sub snap -r /mnt2/Data_Store /mnt2/Data_Store/read_only_snapshot
   ==========================

and /mnt2/Data_Store only contains subvolumes
instead of having files/directries directly.
Then send/receive work as you said. Probably if you run
"ls -li /mnt2/Data_Store", all files have
inode 256 (it means subvolume). In addition,
all the directories under
/mnt2/Data_Store/read_only_snapshot are empty.

It's because "sub snap" only handles one subvolume
and doesn't handle subvolumes inside it. So, if you'd
like to copy all the data by send/receive, you should
capture and send/receive snapshot for each subvolume.

>
> So, then
> btrfs device add /dev/sda4 /mnt/Data_Store
> btrfs balance start /mnt/Data_Store
> btrfs device remove /dev/sdb4 /mnt/Data_Store
> ?

balance is not necessary. When you run
device remove /dev/sdb4, then all the contents of
/dev/sdb4 migrate to /dev/sda4 properly.

Thanks,
Satoru

>
> Or is there a better option?
>
> Regards,
> Hendrik
>
>
>   btrfs fi usage  /mnt2/Data_Store/
> Overall:
>      Device size:                 102.94GiB
>      Device allocated:             74.03GiB
>      Device unallocated:           28.91GiB
>      Device missing:                  0.00B
>      Used:                         47.96GiB
>      Free (estimated):             53.24GiB      (min: 53.24GiB)
>      Data ratio:                       1.00
>      Metadata ratio:                   1.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:69.00GiB, Used:44.67GiB
>     /dev/sdb4      69.00GiB
>
> Metadata,single: Size:5.00GiB, Used:3.29GiB
>     /dev/sdb4       5.00GiB
>
> System,single: Size:32.00MiB, Used:16.00KiB
>     /dev/sdb4      32.00MiB
>
> Unallocated:
>     /dev/sdb4      28.91GiB
>
>
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
> https://www.avast.com/antivirus
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

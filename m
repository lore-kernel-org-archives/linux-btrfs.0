Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23027 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbbEZF4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 01:56:09 -0400
Message-ID: <55640AF3.2090502@cn.fujitsu.com>
Date: Tue, 26 May 2015 13:56:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Felix Koop <fdp@fkoop.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Help needed to recover a RAID5 btrfs
References: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
In-Reply-To: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hello,
>
> I have a RAID5 filesystem where one disk has crashed. Now the filesystem is not
> recognized any more. Any help available?
>
> Here is some info:
>
> root@server:~# uname -a
> Linux server 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux
>
> root@server:~# btrfs --version
> btrfs-progs v4.0
>
> root@server:~# btrfs f sh /dev/Data1vg/afs0
> warning, device 3 is missing
> warning devid 3 not found already
> checksum verify failed on 1111813750784 found 18019A1D wanted FCE227AB
> checksum verify failed on 1111813750784 found 18019A1D wanted FCE227AB
> bytenr mismatch, want=1111813750784, have=65536
> Couldn't read tree root
Tree root is corrupted, which is not a good news.

> Label: none uuid: 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
>   Total devices 3 FS bytes used 213.96GiB
>   devid 2 size 150.00GiB used 108.53GiB path /dev/mapper/Data1vg-afs0
>   devid 4 size 150.00GiB used 108.53GiB path /dev/mapper/Data3vg-afs0
>   *** Some devices missing
The device 3, I guest it's /dev/mapper/data2vg-afs0, does it still 
exists in /dev/mapper?
>
> btrfs-progs v4.0
>
> root@server:~# mount -o degraded -r /dev/Data1vg/afs0 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/Data1vg-afs0,
>   missing codepage or helper program, or other error
>
> In some cases useful info is found in syslog – try
>   dmesg | tail or so.
>
> root@server:~# dmesg | tail
> [104991.996065] BTRFS: open_ctree failed
> [105527.836798] blk_update_request: I/O error, dev fd0, sector 0
> [105527.839477] floppy: error -5 while reading block 0
> [105555.615991] BTRFS info (device dm-52): allowing degraded mounts
> [105555.616000] BTRFS info (device dm-52): disk space caching is enabled
> [105555.665644] BTRFS: bdev (null) errs: wr 38, rd 0, flush 0, corrupt 0, gen 0
> [105556.213570] BTRFS (device dm-52): bad tree block start 14290338419558610620
> 1111828267008
> [105556.216649] BTRFS (device dm-52): bad tree block start 14290338419558610620
> 1111828267008
> [105556.219364] BTRFS: Failed to read block groups: -5
> [105556.236056] BTRFS: open_ctree failed
>
>
> If more info is needed, just tell me what I should do. Thanks.
Need some extra info:
  btrfs-show-super -a -f /dev/mapper/Data1vg-afs0
  btrfs-show-super -a -f /dev/mapper/Data2vg-afs0 (If that is device3 
and exists)
  btrfs-show-super -a -f /dev/mapper/Data3vg-afs0

Maybe we can use old super to restore it to a mountable status.

If you have spare space to backup all the 3 devices, it's recommended to 
do it, as some repair tips may cause some write into disk, and may even 
make things worse.

Thanks,
Qu

>
> ---
>
> Kind greetings
>
> Felix Koop
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

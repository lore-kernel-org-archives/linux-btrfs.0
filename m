Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33849 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbEZWoD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 18:44:03 -0400
Received: by pdbki1 with SMTP id ki1so59101352pdb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 15:44:02 -0700 (PDT)
Date: Tue, 26 May 2015 15:44:00 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Felix Koop <fdp@fkoop.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Help needed to recover a RAID5 btrfs
Message-ID: <20150526224400.GA28433@mew.lv.cox.net>
References: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 25, 2015 at 06:06:20PM +0200, Felix Koop wrote:
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
> Label: none uuid: 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
>  Total devices 3 FS bytes used 213.96GiB
>  devid 2 size 150.00GiB used 108.53GiB path /dev/mapper/Data1vg-afs0
>  devid 4 size 150.00GiB used 108.53GiB path /dev/mapper/Data3vg-afs0
>  *** Some devices missing
> 
> btrfs-progs v4.0
> 
> root@server:~# mount -o degraded -r /dev/Data1vg/afs0 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/Data1vg-afs0,
>  missing codepage or helper program, or other error
> 
> In some cases useful info is found in syslog – try
>  dmesg | tail or so.
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
> 

Just a heads up if you manage to mount it, device replace of a missing
device on RAID5/6 will currently oops (see [1]). If you're feeling
really adventurous, you could try my unreviewed patch series here [2],
but that of course depends on the degraded mount succeeding.

1: https://bugzilla.kernel.org/show_bug.cgi?id=96141
2: http://thread.gmane.org/gmane.comp.file-systems.btrfs/45045

-- 
Omar

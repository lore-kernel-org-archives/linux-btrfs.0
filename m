Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54079 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaLBTTm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 14:19:42 -0500
Received: by mail-qc0-f182.google.com with SMTP id r5so10001237qcx.13
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 11:19:41 -0800 (PST)
Message-ID: <547E10BA.6000707@ubuntu.com>
Date: Tue, 02 Dec 2014 14:19:22 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Konstantin <newsbox1026@web.de>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de>
In-Reply-To: <547CE175.6060409@web.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/1/2014 4:45 PM, Konstantin wrote:
> The bug appears also when using mdadm RAID1 - when one of the
> drives is detached from the array then the OS discovers it and
> after a while (not directly, it takes several minutes) it appears
> under /proc/mounts: instead of /dev/md0p1 I see there /dev/sdb1.
> And usually after some hour or so (depending on system workload)
> the PC completely freezes. So discussion about the uniqueness of
> UUIDs or not, a crashing kernel is telling me that there is a
> serious bug.

I'm guessing you are using metadata format 0.9 or 1.0, which put the
metadata at the end of the drive and the filesystem still starts in
sector zero.  1.2 is now the default and would not have this problem
as its metadata is at the start of the disk ( well, 4k from the start
) and the fs starts further down.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUfhC6AAoJENRVrw2cjl5RQ2EH/0Z0iCFjOs3e5oGuGqT5Wtlc
rXV8R1EfGSxESK0g6QAe7QIvJu+0CdIgccDp8z3ezfPcm1/YRfBXxXA/Y1Wl4hqw
0wuk3bNqMjUmNwIFjEZCkgOSn4Whuppbh3hOOVGNropr4cwd84GP1Cr2vrzwYnkm
If1I3RTaBhAJRSngkP9X+L5J6zBBjaZLlF4AjC/WP/1bd5vkHpGqnFpRTquCPiNV
9LFWQIB+xYdoRdK2l7huS2jQ5kfw+qLZUQO17dU3fcicwwNk56V4HcLEPg9nx9es
pxJo9BAWmQXDpeMcCL4eFECoeAhn0IXoaXb363mmpq11qyYj73r3FzhNQ+ALzPY=
=U65Z
-----END PGP SIGNATURE-----

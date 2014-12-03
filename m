Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:33585 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCDB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 22:01:26 -0500
In-Reply-To: <547E10BA.6000707@ubuntu.com>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: Russell Coker <russell@coker.com.au>
Date: Wed, 03 Dec 2014 14:01:18 +1100
To: Phillip Susi <psusi@ubuntu.com>, Konstantin <newsbox1026@web.de>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <97AF1D81-03EF-47DF-97CB-0EFF4E3CFEA7@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe we should have a warning in mkfs.btrfs for the problematic RAID layouts.

On December 3, 2014 6:19:22 AM GMT+11:00, Phillip Susi <psusi@ubuntu.com> wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>On 12/1/2014 4:45 PM, Konstantin wrote:
>> The bug appears also when using mdadm RAID1 - when one of the
>> drives is detached from the array then the OS discovers it and
>> after a while (not directly, it takes several minutes) it appears
>> under /proc/mounts: instead of /dev/md0p1 I see there /dev/sdb1.
>> And usually after some hour or so (depending on system workload)
>> the PC completely freezes. So discussion about the uniqueness of
>> UUIDs or not, a crashing kernel is telling me that there is a
>> serious bug.
>
>I'm guessing you are using metadata format 0.9 or 1.0, which put the
>metadata at the end of the drive and the filesystem still starts in
>sector zero.  1.2 is now the default and would not have this problem
>as its metadata is at the start of the disk ( well, 4k from the start
>) and the fs starts further down.
>
>
>
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v2.0.17 (MingW32)
>
>iQEcBAEBAgAGBQJUfhC6AAoJENRVrw2cjl5RQ2EH/0Z0iCFjOs3e5oGuGqT5Wtlc
>rXV8R1EfGSxESK0g6QAe7QIvJu+0CdIgccDp8z3ezfPcm1/YRfBXxXA/Y1Wl4hqw
>0wuk3bNqMjUmNwIFjEZCkgOSn4Whuppbh3hOOVGNropr4cwd84GP1Cr2vrzwYnkm
>If1I3RTaBhAJRSngkP9X+L5J6zBBjaZLlF4AjC/WP/1bd5vkHpGqnFpRTquCPiNV
>9LFWQIB+xYdoRdK2l7huS2jQ5kfw+qLZUQO17dU3fcicwwNk56V4HcLEPg9nx9es
>pxJo9BAWmQXDpeMcCL4eFECoeAhn0IXoaXb363mmpq11qyYj73r3FzhNQ+ALzPY=
>=U65Z
>-----END PGP SIGNATURE-----
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.

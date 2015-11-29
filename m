Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:60344 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbK2NpI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 08:45:08 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.80)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1a31hq-0002ti-Pr
	for linux-btrfs@vger.kernel.org; Sun, 29 Nov 2015 14:07:54 +0100
Date: Sun, 29 Nov 2015 14:07:54 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
Message-ID: <20151129130754.GI31524@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a banana pi with a btrfs filesystem of 5 GB in size, which
frequently runs out of space (lots of snapshots). This is currently
again the case:

[27/524]mh@banana:~$ sudo btrfs balance start /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
[28/525]mh@banana:~$ sudo btrfs balance start / -dlimit=3
[sudo] password for mh on banana:
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
[29/526]mh@banana:~$ sudo btrfs balance start / -dlimit=3
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
[30/526]mh@banana:~$ sudo btrfs balance start / -dusage=0
Done, had to relocate 0 out of 8 chunks
[31/527]mh@banana:~$ sudo btrfs balance start / -dlimit=3
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
[32/528]mh@banana:~$ sudo btrfs fi show /
Label: none  uuid: ada6b7f5-98d6-4fee-a3a3-b73bd152ff6c
        Total devices 1 FS bytes used 3.37GiB
        devid    1 size 6.89GiB used 4.22GiB path /dev/mapper/banana-root

btrfs-progs v4.3
[33/529]mh@banana:~$ sudo btrfs fi df /
Data, single: total=3.41GiB, used=3.25GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=384.00MiB, used=121.75MiB
GlobalReserve, single: total=48.00MiB, used=0.00B
[34/530]mh@banana:~$ uname -a
Linux banana 4.3.0-zgbpi-armmp-lpae+ #2 SMP Sat Nov 7 13:07:34 UTC 2015 armv7l GNU/Linux
[36/532]mh@banana:~$ df -h /
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/banana-root  6.9G  3.6G  2.9G  56% /
[37/533]mh@banana:~$

The first kernel that was ever booted on the device was 4.1, I am
therefore reasonably sure that the filesystem was also created with a
recent kernel. Is there any possibility to find out about the kernel
version that a filesystem was created with?

However, the FAQ
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
suggests that for small filesystems (<16 GB), the best solution would
be to upgrade to at least 2.6.37 and recreate the filesystem. 2.6.37
is ancient, from 2011, so I am pretty sure that the filesystem _was_
created at least with a kernel more recent than that.

My normal way to recover from this situation is to btrfs add a new
device, btrfs balance, btrfs --convert=single --force balance, btfs
device remove, btr balance start -mconvert=dup --force and finally
balance start again.

Is there any solution to solve this more elegantly?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbcBZUh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 15:37:26 -0500
From: Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <56D0B782.20606@suse.cz>
Date: Fri, 26 Feb 2016 21:37:22 +0100
MIME-Version: 1.0
In-Reply-To: <56D0B007.2050106@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 21:05 Austin S. Hemmelgarn wrote:

> It's kind of interesting, but I can't reproduce _any_ of this behavior
> with either ext4 or BTRFS when I manually set up the loop devices and
> point mount(8) at those instead of using -o loop on a file. That really
> seems to indicate that this is caused by something mount(8) is doing
> when it's calling losetup.

Behavior of "-oloop" is more similar to "losetup -f /fs.img"? than to
"losetup /dev/loop0 /fs.img".

Anyway, I can reproduce without -oloop:
# losetup /dev/loop0 /btrfs.img
# mount /dev/loop0 /mnt/1
# grep /mnt /proc/self/mountinfo
107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop0 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
# losetup /dev/loop1 /btrfs.img
# mount -osubvol=/ /dev/loop1 /mnt/2
# grep /mnt /proc/self/mountinfo
107 59 0:59 /d0/dd0/ddd0/s1/d1/dd1/ddd1/s2 /mnt/1 rw,relatime shared:45 - btrfs /dev/loop1 rw,space_cache,subvolid=257,subvol=/d0/dd0/ddd0/s1/d1/dd1/ddd1/s2
108 59 0:59 / /mnt/2 rw,relatime shared:48 - btrfs /dev/loop1 rw,space_cache,subvolid=5,subvol=/
# uname -a
Linux oct 4.4.1-1-default #1 SMP PREEMPT Mon Feb 15 11:03:27 UTC 2016 (6398c2d) x86_64 x86_64 x86_64 GNU/Linux

(Note that the system was freshly rebooted. After other experiments,
the second line of mountinfo can be missing completely.)

>> 2) mount(2) called after the reproducer returns OK but does nothing.
>>
> OK, we've determined that mount(2) is misbehaving.  That doesn't change
> the fact that mount(8) is triggering this, and therefore should itself
> be corrected.

> Assume that mount(2) gets fixed so it doesn't lose it's
> mind and /proc/self/mountinfo doesn't change.  There will still be
> issues resulting from mount(8)'s behavior:
> 1. BTRFS will lose it's mind and corrupt data when using a multi-device
> filesystem (due to the problems with duplicate FS UUID's).
> 2. XFS might have similar issues to 1 when using metadata checksumming,
> although it's more likely that it won't allow the second mount to succeed.
> 3. Most other filesystems will likely end up corrupting data.

Do I understand, that you are saying:

Yes, mounting multiple loop devices associated with one file is a
legitimate use, but mount(8) should never do it, because it has other
ugly side effects?

OK, it looks like a next task for mount(8) to fix.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec@suse.com
Lihovarská 1060/12                            tel: +49 911 7405384547
190 00 Praha 9                                 fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76

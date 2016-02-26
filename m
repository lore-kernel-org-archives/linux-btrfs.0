Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbcBZVAw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 16:00:52 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
 <20160226175311.GC17997@ZenIV.linux.org.uk> <56D0A38B.3050701@suse.cz>
 <56D0B007.2050106@gmail.com> <20160226203010.GD17997@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <56D0BCFC.5020302@suse.cz>
Date: Fri, 26 Feb 2016 22:00:44 +0100
MIME-Version: 1.0
In-Reply-To: <20160226203010.GD17997@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 26, 2016 at 21:30 Al Viro wrote:
> IMO on-demand losetup a-la -o loop is simply a bad idea...

So the correct behavior of -o loop should:

Check, whether another mount command already did losetup.

If not, allocate new loop device.

If yes, reuse existing loop device.

Well, it seems to be safe, even if the loop device was not allocated by 
mount(8) itself, as
ioctl(fd, LOOP_CLR_FD)
never returns EBUSY:

# losetup /dev/loop2 /ext4.img
# mount /dev/loop2 /mnt
# strace losetup -d /dev/loop2 2>&1 | tail -n7 | head -n3
open("/dev/loop2", O_RDONLY|O_CLOEXEC)  = 3
ioctl(3, LOOP_CLR_FD)                   = 0
close(3)                                = 0

If the recycling "alien" loop devices will not be considered as a good 
idea, then (if possible):

If the loop device was allocated by mount(8) itself, recycle it.

If the loop device was not allocated by mount(8) itself, return error.

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

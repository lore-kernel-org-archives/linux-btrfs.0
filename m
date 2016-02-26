Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50480 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbcBZRxO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 12:53:14 -0500
Date: Fri, 26 Feb 2016 17:53:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Stanislav Brabec <sbrabec@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
Message-ID: <20160226175311.GC17997@ZenIV.linux.org.uk>
References: <56CF5490.7040102@suse.cz>
 <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz>
 <56D07FAF.3080605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D07FAF.3080605@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 11:39:11AM -0500, Austin S. Hemmelgarn wrote:

> That's just it though, from what I can tell based on what I've seen
> and what you said above, mount(8) isn't doing things correctly in
> this case.  If we were to do this with something like XFS or ext4,
> the filesystem would probably end up completely messed up just
> because of the log replay code (assuming they actually mount the
> second time, I'm not sure what XFS would do in this case, but I
> believe that ext4 would allow the mount as long as the mmp feature
> is off).  It would make sense that this behavior wouldn't have been
> noticed before (and probably wouldn't have mattered even if it had
> been), because most filesystems don't allow multiple mounts even if
> they're all RO, and most people don't try to mount other filesystems
> multiple times as a result of this.

They most certainly do.  The problem is mount(8) treatment of -o loop -
you can mount e.g. ext4 many times, it'll just get you extra references
to the same struct super_block from those new vfsmounts.  IOW, that'll
behave the same way as if you were doing mount --bind on subsequent ones.

And as far as kernel is concerned, /dev/loop* isn't special in any respects;
if you do explicit losetup and mount the resulting /dev/loop<n> as many
times as you wish, it'll work just fine.  And from the kernel POV it's not
different from what it sees with -o loop; setting the loop device up is
done first by separate syscall, then mount(2) for that device is issued.

It's mount(8) that screws up here.

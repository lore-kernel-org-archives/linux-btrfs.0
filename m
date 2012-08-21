Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53426 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2HUQAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 12:00:23 -0400
Date: Tue, 21 Aug 2012 18:00:19 +0200
From: David Sterba <dave@jikos.cz>
To: Not Zippy <notzippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Computer crash, btrfs partition errors
Message-ID: <20120821160019.GN17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
 <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Aug 17, 2012 at 09:02:07PM -0700, Not Zippy wrote:
> My sabayon box locked up while doing a repo sync, now I am getting the
> following errors on one directory on my btrfs partition

Can you be more specific how did you get to the state?
Did you see any related error messages in syslog (from the lockup or
from normal fs use that leads to the following errors)?

> rm: cannot remove
> ?system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/refs?:
> Directory not empty
> rm: cannot remove
> ?system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/hooks?:
> Stale NFS file handle
> rm: cannot remove
> ?system.2/.repo/projects/packages/wallpapers/HoloSpiral.git/HEAD?:
> Stale NFS file handle

So this is a ESTALE error code. If I understand correctly the ?..? marks
around the filename, the names of the files can be obtained but
subsequent stat fails.

> Doing a btrfsck fails with the following error
> # btrfsck /dev/sda2
> checking extents
> leaf parent key incorrect 46329503744
> bad block 46329503744
> owner ref check failed [46329503744 4096]
> Errors found in extent allocation tree

One of the blocks is corrupted, in a way that prevents the file(s) to be
removed, from the fsck log there's bad link between leaf and it parent
node plus some refcounting mismatches. As it's the 'extent allocation
tree', fsck should be able to repair this type of error.

> checking fs roots
> btrfsck: btrfsck.c:394: process_inode_item: Assertion `!(rec->ino !=
> key->objectid || rec->refs > 1)' failed.
> Aborted
> 
> Kernel
> Linux homeu1 3.5.0-sabayon
> btrfs
> Btrfs Btrfs v0.19-dirty
> 
> Can this be repaired ? The drive is still mountable and I have moved
> all other files to another drive so I could wipe it but I was
> wondering if repairing was an option as well..

If you still have the image around, please try 'btrfsck --repair' on it,
and use the latest source version from cmason's repository, unless your
distro ships it (can't tell from the version string).


david

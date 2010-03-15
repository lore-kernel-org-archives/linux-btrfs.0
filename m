From: Chris Mason <chris.mason@oracle.com>
Subject: Re: consistent oops after power fail during btrfs-vol -r
Date: Mon, 15 Mar 2010 16:56:23 -0400
Message-ID: <20100315205623.GB10296@think>
References: <4B9D266A.3000105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Troy Ablan <tablan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B9D266A.3000105@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 14, 2010 at 11:09:46AM -0700, Troy Ablan wrote:
> Hey guys,
> 
> In the middle of a long btrfs-vol -r on a 15-device raid1 the machine
> lost power.  I don't know if that's the cause, but I now have access to
> the filesystem for only a minute or two, and am now consistently getting
> this oops shortly after mount:

Just to include comments from irc, this configuration has dm-crypt on
top of plain sata drives.  This configuration won't pass sata cache
flushing operations from the filesystem to the drive, and so the
writeback cache on these drives needs to be turned off to avoid
corruption during power failures.

This doesn't meant the oopsen are ok, I'm working on a series of EIO
patches to get us past these bugs and at least help people read the data
off the drives.

-chris

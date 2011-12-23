From: Chris Mason <chris.mason@oracle.com>
Subject: Re: FS won't mount, open_ctree failed, Assertion !(path->slots[0] ==
 0) failed
Date: Fri, 23 Dec 2011 13:15:42 -0500
Message-ID: <20111223181542.GU19266@shiny>
References: <CB041FF1.1FD66%dsmith@tgen.org>
 <loom.20111223T103108-120@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Evan LeCompte <evanlec@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111223T103108-120@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2011 at 09:37:28AM +0000, Evan LeCompte wrote:
> I'm having the very same issue as you. I've tried all the latest btrfs tools,
> btrfsck, btrfs-zero-log, restore, find-root etc etc.
> 
> All to no avail. only err output is always 
> 
> "" btrfs_find_last_root: Assertion `!(path->slots[0] == 0)' failed. ""
> 
> This is a very cryptic error that doesn't tell me anything. and it seems to be
> the only error that is ever thrown when transaction id's get out of sync.
> 
> Is there ANY way to even recover ANY files at all from these btrfs filesystems
> that lose transid sync? mine occurred simply from a loose sata cable falling out
> of one of my drives while the system was running.
> 
> This is extremely frustrating, but I guess I have no one to blame but myself. I
> do have a backup but its about a month old (my cron backup script died for some
> reason and I didn't notice). So I'm faced with losing a months worth of work :(
> 
> Please help us, anyone!

Which kernel are you running?  If you're on a 3.2 kernel or you have a
recent pull of my git tree, you can try mount -o recovery.

My guess is that your machine went down pretty quickly after the loose
sata cable fell out?  In that case mount -o recovery should work.

Otherwise we can work through the copy out recovery tools.

-chris


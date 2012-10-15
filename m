Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40354 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2JOUPW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:15:22 -0400
Date: Mon, 15 Oct 2012 22:15:16 +0200
From: David Sterba <dave@jikos.cz>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Systemcall for offline deduplication
Message-ID: <20121015201516.GB10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <507C4343.6060305@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <507C4343.6060305@shiftmail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 15, 2012 at 07:09:23PM +0200, Bob Marley wrote:
> I would really appreciate a systemcall (or ioctl or the like) to allow
> deduplication of a block of a file against a block of another file.
> (ok if blocks need to be aligned to filesystem blocks)

It exists, is called

BTRFS_IOC_CLONE_RANGE
(http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L399)

btrfs_ioctl_clone_range_args
http://lxr.free-electrons.com/source/fs/btrfs/ioctl.h#L254

> The syscall should presumably check that the regions are really equal and
> perform the deduplication atomically.
> 
> This would be the start for a lot of deduplication algorithms in userspace.
> It would be a killer feature for backup systems.

It doesn't do any checks if the range contents match, but for a backup
system, the ranges can be merged at a calm state, ie not new data in
flight.

david

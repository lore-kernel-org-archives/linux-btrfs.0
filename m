Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab3BKRpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 12:45:51 -0500
Date: Mon, 11 Feb 2013 18:45:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add cancellation points to defrag
Message-ID: <20130211174547.GS12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360453086-10683-1-git-send-email-dsterba@suse.cz>
 <5119238A.9080306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5119238A.9080306@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 10:59:54AM -0600, Eric Sandeen wrote:
> On 2/9/13 5:38 PM, David Sterba wrote:
> > The defrag operation can take very long, we want to have a way how to
> > cancel it. The code checks for a pending signal at safe points in the
> > defrag loops and returns EAGAIN. This means a user can press ^C after
> > running 'btrfs fi defrag', woks for both defrag modes, files and root.
> > 
> > Returning from the command was instant in my light tests, but may take
> > longer depending on the aging factor of the filesystem.
> 
> When __btrfs_run_defrag_inode() calls btrfs_defrag_file() and gets
> -EAGAIN back due to the cancellation, will it reset the defrag->
> counters and call btrfs_requeue_inode_defrag()?  Is that ok?
> 
> Should __btrfs_run_defrag_inode explicitly check for and handle
> an actual error returned to it?

__btrfs_run_defrag_inode -> btrfs_defrag_file applies only in case of
autodefrag. The ioctl 'defrag' goes directly to btrfs_defrag_file and
what you describe does not happen here.

(The autodefrag loop runs within kernel threads and I want to avoid
enabling signals for them.)

I agree that the negative error code should be handled in
__btrfs_run_defrag_inode (there are two of them EINVAL and ENOMEM).
Requeing defrag might make sense in theory in the ENOMEM case, but
triggering more activity when the system is low on memory is not
practical.


david

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbbC3NAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 09:00:05 -0400
Date: Mon, 30 Mar 2015 14:59:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: unlock i_mutex after attempting to delete
 subvolume during send
Message-ID: <20150330125946.GE32051@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <74abba0fe653d9ac27bfe4f14ae3e8f65b5b7317.1427539655.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <74abba0fe653d9ac27bfe4f14ae3e8f65b5b7317.1427539655.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 28, 2015 at 04:02:06AM -0700, Omar Sandoval wrote:
> Whenever the check for a send in progress introduced in commit
> 521e0546c970 (btrfs: protect snapshots from deleting during send) is
> hit, we return without unlocking inode->i_mutex. This is easy to see
> with lockdep enabled:
> 
> [  +0.000059] ================================================
> [  +0.000028] [ BUG: lock held when returning to user space! ]
> [  +0.000029] 4.0.0-rc5-00096-g3c435c1 #93 Not tainted
> [  +0.000026] ------------------------------------------------
> [  +0.000029] btrfs/211 is leaving the kernel with locks still held!
> [  +0.000029] 1 lock held by btrfs/211:
> [  +0.000023]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff8135b8df>] btrfs_ioctl_snap_destroy+0x2df/0x7a0
> 
> Make sure we unlock it in the error path.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

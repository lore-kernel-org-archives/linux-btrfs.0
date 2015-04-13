Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35563 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbDMVdS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 17:33:18 -0400
Received: by pabtp1 with SMTP id tp1so114928835pab.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:33:18 -0700 (PDT)
Date: Mon, 13 Apr 2015 14:33:17 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: unlock i_mutex after attempting to delete
 subvolume during send
Message-ID: <20150413213317.GB4857@mew.cs.washington.edu>
References: <00d6e1021fdd56192360d2eb0fb43130f3607fe1.1428700740.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00d6e1021fdd56192360d2eb0fb43130f3607fe1.1428700740.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 10, 2015 at 02:20:40PM -0700, Omar Sandoval wrote:
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
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Just resending this with Filipe's and David's Reviewed-bys and Cc-ing
> stable.
> 
>  fs/btrfs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Ping.

-- 
Omar

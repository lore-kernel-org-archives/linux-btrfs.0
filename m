From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2222
Date: Fri, 27 Jan 2012 12:40:42 -0500
Message-ID: <20120127174042.GF991@shiny>
References: <Pine.LNX.4.64.1201270912570.5607@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1201270912570.5607@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 27, 2012 at 09:31:46AM -0800, Sage Weil wrote:
> Has anyone see this one before?  We've been hitting it sporatically for a 
> while now, although recently we've been able to trigger pretty easily.  
> The result is EINVAL from the snap create ioctl.
> 
> The kernel is v3.2 + some ceph stuff.
> 
> The code in question is
> 
> 		/* if we have links, this was a truncate, lets do that */
> 		if (inode->i_nlink) {
> 			if (!S_ISREG(inode->i_mode)) {
> 				WARN_ON(1);
> 				iput(inode);
> 				continue;
> 			}
> 
> Is this something obvious, or should we spend some time chasing it down?

This doesn't seem right, we've got an orphan on a directory for a
truncate?  The link count is probably 1, but no I haven't seen this.

-chris

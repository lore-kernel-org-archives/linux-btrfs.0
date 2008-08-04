From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] fix ioctl-initiated transactions vs
	wait_current_trans() deadlock
Date: Mon, 04 Aug 2008 09:01:59 -0400
Message-ID: <1217854920.29139.57.camel@think.oraclecorp.com>
References: <Pine.LNX.4.64.0808021135050.23304@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808021135050.23304@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-08-02 at 12:39 -0700, Sage Weil wrote:
> Hi Chris,
> 
> Commit 597:466b27332893 (btrfs_start_transaction: wait for commits in 
> progress) breaks the transaction start/stop ioctls by making 
> btrfs_start_transaction conditionally wait for the next transaction to 
> start.  If an application artificially is holding a transaction open, 
> things deadlock.
> 

Right, once I was done tuning the throttle code I was going to email you
on this.  Your patch looks pretty good, I'll take it in today.

-chris



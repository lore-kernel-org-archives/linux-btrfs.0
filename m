From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] btrfs: 'usertrans' mount option to allow unprivileged
	userspace transactions
Date: Fri, 26 Jun 2009 13:09:44 -0400
Message-ID: <20090626170944.GB2412@infradead.org>
References: <Pine.LNX.4.64.0906221434150.9993@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906221434150.9993@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2009 at 02:45:39PM -0700, Sage Weil wrote:
> This lets an administrator give non-root users access to the btrfs 
> transaction start/end ioctls via a mount option.
> 
> Currently any process using the ioctls must run as root.  That's 
> appropriate in general, since the ioctls allow let any process to hang fs 
> commits by holding an open transaction indefinitely.  But on locked down 
> hosts (i.e. no users), that can be inconvenient because daemons using 
> transactions have to run as root.

If the system is locked down there is no problem giving the capability
to the daemon user.  I'm strong against adding any kind of
privilegue-evading options to filesystems.


From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] btrfs: 'usertrans' mount option to allow unprivileged
 userspace transactions
Date: Mon, 29 Jun 2009 09:40:54 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0906290940030.9725@cobra.newdream.net>
References: <Pine.LNX.4.64.0906221434150.9993@cobra.newdream.net>
 <20090626170944.GB2412@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090626170944.GB2412@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 26 Jun 2009, Christoph Hellwig wrote:
> On Thu, Jun 25, 2009 at 02:45:39PM -0700, Sage Weil wrote:
> > This lets an administrator give non-root users access to the btrfs 
> > transaction start/end ioctls via a mount option.
> > 
> > Currently any process using the ioctls must run as root.  That's 
> > appropriate in general, since the ioctls allow let any process to hang fs 
> > commits by holding an open transaction indefinitely.  But on locked down 
> > hosts (i.e. no users), that can be inconvenient because daemons using 
> > transactions have to run as root.
> 
> If the system is locked down there is no problem giving the capability
> to the daemon user.  I'm strong against adding any kind of
> privilegue-evading options to filesystems.

Well, I was hoping for finer granularity that CAP_SYS_ADMIN, but i can 
live with it.  Thanks.

sage

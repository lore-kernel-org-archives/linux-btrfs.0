From: Mingming <cmm@us.ibm.com>
Subject: Re: btrfs_put_inode
Date: Wed, 21 May 2008 12:02:15 -0700
Message-ID: <1211396535.5571.33.camel@BVR-FS.beaverton.ibm.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <1211390340.5571.19.camel@BVR-FS.beaverton.ibm.com>
	 <48f7fe350805211123j1657382ew5e5e15eb6957cf79@mail.gmail.com>
	 <200805211432.53092.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ryan Hope <rmh3093@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805211432.53092.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 2008-05-21 at 14:32 -0400, Chris Mason wrote:
> On Wednesday 21 May 2008, Ryan Hope wrote:
> > try this patch out,
> > http://zen-sources.org/files/btrfs-stable-for-2.6.26-rc3.patch
> 
> It is a little hard to tell from the big long patch what the incremental 
> difference is ;)
> 
Looks like just break the hook up in super_operations:-)
> -chris


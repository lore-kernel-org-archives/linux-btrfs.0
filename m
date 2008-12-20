From: Chris Mason <chris.mason@oracle.com>
Subject: Re: inode data not getting included in commits?
Date: Fri, 19 Dec 2008 19:11:40 -0500
Message-ID: <1229731900.5033.1.camel@think.oraclecorp.com>
References: <Pine.LNX.4.64.0812181536060.10446@cobra.newdream.net>
	 <3d0408630812181726g7b1be6ey787ff0e6105cfa80@mail.gmail.com>
	 <Pine.LNX.4.64.0812182104580.25096@cobra.newdream.net>
	 <1229695975.6270.12.camel@think.oraclecorp.com>
	 <Pine.LNX.4.64.0812191028020.29416@cobra.newdream.net>
	 <1229713644.6695.48.camel@think.oraclecorp.com>
	 <Pine.LNX.4.64.0812191119110.29416@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yan Zheng <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812191119110.29416@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-12-19 at 12:08 -0800, Sage Weil wrote:

[ trigger data=ordered flush at commit time ]

>  
> > A third option is a different type of xattr operation that doesn't go to
> > disk until the metadata updates done at IO end time.
> > 
> > >From a performance point of view, it'll be much faster than slowing down
> > commit with data writes.
> > 
> > Can that work for you?
> 
> I suspect not, since multiple files are involved.  It's usually something 
> like
> 
>  write A
>  setxattr A
>  write B
>  setxattr C
> 
> and all need to be committed atomically.  The model really is a bundle of 
> arbitrary operations that commit atomically.
> 
> Slower commit times aren't as much of a concern because this is on the 
> storage backend, behind client caches and so forth.  I think it's 
> a reasonable price to pay for the stronger consistency.  
> 
> Hopefully it's not throwing too big a wrench into the data=ordered 
> machinery?  It sort of looks like this is already what you get when taking 
> a snapshot (I see the call to wait_ordered_extnets in commit_transaction 
> when snaps_pending).

If we make it optional, its fine by me to added a data=ordered flush at
commit time.

-chris



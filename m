From: Sage Weil <sage@newdream.net>
Subject: Re: inode data not getting included in commits?
Date: Thu, 18 Dec 2008 21:21:48 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0812182104580.25096@cobra.newdream.net>
References: <Pine.LNX.4.64.0812181536060.10446@cobra.newdream.net>
 <3d0408630812181726g7b1be6ey787ff0e6105cfa80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812181726g7b1be6ey787ff0e6105cfa80@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Dec 2008, Yan Zheng wrote:
> > I noticed some data and metadata getting out of sync on disk, despite
> > wrapping my writes with btrfs transactions.  After digging into it a bit,
> > it appears to be a larger problem with inode size/data getting written
> > during a regular commit.
> > [...]
> 
> This is the desired behaviour of data=ordered. Btrfs transaction commit
> don't flush data, and metadata wont get updated until data IO complete.
> 
> http://article.gmane.org/gmane.comp.file-systems.btrfs/869/match=new+data+ordered+code

Ah, right, so it is.

I think what I'm looking for then is a mount mode to get the old behavior, 
such that each commit flushes previously written data.  Probably a call to 
btrfs_wait_ordered_extents() in btrfs_commit_transaction(), or something 
along those lines...

sage

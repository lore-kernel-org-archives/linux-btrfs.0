From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for
 ctree.h
Date: Fri, 18 Dec 2009 09:10:03 -0500
Message-ID: <20091218141003.GB3202@think>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
 <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
 <4B2B1852.6080105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sniper <s3c24xx@gmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B2B1852.6080105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 18, 2009 at 01:51:14PM +0800, Zhaolei wrote:
> sniper wrote:
> > No, many pointers in btrfs function arguments are not pointing to an
> > absolute address, but relative to the start address of extent.
> > Take following function as example, argument inode_item is an offset
> > value to the beginning of leaf. So we can't reach its member with
> > &inode_item->xxx
> 
> Notice that we are not reach its member, we are getting pointer of its
> member with &inode_item->mtime.
> This operation have same effect as old one.

It relies on gcc doing something specific with the pointer address
manipulation while the original code makes it clear we're just taking
the offset.  We do rely on gcc being gcc in lots of places in the code,
but in this case I prefer the offsetof.

-chris

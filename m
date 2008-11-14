From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] btrfs: allow clone of an arbitrary file range
Date: Fri, 14 Nov 2008 12:43:47 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0811141243320.22610@cobra.newdream.net>
References: <Pine.LNX.4.64.0810301221050.32010@cobra.newdream.net>
 <1226673521.26512.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1226673521.26512.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Nov 2008, Chris Mason wrote:

> On Thu, 2008-10-30 at 12:32 -0700, Sage Weil wrote:
> > Hi,
> > 
> > This patch adds an additional CLONE_RANGE ioctl to clone an arbitrary 
> > (block-aligned) file range to another file.  The original CLONE ioctl 
> > becomes a special case of cloning the entire file range.  The logic is a 
> > bit more complex now since ranges may be cloned to different offsets, and 
> > because we may only be cloning the beginning or end of a particular extent 
> > or checksum item.
> > 
> 
> Just FYI, I've pushed this out to the unstable tree.   Please let me
> know if you have any problems using it.

Thanks, will do!

sage

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 08:02:22 -0400
Message-ID: <1301572893-sup-3464@think>
References: <cover.1301542804.git.larry@elder-gods.org> <20110331063636.GA5297@infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: "Larry D'Anna" <larry@elder-gods.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Yan Zheng <zheng.z.yan@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110331063636.GA5297@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2011-03-31 02:36:36 -0400:
> On Thu, Mar 31, 2011 at 12:00:11AM -0400, Larry D'Anna wrote:
> > This is a simple patch to allow reflinks to be made crossing subvolume
> > boundaries.
> 
> NAK.  subvolumes will have to become vfsmounts sooner or later, and we
> really must not support any operations spanning mountpoints.
> 

Sorry, I disagree here.  reflinks were always intended to be able to
span subvolumes.  There's no conflict at all because they span different
inodes.

-chris

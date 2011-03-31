From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 08:44:15 +0200
Message-ID: <4D9422BF.8000706@gmx.net>
References: <cover.1301542804.git.larry@elder-gods.org> <20110331063636.GA5297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Larry D'Anna <larry@elder-gods.org>, linux-btrfs@vger.kernel.org,
	Yan Zheng <zheng.z.yan@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110331063636.GA5297@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 31.03.2011 08:36, Christoph Hellwig wrote:
> On Thu, Mar 31, 2011 at 12:00:11AM -0400, Larry D'Anna wrote:
>> This is a simple patch to allow reflinks to be made crossing subvolume
>> boundaries.
> 
> NAK.  subvolumes will have to become vfsmounts sooner or later, and we
> really must not support any operations spanning mountpoints.

In what way would this interfere? the reflinked file gets its own inum
in its own mountpoint. The two files only internally share some disk
space.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


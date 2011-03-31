From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 02:36:36 -0400
Message-ID: <20110331063636.GA5297@infradead.org>
References: <cover.1301542804.git.larry@elder-gods.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.z.yan@intel.com>
To: Larry D'Anna <larry@elder-gods.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1301542804.git.larry@elder-gods.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2011 at 12:00:11AM -0400, Larry D'Anna wrote:
> This is a simple patch to allow reflinks to be made crossing subvolume
> boundaries.

NAK.  subvolumes will have to become vfsmounts sooner or later, and we
really must not support any operations spanning mountpoints.


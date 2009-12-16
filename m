From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 04/12] Btrfs: Fix disk_i_size update corner case
Date: Wed, 16 Dec 2009 11:21:46 -0500
Message-ID: <20091216162146.GA3322@think>
References: <4AFBD69D.60206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AFBD69D.60206@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2009 at 05:34:21PM +0800, Yan, Zheng wrote:
> There are some cases file extents are inserted without involving
> ordered struct. In these cases, we update disk_i_size directly,
> without checking pending ordered extent and DELALLOC bit. This
> patch extends btrfs_ordered_update_i_size() to handle these cases.

I'm hitting problems with this one in testing.  I think the issue is
that the extent_mutex was protecting us from something like this:

proc1:
process end io for extent [0, 32768]
btrfs_ordered_update_i_size() -- update i_disk_size to 32768

proc2:
process end io for extent [32768, 55536]
btrfs_ordered_update_i_size() find the rbtree entry [0, 32768], exit

proc1:
remove extent [0, 32768] from rbtree

Because the first extent was still in the rbtree, we didn't update
i_size to the full 55536, even though the first extent was fully
processed.  I think I've got this fixed by removing the extents from the
rbtree when we're in btrfs_ordered_update_i_size().  The current patch
does this only when an ordered extent was passed in.

-chris

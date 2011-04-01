From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix free space cache when there are pinned
	extents and clusters
Date: Fri, 1 Apr 2011 08:15:05 -0400
Message-ID: <20110401121505.GE7484@dhcp231-156.rdu.redhat.com>
References: <1301601548-14612-1-git-send-email-josef@redhat.com> <4D958531.90500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D958531.90500@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2011 at 03:56:33PM +0800, Li Zefan wrote:
> > +	spin_lock(&block_group->tree_lock);
> > +	if (btrfs_block_group_free_space(block_group) !=
> 
> This function call can be replaced by block_group->free_space, so
> we don't have to iterate the tree.
> 
> (This function gets removed in my patchset for inode number caching)
>

Ah yeah good point, thanks,

Josef 

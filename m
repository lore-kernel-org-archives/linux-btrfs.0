From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/6] btrfs: update stats when allocating from a cluster
Date: Mon, 23 Aug 2010 22:50:24 -0400
Message-ID: <20100824025023.GA2638@dhcp231-156.rdu.redhat.com>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD91.4050703@cn.fujitsu.com> <20100823130932.GD2404@localhost.localdomain> <4C731771.1060904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C731771.1060904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 24, 2010 at 08:50:57AM +0800, Li Zefan wrote:
> >>  	spin_unlock(&cluster->lock);
> >>  
> >> +	if (!ret)
> >> +		return 0;
> >> +
> >> +	spin_lock(&block_group->tree_lock);
> >> +
> >> +	block_group->free_space -= bytes;
> >> +	if (entry->bytes == 0) {
> >> +		block_group->free_extents--;
> >> +		kfree(entry);
> >> +	}
> >> +
> >> +	spin_unlock(&block_group->tree_lock);
> >> +
> > 
> > Move this part up so we don't drop the spinlock and then re-grab it.  Thanks,
> > 
> 
> But they are 2 different locks. ;)
> 
> And we can't grab block_group->tree_lock when holding cluster->lock.

Ugh Jesus sorry, ignore me.

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef

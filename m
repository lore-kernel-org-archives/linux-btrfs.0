Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaJIPnV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 11:43:21 -0400
Date: Thu, 9 Oct 2014 17:43:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Re: [PATCH] btrfs: add more superblock checks
Message-ID: <20141009154319.GB22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5433A7D7.4080401@cn.fujitsu.com>
 <5433A97F.8050509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5433A97F.8050509@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 07, 2014 at 04:51:11PM +0800, Qu Wenruo wrote:
> > +	struct btrfs_super_block *sb = fs_info->super_copy;
> > +	int ret = 0;
> > +
> > +	if (sb->root_level > BTRFS_MAX_LEVEL) {
> > +		printk(KERN_ERR "BTRFS: tree_root level too big: %d > %d\n",
> > +				sb->root_level, BTRFS_MAX_LEVEL);
> > +		ret = -EINVAL;
> > +	}
> > +	if (sb->chunk_root_level > BTRFS_MAX_LEVEL) {
> > +		printk(KERN_ERR "BTRFS: chunk_root level too big: %d > %d\n",
> > +				sb->chunk_root_level, BTRFS_MAX_LEVEL);
> > +		ret = -EINVAL;
> > +	}
> > +	if (sb->log_root_level > BTRFS_MAX_LEVEL) {
> > +		printk(KERN_ERR "BTRFS: log_root level too big: %d > %d\n",
> > +				sb->log_root_level, BTRFS_MAX_LEVEL);
> > +		ret = -EINVAL;
> > +	}
> > +
> >   	/*
> > -	 * Placeholder for checks
> > +	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
> > +	 * items yet, they'll be verified later. Issue just a warning.
> >   	 */
> > -	return 0;
> > +	if (!IS_ALIGNED(sb->root, 4096))
> > +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> > +				sb->root);
> > +	if (!IS_ALIGNED(sb->chunk_root, 4096))
> > +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> > +				sb->chunk_root);
> > +	if (!IS_ALIGNED(sb->log_root, 4096))
> > +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> > +				sb->log_root);
> 1) it is better not to call IS_ALIGNED to immediate value//.
> Although current btrfs implement ensures that all sectorsize is larger 
> equal than page_size,
> but Chandan Rajendra is trying to support subpage-sized blocksize,
> which may cause false alert later.

The patch reflects current state, so when the subpage blocksize patches
are merged, this will have to be changed accordingly.

> It would be much better using btrfs_super_sectorsize() instead to 
> improve extendability.

See the comment above, we don't trust the superblock yet and cannot use
the sectorsize reliably.

> 2) missing endian convert.
> On big endian system it would be a disaster....
> btrfs_super_* marco should be used.

Thanks, will fix it.

> > +	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
> > +		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
> > +				fs_info->fsid, sb->dev_item.fsid);
> > +		ret = -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
> > +	 * done later
> > +	 */
> > +	if (sb->num_devices > (1UL << 31))
> > +		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
> > +				sb->num_devices);

> What about also check the devid with sb->num_devices too?
> Every valid devid should be less equal than sb->num_devices if I am right.
> Although iterate dev_item here may be overkilled...

This could be done of course, I've tried to keep the checks very small
and using only directly accessible information. More is possible of
course.

> > +
> > +	if (sb->bytenr != BTRFS_SUPER_INFO_OFFSET) {
> > +		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
> > +				sb->bytenr, BTRFS_SUPER_INFO_OFFSET);
> > +		ret = -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * The generation is a global counter, we'll trust it more than the others
> > +	 * but it's still possible that it's the one that's wrong.
> > +	 */
> > +	if (sb->generation < sb->chunk_root_generation)
> > +		printk(KERN_WARNING
> > +			"BTRFS: suspicious: generation < chunk_root_generation: %llu < %llu\n",
> > +			sb->generation, sb->chunk_root_generation);
> > +	if (sb->generation < sb->cache_generation && sb->cache_generation != (u64)-1)
> > +		printk(KERN_WARNING
> > +			"BTRFS: suspicious: generation < cache_generation: %llu < %llu\n",
> > +			sb->generation, sb->cache_generation);
> > +
> > +	return ret;
> >   }
> >   
> Still the endian problem.

Will fix, thanks.

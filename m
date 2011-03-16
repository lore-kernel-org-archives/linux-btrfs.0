From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Wed, 16 Mar 2011 16:35:25 +0200
Message-ID: <20110316143525.GA2546@kwango.lan.net>
References: <cover.1299941055.git.sensille@gmx.net> <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 12, 2011 at 03:50:42PM +0100, Arne Jansen wrote:

All extent maps are leaked after unmount.  lookup_extent_mapping() takes
a reference, so they are all left with em->refs = 1.  I suggest the
following:

> +static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev, 
> +	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length)
> +{
> +	struct btrfs_mapping_tree *map_tree =
> +		&sdev->dev->dev_root->fs_info->mapping_tree;
> +	struct map_lookup *map;
> +	struct extent_map *em;
> +	int i;
> +	int ret;
> +
> +	read_lock(&map_tree->map_tree.lock);
> +	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
> +	read_unlock(&map_tree->map_tree.lock);
> +
> +	if (!em)
> +		return -EINVAL;
> +
> +	map = (struct map_lookup *)em->bdev;
> +	if (em->start != chunk_offset)
> +		return -EINVAL;
> +
> +	if (em->len < length)
> +		return -EINVAL;
> +
> +	for (i = 0; i < map->num_stripes; ++i) {
> +		if (map->stripes[i].dev == sdev->dev) {
> +			ret = scrub_stripe(sdev, map, i, chunk_offset, length);
> +			if (ret)
> +				return ret;
> +		}
> +	}

+	free_extent_map(em);

> +	return 0;
> +}

Thanks,

		Ilya

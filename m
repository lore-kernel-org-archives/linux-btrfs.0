From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v8 1/8] btrfs: added helper functions to iterate backrefs
Date: Thu, 03 Nov 2011 09:41:16 +0800
Message-ID: <4EB1F13C.3070801@cn.fujitsu.com>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <915659509a8ca58ec0bbf89001bac5afd4fa81b4.1311778307.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <915659509a8ca58ec0bbf89001bac5afd4fa81b4.1311778307.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

(as this is going to be merged into mainline..)

> +/*
> + * calls iterate() for every inode that references the extent identified by
> + * the given parameters. will use the path given as a parameter and return it
> + * released.
> + * when the iterator function returns a non-zero value, iteration stops.
> + */
> +int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
> +				struct btrfs_path *path,
> +				u64 extent_item_objectid,
> +				u64 extent_offset,
> +				iterate_extent_inodes_t *iterate, void *ctx)

While trying to use this API, I found there's a big defect in this function.

   fs_tree 1       fs_tree 2
       \              /
        \            /
         \          /
          \        /
             node
              |
              |
             leaf  (EXTENT_DATA item)

In the above case, the function will find only 1 reference.

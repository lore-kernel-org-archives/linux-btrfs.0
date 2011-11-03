From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v8 1/8] btrfs: added helper functions to iterate backrefs
Date: Thu, 03 Nov 2011 11:32:35 +0100
Message-ID: <4EB26DC3.5080409@jan-o-sch.net>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <915659509a8ca58ec0bbf89001bac5afd4fa81b4.1311778307.git.list.btrfs@jan-o-sch.net> <4EB1F13C.3070801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@oracle.com
To: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB1F13C.3070801@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03.11.2011 02:41, Li Zefan wrote:
> (as this is going to be merged into mainline..)
> 
>> +/*
>> + * calls iterate() for every inode that references the extent identified by
>> + * the given parameters. will use the path given as a parameter and return it
>> + * released.
>> + * when the iterator function returns a non-zero value, iteration stops.
>> + */
>> +int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>> +				struct btrfs_path *path,
>> +				u64 extent_item_objectid,
>> +				u64 extent_offset,
>> +				iterate_extent_inodes_t *iterate, void *ctx)
> 
> While trying to use this API, I found there's a big defect in this function.
> 
>    fs_tree 1       fs_tree 2
>        \              /
>         \            /
>          \          /
>           \        /
>              node
>               |
>               |
>              leaf  (EXTENT_DATA item)
> 
> In the above case, the function will find only 1 reference.

Hum. You are right.

I'm convinced that I've been at this point months ago, only I cannot
find code dealing with counts > 1 on nodes. I'll look for a fix in my
branches or make a new one.

I also recognized that some "btrfs_" prefixes are missing for the
exported functions. I'm going to change this on the next iteration as well.

Currently, this is more of a best-effort resolver. Support for delayed
extents is missing, it should be used on commit roots to get a
consistent state.

For the userspace part, at least the simple scenario outlined isn't
crucial as "btrfs inspect-internal logical-resolve" will find each of
the two paths, depending on the subvolume path you specify. It never
finds both, though, which I agree it should.

Sigh,
-Jan

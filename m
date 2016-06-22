Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55444 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbcFVWUo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 18:20:44 -0400
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
Cc: David Sterba <dsterba@suse.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <376fafee-8baa-2a49-7d77-892ceb419b83@mendix.com>
Date: Thu, 23 Jun 2016 00:20:38 +0200
MIME-Version: 1.0
In-Reply-To: <1466616406-28087-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2016 07:26 PM, David Sterba wrote:
> From: David Sterba <dsterba@suse.cz>
>
> Hi,
>
> the chunk dump is a useful thing, for debugging or balance filters.

Nice!

> Example output:
>
> Chunks on device id: 1
> PNumber            Type        PStart        Length          PEnd     Age         LStart  Usage
> -----------------------------------------------------------------------------------------------
>       0   System/RAID1        1.00MiB      32.00MiB      33.00MiB      47        1.40TiB   0.06
>       1 Metadata/RAID1       33.00MiB       1.00GiB       1.03GiB      31        1.36TiB  64.03
>       2 Metadata/RAID1        1.03GiB      32.00MiB       1.06GiB      36        1.36TiB  77.28
>       3     Data/single       1.06GiB       1.00GiB       2.06GiB      12      422.30GiB  78.90
>       4     Data/single       2.06GiB       1.00GiB       3.06GiB      11      420.30GiB  78.47
> ...
>
> (full output is at http://susepaste.org/view/raw/089a9877)
>
> This patch does the basic output, not filtering or sorting besides physical and
> logical offset. There are possiblities to do more or enhance the output (eg.
> starting with logical chunk and list the related physcial chunks together).
> Or filter by type/profile, or understand the balance filters format.
>
> As it is now, it's per-device dump of physical layout, which was the original
> idea.
>
> Printing 'usage' is not default as it's quite slow, it uses the search ioctl
> and probably not in the best way, or there's some other issue in the
> implementation.

Interesting.

So after reading this, I wrote a little test to test some scenarios:

https://github.com/knorrie/python-btrfs/commit/1ca99880dfa0e14b148f3d9e2b6b381b781eb52d

It's very clear that the most optimal way of doing this search is to 
have nr_items=1 and if possible, specify the length in offset.

I have no idea yet what happens inside the kernel when nr_items is not 
1, in combination with a large extent tree. I'll try to follow the code 
and see if I can find what's making this big difference.

Also, the filesystem with the 1200 second search result is Debian 
3.16.7-ckt25-2, I haven't looked yet if there's different behaviour 
inside handling searches between that kernel and e.g. 4.5.

After loading a huge amount of data in memory, the search with nr_items 
 > 1 only takes 4.6 seconds to come up with the block group item itself, 
and another 4.6 seconds to come up with 0 additional results, only using 
cpu time.

It seems that searching in the empty space between
  (vaddr BLOCK_GROUP_ITEM length+1) and
  (vaddr BLOCK_GROUP_ITEM ULLONG_MAX)
is really expensive, while there's absolutely nothing to find.

I ran into this two days ago, caused by doing an unnecessary extra 
search after finding the block item already:

https://github.com/knorrie/python-btrfs/commit/5a69d9cf0477515ce2d6e50f1741276a49b33af8

> I'll add the patch to devel branch but will not add it for any particular
> release yet, I'd like some feedback first. Thanks.
>
> -------------
> New command 'btrfs inspect-internal dump-chunks' will dump layout of
> chunks as stored on the devices. This corresponds to the physical
> layout, sorted by the physical offset. The block group usage can be
> shown as well, but the search is too slow so it's off by default.
>
> If the physical offset sorting is selected, the empty space between
> chunks is also shown.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  cmds-inspect.c | 364 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 364 insertions(+)
> [...]
> +}
> +
> +static u64 fill_usage(int fd, u64 lstart)
> +{
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_key *sk = &args.key;
> +	struct btrfs_ioctl_search_header sh;
> +	struct btrfs_block_group_item *item;
> +	int ret;
> +
> +	memset(&args, 0, sizeof(args));
> +	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
> +	sk->min_objectid = lstart;
> +	sk->max_objectid = lstart;
> +	sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> +	sk->max_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> +	sk->min_offset = 0;
> +	sk->max_offset = (u64)-1;

The chunk length is already known here, so it can go in offset.

> +	sk->max_transid = (u64)-1;
> +
> +	sk->nr_items = 4096;

Or set to 1 because we already know there can only be one result.

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com

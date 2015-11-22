Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53215 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbbKVCEj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 21:04:39 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Lukas Pirl <btrfs@lukas-pirl.de>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org, calestyo@scientia.net, L.Bonnaud@laposte.net
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565122AA.90904@gmx.com>
Date: Sun, 22 Nov 2015 10:04:26 +0800
MIME-Version: 1.0
In-Reply-To: <564FC3FE.9020905@lukas-pirl.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lukas, Laurent and Christoph,

If any of you can recompile btrfs-progs and use gdb to debug it, would 
anyone please to investigate where did the wrong_chunk_type is set?

It is in the function check_extent_type():
------
/* Check if the type of extent matches with its chunk */
static void check_extent_type(struct extent_record *rec)
{
	struct btrfs_block_group_cache *bg_cache;

	bg_cache = btrfs_lookup_first_block_group(global_info, rec->start);
	if (!bg_cache)
		return;

	/* data extent, check chunk directly*/
	if (!rec->metadata) {
		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA))
			rec->wrong_chunk_type = 1; <<< HERE
		return;
	}

	/* metadata extent, check the obvious case first */
	if (!(bg_cache->flags & (BTRFS_BLOCK_GROUP_SYSTEM |
				 BTRFS_BLOCK_GROUP_METADATA))) {
		rec->wrong_chunk_type = 1; <<< HERE
		return;
	}

	/*
	 * Check SYSTEM extent, as it's also marked as metadata, we can only
	 * make sure it's a SYSTEM extent by its backref
	 */
	if (!list_empty(&rec->backrefs)) {
		struct extent_backref *node;
		struct tree_backref *tback;
		u64 bg_type;

		node = list_entry(rec->backrefs.next, struct extent_backref,
				  list);
		if (node->is_data) {
			/* tree block shouldn't have data backref */
			rec->wrong_chunk_type = 1; <<< HERE
			return;
		}
		tback = container_of(node, struct tree_backref, node);

		if (tback->root == BTRFS_CHUNK_TREE_OBJECTID)
			bg_type = BTRFS_BLOCK_GROUP_SYSTEM;
		else
			bg_type = BTRFS_BLOCK_GROUP_METADATA;
		if (!(bg_cache->flags & bg_type))
			rec->wrong_chunk_type = 1; <<< HERE
	}
}
------

If you can add break point on the "rec->wrong_chunk_type = 1;" line, it 
would be quite helpful for further debugging.

Thanks,
Qu
On 11/21/2015 09:08 AM, Lukas Pirl wrote:
> On 11/21/2015 01:47 PM, Qu Wenruo wrote as excerpted:
>> Hard to say, but we'd better keep an eye on this issue.
>> At least, if it happens again, we should know if it's related to
>> something like newer kernel or snapshots.
>
> I can confirm the initially describe behavior of "btrfs check" and
> reading the data works fine also.
>
> Versions etc.:
>
> $ uname -a
> Linux 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-1~bpo8+1 …
> $ btrfs filesystem show /mnt/data
> Label: none  uuid: 5be372f5-5492-4f4b-b641-c14f4ad8ae23
>          Total devices 6 FS bytes used 2.87TiB
>          devid    1 size 931.51GiB used 636.00GiB path /dev/mapper/…SZ
>          devid    2 size 931.51GiB used 634.03GiB path /dev/mapper/…03
>          devid    3 size 1.82TiB used 1.53TiB path /dev/mapper/…76
>          devid    4 size 1.82TiB used 1.53TiB path /dev/mapper/…78
>          devid    6 size 1.82TiB used 1.05TiB path /dev/mapper/…UK
>          *** Some devices missing
>
> btrfs-progs v4.3
>
> $ btrfs subvolume list /mnt/data | wc -l
> 62
>
> Best,
>
> Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

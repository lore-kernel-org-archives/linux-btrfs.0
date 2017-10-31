Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:51341 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbdJaFop (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 01:44:45 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 2AAC6AC00AD
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:44:41 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: print-tree: Enehance uuid item print
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20171031040341.18840-1-wqu@suse.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <33d7b245-5a6b-6afc-938d-08d21c6776a2@jp.fujitsu.com>
Date: Tue, 31 Oct 2017 14:44:35 +0900
MIME-Version: 1.0
In-Reply-To: <20171031040341.18840-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017/10/31 13:03, Qu Wenruo wrote:
> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL the
> key objectid and key offset are just half of the UUID.
> 
> However we just print the key as %llu, which is converted from little
> endian, not byte order for UUID, nor the traditional 36 bytes human
> readable uuid format.
> 
> Although true engineer can easily convert it in their brain, but to
> make it easier for search, output the result UUID using the 36 chars format.
> 
> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Inspired by UUID related work from Misono.
> ---
>  print-tree.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 3c585e31f1fc..687f871db302 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -803,14 +803,25 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
>  	}
>  }
>  
> -static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
> -			    u32 item_size)
> +static void print_uuid_item(struct extent_buffer *l, int slot,
> +			    unsigned long offset, u32 item_size)
>  {
> +	struct btrfs_key key;
> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
> +	u8 uuid[BTRFS_UUID_SIZE];
> +
> +	/* Reassemble the uuid from key.objecitd and key.offset */
> +	btrfs_item_key_to_cpu(l, &key, slot);
> +	put_unaligned_le64(key.objectid, uuid);
> +	put_unaligned_le64(key.offset, uuid + sizeof(u64));
> +	uuid_unparse(uuid, uuid_str);
> +
>  	if (item_size & (sizeof(u64) - 1)) {
>  		printf("btrfs: uuid item with illegal size %lu!\n",
>  		       (unsigned long)item_size);
>  		return;
>  	}
> +	printf("\t\tuuid %s\n", uuid_str);
>  	while (item_size) {
>  		__le64 subvol_id;
>  
> @@ -1297,7 +1308,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
>  			break;
>  		case BTRFS_UUID_KEY_SUBVOL:
>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>  					btrfs_item_size_nr(eb, i));
>  			break;
>  		case BTRFS_STRING_ITEM_KEY: {
> 

Reviewed-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>


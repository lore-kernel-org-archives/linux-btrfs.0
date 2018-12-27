Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951EAC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6202C214C6
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbeL0Hq0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:46:26 -0500
Received: from mout.gmx.net ([212.227.17.22]:35935 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbeL0Hq0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:46:26 -0500
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgKoE-1gxxdP0vxe-00NinR; Thu, 27
 Dec 2018 08:46:18 +0100
Subject: Re: [PATCH 2/3] btrfs-progs: uuid: Port btrfs_uuid_tree_add()
 function
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-3-wqu@suse.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <8a26b215-b2bc-6a4a-e7b1-f9b1a0189933@gmx.com>
Date:   Thu, 27 Dec 2018 15:54:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181227071333.10964-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:N1naim0U6jFfDDcpgdShBF7A8X2i91p5WxHe7IwuDYfsClo6vMM
 Ztvq3M6AjBfDaiVH3Qi046d2Pp9FQ0ZUKNLzd5AJU+NX1P1T063CbjjjrCxi4+RKBYs2Hhb
 MydEUTWe0uAVoznHoGdhvtqsRLmpC90VaLf7d1xGpEJqKE+qbu4cuN2j/28fvFoqapgLKtt
 fA/5zWADo0GFEcVBKagmA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uEf9HSvs4dg=:3puKAHW8BaAN1JGe0zvxfE
 uK652zMfWZqrJyKzccBgp5vHbhIawcAyNzN44TJRt52XAD0evPjGejyajfL9ax8C0WZa7Tsmv
 s//jg2lxWjKgZ0BSO5UlDYEe3wuD6B2wYF75wCBTUN0UomCbUbTvJVnyXF5hTzpVvLyybDeHE
 qRt9VhstnOYV5QdWYvXv/elTWCu2d3VNRj7bXKtYePSimiazrj7h4hdojBeXBumoPZPowLwkU
 LFlxaH2oRgxsCQcfq4BbSqirtAf6j/1XHTle2LAQ0xhlr+9hLaK5pNOSWcxJCBD9wAiTfk/M2
 IOlK8HRhxhuMqp4y0wqIpYk3zKU6wvTaj4M9gnOeCAUqPBR7dJIX/t2TzXTvK0EQ//CY0hYac
 KRyIEP1H0YCAzGO60n/pLtV716Dow3UldxxOJWDzfNOmPyTllaQ1wkEX6gVXlSzeUUHUH0ZWZ
 XJeOLjBsWne6fdPnQGNO2P3FcpPE/OWU36783ruKIYtqyYaXKqvC0It/NUakau1K4e4TRvePx
 sPsI2ixG3hUmjAyLs1SKd//BYA9oyxnQohFnyFgnVbGQAss7s0q4yNZ+pkfdCNohkV9GN686R
 69kLYHO5H7MYkr9vEhbFyyAo6MAfcBYoj/JF2cer777UCnS9Zcwq8jApF8Fy6iTshFeLIYJ2H
 jYHsDV+1cLHz2VTLy8pYI+S5nGMSkDFW0rYiIFrp0xFMC6QkMbuwwZhvYRie7l+YLDR1eVQFg
 pR5RPdr0l1L2tNavIFIBre9TDORdFgGuIobcdKXjD6bAAPJzckKtOO5ilKO0PJX+btaB7LgeV
 UKf3Oc0nY/hSRLNyEsz7nMb9peyTCi58/y+0eWHxc+9zlKQdLQI7U9X2yRk6UF2vkdwKcaJyG
 grzk6P+/NGtvBX6tkYYZ9+zA5O90ULfzYV890wNuskZ3ZUvN7N0EbcXf3/mf0Q
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/27/18 3:13 PM, Qu Wenruo wrote:
> This function provide the offline ability to add new uuid tree entry.
> This provides the basis for later proper uuid tree initialization.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <damenly_su@gmx.com>

> ---
>   ctree.h     |  7 +++++-
>   uuid-tree.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/ctree.h b/ctree.h
> index f9c49d6041c1..7b9e3f1cef6e 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -1101,6 +1101,7 @@ struct btrfs_fs_info {
>   	struct btrfs_root *csum_root;
>   	struct btrfs_root *quota_root;
>   	struct btrfs_root *free_space_root;
> +	struct btrfs_root *uuid_root;
>   
>   	struct rb_root fs_root_tree;
>   
> @@ -2774,11 +2775,15 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
>   			struct btrfs_root *root, struct btrfs_path *path,
>   			u64 isize);
>   
> -/* uuid-tree.c */
> +/* uuid-tree.c, mounted fs (online) interface */
>   int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id);
>   int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
>   					   u64 *subvol_id);
>   
> +/* uuid-tree.c, unmounted fs (offline) interface */
> +int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
> +			u64 subid_cpu);
> +
>   static inline int is_fstree(u64 rootid)
>   {
>   	if (rootid == BTRFS_FS_TREE_OBJECTID ||
> diff --git a/uuid-tree.c b/uuid-tree.c
> index b9190103c355..3f547198f016 100644
> --- a/uuid-tree.c
> +++ b/uuid-tree.c
> @@ -170,3 +170,68 @@ out:
>   	btrfs_free_path(path);
>   	return ret;
>   }
> +
> +int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
> +			u64 subid_cpu)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_root *uuid_root = fs_info->uuid_root;
> +	int ret;
> +	struct btrfs_path *path = NULL;
> +	struct btrfs_key key;
> +	struct extent_buffer *eb;
> +	int slot;
> +	unsigned long offset;
> +	__le64 subid_le;
> +
> +	if (!uuid_root) {
> +		warning("%s: uuid root is not initialized", __func__);
> +		return -EINVAL;
> +	}
> +
> +	ret = btrfs_uuid_tree_lookup(uuid_root, uuid, type, subid_cpu);
> +	if (ret != -ENOENT)
> +		return ret;
> +
> +	key.type = type;
> +	btrfs_uuid_to_key(uuid, &key.objectid, &key.offset);
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = btrfs_insert_empty_item(trans, uuid_root, path, &key,
> +				      sizeof(subid_le));
> +	if (ret >= 0) {
> +		/* Add an item for the type for the first time */
> +		eb = path->nodes[0];
> +		slot = path->slots[0];
> +		offset = btrfs_item_ptr_offset(eb, slot);
> +	} else if (ret == -EEXIST) {
> +		/*
> +		 * An item with that type already exists.
> +		 * Extend the item and store the new subid at the end.
> +		 */
> +		btrfs_extend_item(uuid_root, path, sizeof(subid_le));
> +		eb = path->nodes[0];
> +		slot = path->slots[0];
> +		offset = btrfs_item_ptr_offset(eb, slot);
> +		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
> +	} else if (ret < 0) {
> +		warning("insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!",
> +			ret, (unsigned long long)key.objectid,
> +			(unsigned long long)key.offset, type);
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	subid_le = cpu_to_le64(subid_cpu);
> +	write_extent_buffer(eb, &subid_le, offset, sizeof(subid_le));
> +	btrfs_mark_buffer_dirty(eb);
> +
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> 

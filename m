Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95874C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5DD214AE
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbeL0H3a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:29:30 -0500
Received: from mout.gmx.net ([212.227.17.20]:58549 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbeL0H33 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:29:29 -0500
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lh7M3-1h71R00irn-00oUvF; Thu, 27
 Dec 2018 08:29:21 +0100
Subject: Re: [PATCH 1/3] btrfs-progs: uuid: Port kernel
 btrfs_uuid_tree_lookup()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-2-wqu@suse.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <2a24d1cf-41b4-b4db-7aae-33c836c9a6b0@gmx.com>
Date:   Thu, 27 Dec 2018 15:37:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181227071333.10964-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:6Ymcyf3Z/9zlKwhsd/itJBOOCOU5Yfr4tDBmdM/eM85FKjvMZNd
 k1MI7pbKjS8gMaTOy/RPeYfp7wspJQT/47HHuomOhjq2WW/CYj2QaIgRGShfnbiH3blPaco
 K19iMg4il3TAkjIgutVlKIrNv516OVYcinhvzAa7KIRa5MYLp2GIHPUAgT76JuynLmBDgZJ
 BL9KT8PA8exLftnNvIVeg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XY4Y1Jyo9wI=:6mgmYwknikvI7PrQT23vSc
 NN5GzwoXzqSlNgZj07XRihg1govkFW3/3mkC9EiRBKj4s/Ttv6Q7HJ4vyIWRen0dYQDdUwmxF
 9p4UcJnJ3IP1XKgRoOu6r1qbCCubq8iwf6znJBKw8jbvPkicGtSZdBUfR1TCAuutY2IFP9evE
 nHSX6j4F+WnHHk4y6cph3X1PxiEsXjN+HqNeG8v/SfWmkto3JleNH02cHn//Ai6JSOIS3cm61
 YebQGr/7LvccE8vxisTRJXOUJfBDAOivOVeJSi/hlYYWAlpMg3VooV8FltAMtwxYaFcEKjog7
 bIoTy0L3NyItlVbzE9D/eat0NvBZ7MPKHPLxPc+2ptOv15VIyjZLR03qfIojmA2TVGnoTMHBD
 4e19pXfrNgIYdJKi9wDaJVgj1t+JUgvnKejh8g28k5idq99AUDJki6jtte0KNKzuUAW6BTsNF
 eUUdkWFsAr5LuRnX/TCM37WOWw92TlQD98isJEZ/UB8jniJw6TFjDgIpRhvyosAf+q9qCzpRY
 RuWU+HWPqgJBw/56ezj8AOOF6Vnnh517SETfMYwXOY+aFPHgJdw0Z6PQb0cWdTHzxzBmdjUJZ
 OFn41Io9Rsu5IQBS2WXX0vBUHHs2Yn3uoZoDfidHZ+87Vu+3L72ZCQBkCvjfhobffiz8DjFJP
 pgebpLdML0l0kVyIc2gv4dGgzIcFkco1ey0pbFkGj3C4zKIun7JMymFmLUAxk7pJhNsBMQEvE
 wwpIT53YTIoi0vBfls4SNSaRVd12ChUADeV+ZAPL9zM7/WiY2Z9pzHMGH6H0te4shlxf0j65R
 dU/KP9bycb90poRjjYET64+Ey1wK0PLkHsk4UrwUnddJ9IkvEqP/gfCduHfAJD4J1+5johIbT
 gHItbcI+PbAeftjBdZBh2Qnz0Aif0rHjwu6Voz+gKzBxglPT8h6ax/AdmUoRyN
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/27/18 3:13 PM, Qu Wenruo wrote:
> Although we have btrfs_uuid_tree_lookup_any(), it's an online function
> utilizing tree search ioctl, not an offline search function.
> 
> This patch will port kernel btrfs_uuid_tree_lookup() into btrfs-progs
> for later proper uuid tree initialization.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

One nitpick bellow.

Reviewed-by: Su Yue <damenly_su@gmx.com>
> ---
>   uuid-tree.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/uuid-tree.c b/uuid-tree.c
> index 320eb67e1404..b9190103c355 100644
> --- a/uuid-tree.c
> +++ b/uuid-tree.c
> @@ -23,6 +23,7 @@
>   #include "transaction.h"
>   #include "disk-io.h"
>   #include "print-tree.h"
> +#include "utils.h"
>   
>   
>   static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
> @@ -32,8 +33,11 @@ static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
>   	*key_offset = get_unaligned_le64(uuid + sizeof(u64));
>   }
>   
> -
> -/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
> +/*
> + * Search uuid tree of a *MOUNTED* btrfs (online)
> + *
> + * return -ENOENT for !found, < 0 for errors, or 0 if an item was found
> + */
>   static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
>   				      u64 *subid)
>   {
> @@ -103,3 +107,66 @@ int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
>   					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
>   					  subvol_id);
>   }
> +
> +/*
> + * Search uuid tree of an *UNMOUNTED* btrfs (offline)

For consistency of btrfs_uuid_tree_lookup_any(), I'd like to add
"> + * return -ENOENT for !found, < 0 for errors, or 0 if an item was found"
here too :).

> + */
> +static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
> +				  u8 type, u64 subid)
> +{
> +	int ret;
> +	struct btrfs_path *path = NULL;
> +	struct extent_buffer *eb;
> +	int slot;
> +	u32 item_size;
> +	unsigned long offset;
> +	struct btrfs_key key;
> +
> +	if (!uuid_root) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	btrfs_uuid_to_key(uuid, &key.objectid, &key.offset);
> +	key.type = type;
> +	ret = btrfs_search_slot(NULL, uuid_root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	eb = path->nodes[0];
> +	slot = path->slots[0];
> +	item_size = btrfs_item_size_nr(eb, slot);
> +	offset = btrfs_item_ptr_offset(eb, slot);
> +	ret = -ENOENT;
> +
> +	if (!IS_ALIGNED(item_size, sizeof(u64))) {
> +		warning("uuid item with illegal size %lu!",
> +			(unsigned long)item_size);
> +		goto out;
> +	}
> +	while (item_size) {
> +		__le64 data;
> +
> +		read_extent_buffer(eb, &data, offset, sizeof(data));
> +		if (le64_to_cpu(data) == subid) {
> +			ret = 0;
> +			break;
> +		}
> +		offset += sizeof(data);
> +		item_size -= sizeof(data);
> +	}
> +
> +out:
> +	btrfs_free_path(path);
> +	return ret;
> +}
> 

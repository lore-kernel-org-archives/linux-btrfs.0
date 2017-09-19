Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57946 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdISIso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 04:48:44 -0400
Subject: Re: [PATCH] btrfs-progs: check: check invalid extent_inline_ref type
 in lowmem
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170919083213.9082-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ab586271-41f9-611f-ec0b-179a3a030f67@gmx.com>
Date: Tue, 19 Sep 2017 16:48:30 +0800
MIME-Version: 1.0
In-Reply-To: <20170919083213.9082-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月19日 16:32, Su Yue wrote:
> Lowmem check does not skip invalid type in extent_inline_ref then
> calls btrfs_extent_inline_ref_size(type) which causes crash.
> 
> Example:
> $ ./btrfs-corrupt-block -e -l 20971520 /tmp/data_small
> corrupting extent record: key 20971520 169 0
> $ btrfs check --mode=lowmem  /tmp/data_small
> Checking filesystem on /tmp/data_small
> UUID: ee205d69-8724-4aa2-a4f5-bc8558a62169
> checking extents
> ERROR: extent[20971520 16384] backref type mismatch, missing bit: 2
> ERROR: extent[20971520 16384] backref generation mismatch,
> wanted: 7, have: 0
> ERROR: extent[20971520 16384] is referred by other roots than 3
> ctree.h:1754: btrfs_extent_inline_ref_size: BUG_ON `1` triggered,
> value 1
> btrfs(+0x543db)[0x55fabc2ab3db]
> btrfs(+0x587f7)[0x55fabc2af7f7]
> btrfs(+0x5fa44)[0x55fabc2b6a44]
> btrfs(cmd_check+0x194a)[0x55fabc2bd717]
> btrfs(main+0x88)[0x55fabc2682e0]
> /usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f021c3824ca]
> btrfs(_start+0x2a)[0x55fabc267e7a]
> [1]    5188 abort (core dumped)  btrfs check --mode=lowmem /tmp/data_small
> 
> Fix it by checking type before obtaining inline_ref size.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Code itself looks good.
And test case please.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

However, such whac-a-mole fix will finally be a nightmare to maintain.

What about integrating all of such validation checkers into one place?
So fsck part will only need to check their cross reference without 
bothering such corruption.

Just like the kernel patch I submitted some times ago.
https://www.spinics.net/lists/linux-btrfs/msg68498.html

Thanks,
Qu

> ---
>   cmds-check.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 4e0b0fe4..74c10c75 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -11565,6 +11565,10 @@ static int check_tree_block_ref(struct btrfs_root *root,
>   						offset, level + 1, owner,
>   						NULL);
>   			}
> +		} else {
> +			error("extent[%llu %u %llu] has unknown ref type: %d",
> +			      key.objectid, key.type, key.offset, type);
> +			break;
>   		}
>   
>   		if (found_ref)
> @@ -11831,6 +11835,11 @@ static int check_extent_data_item(struct btrfs_root *root,
>   			found_dbackref = !check_tree_block_ref(root, NULL,
>   				btrfs_extent_inline_ref_offset(leaf, iref),
>   				0, owner, NULL);
> +		} else {
> +			error("extent[%llu %u %llu] has unknown ref type: %d",
> +			      disk_bytenr, BTRFS_EXTENT_DATA_KEY,
> +			      disk_num_bytes, type);
> +			break;
>   		}
>   
>   		if (found_dbackref)
> 

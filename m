Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F42C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6B7218A4
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbfABKAu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 05:00:50 -0500
Received: from mout.gmx.net ([212.227.15.18]:42317 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729120AbfABKAu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 05:00:50 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MhiTL-1h1XV70OCB-00MqFy; Wed, 02
 Jan 2019 11:00:39 +0100
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <ac1e6b87-f4e3-36c0-af1a-72e3b623c80a@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <ffd4e7af-e595-92eb-b9d5-ac6d4bef1913@gmx.com>
Date:   Wed, 2 Jan 2019 18:00:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <ac1e6b87-f4e3-36c0-af1a-72e3b623c80a@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wreWr/BZ6XYm4TIykIOVK0/nRXssdA7fN64/hTViGfU2z5OVusr
 HW9F/TG7I9/bzm4v09mCYdobXGrfKcz6P43Oai4EWEzrIZzPG4p6SRggzs/FRtQr6G5yVc8
 k3wdssu4x2iraNp6I81J5YtTPPkppqav7lUEsy/OA93/EGIOyiN0m6i98ZJbAPUvvLYOref
 E95os+I4VPx0BIl03lcsg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6UFVqhMHhp8=:c3ZEV5ZmcqPiUl05Ud64eW
 I6W99Nu6gRNeA1Eeyoqp0OEwlWr/AFa5Bpdd7hJvU0CZGPylyseS6cbnxa4LLQNULq3WqrQuJ
 z8pEHA1JwxelsuiVYTqMLn0o2CTXA4h4tzXz1x6cX3QvDagAYbLcAJWQIvT6H32vYlIkSaxDC
 DB620MckbQvMga34Vwn2mahR7a+G5sGEcd19yjncQQI7oXVikAZuLu11H/OmJgT78ndlHz9p7
 6mOZngZoHSUZ8FX08TPPBWa2X5/BcL3/vlzXdl3lRxW4GtuhBtqh2y0LfZhJEi2TGkfwVNERY
 e7HCPRPXkXoBYN/98tFyryF9LDARj3UQWgtha2uo/B38TNwU6vG7nTtPpFm4nckHQbGGXEzh6
 Tl6weIuMyFRF6zGi7I+ocV5Y9qdadMpq7g6L8d8EJLLJsS7IPyAAWRuUOIh1LEAmXCVYAZnZi
 pZGxNXeN12RR8FrepMr/hlJI9SEwuPBPX1LEE4wfYADxv1yegI7tspYYpO4x5Tq7GJR5KWVxN
 LZCnqc4XCIY5D/md+wQrPhwhUrQkjEifrtjTZA4SY895FOrKjmUWjL6dh+V7hk740+VrelCah
 5LFezvCiAwfz+P7qVw5a2mjJlJ/l8sJyQr75Eeahvok+n9UUJ0PyBnbqyPOOMYQHTdLQALjOl
 iPIeI1R2umhgdoN1QkJ7phnpos+GWTeVUb6f0H/TJtPk132i1i+41QyFtEetaWREJmBcQKz8e
 zaIspHOA7jdN2upFXv2oteKj8zaLpk7xyH2uoH8pznDiO4vofPBuvXSQ1XAkja7JXrehZUw9F
 Ip0vj6IRs6VQ4GWIFIZIW9fnDUeyN0LQs7Bq1QK4Rn3GnkSbLbzoaZlZfGTgz3guF3zWyWXFm
 2GvhLcqnSbibVHZg1hoy2TdE42rN0+HT7C6f5biQTJT2p+CzB9ll0NiAZhqEGryYFAdnV85D0
 6nvNW7vPoAw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/2 下午5:13, Nikolay Borisov wrote:
> 
> 
> On 27.12.18 г. 9:13 ч., Qu Wenruo wrote:
>> Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
>> creates uuid tree at mkfs time.
>>
>> However it doesn't populate uuid tree correctly nor just create an empty
>> root.
>> It uses create_tree(), which just copies the content of fs root,
>> containing meaningless INODE_ITEM:
>>
>> v4.15 mkfs (no uuid tree creation) + kernel mount:
>>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>>   leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
>>   leaf 30572544 flags 0x1(WRITTEN) backref revision 1
>>   fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
>>   chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
>> 	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
>> 		subvol_id 5
>>
>> v4.19.1 mkfs (incorrect one), no kernel mount:
>>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>>   leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
>>   leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>>   fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
>>   chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
>> 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>> 		generation 3 transid 0 size 0 nbytes 16384
>> 		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
>> 		sequence 0 flags 0x0(none)
>> 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>> 		index 0 namelen 2 name: ..
>>
>> This patchset will fix it by populuating uuid tree properly:
>> (NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so we
>>  can only fix it by populating uuid tree correctly)
>>
>> w/ this patchset, no kernel mount:
>>   uuid tree key (UUID_TREE ROOT_ITEM 0)
>>   leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
>>   leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>>   fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
>>   chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
>> 	item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL 0x86cde09cb78bcca0) itemoff 16275 itemsize 8
>> 		subvol_id 5
>>
>> For kernel, except tree-checker needs an non-empty uuid tree, both all
>> above behavior won't cause problem, but it's always better to keep a
>> good standardized behavior.
>>
>> Furthermore, to avoid such problem from happening again, rename the
>> function create_tree() to create_empty_tree() and create_inode_tree(),
>> without an @root parameter to avoid such problem.
>>
>> Fixes: 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  disk-io.c     |   4 ++
>>  mkfs/common.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mkfs/common.h |   3 ++
>>  mkfs/main.c   |  36 +-----------------
>>  4 files changed, 112 insertions(+), 34 deletions(-)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index 5fafa144c0d3..2cb7f2097fc9 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -694,6 +694,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
>>  {
>>  	if (fs_info->quota_root)
>>  		free(fs_info->quota_root);
>> +	if (fs_info->uuid_root)
>> +		free(fs_info->uuid_root);
>>  
>>  	free(fs_info->tree_root);
>>  	free(fs_info->extent_root);
>> @@ -964,6 +966,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
>>  		free_extent_buffer(fs_info->log_root_tree->node);
>>  	if (fs_info->chunk_root)
>>  		free_extent_buffer(fs_info->chunk_root->node);
>> +	if (fs_info->uuid_root)
>> +		free_extent_buffer(fs_info->uuid_root->node);
>>  }
>>  
>>  static void free_map_lookup(struct cache_extent *ce)
>> diff --git a/mkfs/common.c b/mkfs/common.c
>> index f7e3badcf2b9..1f5e1d03a6e3 100644
>> --- a/mkfs/common.c
>> +++ b/mkfs/common.c
>> @@ -23,6 +23,7 @@
>>  #include "disk-io.h"
>>  #include "volumes.h"
>>  #include "utils.h"
>> +#include "transaction.h"
>>  #include "mkfs/common.h"
>>  
>>  static u64 reference_root_table[] = {
>> @@ -822,4 +823,106 @@ int test_minimum_size(const char *file, u64 min_dev_size)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Create a tree with all its content copied from @source
>> + *
>> + * Caller must ensure @source only has one leaf.
>> + */
>> +static int __create_tree(struct btrfs_trans_handle *trans,
>> +			 struct btrfs_root *root, u64 objectid)
>> +{
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>> +	struct btrfs_key location;
>> +	struct btrfs_root_item root_item;
>> +	struct extent_buffer *tmp;
>> +	u8 uuid[BTRFS_UUID_SIZE] = {0};
>> +	int ret;
>> +
>> +	ASSERT(btrfs_header_level(root->node) == 0);
>> +
>> +	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
>> +	if (ret)
>> +		return ret;
>> +
>> +	memcpy(&root_item, &root->root_item, sizeof(root_item));
>> +	btrfs_set_root_bytenr(&root_item, tmp->start);
>> +	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
>> +	btrfs_set_root_generation(&root_item, trans->transid);
>> +	/* clear uuid and o/ctime of source tree */
>> +	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
>> +	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
>> +	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
>> +	free_extent_buffer(tmp);
>> +
>> +	location.objectid = objectid;
>> +	location.type = BTRFS_ROOT_ITEM_KEY;
>> +	location.offset = 0;
>> +	ret = btrfs_insert_root(trans, fs_info->tree_root,
>> +				&location, &root_item);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Create an *EMPTY* tree
>> + *
>> + * Caller must ensure at the time of calling, csum tree is still empty
>> + */
>> +static int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid)
>> +{
>> +	struct btrfs_root *csum_root = trans->fs_info->csum_root;
>> +
>> +	ASSERT(btrfs_header_level(csum_root->node) == 0 &&
>> +	       btrfs_header_nritems(csum_root->node) == 0);
>> +	return __create_tree(trans, csum_root, objectid);
> 
> nit: IMO this approach (of using a tree as a prototype) is rather bogus
> since you exploit the fact that an arbitrary tree (in this case csum)
> *should* be empty and so you use it as the source for another empty
> tree. Analogically, further down you exploit the fact that the fs_tree
> has a default inode and copy that.
> 
> I'd prefer it if every tree was created explicitly so that in the future
> when its layout might change we touch the respective function. This is
> not critical but it's something to think about.

Yes, I also though about this.

The primary reason here is to reduce new code and reuse as much code as
possible.

The trade off looks OK for mkfs usage, as we have the full control of
when certain tree is empty or not.
And that's why such create_empty_tree() is only exposed for mkfs, not
ctree.h.

But considering how many create_tree() we're implementing in different
sub commands, it looks pretty valid, and I'll try to refactor these
functions using mentioned solution.

> 
>> +}
>>  
>> +/*
>> + * Create a tree containing an root inode
>> + *
>> + * Caller must ensure at the time of calling, fs tree only contains 2 items
>> + * (one for INODE_ITEM and one for INODE_REF)
>> + */
>> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)
> 
> This function is really misnamed, since it's creating the
> DATA_RELOC_TREE, yet it's called create_inode_tree. Why not simply
> create_data_reloc_tree or are you planning on using this function more
> than once?

In fact this could be used for fs, data reloc, and all subvolume trees.

That's my primary reason not naming it create_data_reloc_tree().
Although currently it's only used by data reloc tree.

> 
>> +{
>> +	struct btrfs_root *fs_root = trans->fs_info->fs_root;
>> +
>> +	ASSERT(btrfs_header_level(fs_root->node) == 0 &&
>> +	       btrfs_header_nritems(fs_root->node) == 2);
>> +	return __create_tree(trans, fs_root, objectid);
>> +}
>> +
>> +int create_uuid_tree(struct btrfs_trans_handle *trans)
>> +{
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>> +	struct btrfs_root *uuid_root = fs_info->uuid_root;
>> +	struct btrfs_key key;
>> +	int ret;
>> +
>> +	if (!uuid_root) {
> 
> Isn't this always true,  so the conditional here is redundant?
Just a much better solution than ASSERT()/BUG_ON().

It won't hurt and will handle wrong calling order.

Thanks,
Qu

> 
>> +		ret = create_empty_tree(trans, BTRFS_UUID_TREE_OBJECTID);
>> +		if (ret < 0) {
>> +			errno = -ret;
>> +			error("failed to create uuid root: %m");
>> +			return ret;
>> +		}
>> +		key.objectid = BTRFS_UUID_TREE_OBJECTID;
>> +		key.type = BTRFS_ROOT_ITEM_KEY;
>> +		key.offset = 0;
>> +		uuid_root = btrfs_read_fs_root_no_cache(fs_info, &key);
>> +		if (IS_ERR(uuid_root)) {
>> +			errno = -PTR_ERR(uuid_root);
>> +			error("failed to read uuid root: %m");
>> +			return PTR_ERR(uuid_root);
>> +		}
>> +		fs_info->uuid_root = uuid_root;
>> +	}
>> +	ret = btrfs_uuid_tree_add(trans, fs_info->fs_root->root_item.uuid,
>> +				  BTRFS_UUID_KEY_SUBVOL,
>> +				  fs_info->fs_root->root_key.objectid);
>> +	if (ret < 0) {
>> +		errno = -ret;
>> +		error("failed to add uuid tree entry for fs root: %m");
>> +	}
>> +	return ret;
>> +}
>> diff --git a/mkfs/common.h b/mkfs/common.h
>> index 28912906d0a9..adb5d561c38d 100644
>> --- a/mkfs/common.h
>> +++ b/mkfs/common.h
>> @@ -75,4 +75,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
>>  int test_status_for_mkfs(const char *file, bool force_overwrite);
>>  int test_dev_for_mkfs(const char *file, int force_overwrite);
>>  
>> +int create_uuid_tree(struct btrfs_trans_handle *trans);
>> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid);
>> +
>>  #endif
>> diff --git a/mkfs/main.c b/mkfs/main.c
>> index b6748f7fe853..ea3d1ae80e5e 100644
>> --- a/mkfs/main.c
>> +++ b/mkfs/main.c
>> @@ -309,38 +309,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>  
>> -static int create_tree(struct btrfs_trans_handle *trans,
>> -			struct btrfs_root *root, u64 objectid)
>> -{
>> -	struct btrfs_key location;
>> -	struct btrfs_root_item root_item;
>> -	struct extent_buffer *tmp;
>> -	u8 uuid[BTRFS_UUID_SIZE] = {0};
>> -	int ret;
>> -
>> -	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
>> -	if (ret)
>> -		return ret;
>> -
>> -	memcpy(&root_item, &root->root_item, sizeof(root_item));
>> -	btrfs_set_root_bytenr(&root_item, tmp->start);
>> -	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
>> -	btrfs_set_root_generation(&root_item, trans->transid);
>> -	/* clear uuid and o/ctime of source tree */
>> -	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
>> -	btrfs_set_stack_timespec_sec(&root_item.otime, 0);
>> -	btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
>> -	free_extent_buffer(tmp);
>> -
>> -	location.objectid = objectid;
>> -	location.type = BTRFS_ROOT_ITEM_KEY;
>> -	location.offset = 0;
>> -	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
>> -				&location, &root_item);
>> -
>> -	return ret;
>> -}
>> -
>>  static void print_usage(int ret)
>>  {
>>  	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
>> @@ -1203,13 +1171,13 @@ raid_groups:
>>  		goto out;
>>  	}
>>  
>> -	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
>> +	ret = create_inode_tree(trans, BTRFS_DATA_RELOC_TREE_OBJECTID);
>>  	if (ret) {
>>  		error("unable to create data reloc tree: %d", ret);
>>  		goto out;
>>  	}
>>  
>> -	ret = create_tree(trans, root, BTRFS_UUID_TREE_OBJECTID);
>> +	ret = create_uuid_tree(trans);
>>  	if (ret)
>>  		warning(
>>  	"unable to create uuid tree, will be created after mount: %d", ret);
>>

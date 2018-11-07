Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95491C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 09:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF5620827
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 09:14:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FF5620827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbeKGSoJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 13:44:09 -0500
Received: from mout.gmx.net ([212.227.15.19]:50103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGSoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 13:44:09 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lk7fW-1fmczY2CQU-00c6VL; Wed, 07
 Nov 2018 10:14:35 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lk7fW-1fmczY2CQU-00c6VL; Wed, 07
 Nov 2018 10:14:35 +0100
Subject: Re: [PATCH 09/13] btrfs-progs: Revert "btrfs-progs: Record orphan
 data extent ref to corresponding root."
To:     "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-10-suy.fnst@cn.fujitsu.com>
 <1dbd9415-9244-657d-66dd-e57f71c134ca@gmx.com>
 <619b1f82-4100-deca-fad3-5704918e1c4c@cn.fujitsu.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <4b2e8fec-5f7f-a03a-6999-a43545e38756@gmx.com>
Date:   Wed, 7 Nov 2018 17:14:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <619b1f82-4100-deca-fad3-5704918e1c4c@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Aj44myO4+DSdrk3hGc995KPhTLwXvOJCdMA5Op9t4w+2qBBY4eI
 rQL27eaGH02sOhB7hWYu+pZ6MxaqJ3PHXl79YNzpA68DUKxHQ1fjy0fiT9RCz0ab3Aavo07
 +7Q6RxDhMVzMJTq6EMjgnVN5ehrBUTwDmSW0r8L3EIHfgXLQkSZZgVAtfZHzJvN1/O11iYE
 yPYfn9ELqcHY6XTIWVdhg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:AOm06jNJtYM=:zlywFyMI4bCxgl+aVixq8W
 gtMdco13DHfDcowNDTM/17MWgsLKHpze4HHfBetl3QCMSLqqJJ/acODgN3Z3/xOXFvC5VzPn4
 Z9arWK6cvsS3GNqm5GV7R/Ne92vljLuwnYhNCTUkVMc3OsaIw5nyHrqPlRg9480MnzRpnuogp
 YxnTcR7zsHP4xUPYkZsxzxsMUfoOVez95ZhKfdnO2+KkKzpAHjrAktzQb8S5uLIJ+gooK1sBT
 umL/Nwh45ZKHspqIA1h7fpdd32FLlQIQxN6F1sjxIREwo1drXD//AAMyBuQqReDFHSpPxkckN
 46SYpguvCDHja8wA1kLOrY5EAEx6iNp4+Cwti0uSlzy+pKDyzjMLi79vLdJ2HN/ud/MkGw4wg
 LEumsv6cCfQ6AQT+NhtxgCxi1r0sXqTdIehNrvOPJiXwf8kLWWgQVnX5kNjI/Sf4NRPWzfv+p
 7ZqwXbDj5AppnTot8wDI6Ji332PGA0xyCPNz207sz6xuH2k7P+jV8dJA5i45B0HkKx4SG0mZt
 3graBawJE5YTXVzxjLzH+ySpOqHbRvraTJl+3foWQYQhqtvia32K3s25Oj/bu91SjD5sVToTD
 PjB46fIeNAyI3+47AG9lmhnSvDZwvagpffbxpmIGoYqpdXRL397A2y6jlAgZDdbWH4PYiyFKg
 +tzlIBCFgUlsdXigT2MfcpNf+jH437RMsu0bNuPBtpogYB4cIGzCTkcCUf8t7zy0oNcoxszOt
 zxFajt8s4jgseqU25IFL/xVlLkY6V33Gsn+DwsRR57Jo8JqletmJha71lDGJeyHiNsrWW+mW7
 caF1rc3Qc/ufNVoez+jnUcjpFpjpBWYtAJVEoHlBGvL21rqHJI=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/7 下午5:09, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
> 
> 
> On 10/24/2018 8:29 AM, Qu Wenruo wrote:
>>
>> On 2018/10/23 下午5:41, Su Yue wrote:
>>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>>
>>> The reason for revert is that according to the existing situation, the
>>> probability of problem in the extent tree is higher than in the fs Tree.
>>> So this feature should be removed.
>>>
>> The same problem as previous patch.
>>
>> We need an example on how such repair could lead to further corruption.
>>
>> Thanks,
>> Qu
> 
> Firstly In record_orphan_data_extents() function:
> 
>     key.objectid = dback->owner;
>     key.type = BTRFS_EXTENT_DATA_KEY;
>     key.offset = dback->offset;//
>     ret = btrfs_search_slot(NULL, dest_root, &key, &path, 0, 0);
> 
> 'dback->offset' is wrong use here.
> 
> Secondly when disk bytenr in file extent item is wrong, the file extent
> data is always inserted to fs tree which will lead to fs check failed.

What about an example like:

Before:
 (XXXX EXTENT_DATA XXXX)
   #And some description about missing INODE_ITEM

After repair:
 (XXXX EXTENT_DATA XXXX)
  # Then describe what's wrong.

IMHO, with a format similar to inspect tree, along with some
description, it will be much easier for us to understand why the old
repair is causing more problem.

Thanks,
Qu

> 
> Thanks,
> Su
> 
>>> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>> ---
>>>   check/main.c          | 120 +-----------------------------------------
>>>   check/mode-original.h |  17 ------
>>>   ctree.h               |  10 ----
>>>   disk-io.c             |   1 -
>>>   4 files changed, 1 insertion(+), 147 deletions(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 268de5dd5f26..bd1f322e0f12 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -511,22 +511,6 @@ cleanup:
>>>       return ERR_PTR(ret);
>>>   }
>>>   -static void print_orphan_data_extents(struct list_head
>>> *orphan_extents,
>>> -                      u64 objectid)
>>> -{
>>> -    struct orphan_data_extent *orphan;
>>> -
>>> -    if (list_empty(orphan_extents))
>>> -        return;
>>> -    printf("The following data extent is lost in tree %llu:\n",
>>> -           objectid);
>>> -    list_for_each_entry(orphan, orphan_extents, list) {
>>> -        printf("\tinode: %llu, offset:%llu, disk_bytenr: %llu,
>>> disk_len: %llu\n",
>>> -               orphan->objectid, orphan->offset, orphan->disk_bytenr,
>>> -               orphan->disk_len);
>>> -    }
>>> -}
>>> -
>>>   static void print_inode_error(struct btrfs_root *root, struct
>>> inode_record *rec)
>>>   {
>>>       u64 root_objectid = root->root_key.objectid;
>>> @@ -578,9 +562,6 @@ static void print_inode_error(struct btrfs_root
>>> *root, struct inode_record *rec)
>>>       if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
>>>           fprintf(stderr, ", invalid inline ram bytes");
>>>       fprintf(stderr, "\n");
>>> -    /* Print the orphan extents if needed */
>>> -    if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>>> -        print_orphan_data_extents(&rec->orphan_extents,
>>> root->objectid);
>>>         /* Print the holes if needed */
>>>       if (errors & I_ERR_FILE_EXTENT_DISCOUNT) {
>>> @@ -683,18 +664,6 @@ static struct inode_record *get_inode_rec(struct
>>> cache_tree *inode_cache,
>>>       return rec;
>>>   }
>>>   -static void free_orphan_data_extents(struct list_head
>>> *orphan_extents)
>>> -{
>>> -    struct orphan_data_extent *orphan;
>>> -
>>> -    while (!list_empty(orphan_extents)) {
>>> -        orphan = list_entry(orphan_extents->next,
>>> -                    struct orphan_data_extent, list);
>>> -        list_del(&orphan->list);
>>> -        free(orphan);
>>> -    }
>>> -}
>>> -
>>>   static void free_inode_rec(struct inode_record *rec)
>>>   {
>>>       struct inode_backref *backref;
>>> @@ -707,7 +676,6 @@ static void free_inode_rec(struct inode_record *rec)
>>>           list_del(&backref->list);
>>>           free(backref);
>>>       }
>>> -    free_orphan_data_extents(&rec->orphan_extents);
>>>       free_file_extent_holes(&rec->holes);
>>>       free(rec);
>>>   }
>>> @@ -3286,7 +3254,6 @@ skip_walking:
>>>         free_corrupt_blocks_tree(&corrupt_blocks);
>>>       root->fs_info->corrupt_blocks = NULL;
>>> -    free_orphan_data_extents(&root->orphan_data_extents);
>>>       return ret;
>>>   }
>>>   @@ -7137,88 +7104,6 @@ static int find_possible_backrefs(struct
>>> btrfs_fs_info *info,
>>>       return 0;
>>>   }
>>>   -/*
>>> - * Record orphan data ref into corresponding root.
>>> - *
>>> - * Return 0 if the extent item contains data ref and recorded.
>>> - * Return 1 if the extent item contains no useful data ref
>>> - *   On that case, it may contains only shared_dataref or metadata
>>> backref
>>> - *   or the file extent exists(this should be handled by the extent
>>> bytenr
>>> - *   recovery routine)
>>> - * Return <0 if something goes wrong.
>>> - */
>>> -static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
>>> -                      struct extent_record *rec)
>>> -{
>>> -    struct btrfs_key key;
>>> -    struct btrfs_root *dest_root;
>>> -    struct extent_backref *back, *tmp;
>>> -    struct data_backref *dback;
>>> -    struct orphan_data_extent *orphan;
>>> -    struct btrfs_path path;
>>> -    int recorded_data_ref = 0;
>>> -    int ret = 0;
>>> -
>>> -    if (rec->metadata)
>>> -        return 1;
>>> -    btrfs_init_path(&path);
>>> -    rbtree_postorder_for_each_entry_safe(back, tmp,
>>> -                         &rec->backref_tree, node) {
>>> -        if (back->full_backref || !back->is_data ||
>>> -            !back->found_extent_tree)
>>> -            continue;
>>> -        dback = to_data_backref(back);
>>> -        if (dback->found_ref)
>>> -            continue;
>>> -        key.objectid = dback->root;
>>> -        key.type = BTRFS_ROOT_ITEM_KEY;
>>> -        key.offset = (u64)-1;
>>> -
>>> -        dest_root = btrfs_read_fs_root(fs_info, &key);
>>> -
>>> -        /* For non-exist root we just skip it */
>>> -        if (IS_ERR(dest_root) || !dest_root)
>>> -            continue;
>>> -
>>> -        key.objectid = dback->owner;
>>> -        key.type = BTRFS_EXTENT_DATA_KEY;
>>> -        key.offset = dback->offset;
>>> -
>>> -        ret = btrfs_search_slot(NULL, dest_root, &key, &path, 0, 0);
>>> -        btrfs_release_path(&path);
>>> -        /*
>>> -         * For ret < 0, it's OK since the fs-tree may be corrupted,
>>> -         * we need to record it for inode/file extent rebuild.
>>> -         * For ret > 0, we record it only for file extent rebuild.
>>> -         * For ret == 0, the file extent exists but only bytenr
>>> -         * mismatch, let the original bytenr fix routine to handle,
>>> -         * don't record it.
>>> -         */
>>> -        if (ret == 0)
>>> -            continue;
>>> -        ret = 0;
>>> -        orphan = malloc(sizeof(*orphan));
>>> -        if (!orphan) {
>>> -            ret = -ENOMEM;
>>> -            goto out;
>>> -        }
>>> -        INIT_LIST_HEAD(&orphan->list);
>>> -        orphan->root = dback->root;
>>> -        orphan->objectid = dback->owner;
>>> -        orphan->offset = dback->offset;
>>> -        orphan->disk_bytenr = rec->cache.start;
>>> -        orphan->disk_len = rec->cache.size;
>>> -        list_add(&dest_root->orphan_data_extents, &orphan->list);
>>> -        recorded_data_ref = 1;
>>> -    }
>>> -out:
>>> -    btrfs_release_path(&path);
>>> -    if (!ret)
>>> -        return !recorded_data_ref;
>>> -    else
>>> -        return ret;
>>> -}
>>> -
>>>   /*
>>>    * when an incorrect extent item is found, this will delete
>>>    * all of the existing entries for it and recreate them
>>> @@ -7560,10 +7445,7 @@ static int check_extent_refs(struct btrfs_root
>>> *root,
>>>               fprintf(stderr, "extent item %llu, found %llu\n",
>>>                   (unsigned long long)rec->extent_item_refs,
>>>                   (unsigned long long)rec->refs);
>>> -            ret = record_orphan_data_extents(root->fs_info, rec);
>>> -            if (ret < 0)
>>> -                goto repair_abort;
>>> -            fix = ret;
>>> +            fix = 1;
>>>               cur_err = 1;
>>>           }
>>>           if (all_backpointers_checked(rec, 1)) {
>>> diff --git a/check/mode-original.h b/check/mode-original.h
>>> index ec2842e0b3be..ed995931fcd5 100644
>>> --- a/check/mode-original.h
>>> +++ b/check/mode-original.h
>>> @@ -57,21 +57,6 @@ static inline struct data_backref*
>>> to_data_backref(struct extent_backref *back)
>>>       return container_of(back, struct data_backref, node);
>>>   }
>>>   -/*
>>> - * Much like data_backref, just removed the undetermined members
>>> - * and change it to use list_head.
>>> - * During extent scan, it is stored in root->orphan_data_extent.
>>> - * During fs tree scan, it is then moved to
>>> inode_rec->orphan_data_extents.
>>> - */
>>> -struct orphan_data_extent {
>>> -    struct list_head list;
>>> -    u64 root;
>>> -    u64 objectid;
>>> -    u64 offset;
>>> -    u64 disk_bytenr;
>>> -    u64 disk_len;
>>> -};
>>> -
>>>   struct tree_backref {
>>>       struct extent_backref node;
>>>       union {
>>> @@ -184,7 +169,6 @@ struct file_extent_hole {
>>>   #define I_ERR_ODD_CSUM_ITEM        (1 << 11)
>>>   #define I_ERR_SOME_CSUM_MISSING        (1 << 12)
>>>   #define I_ERR_LINK_COUNT_WRONG        (1 << 13)
>>> -#define I_ERR_FILE_EXTENT_ORPHAN    (1 << 14)
>>>   #define I_ERR_FILE_EXTENT_TOO_LARGE    (1 << 15)
>>>   #define I_ERR_ODD_INODE_FLAGS        (1 << 16)
>>>   #define I_ERR_INLINE_RAM_BYTES_WRONG    (1 << 17)
>>> @@ -212,7 +196,6 @@ struct inode_record {
>>>       u64 extent_start;
>>>       u64 extent_end;
>>>       struct rb_root holes;
>>> -    struct list_head orphan_extents;
>>>         u32 refs;
>>>   };
>>> diff --git a/ctree.h b/ctree.h
>>> index 2a2437070ef9..2e0896390434 100644
>>> --- a/ctree.h
>>> +++ b/ctree.h
>>> @@ -1177,16 +1177,6 @@ struct btrfs_root {
>>>       u32 type;
>>>       u64 last_inode_alloc;
>>>   -    /*
>>> -     * Record orphan data extent ref
>>> -     *
>>> -     * TODO: Don't restore things in btrfs_root.
>>> -     * Directly record it into inode_record, which needs a lot of
>>> -     * infrastructure change to allow cooperation between extent
>>> -     * and fs tree scan.
>>> -     */
>>> -    struct list_head orphan_data_extents;
>>> -
>>>       /* the dirty list is only used by non-reference counted roots */
>>>       struct list_head dirty_list;
>>>       struct rb_node rb_node;
>>> diff --git a/disk-io.c b/disk-io.c
>>> index 4bc2e77d438a..992f4b870e9f 100644
>>> --- a/disk-io.c
>>> +++ b/disk-io.c
>>> @@ -480,7 +480,6 @@ void btrfs_setup_root(struct btrfs_root *root,
>>> struct btrfs_fs_info *fs_info,
>>>       root->last_inode_alloc = 0;
>>>         INIT_LIST_HEAD(&root->dirty_list);
>>> -    INIT_LIST_HEAD(&root->orphan_data_extents);
>>>       memset(&root->root_key, 0, sizeof(root->root_key));
>>>       memset(&root->root_item, 0, sizeof(root->root_item));
>>>       root->root_key.objectid = objectid;
>>>
>>
> 
> 
> 

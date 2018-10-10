Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C65C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2F820645
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B2F820645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbeJJQfv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:35:51 -0400
Received: from mout.gmx.net ([212.227.15.18]:36225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbeJJQfv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 12:35:51 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LaXIV-1fP3Vc1yql-00mHIg; Wed, 10
 Oct 2018 11:14:28 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LaXIV-1fP3Vc1yql-00mHIg; Wed, 10
 Oct 2018 11:14:28 +0200
Subject: Re: [PATCH v2 1/4] btrfs: Introduce find_free_extent_ctrl structure
 for later rework
To:     Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180821084426.7858-1-wqu@suse.com>
 <20180821084426.7858-2-wqu@suse.com>
 <64f3e309-a664-c844-ef13-6156dabde4d8@cn.fujitsu.com>
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
Message-ID: <e19797a3-d278-7ad7-cb21-29f4dd4a0a6c@gmx.com>
Date:   Wed, 10 Oct 2018 17:14:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <64f3e309-a664-c844-ef13-6156dabde4d8@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:NRHPx0oPlKDD/zbRuJ1xKRjsJSuSkbQDGj2xksOnnubXuGMKm1b
 vUsW70N1nRWHZ+vQiuX9TEx5U0xVGyDb+LcnrNQpth+9Kr3Q+9x6N+mb0tnbuVvkf45UEHB
 bPgJxMR0EJaq/NA5zTdY0PjgDlP5R8E8Ci7z41Mm39SpEKsvJq2t3UDEzb9oyIdVrK9zoqe
 I25LnfNzTXHVU5tdWEV/g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:A6wH/9IzkRA=:qRNW2+ISGuScC8Ru8HbRRQ
 yBCzimiBam1aW7a3bi+B9KoXTtmu0Qjlf0juLKHcq40mDxXiGypYF/DK+3iiETuvikOS95amu
 zTZrjBuIQxN/Pj6sPasrOq/uIJWZ15h21DG1E9J9UcmsgUbVcHbIjKGeOOA6tU2EnYCpL1zTz
 fJYpHwUnAmmcIo/4gh3nlNbAAt84fYkmEZ4YpWuroZ6G3Ga9ApvAw6K7ipxSj6uUPjH66pW3e
 aiDShEpTusEfPB/UjNY+XodeRDegWG2s7DxQ++wf7zTexhq38EmTO6hhpUI17F8puRjBbp0BL
 NZbmIhuKpC5do+ConE6v1bnEW8OzSqW4CGz0xXFyWX8DtAlCJ1FOafB0akToPJstFGYA6UBQy
 5WDuobKMLE75jPIBD1VdxJqoDc6E2O9GCl29y2yeF8Z7yCH1NPEf/Rf9QIH+opj1/w7CnqcHg
 YVxHSLRUSea0Xh4FLT8fM9IwtuqwOYftXUNNb9HVX9QMU9D36129N65SSBJTzHZ2gQHBuYnrH
 Oj01SMKNFSB/Np5jwIMfXEeu0SQ6B7ypjrBvw09oDmcLiy1SfWZUPgfHW7q8GMveeLJA0osUL
 FAxEU3KseVpLyU7L9nZN/UkKWWZ7h1qBZaYBHuPJZMEvkL0pRUhsc4VwFewrtKiopVqGgFr8u
 Q4pGIZZrv73uNHjiOM2MuJYceM1qjB8nSdOAlNLPg+glCJgQPMLti+5yhRo7O4zMiyg4sU+Re
 2G24Ubu1gPxdwEVQkg++GcRhG1jziLoKghTIXPldDuGFYk/TwU5FHEAuyq2Ji5vQNyuF3reoV
 wXu7FUTVp8dF44yNypkm+kPyeoMKQz2od92Jn1S7JylEP4dLiM=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/10 下午4:51, Su Yue wrote:
> 
> 
> On 8/21/18 4:44 PM, Qu Wenruo wrote:
>> Instead of tons of different local variables in find_free_extent(),
>> extract them into find_free_extent_ctrl structure, and add better
>> explanation for them.
>>
>> Some modification may looks redundant, but will later greatly simplify
>> function parameter list during find_free_extent() refactor.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/extent-tree.c | 244 ++++++++++++++++++++++++++---------------
>>   1 file changed, 156 insertions(+), 88 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index cb4f7d1cf8b0..7bc0bdda99d4 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7391,6 +7391,56 @@ btrfs_release_block_group(struct
>> btrfs_block_group_cache *cache,
>>       btrfs_put_block_group(cache);
>>   }
>>   +/*
>> + * Internal used structure for find_free_extent() function.
>> + * Wraps needed parameters.
>> + */
>> +struct find_free_extent_ctrl {
> 
> Nit: To follow existed naming style, may "find_free_extent_ctl" is more
> considerable?

Indeed, no one is using "ctrl" in current btrfs base.

> 
>> +    /* Basic allocation info */
>> +    u64 ram_bytes;
>> +    u64 num_bytes;
>> +    u64 empty_size;
>> +    u64 flags;
>> +    int delalloc;
>> +
>> +    /* Where to start the search inside the bg */
>> +    u64 search_start;
>> +
>> +    /* For clustered allocation */
>> +    u64 empty_cluster;
>> +
>> +    bool have_caching_bg;
>> +    bool orig_have_caching_bg;
>> +
>> +    /* RAID index, converted from flags */
>> +    int index;
>> +
>> +    /* Current loop number */
>> +    int loop;
>> +
>> +    /*
>> +     * Whether we're refilling a cluster, if true we need to re-search
>> +     * current block group but don't try to refill the cluster again.
>> +     */
>> +    bool retry_clustered;
>> +
>> +    /*
>> +     * Whether we're updating free space cache, if true we need to
>> re-search
>> +     * current block group but don't try updating free space cache
>> again.
>> +     */
>> +    bool retry_unclustered;
>> +
>> +    /* If current block group is cached */
>> +    int cached;
>> +
>> +
> 
> No need for the line.

Right.

Thanks,
Qu

> 
> Thanks,
> Su
>> +    /* Max extent size found */
>> +    u64 max_extent_size;
>> +
>> +    /* Found result */
>> +    u64 found_offset;
>> +};
>> +
>>   /*
>>    * walks the btree of allocated extents and find a hole of a given
>> size.
>>    * The key ins is changed to record the hole:
>> @@ -7411,20 +7461,26 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>       struct btrfs_root *root = fs_info->extent_root;
>>       struct btrfs_free_cluster *last_ptr = NULL;
>>       struct btrfs_block_group_cache *block_group = NULL;
>> -    u64 search_start = 0;
>> -    u64 max_extent_size = 0;
>> -    u64 empty_cluster = 0;
>> +    struct find_free_extent_ctrl ctrl = {0};
>>       struct btrfs_space_info *space_info;
>> -    int loop = 0;
>> -    int index = btrfs_bg_flags_to_raid_index(flags);
>> -    bool failed_cluster_refill = false;
>> -    bool failed_alloc = false;
>>       bool use_cluster = true;
>> -    bool have_caching_bg = false;
>> -    bool orig_have_caching_bg = false;
>>       bool full_search = false;
>>         WARN_ON(num_bytes < fs_info->sectorsize);
>> +
>> +    ctrl.ram_bytes = ram_bytes;
>> +    ctrl.num_bytes = num_bytes;
>> +    ctrl.empty_size = empty_size;
>> +    ctrl.flags = flags;
>> +    ctrl.search_start = 0;
>> +    ctrl.retry_clustered = false;
>> +    ctrl.retry_unclustered = false;
>> +    ctrl.delalloc = delalloc;
>> +    ctrl.index = btrfs_bg_flags_to_raid_index(flags);
>> +    ctrl.have_caching_bg = false;
>> +    ctrl.orig_have_caching_bg = false;
>> +    ctrl.found_offset = 0;
>> +
>>       ins->type = BTRFS_EXTENT_ITEM_KEY;
>>       ins->objectid = 0;
>>       ins->offset = 0;
>> @@ -7460,7 +7516,7 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>           spin_unlock(&space_info->lock);
>>       }
>>   -    last_ptr = fetch_cluster_info(fs_info, space_info,
>> &empty_cluster);
>> +    last_ptr = fetch_cluster_info(fs_info, space_info,
>> &ctrl.empty_cluster);
>>       if (last_ptr) {
>>           spin_lock(&last_ptr->lock);
>>           if (last_ptr->block_group)
>> @@ -7477,10 +7533,12 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>           spin_unlock(&last_ptr->lock);
>>       }
>>   -    search_start = max(search_start, first_logical_byte(fs_info, 0));
>> -    search_start = max(search_start, hint_byte);
>> -    if (search_start == hint_byte) {
>> -        block_group = btrfs_lookup_block_group(fs_info, search_start);
>> +    ctrl.search_start = max(ctrl.search_start,
>> +                first_logical_byte(fs_info, 0));
>> +    ctrl.search_start = max(ctrl.search_start, hint_byte);
>> +    if (ctrl.search_start == hint_byte) {
>> +        block_group = btrfs_lookup_block_group(fs_info,
>> +                               ctrl.search_start);
>>           /*
>>            * we don't want to use the block group if it doesn't match our
>>            * allocation bits, or if its not cached.
>> @@ -7502,7 +7560,7 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                   btrfs_put_block_group(block_group);
>>                   up_read(&space_info->groups_sem);
>>               } else {
>> -                index = btrfs_bg_flags_to_raid_index(
>> +                ctrl.index = btrfs_bg_flags_to_raid_index(
>>                           block_group->flags);
>>                   btrfs_lock_block_group(block_group, delalloc);
>>                   goto have_block_group;
>> @@ -7512,21 +7570,19 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>           }
>>       }
>>   search:
>> -    have_caching_bg = false;
>> -    if (index == 0 || index == btrfs_bg_flags_to_raid_index(flags))
>> +    ctrl.have_caching_bg = false;
>> +    if (ctrl.index == btrfs_bg_flags_to_raid_index(flags) ||
>> +        ctrl.index == 0)
>>           full_search = true;
>>       down_read(&space_info->groups_sem);
>> -    list_for_each_entry(block_group, &space_info->block_groups[index],
>> +    list_for_each_entry(block_group,
>> &space_info->block_groups[ctrl.index],
>>                   list) {
>> -        u64 offset;
>> -        int cached;
>> -
>>           /* If the block group is read-only, we can skip it entirely. */
>>           if (unlikely(block_group->ro))
>>               continue;
>>             btrfs_grab_block_group(block_group, delalloc);
>> -        search_start = block_group->key.objectid;
>> +        ctrl.search_start = block_group->key.objectid;
>>             /*
>>            * this can happen if we end up cycling through all the
>> @@ -7550,9 +7606,9 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>           }
>>     have_block_group:
>> -        cached = block_group_cache_done(block_group);
>> -        if (unlikely(!cached)) {
>> -            have_caching_bg = true;
>> +        ctrl.cached = block_group_cache_done(block_group);
>> +        if (unlikely(!ctrl.cached)) {
>> +            ctrl.have_caching_bg = true;
>>               ret = cache_block_group(block_group, 0);
>>               BUG_ON(ret < 0);
>>               ret = 0;
>> @@ -7580,20 +7636,21 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                 if (used_block_group != block_group &&
>>                   (used_block_group->ro ||
>> -                 !block_group_bits(used_block_group, flags)))
>> +                 !block_group_bits(used_block_group, ctrl.flags)))
>>                   goto release_cluster;
>>   -            offset = btrfs_alloc_from_cluster(used_block_group,
>> +            ctrl.found_offset = btrfs_alloc_from_cluster(
>> +                        used_block_group,
>>                           last_ptr,
>>                           num_bytes,
>>                           used_block_group->key.objectid,
>> -                        &max_extent_size);
>> -            if (offset) {
>> +                        &ctrl.max_extent_size);
>> +            if (ctrl.found_offset) {
>>                   /* we have a block, we're done */
>>                   spin_unlock(&last_ptr->refill_lock);
>>                   trace_btrfs_reserve_extent_cluster(
>>                           used_block_group,
>> -                        search_start, num_bytes);
>> +                        ctrl.search_start, num_bytes);
>>                   if (used_block_group != block_group) {
>>                       btrfs_release_block_group(block_group,
>>                                     delalloc);
>> @@ -7619,7 +7676,7 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                * first, so that we stand a better chance of
>>                * succeeding in the unclustered
>>                * allocation.  */
>> -            if (loop >= LOOP_NO_EMPTY_SIZE &&
>> +            if (ctrl.loop >= LOOP_NO_EMPTY_SIZE &&
>>                   used_block_group != block_group) {
>>                   spin_unlock(&last_ptr->refill_lock);
>>                   btrfs_release_block_group(used_block_group,
>> @@ -7637,18 +7694,19 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                   btrfs_release_block_group(used_block_group,
>>                                 delalloc);
>>   refill_cluster:
>> -            if (loop >= LOOP_NO_EMPTY_SIZE) {
>> +            if (ctrl.loop >= LOOP_NO_EMPTY_SIZE) {
>>                   spin_unlock(&last_ptr->refill_lock);
>>                   goto unclustered_alloc;
>>               }
>>                 aligned_cluster = max_t(unsigned long,
>> -                        empty_cluster + empty_size,
>> +                        ctrl.empty_cluster + empty_size,
>>                             block_group->full_stripe_len);
>>                 /* allocate a cluster in this block group */
>>               ret = btrfs_find_space_cluster(fs_info, block_group,
>> -                               last_ptr, search_start,
>> +                               last_ptr,
>> +                               ctrl.search_start,
>>                                  num_bytes,
>>                                  aligned_cluster);
>>               if (ret == 0) {
>> @@ -7656,26 +7714,29 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                    * now pull our allocation out of this
>>                    * cluster
>>                    */
>> -                offset = btrfs_alloc_from_cluster(block_group,
>> +                ctrl.found_offset = btrfs_alloc_from_cluster(
>> +                            block_group,
>>                               last_ptr,
>>                               num_bytes,
>> -                            search_start,
>> -                            &max_extent_size);
>> -                if (offset) {
>> +                            ctrl.search_start,
>> +                            &ctrl.max_extent_size);
>> +                if (ctrl.found_offset) {
>>                       /* we found one, proceed */
>>                       spin_unlock(&last_ptr->refill_lock);
>>                       trace_btrfs_reserve_extent_cluster(
>> -                        block_group, search_start,
>> +                        block_group, ctrl.search_start,
>>                           num_bytes);
>>                       goto checks;
>>                   }
>> -            } else if (!cached && loop > LOOP_CACHING_NOWAIT
>> -                   && !failed_cluster_refill) {
>> +            } else if (!ctrl.cached && ctrl.loop >
>> +                   LOOP_CACHING_NOWAIT
>> +                   && !ctrl.retry_clustered) {
>>                   spin_unlock(&last_ptr->refill_lock);
>>   -                failed_cluster_refill = true;
>> +                ctrl.retry_clustered = true;
>>                   wait_block_group_cache_progress(block_group,
>> -                       num_bytes + empty_cluster + empty_size);
>> +                       num_bytes + ctrl.empty_cluster +
>> +                       empty_size);
>>                   goto have_block_group;
>>               }
>>   @@ -7701,89 +7762,96 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>               last_ptr->fragmented = 1;
>>               spin_unlock(&last_ptr->lock);
>>           }
>> -        if (cached) {
>> +        if (ctrl.cached) {
>>               struct btrfs_free_space_ctl *ctl =
>>                   block_group->free_space_ctl;
>>                 spin_lock(&ctl->tree_lock);
>>               if (ctl->free_space <
>> -                num_bytes + empty_cluster + empty_size) {
>> -                if (ctl->free_space > max_extent_size)
>> -                    max_extent_size = ctl->free_space;
>> +                num_bytes + ctrl.empty_cluster + empty_size) {
>> +                if (ctl->free_space > ctrl.max_extent_size)
>> +                    ctrl.max_extent_size = ctl->free_space;
>>                   spin_unlock(&ctl->tree_lock);
>>                   goto loop;
>>               }
>>               spin_unlock(&ctl->tree_lock);
>>           }
>>   -        offset = btrfs_find_space_for_alloc(block_group, search_start,
>> -                            num_bytes, empty_size,
>> -                            &max_extent_size);
>> +        ctrl.found_offset = btrfs_find_space_for_alloc(block_group,
>> +                ctrl.search_start, num_bytes, empty_size,
>> +                &ctrl.max_extent_size);
>>           /*
>>            * If we didn't find a chunk, and we haven't failed on this
>>            * block group before, and this block group is in the middle of
>>            * caching and we are ok with waiting, then go ahead and wait
>> -         * for progress to be made, and set failed_alloc to true.
>> +         * for progress to be made, and set ctrl.retry_unclustered to
>> +         * true.
>>            *
>> -         * If failed_alloc is true then we've already waited on this
>> -         * block group once and should move on to the next block group.
>> +         * If ctrl.retry_unclustered is true then we've already waited
>> +         * on this block group once and should move on to the next block
>> +         * group.
>>            */
>> -        if (!offset && !failed_alloc && !cached &&
>> -            loop > LOOP_CACHING_NOWAIT) {
>> +        if (!ctrl.found_offset && !ctrl.retry_unclustered &&
>> +            !ctrl.cached && ctrl.loop > LOOP_CACHING_NOWAIT) {
>>               wait_block_group_cache_progress(block_group,
>>                           num_bytes + empty_size);
>> -            failed_alloc = true;
>> +            ctrl.retry_unclustered = true;
>>               goto have_block_group;
>> -        } else if (!offset) {
>> +        } else if (!ctrl.found_offset) {
>>               goto loop;
>>           }
>>   checks:
>> -        search_start = round_up(offset, fs_info->stripesize);
>> +        ctrl.search_start = round_up(ctrl.found_offset,
>> +                         fs_info->stripesize);
>>             /* move on to the next group */
>> -        if (search_start + num_bytes >
>> +        if (ctrl.search_start + num_bytes >
>>               block_group->key.objectid + block_group->key.offset) {
>> -            btrfs_add_free_space(block_group, offset, num_bytes);
>> +            btrfs_add_free_space(block_group, ctrl.found_offset,
>> +                         num_bytes);
>>               goto loop;
>>           }
>>   -        if (offset < search_start)
>> -            btrfs_add_free_space(block_group, offset,
>> -                         search_start - offset);
>> +        if (ctrl.found_offset < ctrl.search_start)
>> +            btrfs_add_free_space(block_group, ctrl.found_offset,
>> +                    ctrl.search_start - ctrl.found_offset);
>>             ret = btrfs_add_reserved_bytes(block_group, ram_bytes,
>>                   num_bytes, delalloc);
>>           if (ret == -EAGAIN) {
>> -            btrfs_add_free_space(block_group, offset, num_bytes);
>> +            btrfs_add_free_space(block_group, ctrl.found_offset,
>> +                         num_bytes);
>>               goto loop;
>>           }
>>           btrfs_inc_block_group_reservations(block_group);
>>             /* we are all good, lets return */
>> -        ins->objectid = search_start;
>> +        ins->objectid = ctrl.search_start;
>>           ins->offset = num_bytes;
>>   -        trace_btrfs_reserve_extent(block_group, search_start,
>> num_bytes);
>> +        trace_btrfs_reserve_extent(block_group, ctrl.search_start,
>> +                       num_bytes);
>>           btrfs_release_block_group(block_group, delalloc);
>>           break;
>>   loop:
>> -        failed_cluster_refill = false;
>> -        failed_alloc = false;
>> +        ctrl.retry_clustered = false;
>> +        ctrl.retry_unclustered = false;
>>           BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
>> -               index);
>> +               ctrl.index);
>>           btrfs_release_block_group(block_group, delalloc);
>>           cond_resched();
>>       }
>>       up_read(&space_info->groups_sem);
>>   -    if ((loop == LOOP_CACHING_NOWAIT) && have_caching_bg
>> -        && !orig_have_caching_bg)
>> -        orig_have_caching_bg = true;
>> +    if ((ctrl.loop == LOOP_CACHING_NOWAIT) && ctrl.have_caching_bg
>> +        && !ctrl.orig_have_caching_bg)
>> +        ctrl.orig_have_caching_bg = true;
>>   -    if (!ins->objectid && loop >= LOOP_CACHING_WAIT &&
>> have_caching_bg)
>> +    if (!ins->objectid && ctrl.loop >= LOOP_CACHING_WAIT &&
>> +        ctrl.have_caching_bg)
>>           goto search;
>>   -    if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
>> +    if (!ins->objectid && ++ctrl.index < BTRFS_NR_RAID_TYPES)
>>           goto search;
>>         /*
>> @@ -7794,23 +7862,23 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>        * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and
>> try
>>        *            again
>>        */
>> -    if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE) {
>> -        index = 0;
>> -        if (loop == LOOP_CACHING_NOWAIT) {
>> +    if (!ins->objectid && ctrl.loop < LOOP_NO_EMPTY_SIZE) {
>> +        ctrl.index = 0;
>> +        if (ctrl.loop == LOOP_CACHING_NOWAIT) {
>>               /*
>>                * We want to skip the LOOP_CACHING_WAIT step if we
>>                * don't have any uncached bgs and we've already done a
>>                * full search through.
>>                */
>> -            if (orig_have_caching_bg || !full_search)
>> -                loop = LOOP_CACHING_WAIT;
>> +            if (ctrl.orig_have_caching_bg || !full_search)
>> +                ctrl.loop = LOOP_CACHING_WAIT;
>>               else
>> -                loop = LOOP_ALLOC_CHUNK;
>> +                ctrl.loop = LOOP_ALLOC_CHUNK;
>>           } else {
>> -            loop++;
>> +            ctrl.loop++;
>>           }
>>   -        if (loop == LOOP_ALLOC_CHUNK) {
>> +        if (ctrl.loop == LOOP_ALLOC_CHUNK) {
>>               struct btrfs_trans_handle *trans;
>>               int exist = 0;
>>   @@ -7834,7 +7902,7 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                * case.
>>                */
>>               if (ret == -ENOSPC)
>> -                loop = LOOP_NO_EMPTY_SIZE;
>> +                ctrl.loop = LOOP_NO_EMPTY_SIZE;
>>                 /*
>>                * Do not bail out on ENOSPC since we
>> @@ -7850,18 +7918,18 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>                   goto out;
>>           }
>>   -        if (loop == LOOP_NO_EMPTY_SIZE) {
>> +        if (ctrl.loop == LOOP_NO_EMPTY_SIZE) {
>>               /*
>>                * Don't loop again if we already have no empty_size and
>>                * no empty_cluster.
>>                */
>>               if (empty_size == 0 &&
>> -                empty_cluster == 0) {
>> +                ctrl.empty_cluster == 0) {
>>                   ret = -ENOSPC;
>>                   goto out;
>>               }
>>               empty_size = 0;
>> -            empty_cluster = 0;
>> +            ctrl.empty_cluster = 0;
>>           }
>>             goto search;
>> @@ -7878,9 +7946,9 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>   out:
>>       if (ret == -ENOSPC) {
>>           spin_lock(&space_info->lock);
>> -        space_info->max_extent_size = max_extent_size;
>> +        space_info->max_extent_size = ctrl.max_extent_size;
>>           spin_unlock(&space_info->lock);
>> -        ins->offset = max_extent_size;
>> +        ins->offset = ctrl.max_extent_size;
>>       }
>>       return ret;
>>   }
>>
> 
> 

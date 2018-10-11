Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C6BC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8E02077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E8E02077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbeJKTL1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:11:27 -0400
Received: from mout.gmx.net ([212.227.17.22]:60255 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeJKTL1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:11:27 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MO7Ca-1g534C2TqO-005Z8j; Thu, 11
 Oct 2018 13:43:57 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MO7Ca-1g534C2TqO-005Z8j; Thu, 11
 Oct 2018 13:43:57 +0200
Subject: Re: [PATCH v2 3/4] btrfs: Refactor unclustered extent allocation into
 find_free_extent_unclustered()
To:     Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180821084426.7858-1-wqu@suse.com>
 <20180821084426.7858-4-wqu@suse.com>
 <b0f516ff-c5c9-1689-23b8-4226d39d8a68@cn.fujitsu.com>
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
Message-ID: <72e0e18a-eb43-0a57-1631-d8e3176b7f04@gmx.com>
Date:   Thu, 11 Oct 2018 19:43:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <b0f516ff-c5c9-1689-23b8-4226d39d8a68@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:scpDWkhs8N5nX9tbnFI1kUsv4aXXHi+fKegZIKT0RwhrKkz7Tzl
 Vze2mrgNP9kJdMVJQSt3bigq28wRJxXq/Cjkk31LZ3zlggisfpFtOpdPpQV7LT4JV2Lg0YI
 B4cYI20NDGpH8qT+x2047vx0/udGah9P3TcEV3c+AwrPQIZSK7FIIudNUTDvMZCc/IHjId3
 /xxPqvOii0HLDCkIuHj7A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:wR91Pf0VDfg=:FMitRQUrficsPf9tjdPWop
 UqDYwzvkBGQQ3j+0dAis5Ljo1FAev7+ZWD+YFJsBiknziyxKEa7Vp8MxMKLDYUdUp1cP7XHJ3
 OdPExhhtD5bcGkFwEV9tWaab7LQRw1Z9SNWU4gRjQfc9DbWQKg+iXd8pvVNBc60zcLCyLZIFb
 2JWedBVlojLvcYwvsM3a8hKSZM/qTbSYPokGhN0G+PRvyediq84uVfMYWrZGYubsVvL3f3nRj
 KLwwkuCC/Z9PeEnpJFGSxO1xCqFmVPNz6+hjKdKPOEw6XvBFZG44ZeluaxA/YCEP4NqbZ6wbq
 NELaoX1imlx/JiAgqi9Tmuh2M++Cp2Uws/kmNYyBNIcHt9gLBlEr21PkL/2YqYSrHxGtc59Fo
 JoDbqCFKBZSY/RbIegfLPpzIwgfE5R+WISKt96b66KOWXDXaG5APo+Ph6/ztQditTJDGPahne
 wRz5mRO5oDPUlBOyXHC+4PomI+oTEvgOVfVabZ9BS7DQAPdW0nyftcOLvOrPrjEzrFfrpf2UN
 UaJDy8t0lz62wGfvV8xB8ZOMZge1KwpiqT7BkL6V5D2u2F7WtEdeVviY/a3bTz8KAcwdCOzTS
 d/IANkb2L1qQNCLjQA5gNco0R3HCSXEHVy6JH6LxFiIOXfo3XlVgRkGeSS4QnJ6D4wyku0tWx
 sd4wlXlKZhf4o7K0xzKDg/fgpheOKANQPCJjkFM1P0W1eqyzPhGH6TQgtjbpAGtp4y3qrIsrl
 erh4J2ZKoeC2seWW/fn4/qgw5CGbH5rsJV4II8TTbzzAW1zWh7jfxd1XaOKRjavMF5nFFV5iJ
 9uXiG2AxboSw5aBDxqgd7GuPljXCwgPY42UnsNceSzy4WJsWmY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/11 上午10:15, Su Yue wrote:
> 
> 
> On 8/21/18 4:44 PM, Qu Wenruo wrote:
>> This patch will extract unclsutered extent allocation code into
>> find_free_extent_unclustered().
>>
>> And this helper function will use return value to indicate what to do
>> next.
>>
>> This should make find_free_extent() a little easier to read.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.c | 112 ++++++++++++++++++++++++-----------------
>>   1 file changed, 66 insertions(+), 46 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a603900e0eb8..5bc8919edac2 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7546,6 +7546,67 @@ static int find_free_extent_clustered(struct
>> btrfs_block_group_cache *bg,
>>       return 1;
>>   }
>>   +/*
>> + * Return >0 to inform caller that we find nothing
>> + * Return -EAGAIN to inform caller that we need to re-search this
>> block group
> 
> How about adding description of return 0?

Although 0 is pretty boring, it still makes sense.
Will be in next update

Thanks,
Qu
> 
> Thanks,
> Su
>> + */
>> +static int find_free_extent_unclustered(struct
>> btrfs_block_group_cache *bg,
>> +        struct btrfs_free_cluster *last_ptr,
>> +        struct find_free_extent_ctrl *ctrl)
>> +{
>> +    u64 offset;
>> +
>> +    /*
>> +     * We are doing an unclustered alloc, set the fragmented flag so we
>> +     * don't bother trying to setup a cluster again until we get more
>> space.
>> +     */
>> +    if (unlikely(last_ptr)) {
>> +        spin_lock(&last_ptr->lock);
>> +        last_ptr->fragmented = 1;
>> +        spin_unlock(&last_ptr->lock);
>> +    }
>> +    if (ctrl->cached) {
>> +        struct btrfs_free_space_ctl *free_space_ctl;
>> +
>> +        free_space_ctl = bg->free_space_ctl;
>> +        spin_lock(&free_space_ctl->tree_lock);
>> +        if (free_space_ctl->free_space <
>> +            ctrl->num_bytes + ctrl->empty_cluster + ctrl->empty_size) {
>> +            ctrl->max_extent_size = max_t(u64,
>> +                    ctrl->max_extent_size,
>> +                    free_space_ctl->free_space);
>> +            spin_unlock(&free_space_ctl->tree_lock);
>> +            return 1;
>> +        }
>> +        spin_unlock(&free_space_ctl->tree_lock);
>> +    }
>> +
>> +    offset = btrfs_find_space_for_alloc(bg, ctrl->search_start,
>> +            ctrl->num_bytes, ctrl->empty_size,
>> +            &ctrl->max_extent_size);
>> +
>> +    /*
>> +     * If we didn't find a chunk, and we haven't failed on this block
>> group
>> +     * before, and this block group is in the middle of caching and
>> we are
>> +     * ok with waiting, then go ahead and wait for progress to be
>> made, and
>> +     * set @retry_unclustered to true.
>> +     *
>> +     * If @retry_unclustered is true then we've already waited on
>> this block
>> +     * group once and should move on to the next block group.
>> +     */
>> +    if (!offset && !ctrl->retry_unclustered && !ctrl->cached &&
>> +        ctrl->loop > LOOP_CACHING_NOWAIT) {
>> +        wait_block_group_cache_progress(bg, ctrl->num_bytes +
>> +                        ctrl->empty_size);
>> +        ctrl->retry_unclustered = true;
>> +        return -EAGAIN;
>> +    } else if (!offset) {
>> +        return 1;
>> +    }
>> +    ctrl->found_offset = offset;
>> +    return 0;
>> +}
>> +
>>   /*
>>    * walks the btree of allocated extents and find a hole of a given
>> size.
>>    * The key ins is changed to record the hole:
>> @@ -7747,54 +7808,13 @@ static noinline int find_free_extent(struct
>> btrfs_fs_info *fs_info,
>>               /* ret == -ENOENT case falss through */
>>           }
>>   -        /*
>> -         * We are doing an unclustered alloc, set the fragmented flag so
>> -         * we don't bother trying to setup a cluster again until we get
>> -         * more space.
>> -         */
>> -        if (unlikely(last_ptr)) {
>> -            spin_lock(&last_ptr->lock);
>> -            last_ptr->fragmented = 1;
>> -            spin_unlock(&last_ptr->lock);
>> -        }
>> -        if (ctrl.cached) {
>> -            struct btrfs_free_space_ctl *ctl =
>> -                block_group->free_space_ctl;
>> -
>> -            spin_lock(&ctl->tree_lock);
>> -            if (ctl->free_space <
>> -                num_bytes + ctrl.empty_cluster + empty_size) {
>> -                if (ctl->free_space > ctrl.max_extent_size)
>> -                    ctrl.max_extent_size = ctl->free_space;
>> -                spin_unlock(&ctl->tree_lock);
>> -                goto loop;
>> -            }
>> -            spin_unlock(&ctl->tree_lock);
>> -        }
>> -
>> -        ctrl.found_offset = btrfs_find_space_for_alloc(block_group,
>> -                ctrl.search_start, num_bytes, empty_size,
>> -                &ctrl.max_extent_size);
>> -        /*
>> -         * If we didn't find a chunk, and we haven't failed on this
>> -         * block group before, and this block group is in the middle of
>> -         * caching and we are ok with waiting, then go ahead and wait
>> -         * for progress to be made, and set ctrl.retry_unclustered to
>> -         * true.
>> -         *
>> -         * If ctrl.retry_unclustered is true then we've already waited
>> -         * on this block group once and should move on to the next block
>> -         * group.
>> -         */
>> -        if (!ctrl.found_offset && !ctrl.retry_unclustered &&
>> -            !ctrl.cached && ctrl.loop > LOOP_CACHING_NOWAIT) {
>> -            wait_block_group_cache_progress(block_group,
>> -                        num_bytes + empty_size);
>> -            ctrl.retry_unclustered = true;
>> +        ret = find_free_extent_unclustered(block_group, last_ptr,
>> +                           &ctrl);
>> +        if (ret == -EAGAIN)
>>               goto have_block_group;
>> -        } else if (!ctrl.found_offset) {
>> +        else if (ret > 0)
>>               goto loop;
>> -        }
>> +        /* ret == 0 case falls through */
>>   checks:
>>           ctrl.search_start = round_up(ctrl.found_offset,
>>                            fs_info->stripesize);
>>
> 
> 

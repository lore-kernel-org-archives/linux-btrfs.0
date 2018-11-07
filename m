Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225AAC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 06:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFBAE2081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 06:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFBAE2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbeKGQJW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 11:09:22 -0500
Received: from mout.gmx.net ([212.227.15.19]:38085 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbeKGQJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 11:09:22 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGjL7-1gGD2o1u5Z-00DW1o; Wed, 07
 Nov 2018 07:40:20 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGjL7-1gGD2o1u5Z-00DW1o; Wed, 07
 Nov 2018 07:40:20 +0100
Subject: Re: [PATCH 10/13] btrfs-progs: check: fix bug in
 find_possible_backrefs
To:     "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-11-suy.fnst@cn.fujitsu.com>
 <ebe648fe-e947-e874-9a88-7d34f942c746@gmx.com>
 <c5eec2b3-7597-c920-f86f-0a3441079b92@cn.fujitsu.com>
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
Message-ID: <51fa6a57-655e-347b-a75d-f5ca9c7640d9@gmx.com>
Date:   Wed, 7 Nov 2018 14:40:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c5eec2b3-7597-c920-f86f-0a3441079b92@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zPiVib7ROXfk3VRTeznvrGxBg6gRCL4hwNdrPyhXd7XYSPME6A4
 1nBOQwfvWGPp+g4FjxVn0aFsghVvwMdd/u7+T9jM1cdMUxKZpNWSswtCRVG4ezzj8vSkR6r
 +IuLcmmGqQ9X2WtKhMbdGlT4XEI9vipaFGqEoV59/Ycbc0zVb3LYzn26qVlhAkN0o+392PN
 QsrqLLen3l3taauSWEndg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:1dTHTm0FDvg=:vqUYPlpIbyBim550974XzS
 M7ozCnPZWzFLfEt6mh65qEzQ501a/QSc3LAzBNA3wJPhSPguIHJfEWI+WCVgOlhAjR8eOsLQA
 /N3fz5flVSHoYV+yw0updhdGcI2961JB16ERWxANS9TiRTz4Gf93H4ZvSd4145yOFm2p0Y98P
 UlE5L/bWBpgmuiK1UrYyDiEPCZZibhjwQoQ+9p9nje4IYeLgjOgAywT8Ud/TI+UNN7BJebg7c
 89uUWOAxiVJ0VIbY77cv+2wuSj9Oc0kqCD0YOe5efCQyjwjSbF0XDah1hbSJqBIJ8lAfzBy+Q
 2ju2n6jnIOHF/FR7NywqAe1O8Gn+qspWP2WSHiBKYSYaOIc2uTav+1J1+9asA+RvAkxOhKOrT
 FY6zAP45WpM259oCjf9vzh8hjevQTvmdeJXq0oqLT11uf+G6GNWZAS+OKkivHBcStikBpO7ER
 RtrBykj4wt8FmXc23WCgK06gtl8dyxa5usFoi3Qr6047rnH9C9jTucPqFGlFtL9PrxS0CrDeU
 n/wutbMUYhJ8Rli+bg2Sh868bqk4NHCVuUfApo1lp0pCrZLREfXg3hzdOY+lreWpEYbCf1g7M
 nnUn6XGhk1M4SJ9PXKrqEMUFjlHHVAUE3tWVAbCIdmpBE1bUCBjTFNlA6+q8qUkcU452czBaB
 bmGsuDffV77NCQo+uLijxPHwJkIHS+9DZoXTNj8Ta/urCYTLmdZZ08fXXrf7LYNU4XDaPPb8o
 DqwP5UYxxyyA7R5w4Bisyx3p3sejPtFt5EYm2QVmV3qhzIhWK3xah3rtrWIYtiBYaLi+HzADD
 6o5JCbx/74wixYq0pCxKbjc/YcYRL+tbX+dbLqmo0c1NW/Z85U=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/7 下午2:28, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
> 
> 
> On 10/24/2018 8:34 AM, Qu Wenruo wrote:
>>
>> On 2018/10/23 下午5:41, Su Yue wrote:
>>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>>
>>> It may cost more time to search all extent data of correspond files but
>>> should not influence total speed too much cause that only corrupted
>>> extent items are participated in.
>> Sorry, I didn't really get the point of the modification from the commit
>> message.
>>
>> Would you please explain the purpose of this patch first?
>>
>> Thanks,
>> Qu
> 
> In find_possible_backrefs() function:
> 
>     key.objectid = dback->owner;
>     key.type = BTRFS_EXTENT_DATA_KEY;
>     key.offset = dback->offset;//
>     ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> 
> 'dback->offset' is not the offset in file range, we'll find wrong file
> extent.

Now this makes sense.

The original commit message doesn't touch this part, and focused on the
side effect, not the problem itself.

Please update the commit message.

Thanks,
Qu

> 
> Thanks,
> 
> Su
> 
>>> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>> ---
>>>   check/main.c | 110 ++++++++++++++++++++++++++++++++++++++++++---------
>>>   1 file changed, 92 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index bd1f322e0f12..90d9fd570287 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -7015,6 +7015,89 @@ out:
>>>       return ret ? ret : nr_del;
>>>   }
>>>   +/*
>>> + * Based extent backref item, we find all file extent items in the
>>> fs tree. By
>>> + * the info we can rebuild the extent backref item
>>> + */
>>> +static int __find_possible_backrefs(struct btrfs_root *root,
>>> +        u64 owner, u64 offset, u64 bytenr, u64 *refs_ret,
>>> +        u64 *bytes_ret)
>>> +{
>>> +    int ret = 0;
>>> +    struct btrfs_path path;
>>> +    struct btrfs_key key;
>>> +    struct btrfs_key found_key;
>>> +    struct btrfs_file_extent_item *fi;
>>> +    struct extent_buffer *leaf;
>>> +    u64 backref_offset, disk_bytenr;
>>> +    int slot;
>>> +
>>> +    btrfs_init_path(&path);
>>> +
>>> +    key.objectid = owner;
>>> +    key.type = BTRFS_INODE_ITEM_KEY;
>>> +    key.offset = 0;
>>> +
>>> +    ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>>> +    if (ret > 0)
>>> +        ret = -ENOENT;
>>> +    if (ret) {
>>> +        btrfs_release_path(&path);
>>> +        return ret;
>>> +    }
>>> +
>>> +    btrfs_release_path(&path);
>>> +
>>> +    key.objectid = owner;
>>> +    key.type = BTRFS_EXTENT_DATA_KEY;
>>> +    key.offset = 0;
>>> +
>>> +    ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
>>> +    if (ret < 0) {
>>> +        btrfs_release_path(&path);
>>> +        return ret;
>>> +    }
>>> +
>>> +    while (1) {
>>> +        leaf = path.nodes[0];
>>> +        slot = path.slots[0];
>>> +
>>> +        if (slot >= btrfs_header_nritems(leaf)) {
>>> +            ret = btrfs_next_leaf(root, &path);
>>> +            if (ret) {
>>> +                if (ret > 0)
>>> +                    ret = 0;
>>> +                break;
>>> +            }
>>> +
>>> +            leaf = path.nodes[0];
>>> +            slot = path.slots[0];
>>> +        }
>>> +
>>> +        btrfs_item_key_to_cpu(leaf, &found_key, slot);
>>> +        if ((found_key.objectid != owner) ||
>>> +            (found_key.type != BTRFS_EXTENT_DATA_KEY))
>>> +            break;
>>> +
>>> +        fi = btrfs_item_ptr(leaf, slot,
>>> +                struct btrfs_file_extent_item);
>>> +
>>> +        backref_offset = found_key.offset -
>>> +            btrfs_file_extent_offset(leaf, fi);
>>> +        disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
>>> +        *bytes_ret = btrfs_file_extent_disk_num_bytes(leaf,
>>> +                                fi);
>>> +        if ((disk_bytenr == bytenr) &&
>>> +            (backref_offset == offset)) {
>>> +            (*refs_ret)++;
>>> +        }
>>> +        path.slots[0]++;
>>> +    }
>>> +
>>> +    btrfs_release_path(&path);
>>> +    return ret;
>>> +}
>>> +
>>>   static int find_possible_backrefs(struct btrfs_fs_info *info,
>>>                     struct btrfs_path *path,
>>>                     struct cache_tree *extent_cache,
>>> @@ -7024,9 +7107,9 @@ static int find_possible_backrefs(struct
>>> btrfs_fs_info *info,
>>>       struct extent_backref *back, *tmp;
>>>       struct data_backref *dback;
>>>       struct cache_extent *cache;
>>> -    struct btrfs_file_extent_item *fi;
>>>       struct btrfs_key key;
>>>       u64 bytenr, bytes;
>>> +    u64 refs;
>>>       int ret;
>>>         rbtree_postorder_for_each_entry_safe(back, tmp,
>>> @@ -7054,24 +7137,15 @@ static int find_possible_backrefs(struct
>>> btrfs_fs_info *info,
>>>           if (IS_ERR(root))
>>>               return PTR_ERR(root);
>>>   -        key.objectid = dback->owner;
>>> -        key.type = BTRFS_EXTENT_DATA_KEY;
>>> -        key.offset = dback->offset;
>>> -        ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>>> -        if (ret) {
>>> -            btrfs_release_path(path);
>>> -            if (ret < 0)
>>> -                return ret;
>>> -            /* Didn't find it, we can carry on */
>>> -            ret = 0;
>>> +        refs = 0;
>>> +        bytes = 0;
>>> +        ret = __find_possible_backrefs(root, dback->owner,
>>> +                dback->offset, rec->start, &refs, &bytes);
>>> +        if (ret)
>>>               continue;
>>> -        }
>>>   -        fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
>>> -                    struct btrfs_file_extent_item);
>>> -        bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], fi);
>>> -        bytes = btrfs_file_extent_disk_num_bytes(path->nodes[0], fi);
>>> -        btrfs_release_path(path);
>>> +        bytenr = rec->start;
>>> +
>>>           cache = lookup_cache_extent(extent_cache, bytenr, 1);
>>>           if (cache) {
>>>               struct extent_record *tmp;
>>> @@ -7090,7 +7164,7 @@ static int find_possible_backrefs(struct
>>> btrfs_fs_info *info,
>>>                   continue;
>>>           }
>>>   -        dback->found_ref += 1;
>>> +        dback->found_ref += refs;
>>>           dback->disk_bytenr = bytenr;
>>>           dback->bytes = bytes;
>>>  
>>
> 
> 
> 

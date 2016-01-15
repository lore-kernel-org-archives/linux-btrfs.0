Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751930AbcAOBlg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 20:41:36 -0500
Subject: Re: [PATCH v4 07/18] btrfs: dedup: Implement btrfs_dedup_calc_hash
 interface
To: <fdmanana@gmail.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1452751054-2365-8-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H4gpHUCZrBK6WLJMhDaj+j_gJJguZwTVzLO6E0eR0fgNw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56984E3D.50703@cn.fujitsu.com>
Date: Fri, 15 Jan 2016 09:41:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4gpHUCZrBK6WLJMhDaj+j_gJJguZwTVzLO6E0eR0fgNw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/01/14 10:08 +0000:
> On Thu, Jan 14, 2016 at 5:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Unlike in-memory or on-disk dedup method, only SHA256 hash method is
>> supported yet, so implement btrfs_dedup_calc_hash() interface using
>> SHA256.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/dedup.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 57 insertions(+)
>>
>> diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
>> index d6ee576..8860916 100644
>> --- a/fs/btrfs/dedup.c
>> +++ b/fs/btrfs/dedup.c
>> @@ -465,3 +465,60 @@ int btrfs_dedup_search(struct inode *inode, u64 file_pos,
>>          }
>>          return ret;
>>   }
>> +
>> +static int hash_data(struct btrfs_dedup_info *dedup_info, const char *data,
>> +                    u64 length, struct btrfs_dedup_hash *hash)
>> +{
>> +       struct crypto_shash *tfm = dedup_info->dedup_driver;
>> +       struct {
>> +               struct shash_desc desc;
>> +               char ctx[crypto_shash_descsize(tfm)];
>> +       } sdesc;
>> +       int ret;
>> +
>> +       sdesc.desc.tfm = tfm;
>> +       sdesc.desc.flags = 0;
>> +
>> +       ret = crypto_shash_digest(&sdesc.desc, data, length,
>> +                                 (char *)(hash->hash));
>> +       return ret;
>> +}
>> +
>> +int btrfs_dedup_calc_hash(struct btrfs_root *root, struct inode *inode,
>> +                         u64 start, struct btrfs_dedup_hash *hash)
>> +{
>> +       struct page *p;
>> +       struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
>> +       char *data;
>> +       int i;
>> +       int ret;
>> +       u64 dedup_bs;
>> +       u64 sectorsize = root->sectorsize;
>> +
>> +       if (!dedup_info || !hash)
>> +               return 0;
>> +
>> +       WARN_ON(!IS_ALIGNED(start, sectorsize));
>> +
>> +       dedup_bs = dedup_info->blocksize;
>> +       sectorsize = root->sectorsize;
>> +
>> +       data = kmalloc(dedup_bs, GFP_NOFS);
>> +       if (!data)
>> +               return -ENOMEM;
>> +       for (i = 0; sectorsize * i < dedup_bs; i++) {
>> +               char *d;
>> +
>> +               /* TODO: Add support for subpage size case */
>> +               p = find_get_page(inode->i_mapping,
>> +                                 (start >> PAGE_CACHE_SHIFT) + i);
>> +               WARN_ON(!p);
>
> If !p, we should return with an error too, otherwise we'll get a null
> pointer dereference below.

Right, and that's also true for all the caller of find_get_page() in btrfs.

I'll also locate and fix them in another patch before btrfs dedup patchset.

Thanks for the review and hint.
Qu

>
>> +               d = kmap_atomic(p);
>> +               memcpy((data + sectorsize * i), d, sectorsize);
>> +               kunmap_atomic(d);
>> +               page_cache_release(p);
>> +       }
>> +       ret = hash_data(dedup_info, data, dedup_bs, hash);
>> +       kfree(data);
>> +       return ret;
>> +}
>> --
>> 2.7.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>



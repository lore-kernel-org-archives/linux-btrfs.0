Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B80C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 02:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 580E520645
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 02:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 580E520645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbeLKCDQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 21:03:16 -0500
Received: from mout.gmx.net ([212.227.17.20]:55003 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbeLKCDP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 21:03:15 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF5C3-1ggifW3GCh-00GHLm; Tue, 11
 Dec 2018 03:03:02 +0100
Subject: Re: [PATCH 7/8] btrfs: extent-tree: Use btrfs_ref to refactor
 btrfs_inc_extent_ref()
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-8-wqu@suse.com>
 <cfd001a5-f0af-3729-48e8-b82d831ce21d@suse.com>
 <20181210172809.GK23615@twin.jikos.cz>
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
Message-ID: <a55adc77-85d2-311f-b34a-443ac09a1d30@gmx.com>
Date:   Tue, 11 Dec 2018 10:02:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181210172809.GK23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UpscxN5QdUZYs0JemD3lcUOfsThGXzcb4eFfgEfKj9fa9WG7fCo
 3CPuBsUDSDpZUaBPh+NzuE5I0Xog2r9EkOHbj30nugfkxHpEWuFleUwZ9nFP8JXpYPPOrpE
 SBntPHYIzzjTiFPPij2C/bZmoF9SLEFHvcHNwgJdkTlUcYb1CA6eYTtiTrHrxfjAFAIdBwI
 Oq/avEftyQiVDHWEfI64g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Is6KhLEPWok=:73l8YCm33Eh+JH8ZTi+gR0
 1XHZoLhXWK5iWn91AtyjJtNubz6+G1hBzRGxGH1rEuYQImvC6mufV08+cdqgCdFffKCxEZC8J
 rO9Gnsr0ziDeFvKNq6lsgSpPKuZqPGWuFiGnbYgeuZOxYeitfNJtNn2ugHX3b6Ni2PQvNHrCE
 kzrl6lKjDuKKX5ePA1MeYQoEkVcwCWO6hk1ZdDYuVSECEGiZNKDoK0sw7QJy3dHsqFUQXZtXa
 035lFEB8CcDMqz6KPEGZRIHNvLfEbGdN9ZTUB34wwo7SzXe49NfdekJH8flaY59KUol9d2EVT
 wbaChvw/zRd753hPXS0Zmmdj0R3O9z8L5m8cN4ivUOhqTmYxhdSBkNYQHIIm/ymbnkUjgbeaP
 cKc5n6i4qoIkdjXKZnNK7eVsUZ9L09OsrRNW/QMygvd+GsaTx6z6Y/6Tvnma8OXc2bYe/yPZM
 3sTMjZwUTQ0CTCeUE8k4Kv7etFBg/+FhC5nrxZB2+URAMCi5fO7Yi1uk6IDz/epen3iwxmBmY
 3LrfWo3qVzYTw7Ri3l4+nxebo9lFyZcjdI9CFTgJ+1/gmjZFetPIwVgnrxt4fr68l9ffvVJai
 8l9tyf5sNoZOiY6VgboM2PYEkutxea1Z2K4CPeOikrJB06liUDIXyiNdjl2w819k85ratY4r+
 vU2i9hDPDilinfJh/5wUb2JBGqkD5+zmf/B8OStgMtIbw8NUQtU0sI/H4KxBWvEQ31ewogN4a
 AkLqj0Fa6hp6Fu2r2el/soFdnr1wToJMmpafTYHfLLMxPI3iLmEDni451MNbdVqZK5o82/cDY
 b2n3Fd9s5Ushqy4YlSRIvs9ZkRNTi5rhNOC5NBZA/ADe8ww3rufIXNZbTEvuB361Gj44vMNQ0
 fs1ZiQnsYDt8kxVoT4L6mkFL8oCHeiUTZ2YkuCGEYXYnV5JaJr/3SDCkGJWf8uH/ZVr1MB35H
 KlmeTOUZa3A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/11 上午1:28, David Sterba wrote:
> On Mon, Dec 10, 2018 at 11:52:25AM +0200, Nikolay Borisov wrote:
>> On 6.12.18 г. 8:59 ч., Qu Wenruo wrote:
>>> Now we don't need to play the dirty game of reusing @owner for tree block
>>> level.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/ctree.h       |  6 ++---
>>>  fs/btrfs/extent-tree.c | 58 ++++++++++++++++++++++--------------------
>>>  fs/btrfs/file.c        | 20 ++++++++++-----
>>>  fs/btrfs/inode.c       | 10 +++++---
>>>  fs/btrfs/ioctl.c       | 17 ++++++++-----
>>>  fs/btrfs/relocation.c  | 44 ++++++++++++++++++++------------
>>>  fs/btrfs/tree-log.c    | 12 ++++++---
>>>  7 files changed, 100 insertions(+), 67 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 6f4b1e605736..db3df5ce6087 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -40,6 +40,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
>>>  extern struct kmem_cache *btrfs_path_cachep;
>>>  extern struct kmem_cache *btrfs_free_space_cachep;
>>>  struct btrfs_ordered_sum;
>>> +struct btrfs_ref;
>>>  
>>>  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
>>>  
>>> @@ -2682,10 +2683,7 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
>>>  void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
>>>  int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
>>>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>> -			 struct btrfs_root *root,
>>> -			 u64 bytenr, u64 num_bytes, u64 parent,
>>> -			 u64 root_objectid, u64 owner, u64 offset,
>>> -			 bool for_reloc);
>>> +			 struct btrfs_ref *generic_ref);
>>>  
>>>  int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
>>>  int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 70c05ca30d9a..ff60091aef6b 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -2026,36 +2026,28 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>>>  
>>>  /* Can return -ENOMEM */
>>>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>> -			 struct btrfs_root *root,
>>> -			 u64 bytenr, u64 num_bytes, u64 parent,
>>> -			 u64 root_objectid, u64 owner, u64 offset,
>>> -			 bool for_reloc)
>>> +			 struct btrfs_ref *generic_ref)
>>>  {
>>> -	struct btrfs_fs_info *fs_info = root->fs_info;
>>> -	struct btrfs_ref generic_ref = { 0 };
>>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>>  	int old_ref_mod, new_ref_mod;
>>>  	int ret;
>>>  
>>> -	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
>>> -	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
>>> +	BUG_ON(generic_ref->type == BTRFS_REF_NOT_SET ||
>>> +	       !generic_ref->action);
>>
>> Ouch, we should be removing BUG_ONs and not introducing new ones. Make
>> it an assert

Oh I forgot this one, it should be ASSERT().

>>
>>> +	BUG_ON(generic_ref->type == BTRFS_REF_METADATA &&
>>> +	       generic_ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID);
>>
>> Ideally this should also be converted to an assert. I guess it could
>> only happen if the filesystem is corrupted so perhaps is redundant now?

This is from the original code, just changed to btrfs_ref interface.

Unlike previous easy check, this one could happen by careless caller,
just one wrong @ref_root could easily lead to this BUG_ON().

> 
> I think we need more types of assert, not all BUG_ONs can be replaced by
> ASSERT as behaviour would change depending ond CONFIG_BTRFS_ASSERTS. IMO
> the asserts are best suited for development-time checks and cannot
> replace runtime-checks where the BUG_ON is a big hammer to stop
> execution otherwise it would cause worse things later.

Yep, so I kept the original BUG_ON().
(Although forgot to use ASSERT() for the new check)

> 
> This was mentioned in the past a few times, what we really don't want
> are new BUG_ONs instead of proper error handling. The rest would be nice
> to annotate by comments why it's there and that there's really no other
> way around that.

Then I'd go back to my old practice, return EINVAL/EUCLEAN with proper
error message.
By that way, we won't continue under all case, and with proper error
message to info developer to simplify user debug.

The only reason for me not to do this practice this time is, I didn't
see much adoption except me.

So if there is some positive feedback, I'd like to use such practice more.

Thanks,
Qu

> 
> I don't recall all the ideas so am not saying either way for the asserts
> or bugons. Both would be ok here and full audit of BUG_ONs is one of my
> long-term projects so it would get sorted eventually.
> 

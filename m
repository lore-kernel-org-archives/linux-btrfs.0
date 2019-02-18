Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86B6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91B152184A
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfBRJd1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:33:27 -0500
Received: from mout.gmx.net ([212.227.17.20]:50363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfBRJd0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:33:26 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MRGvT-1gTmU512lD-00UWuF; Mon, 18
 Feb 2019 10:33:03 +0100
Subject: Re: [PATCH v5.1 12/12] btrfs: Do mandatory tree block check before
 submitting bio
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-13-wqu@suse.com>
 <7a0248d2-754d-e352-796b-df41f9fbce53@suse.com>
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
Message-ID: <21bfa550-7efb-5405-bb2c-01689567c788@gmx.com>
Date:   Mon, 18 Feb 2019 17:32:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <7a0248d2-754d-e352-796b-df41f9fbce53@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:C8BuKPDMjTFUUqsOg+vGxHAzL/5T/5EbV8O5CgI44aXoNxAgFgr
 U72X0wZqjvoYJSK4CneTWB9DJn0hYiOabRRDTg1nfKC+CF72S+jdvIokWbYBmtzNGfeuF8t
 KlOGVeHONny7Bxu2ApBFFtWeWzXmNJ5JwMm1ZVUD8vkYxXmJCMRwDfjn7hwuSjP3T7s3sAX
 0GUYDe6NDvmVxSFvi6Mwg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FyYt/QXlTJM=:dtDN4q33bzYNjNFpzfGyas
 1EhtXI/c7+FGCmLBsqsAYGverE/wDSJz5dd8ZFrL/eS7KWw/ScLfdb9pRh0UpiR7JDNVRU2rr
 +oFAYgei1Dtbry/B45jrulTW5VaV8ohkWU6PrvS38wlQeefjPlnYi0f8VNx0pbRWH/zh6uXr1
 70cCVHbfErNlPS+p/7fgfHxyjbiMkz2unjDwu8aGbuItpkxRzUOPoP3lJAIAgNeEtoZ5j0G8/
 sZq50qp/R6beglOQ8HBcgY6T2R9fOfLjOJ7qReFqjooxfzdVXz2wd6BmO5J+q0e3BtswZAgpd
 5dX1m0kHRcJUSK2yjJ0GzE3Lbd65yZCByLlqiaszo7AwP3OLPvaNPmhLibGzsWPAUgl7SaSX3
 2APWE/Lq2iaGpVhmrgEizSNPeqjIdiBP+y8JpFkZO5ustGntqXdT7Jo5WRFPK3wbcgHNtvzo6
 K9XN/9KzA7299q1yd4Yl8uRXX0kztamW+X5H0diEQCOjWgzVFzo23y9Kdkl4umV4ITpDyBXqO
 1h/Cm5dMTx/jIbSkNZCoiw22kR3mRR2V45G66xi9EXB5LP1iw01EMWFhSvu2+3GXhLtAaNGUP
 ty+8JUFVwTpb2NAiIRhC72LWGcFPeEksWLxomzJDNOzzMu1JWSN4bqBUdpuyf5fmDjvzRkn0l
 JixfpC5vLbjWFHx/ZUlmyc89rFdW8Y+2EnRVH+qMQ431msTgXx2ehKYIV0UMfC6Wg4w/dd2ZY
 +py8kuFdmtBJvo3EDeLvPvajrNEDpZomz/hdO1oOIi/f+DhGSPL4LuwxTrtYnas9WdxP9ns5R
 wwnIBu4dxRYmqLT7LT2mB0MK4vIAQlnLDyFLymiu0AHvIlIVTve/KPE5eya0wjRxmAOsUshW+
 V/f8WwgkFUUFhAV6g6bp3h+/Dz111OJt5lo5TXCauypVj+vLks+C36+8EAgqNheGdrxVkHuBf
 V93sCYWM0IA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[snip]
>>
>> Reported-by: Leonard Lausen <leonard@lausen.nl>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c      | 10 ++++++++++
>>  fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
>>  fs/btrfs/tree-checker.h |  8 ++++++++
>>  3 files changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 6052ab508f84..fff789f8db63 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>>  			return -EUCLEAN;
>>  		}
>>  	} else {
>> +		if (btrfs_header_level(buf))
>> +			err = btrfs_check_node(fs_info, buf);
>> +		else
>> +			err = btrfs_check_leaf_write(fs_info, buf);
>> +		if (err < 0) {
>> +			btrfs_err(fs_info,
>> +			"block=%llu write time tree block corruption detected",
>> +				  buf->start);
>> +			return err;
>> +		}
> 
> This code should be moved in csum_dirty_buffer. Currently there is
> pending cleanups in csum_tree_block and the final if there will be
> removed and respective read/write code factored out in
> csum_dirty_buffer/btree_readpage_end_io_hook.

I have no preference here.
As long as the timing isn't changed, I'm fine either way.

But at least, from my last check on misc-next, there is no conflict at
all. So the pending cleanup isn't so pending right now?

Thanks,
Qu

> 
> Eventually csum_tree_block's sole purpose should be to calculate the
> checksum and nothing more.
> 
>>  		write_extent_buffer(buf, result, 0, csum_size);
>>  	}
>>  
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index a62e1e837a89..b8cdaf472031 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -477,7 +477,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>>  }
>>  
>>  static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>> -		      bool check_item_data)
>> +		      bool check_item_data, bool check_empty_leaf)
>>  {
>>  	/* No valid key type is 0, so all key should be larger than this key */
>>  	struct btrfs_key prev_key = {0, 0, 0};
>> @@ -516,6 +516,18 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>>  				    owner);
>>  			return -EUCLEAN;
>>  		}
>> +
>> +		/*
>> +		 * Skip empty leaf check, mostly for write time tree block
>> +		 *
>> +		 * Such skip mostly happens for tree block write time, as
>> +		 * we can't use @owner as accurate owner indicator.
>> +		 * Case like balance and new tree block created for commit root
>> +		 * can break owner check easily.
>> +		 */
>> +		if (!check_empty_leaf)
>> +			return 0;
>> +
>>  		key.objectid = owner;
>>  		key.type = BTRFS_ROOT_ITEM_KEY;
>>  		key.offset = (u64)-1;
>> @@ -636,13 +648,19 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>>  int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
>>  			  struct extent_buffer *leaf)
>>  {
>> -	return check_leaf(fs_info, leaf, true);
>> +	return check_leaf(fs_info, leaf, true, true);
>>  }
>>  
>>  int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
>>  			     struct extent_buffer *leaf)
>>  {
>> -	return check_leaf(fs_info, leaf, false);
>> +	return check_leaf(fs_info, leaf, false, true);
>> +}
>> +
>> +int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *leaf)
>> +{
>> +	return check_leaf(fs_info, leaf, false, false);
>>  }
>>  
>>  int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
>> diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
>> index ff043275b784..6f8d1b627c53 100644
>> --- a/fs/btrfs/tree-checker.h
>> +++ b/fs/btrfs/tree-checker.h
>> @@ -23,6 +23,14 @@ int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
>>   */
>>  int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
>>  			     struct extent_buffer *leaf);
>> +
>> +/*
>> + * Write time specific leaf checker.
>> + * Don't check if the empty leaf belongs to a tree root. Mostly for balance
>> + * and new tree created in current transaction.
>> + */
>> +int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *leaf);
>>  int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
>>  
>>  #endif
>>

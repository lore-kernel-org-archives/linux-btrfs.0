Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB64C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90569208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90569208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbeKPS2C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:28:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:49048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727405AbeKPS2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:28:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 375C8ACD3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:16:43 +0000 (UTC)
Subject: Re: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-8-wqu@suse.com>
 <05314eb4-29e5-8c30-05ca-5566ec12eb83@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
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
Message-ID: <b3a56874-b52e-5dbb-74fd-b1a40757965c@suse.de>
Date:   Fri, 16 Nov 2018 16:16:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <05314eb4-29e5-8c30-05ca-5566ec12eb83@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/16 下午4:13, Nikolay Borisov wrote:
> 
> 
> On 16.11.18 г. 9:54 ч., Qu Wenruo wrote:
>> The only location is the following code:
>>
>> 	int level = path->lowest_level + 1;
>>  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
>>  	while(level < BTRFS_MAX_LEVEL) {
>> 		slot = path->slots[level] + 1;
>> 		...
>> 	}
>> 	path->slots[level] = slot;
>>
>> Again, it's the stupid compiler needs some hint for the fact that
>> we will always enter the while loop for at least once, thus @slot should
>> always be initialized.
>>
>> Fix it by assign level after the BUG_ON(), so the stupid compiler knows
>> we will always go into the while loop.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> I don't get this warning on gcc 7.3. Also from your changelog it's not
> really clear what the compiler is confused about.

My gcc 8.2.1 reports it with "make W=1"

I'll just update the commit message with the original report:

  ctree.c: In function 'btrfs_next_sibling_tree_block':
  ctree.c:2990:21: warning: 'slot' may be used uninitialized in this
function [-Wmaybe-uninitialized]
    path->slots[level] = slot;
    ~~~~~~~~~~~~~~~~~~~^~~~~~

Thanks,
Qu

> 
> Codewise lgtm:
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
>> ---
>>  ctree.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/ctree.c b/ctree.c
>> index 46e2ccedc0bf..9c9cb0dfdbf2 100644
>> --- a/ctree.c
>> +++ b/ctree.c
>> @@ -2961,11 +2961,12 @@ int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
>>  				  struct btrfs_path *path)
>>  {
>>  	int slot;
>> -	int level = path->lowest_level + 1;
>> +	int level;
>>  	struct extent_buffer *c;
>>  	struct extent_buffer *next = NULL;
>>  
>>  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
>> +	level = path->lowest_level + 1;
>>  	while(level < BTRFS_MAX_LEVEL) {
>>  		if (!path->nodes[level])
>>  			return 1;
>>

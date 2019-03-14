Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6A2C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B6D21019
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfCNIC3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:02:29 -0400
Received: from mout.gmx.net ([212.227.17.20]:53295 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfCNIC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 04:02:29 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9vnQ-1hAy673kts-00B6Ql; Thu, 14
 Mar 2019 09:02:13 +0100
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
To:     Nikolay Borisov <nborisov@suse.com>, Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190314075041.28966-1-kjlu@umn.edu>
 <b0b494f4-8686-8e50-faca-625d6f89bbe3@suse.com>
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
Message-ID: <50fa02f1-18c0-b039-ec2f-e16b715f53ff@gmx.com>
Date:   Thu, 14 Mar 2019 16:02:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <b0b494f4-8686-8e50-faca-625d6f89bbe3@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:A6CImGBwyH0Buf3Q3eyiImwF7EuHV6hkHF78MlKq1juKlRU/bQ2
 9Tcb6BYexmmdQzrAQNiuxkTFfxqyZVKg8fw3AuBeanI+bD+mbnXRBokxtg/b7BvkNr0qQr6
 kWO323c10C6/xyPcWNDZNQHv4d+W94i9h1ZCXtifqERkSsv/lqSKniIDnhsEyklioP1rub8
 UYTGIUxrO9smLMCin+2SQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aEUq/oyfppk=:x5uHxWuHttfcSiRKJU1nWo
 SHs+cy7kFSKsCmQ6KXkD6YIbceD5u7EqrqrRDUfNnSp5Ss1HqOoZIIyITXvOxzpwNedWXYRap
 dZPICgrwX34klqZtKeePqS7XTbtRl5FjYwJX83VuwZYGvo4wB0mCBPXiGb3ZaSlKYRbT83uMO
 u1VZGXSXqFrP6R4eAlVpKPDyenqck/o0ZZbxMJSkiY8C0AhYBjbprZQpZBpiZoyldsWOECJg2
 Ig7IUMTteMwvJzWIov7SWORntW2R4RG5ecXFpMMbJgniN1TiFG04QwOUBha7ZzoG+kb4lApg4
 TrJcZsxRWhRWAZeoEyrVb8FAUsYw9IKo9BmKU1SzFOVneGdKakG/iNlWleOrfQJVhtyNFpbTK
 eSnK5TllOfZzyKdi2LyQhYYcRBl/hfWpa9r9fjpyiITtTxIDr3Gz4KSRwC1dZ+ePGCKtvzmiP
 3TGeSQ+JneJP9QZJPg/515nNhCWF5CkIhvorXEzdAhke7O7uvnpf8oRjWoIlvpdZRTY+3ShG0
 Xr4/hjMwD/iQGkL4OaOvvhBxl1K9w6AGesrWtp7RMBscap3Lg8Nj+Q18QxZEdPaFooTLGRdmm
 baKmgQ3/okUpeDWz0Q9S3zA+Ce9Z7fr4ECShSK7hDdQbXNW71z49cuHKZBCBE/6K3h+nCRkMf
 R5+KNShqHZ3Y8eaGktIkHOE9qM8qwvI8jv9Pk/aznv7x0YLCFJRul42hp/yI/TaLama51mkzK
 SC8y3KeA8D8NqZwpqE8uTOwE4vkPiiEABstTQbz3D2ULMW2nncyF+CHOcNZWlxVUr0ealvPUH
 d/IMUrIG2FSqdQF+GQ8tabVD70Q5uNhqJHMERA8MjuiHklQ0T+y5uxjup9GfGwsDPdh36AjGj
 /HBpg8Nol/A+faOOyYJfSMjBTEBOY/vKkUqxbiuVF6LVrlIe8m0HGJfR483RiCERWgVNsgh+f
 2iQWfwrnu9A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/14 下午3:54, Nikolay Borisov wrote:
> 
> 
> On 14.03.19 г. 9:50 ч., Kangjie Lu wrote:
>> btrfs_lookup_block_group may fail and return NULL. The fix goes
>> to out when it fails to avoid NULL pointer dereference.
> 
> Actually no, in this case btrfs_lookup_block_group must never fail
> because if we have an allocated eb then it must have been allocated from
> a bg.

Yep, that's the normal case.

However I'm wondering if it's possible to get a bad eb which is cached.

Then we could hit such situation.

So I still believe being safe here still makes sense, especially who
knows future fuzzed image will be.

Thanks,
Qu

> 
>>
>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>> ---
>>  fs/btrfs/extent-tree.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 994f0cc41799..b1e7985bcb9d 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7303,6 +7303,8 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>>  
>>  		pin = 0;
>>  		cache = btrfs_lookup_block_group(fs_info, buf->start);
>> +		if (!cache)
>> +			goto out;
>>  
>>  		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
>>  			pin_down_extent(fs_info, cache, buf->start,
>>

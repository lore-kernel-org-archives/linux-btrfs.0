Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7619DC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3BC20875
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:22:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3BC20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbeJEQUq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:20:46 -0400
Received: from mout.gmx.net ([212.227.17.21]:51559 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbeJEQUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 12:20:46 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lxt3Q-1fce702GNo-015Mi0; Fri, 05
 Oct 2018 11:22:47 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lxt3Q-1fce702GNo-015Mi0; Fri, 05
 Oct 2018 11:22:47 +0200
Subject: Re: [PATCH 1/2] btrfs: volumes: Make sure there is no overlap dev
 extents at mount time
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181005082525.22441-1-wqu@suse.com>
 <20181005082525.22441-2-wqu@suse.com>
 <658c8276-4294-d31f-7c63-83fa244dc213@suse.com>
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
Message-ID: <6b144bff-a328-98ac-b243-b82092ddbdc3@gmx.com>
Date:   Fri, 5 Oct 2018 17:22:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <658c8276-4294-d31f-7c63-83fa244dc213@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lT+bexgI2cuN/xIWHzbsv3iiYGJS9OFdLUw4/Ikujuid70r12+d
 9BQdoEWgaT8FJBW2Ie4t+TQ/HUvlqpu1ARE0SQyFViPtWzy9hE0MloX4TxJs+4SyyD8NwiY
 GrD+5LcIivUDG0HTAV6NDpJKp9Kfln3u1ChAQfnHQDfG0BmZ3AYGwjdMNPWfieCepHYGkl3
 3FfR8MCHorkaUNJVvDsqg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:E5+k7i+8xs0=:wY5dsAAP2id5NMzGlFMR9I
 n7eBQan82HW2X33QRPG0klnh3Xu0vAWyeF8B1pNMLFXIHNN1s+fatk6WPjj3nS5meShdvGjCE
 DsxdZ9TQXTF7cA97LPrrrejpLFmTvfHI+8mFiRBxb8HP5gYdxvZF+ciVGySdNqYlVj5/17NlN
 c9FsRdQI18estcH5pLd7ndxKf7wuNlMHSYyVPI3Lzw5ycvwCkNQKNwJsUY68cJ5HXs+47BZ+k
 jDuN9U+68B5h2djjUS1ZkQyQtIJWZ2dT0gkKClLI371/EssPNeRe+de0wlogAaloXf3x2BiS8
 kTMveYaMjudVUdl4iuEzv8rwv2o9PtCNR7FJnu0O+6aek6nD8qeApmsQZBtZUK+Qnf8mxaJi1
 iff7mkhbBnbqi5lL7D7PPzY4J/veTzg3JX7uVF+qvYCm971PXFMprZky+A3HqlUp9OoH4fat/
 L4gY/Ni6P5BdZAWSCWVhvSgWCp42hoNIf0wSBD8iot3i/nzWFZpBRMRYGmEsYfav47oRItNTP
 qHdXbb/Sw9QxiigH+rfTLUqA5cQjCz4rjdqb6XX6uU2GB3hx9OqFzchyJAF1oMc/ufTKLdkta
 tIas2D2tQf4SnuNBl3e4YG632VJnWC1oeIzGUl13m7O3tw0zVFYXEaU13MihI3qUZcFjK1++7
 nkECuaWQTyuT+fPzs0U84S6/9VbAMkVms2vCVA3S5OCxCPLdFndxlzcbkVhsPnzXg2QJiqNQa
 hUCyeajC+9yeSsaZB+vQDSSzwaCqjI23yQ2V3qXCdrpoxIs1DIMGYDONEXgEllEdq+Mq/QYf+
 9YehYEh/Xkp+kI7fO6rIfp9UIZEj0keWzsguVcdm47GRSX584w=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/5 下午4:56, Nikolay Borisov wrote:
> 
> 
> On  5.10.2018 11:25, Qu Wenruo wrote:
>> Enhance btrfs_verify_dev_extents() to remember previous checked dev
>> extents, so it can check if one dev extent overlaps with previous dev extent.
>>
>> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> If this is related to the initial report here:
> 
> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
> 
> I'd rather have it as a link to the commit:
> 
> Link:
> https://lore.kernel.org/linux-btrfs/b3461a38-e5f8-f41d-c67c-2efac8129054@mendix.com/

I'd prefer something shorter, like.
Link: https://www.spinics.net/lists/linux-btrfs/msg82370.html

Is there any shorter URL version from lore.kernel.org?

Will add such tag in next version.

Thanks,
Qu

> 
> Since I wouldn't expect this occur but clearly there is a bug.
> 
> 
>> ---
>>  fs/btrfs/volumes.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index da86706123ff..bf0b2c16847a 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -7462,6 +7462,8 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>>  	struct btrfs_path *path;
>>  	struct btrfs_root *root = fs_info->dev_root;
>>  	struct btrfs_key key;
>> +	u64 prev_devid = 0;
>> +	u64 prev_dev_ext_end = 0;
>>  	int ret = 0;
>>  
>>  	key.objectid = 1;
>> @@ -7506,10 +7508,22 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>>  		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
>>  		physical_len = btrfs_dev_extent_length(leaf, dext);
>>  
>> +		/* Check if this dev extent over lap with previous one */
>> +		if (devid == prev_devid && physical_offset < prev_dev_ext_end) {
>> +			btrfs_err(fs_info,
>> +"dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
>> +				  devid, physical_offset, prev_dev_ext_end);
>> +			ret = -EUCLEAN;
>> +			goto out;
>> +		}
>> +
>>  		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
>>  					    physical_offset, physical_len);
>>  		if (ret < 0)
>>  			goto out;
>> +		prev_devid = devid;
>> +		prev_dev_ext_end = physical_offset + physical_len;
>> +
>>  		ret = btrfs_next_item(root, path);
>>  		if (ret < 0)
>>  			goto out;
>>

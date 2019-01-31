Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0347FC282D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 00:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27DD20823
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 00:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfAaADv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 19:03:51 -0500
Received: from mout.gmx.net ([212.227.15.18]:59169 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfAaADv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 19:03:51 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MAQXq-1gzOtj290M-00BerI; Thu, 31
 Jan 2019 01:03:42 +0100
Subject: Re: [PATCH v4 03/12] btrfs: disk-io: Show the timing of corrupted
 tree block explicitly
To:     Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-4-wqu@suse.com> <20190130145719.GS2900@twin.jikos.cz>
 <2c22a5e9-41d0-d62a-ad88-5be3da59e441@suse.com>
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
Message-ID: <0d1caf58-8015-2fdb-d75d-60870b13312c@gmx.com>
Date:   Thu, 31 Jan 2019 08:03:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2c22a5e9-41d0-d62a-ad88-5be3da59e441@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:aMjSTRlzPLa9IHF6rgmVL/JToKRc6E2npcI+LGOgaklU8DRs8Q4
 DWqvT/NpM2ZOkRn7X4ZBd8LgL/XOwx8obo+3zURHeu2cn0oFqX+/nfkpUjQeXA1LfrqU12B
 lKv+2kUH/nIF5ajkQ5jtmtwfGWqRnnhAP4Ntk34RG3DBqSaVKl9Db1ekgWRcofWQ9p5mAOX
 WCfWDP3vtKwbybW/sravg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wdD9sxI0M9s=:4X7UXoxpVnloDnvK3jpSdH
 MI9/NoSGL0SWaAnD5uRf/jGRcCGysxFLQpcrqksTdqmBuJasl6R9dSBIv34DMhd45HGBNOHAx
 ydz4h916QbHI9sYlukZDT9RVqwR49OnZh1CizZdlzhA9BuxtaT9jLvvAmPv2DfM3DXEyEuu9h
 mDzukIlORaa3fLHHo1HN8RjICDxY/f6VdvUqR/PJyweEwZN/shQbHxlQZ+UUSE4xWOY6erx7N
 2tr+IB+AAj/+INlLEhzHLkeRMrUHQgUdHd2JIkrZjsAn9uNFUBWUXLx0+o7LDjs1p7/mFDbU2
 ipsYqg58MCkoObWv0jwuOLsjYBtUV6cR0tV70fIfkrbnb53AwcZnN5oq7FY97L5rm+NnGy+Ua
 CKrT4Wn7xzgWG57EMOWMsYFo8e1Zm2PZBOM8HtaUyrQfI+49ot6EyHdbw3gg1fWKpusvxYjVA
 gvIOH7DPAkps4rmjee+MwtV5KD++SFcudjSQ6BOIqEiVNVgivuOAQNLd4uCPe3DCxiOVDB4GJ
 wa6WuWUazzFDOlLxwMpPnOWSr4+fOZTgYPbBKPNP6KvOMmU2V7q/0HLGse80SxLWR01x1B7Uh
 wyhBYgdHo1t41Mcbs+YYZzRIP0NMs2xSdq4MpJjwqJthJW+Qd6N029KjKuuvW0jai5FNc6R7J
 2Nn/x0MD3RhVkBgAnAUA8wwyObGbrfzUpP9Bliap2F++7HcbugNoXtOwz3d+1tPZzPKVtH9pC
 k42jqeNCc3Sp05solWDNm0Eu2N/beBQ9bkvNfmVv914hApkh7IHo7/FGW+jEX3AFkwbeWXkhi
 s4/Pg5TS1Pw9EJ65tLfWFa7kWT+X2ARB9vePcv+4Eu5i7BLhDaRyNGrbSo7QW7Tp+YjSkNnI6
 3/dbN2+IeNKbPQoL6S6+nZmPzLiocOK09jdcUzmotkIEUkXnJvfmkkcN8xvLRBANCxdbbsdVo
 vnE3F3swtrw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/30 下午10:59, Nikolay Borisov wrote:
> 
> 
> On 30.01.19 г. 16:57 ч., David Sterba wrote:
>> On Fri, Jan 25, 2019 at 01:09:16PM +0800, Qu Wenruo wrote:
>>> Just add one extra line to show when the corruption is detected.
>>> Currently only read time detection is possible.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>  fs/btrfs/disk-io.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 794d5bb7fe33..426e9f450f70 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -658,6 +658,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>>  
>>>  	if (!ret)
>>>  		set_extent_buffer_uptodate(eb);
>>> +	else
>>> +		btrfs_err(fs_info, "read time tree block corrupted detected");
>>
>> I'm not sure the 'read time' is clear enoug, my suggestion is to use
>> 'post-read' (and pre-write analogicaly). What do you think?
> 
> 
> How about "error during tree block reading" or "error reading treeblock"?

Nikolay's suggestion looks more straightforward to me.

+1 for his idea.

The 'post-read' still could confuse end-user IMHO.

Thanks,
Qu

> 
>>

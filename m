Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2234C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EAB320868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EAB320868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbeJLQS1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:18:27 -0400
Received: from mout.gmx.net ([212.227.15.18]:60615 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeJLQS1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:18:27 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7Xi3-1fQSYA0wKN-00xNGl; Fri, 12
 Oct 2018 10:46:58 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7Xi3-1fQSYA0wKN-00xNGl; Fri, 12
 Oct 2018 10:46:58 +0200
Subject: Re: [PATCH 2/2] btrfs-progs: Deprecate unused super block member
 log_root_transid
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181012064258.27033-1-wqu@suse.com>
 <20181012064258.27033-2-wqu@suse.com>
 <2b4ff29a-ff9b-8b56-ef13-4b76e72a281f@suse.com>
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
Message-ID: <fbb5f43e-8eb0-08c6-a1c9-855efd960d3d@gmx.com>
Date:   Fri, 12 Oct 2018 16:46:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <2b4ff29a-ff9b-8b56-ef13-4b76e72a281f@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lg/FoMlZGNAnMAZAEe8mX/sWqeqePmzHtmXEcPNAofRgHDqr5DE
 x4/jC2dF35nrgDKObzW+8/l4YAncRpZN215zgWuDsv0a7g07f3k3yZ9bYwSQE/U/Rn6gCPd
 /9LYBamAIUAVnswsiBg/J88RdmoM36P4ODp0r0JcTRsGyb/GCsZzqCuIaq8O3I6QP+FsZwd
 E8QG2ofgo7x+J8ibH8T9Q==
X-UI-Out-Filterresults: notjunk:1;V01:K0:bfAwA7yuQ78=:NRHFYf5vrIeo1wLcLsBO6B
 rSLdz8VH0fqND1eqiZar5W2pXUAIq5lYnCq4I1Ng5itv0/1agjtVWcVumT4qaFfR8ZxQd2OFV
 42HHWJF+13Uh0+iJbLPCcmcNMwFicMGrs1c0zMMzjbpgkRlHXod6d8o3Mwo7MeoeqfO7z7rh6
 zXm+/f8jqfghZynT2NKEVmoD3REfju2Q10ZrItD8527HSz9a2c97X8KcHVew9QXfD/JtrbSmr
 3T3IGwwYk364aRgHeVGr6IAqgqmEPPOkj449ytbJNmeGWNnthkUd8doyHvMKCWYr5IRo+ZBpQ
 lehvWjuWXpOZxomKOrVGJ/VvTj28ye2k9iOzHCAS9/uD8n1dtybUsKL71MmuoJ9ugRawwGJv0
 lWFZ3AxWbyeJYxJhUPcFk/rfxlbsRHZiFcHHuDXIkP3cCvuuh0O2/OiRg3vT0GJuiVBweGXCk
 v04SCilZF0e5pYdnSfBQO8wM1xDQJ0c9nVpx7UiB7k6IebsU2a9Avvyp0K1APyF+jWDdmBEQw
 B3hBp5hpDWBSJE0lbQrDta9MjG2Cw8V+/9ZjJnWGVQRFCilTFV/SIM1iTphN5WnYeRxeWYpQu
 uJLxMNDy1ut+NlEti+T2UZ12e6DmxXLdgyrQBsGerQ56zlbHcYdRF3VFcv57jC8mmo9vHsmxb
 SYJ0WtkpvnB0UXlxZjVhJufoo0BSE8XudHZ/m/z7VA3vT4H1su2u53fbmDB6aoTRSdlq2YVHx
 3YwmD/45hDeG082Oq9aipGWGBH/I+aB7Jiz2oY2kc/lk0u5z95EG5+/QPOo4G+MbBU9+spUxR
 oFDSnL4zzX/MNaGfkHjUi5AXszDYeCshiwYurPmKEdDI9kyd4Q=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/12 下午2:53, Nikolay Borisov wrote:
> 
> 
> On 12.10.2018 09:42, Qu Wenruo wrote:
>> The only user of it is "btrfs inspect dump-super".
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  cmds-inspect-dump-super.c | 4 ++--
>>  ctree.h                   | 6 ++----
>>  2 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
>> index e965267c5d96..3f33931ed9bc 100644
>> --- a/cmds-inspect-dump-super.c
>> +++ b/cmds-inspect-dump-super.c
>> @@ -387,8 +387,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>>  	       (unsigned long long)btrfs_super_chunk_root_level(sb));
>>  	printf("log_root\t\t%llu\n",
>>  	       (unsigned long long)btrfs_super_log_root(sb));
>> -	printf("log_root_transid\t%llu\n",
>> -	       (unsigned long long)btrfs_super_log_root_transid(sb));
>> +	printf("log_root_transid (deprecated)\t%llu\n",
>> +	       le64_to_cpu(sb->__unused_log_root_transid));
> 
> This should be entirely removed.

It looks OK to me.
Just like the old leafsize.

And if we try to use this member again, even old progs could show it
without problem.

Thanks,
Qu

> 
>>  	printf("log_root_level\t\t%llu\n",
>>  	       (unsigned long long)btrfs_super_log_root_level(sb));
>>  	printf("total_bytes\t\t%llu\n",
>> diff --git a/ctree.h b/ctree.h
>> index 4719962df67d..a314fdb102b0 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -427,8 +427,8 @@ struct btrfs_super_block {
>>  	__le64 chunk_root;
>>  	__le64 log_root;
>>  
>> -	/* this will help find the new super based on the log root */
>> -	__le64 log_root_transid;
>> +	/* This member is never touched, should always be 0 */
>> +	__le64 __unused_log_root_transid;
>>  	__le64 total_bytes;
>>  	__le64 bytes_used;
>>  	__le64 root_dir_objectid;
>> @@ -2203,8 +2203,6 @@ BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
>>  			 chunk_root_level, 8);
>>  BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block,
>>  			 log_root, 64);
>> -BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
>> -			 log_root_transid, 64);
>>  BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
>>  			 log_root_level, 8);
>>  BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
>>

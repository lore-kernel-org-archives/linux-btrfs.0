Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D79C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F291A2184B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hsBbC/CW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfDRGth (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:49:37 -0400
Received: from mout.gmx.net ([212.227.17.20]:60669 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfDRGtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 02:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555570167;
        bh=oekkLbX7JEL4sGodgRXtOPwXU6xsgW84VKn4zokKYWk=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=hsBbC/CW5/oPd8wF1UCAZxr4j2AUPZCgsmSZRSUDkun4TUtHKDhH22d3gJpbTmcYb
         La9pxkMwzhPms+agoekT59QkeOwgYeL59ZTJq5MW142jhq1gXq2Ia3LSi/WPi1NMR/
         oiac3EP3CwT97p/nXDkuuGHBpHsFZNRA9EwpbX5s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Md31i-1hZET13idu-00I9nR; Thu, 18
 Apr 2019 08:49:26 +0200
Subject: Re: [PATCH] btrfs: volumes: Check memory allocation failure for
 alloc_btrfs_bio()
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190418062807.32340-1-wqu@suse.com>
 <32da9d6c-0870-c5a6-4b7e-11404a2663ef@suse.com>
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
Message-ID: <303a8588-8ab0-7827-203e-469d9ae4c33c@gmx.com>
Date:   Thu, 18 Apr 2019 14:49:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <32da9d6c-0870-c5a6-4b7e-11404a2663ef@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q3IOxmvwxbUyhbbxI0bDKqFRCM/ICZKuPFQZoTXRPt1yjHCYYyq
 zdi8iui04w7KUCVU+8OuXVL21auS/oL/+AgHN2Y3/UF875SjxRP/pisUN3Iq6EBkmY9uA/S
 0F2y9e1D5SNIJIbGJEsD9nLJUasnCE5jwXxkCYsX+mVKkl09nRQ5Kf612OCjX+n0lvi2xn5
 bc/AO2BljixwPnGSL4wng==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7KWdMw8xBAo=:uqt8LIWMoF8idLpVXu+O61
 pn82AsjYQzS3f7QEg46MehJsZ2sAhlWRjE1nZ89Ub7Ei9IvxEg+TCd3YWl8vzD8Sq3pYDzFDm
 02Qw/bK29DTgGVYJ6Fs3HHFfKQFmfpJLvXUp2jLO28t6cWI82r701fjCvAPdKL8aEknUW92EO
 xvJnvJonnGYlqJInzt2T9s+c+j7zl0rm6dXtNUGYZLM6uUOiqv19aWMrLHNGrsbRaDmJnBuTp
 PAGuDV7/3HpudKlfRmhW9WAn7cXQpFI/HTaDWbsUxTZthYiwmLgBPAhvZtdxYklo6Clv/K76j
 hZFSUsZ+FS5EZzDik0DmJUupqbc54M2zCuSyijgvpWA7EcF4rWzFar5exbZfGngUuDmO7kLcN
 d2MTE5rXiCFqYf+vFzn+cmgvrJSs8URXxoVoYyH1dfMDhu8DVL6/e3+aNs6LEzd6JfglUE8Xh
 ueNFmQJkmHVo2NqytQXcaK0DmBFZaSqU2z2dt6VI3ls4YayFaeWo7s+xMV+6XsIhZyt3x5zB6
 PqOoojuGfh+cjEUC9tsW9xnbb6MMOHQ2198NfXIg3PIh2SiqCDMTmu+PdcQJW9XZXYBskJKgJ
 v25iXetj1W4hGXvwcqmu93abkSyGUSOwQBgmQoDzlPLxXmCh9VFSsFiGUaFFvVJOPaKyNxGb1
 EtjKjOaKMwDuXMn9jmNqPlW78SOnO+HgPebtnimMoupBq0HBsnUg1BzLylFMvhJ+kO+KOJ/OL
 RXOqqvxIbJEe+phz7G0APDSJ+clcSF/pZkzb5mCdKQHH9DI6uMxLWTqFn2FTq8oNy+E2km6lK
 5ObUhuCUE6YWoz/qq82nmSE4StNh+nJ3FBGSXXDJNu1GalBGO0nshzqP6YLo7vSuJ6YQgCaXW
 fkpDAxr3XE0cylUphsnGWrsCU2L/zE32TobON06ftEEuodZ3TkWgJkAnjY/odEqsJ+cpTbJjo
 zGBPx/yinIQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/18 =E4=B8=8B=E5=8D=882:34, Nikolay Borisov wrote:
>
>
> On 18.04.19 =D0=B3. 9:28 =D1=87., Qu Wenruo wrote:
>> [BUG]
>> With kmalloc failure injection for submit_one_bio(), btrfs can crash li=
ke:
>>
>>   BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0038
>>   #PF error: [WRITE]
>>   PGD 0 P4D 0
>>   Oops: 0002 [#1] PREEMPT SMP PTI
>>   CPU: 1 PID: 247 Comm: kworker/u8:4 Not tainted 5.1.0-rc5-custom+ #19
>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/=
2015
>>   Workqueue: writeback wb_workfn (flush-btrfs-6)
>>   RIP: 0010:alloc_btrfs_bio+0x1e/0x30 [btrfs]
>>   Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 63 f6 48 =
63 ff 48 8d 7c fe 18 be 40 8d 00 00 48 c1 e7 02 e8 a2 86 94 e0 <c7> 40 38 =
00 00 00 00 c7 00 01 00 00 00 c3 0f 1f 40 00 0f 1f 44 00
>>   Call Trace:
>>    __btrfs_map_block+0x5ce/0x1210 [btrfs]
>>    ? btrfs_bio_counter_inc_blocked+0x3a/0xc0 [btrfs]
>>    btrfs_map_bio+0x9a/0x430 [btrfs]
>>    btree_submit_bio_hook+0x82/0xb0 [btrfs]
>>    submit_one_bio+0x95/0xc0 [btrfs]
>>    copy_oldmem_page_encrypted+0x20/0x20
>>    ? write_one_eb+0x18f/0x2a0 [btrfs]
>>    ? end_extent_buffer_writeback+0x20/0x20 [btrfs]
>>    ? btree_write_cache_pages+0x12c/0x350 [btrfs]
>>    ? do_writepages+0x41/0xd0
>>    ? __writeback_single_inode+0x54/0x650
>>    ? writeback_sb_inodes+0x1f9/0x540
>>    ? __writeback_inodes_wb+0x5d/0xb0
>>    ? wb_writeback+0x340/0x4b0
>>    ? wb_workfn+0x410/0x5d0
>>    ? process_one_work+0x294/0x650
>>    ? worker_thread+0x2d/0x3d0
>>    ? process_one_work+0x650/0x650
>>    ? kthread+0x112/0x130
>>    ? kthread_park+0x80/0x80
>>    ? ret_from_fork+0x3a/0x50
>>   ---[ end trace b637169fb8b17c9c ]---
>>
>> [CAUSE]
>> We just forgot to check the return value of kmalloc.
>> Surprisingly, all alloc_btrfs_bio() callers have handled memory
>> allocation pretty well.
>>
>
> The allocation uses the GFP_NOFAIL modified, which, according to the doc=
s:
>
>  * The VM implementation _must_ retry infinitely: the caller
>  * cannot handle allocation failures. The allocation could block
>
>  * indefinitely but will never return with failure. Testing for
>
>  * failure is pointless.

Forgot the NOFAIL bit.

>
> The allocation requested is at least 128 bytes (assuming real_stripes is
> 0).
>
> 96 + 24 * total_stripes + 4 * real_stripes + 8 * total_stripes
>
> Considering this I think it might be prudent to also remove the NOFAIL
> flag altogether

Definitely will remove NOFAIL flag for V2.

Thanks,
Qu
>
>
>> [FIX]
>> Check and return if we failed memory allocation.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>
> Though the change is fine:
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
>
>> ---
>>  fs/btrfs/volumes.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 78bab7803bda..875d0eee1785 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5582,6 +5582,8 @@ static struct btrfs_bio *alloc_btrfs_bio(int tota=
l_stripes, int real_stripes)
>>  		sizeof(u64) * (total_stripes),
>>  		GFP_NOFS|__GFP_NOFAIL);
>>
>> +	if (!bbio)
>> +		return NULL;
>>  	atomic_set(&bbio->error, 0);
>>  	refcount_set(&bbio->refs, 1);
>>
>>

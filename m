Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CA5C2BC61
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 05:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD46020827
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 05:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD46020827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbeJ2Okq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 10:40:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:44629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbeJ2Okp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 10:40:45 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lpspj-1fbvEo2GE3-00fhm1; Mon, 29
 Oct 2018 06:53:26 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lpspj-1fbvEo2GE3-00fhm1; Mon, 29
 Oct 2018 06:53:26 +0100
Subject: Re: [PATCH v2] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.de>,
        David Sterba <DSterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <1540554115-11226-1-git-send-email-nborisov@suse.com>
 <abaee0e6-c865-3402-3352-33dc6a1d4ed7@suse.de>
 <10430924-b70e-4882-15fc-61c0376d83a4@suse.com>
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
Message-ID: <86d8a6c9-8492-86c0-40d1-324342ab1e2a@gmx.com>
Date:   Mon, 29 Oct 2018 13:53:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <10430924-b70e-4882-15fc-61c0376d83a4@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7hK7xgnQfNvS6mDzCOIx/FZ5qTU4s6bmhsEVH3ybUZ4FkExKoz6
 gCbNtnaoYmvnewW/XO5f4pB+1BLPAl2BcXXcpbSAU61L+MAZPZ/WU754Yj0snBMcGZIsSm0
 +UIplRp2GvXNInaXa+1TJN0m2pOacKMMwo3r1tQnuBLbV5+OsnNEJ9/o6Zfmj4vsFq4cewt
 CgZ5k4bjcbbxMVsb10Jcw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:riG2MzD08LQ=:4b08x0tIoVOZpZ9RdO/ARU
 cA45UbscnJ2o33OzkMrRY2syDxjuxxsEhLQjLtC892au9Wj4Phf9jrfMxSfb3K0syQJViiUOV
 cTuaH7o4oXNgmlgJgyAUIiE82zwpwmHGmh58m1YMW/3fITw0VmXh4v9wTi3oOT/X6mdlTZNQ3
 jFs/B3zV4hZlIUsJR7eTcAasPWh5GRVrXazx8iYoA6Ou/tpiTwImAQaRpe1vAwMGhhwXY69PW
 xUES30w1hPceFKwrYkGSdEISsvcUfkMPoZzB5446qsrYyMU1ansqDnWArf7UfnwuGpbCwmtRl
 qSEHTjOsxBDtlcKMV8Atm9Y4ohre8CtZRdwf5/NPvBO7inmmC2QXj6w+NyNKtabHvwXkLBFJt
 avfFqypc35+da9JWv5jl2qRZRFUQe7rVgy++BfwFhMZNURZDEEbzTzWekdvJ9pTX1rnBys+6y
 y8PqruKhVMZ2j2ZL/yTvbmMSON+49ZrzThlSGczRjdzcG5YGvOJQyQcKeEyteHUNxO2iiRen1
 41+IgzQ7VOcFUkm2GrxeXA2ayUhCDZb1OEzgPjqsSPhXTdYoNFVpDJgiRxcp45l6XTIKch+wz
 JBkTzgOXx07d1vufeyhQrm6TLntY5V79F7CBU0EKg1L46etUXge4vL8nqXAD7E/z1diI5HTPV
 Bdurpb6fEhPFLx29LhJFcVeDmk+CnRGAzzc25juX7KLdc7ghnkMhh7tioJZgq+/Y7eI8MF6yS
 QG+gdM+TAY2jAxucJWaiXLUW8NhP5xlRJFvnhaCdJsmOaBSykNJKWaTOamM1CPPv4T5Om14xL
 V8Ny/Pc10ubv28a/hhfcdJdJsPjdWWe7y/yyXu7JUw3HIrcfS8=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[snip]
>> The cause sounds valid, however would you please explain more about how
>> such cleaning on unrelated delalloc range happens?
> 
> So in my case the following happened - 2 block groups were created as
> delalloc ranges in the - 0-1m and 1m-128m. Their respective pages were
> dirtied, so when page 0 - 0-4k when into writepage_delalloc,
> find_lock_delalloc_range would return the range 0-1m. So the call to
> fill_delalloc instantiates OE 0-1m and writeback continues as expected.
> 
> Now, when the 2nd page from range 0-1m is again set for writeback and
> find_lock_delalloc_range is called with delalloc_start ==  4096 it will
> actually return the range 1m-128m.

IMHO this looks strange and may need extra investigation.

Normally I would expect it returns the range 0~1M or 4K~1M.

But that doesn't affect the fix patch anyway.

Thanks,
Qu

> Then fill_delalloc is called with
> locked_page belonging to the range which was already instantiated and
> the start/end arguments pointing to 1m-128m if an error occurred in
> run_delalloc_range in this case then  btrfs_cleanup_ordered_extents will
> be called which will clear Private2 bit for pages belonging to 1m-128m
> range and the OE will be cleared of all but the first page (since the
> code wrongly assumed locked_page always belongs to the range currently
> being instantiated).
> 


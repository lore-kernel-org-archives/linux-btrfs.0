Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533EDC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 08:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1067B20830
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 08:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="OWNUZkBN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfDBIL2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 04:11:28 -0400
Received: from mout.gmx.net ([212.227.15.18]:50711 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfDBIL1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 04:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554192680;
        bh=jgP6biVriiMNUtZNwygolZByA4VxtyBehw5BkqH+O9o=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=OWNUZkBNU0fi059/kMjtR0glU6cnjjaTGRNyuzCB/FpqghAL3bZVX4l+jM/4Ut5SU
         26uY8PQWAbsQOW+0dIGIcMyMrcPYGtsq2l1Abg2xtXylr0HGmMCLvVWhKREE9ENcEs
         VMR7SB/tVhdYiBgSO+b5h6lIWKqPqsTIwfRldNoY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MNIi1-1hHWyk39XF-006xcn; Tue, 02
 Apr 2019 10:11:20 +0200
Subject: Re: Is it a good idea to export certain internal structure
 declaration to make bcc/ebpf happier?
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        iovisor-dev@lists.iovisor.org
References: <28e33708-6f0d-ec65-5565-4c41e741a87e@gmx.com>
 <c1b06936-ba94-4467-8744-886b41bea2b6@suse.com>
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
Message-ID: <790c755e-a1f3-5faa-30a1-d9688b4293c0@gmx.com>
Date:   Tue, 2 Apr 2019 16:11:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <c1b06936-ba94-4467-8744-886b41bea2b6@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aR9+FVzu1khl/dEbXv9oo25QSraayMKUKdgI0ufDsqzERwSq1lf
 X8XN70iiyha5Ti+mI9eT/PWhDDb/u6qssIUq+C8RdtBsbqY7UKDARtqz1sROGe4CSx0/MYs
 Per0i/mGHJ5HAidm0eaD+vkAkPkZ2abToObNbpx5XOtDavEs/+/wF675IOhGG0VaDdJVLpV
 Dbr/OjFrg54UzhVOnIloQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CctfEwc/sCg=:T1DJ2XdGJNo7V6hpK6ZUfB
 0UQwFMsVWD9uHjNV600c3yGB5ETI1eJk/V1zy1kgsnI8dXHiFt/TNMIsz/r18A+Hi6nMoOyYg
 bNeG5eEJhbDwCRiYzr23mhgLKLz2Pfj9qHXG9NZ4lBuWKXgQb6F7MhGeOyd2LlII7VJPCVM22
 vA9w07SFGMc8Q+NYone+VQVbtw9rTaxl+noBNOdu/w6fsQTZ6UhKh8d7XTI/hazz0mxrtSY+R
 ur7uaU72NS/5EuBKo7kDoQnr6M7KRWnh/kNThlzuVUsMR8zp4IFNyMWeGblE6r0tqmDEQzFV7
 wAEQnuEBN+eLyvYtj3YwTTks3ZqXQgkwRPVS7t2Nx9cqTNleb22HiXKa7shZ5Z/YmW5cx0kmt
 XfrijMRfja14+rxOnFfNQbgKGW0QTeQfR2of2pENEW6yo7eHxdffXFdWSu8H7jKXxrfyPGTGN
 HHu60cWX4dojAeOF8hEaj2/gGeQ1djmBPrrYPYSZcrCw2sxI8/Xdr4Fjd2MRcTDx9J346ORuy
 xQrzrWNBtYicn3Ix8jLhCHDK0xcseUevusF1c1aUi2vELe6eLvf4mTl0K29qvwB9XUJmrqqs8
 Ot9C2ZAdyyDw+ZwEAHbHLREoZDL+prLvQVgzy3suPzYWLFCVRbKDm3jp+ZJXiVCw9tM191Bnb
 /dk/e1giCElrdVxzte8dI6htVfqB0m0o0cjfezxCP8rgaQVjU7a0eAJXTSzmnY6JPY0FYl6Ab
 /kQSlD32/xbrQTAorikTMJAuiG58zREpBlNjUaS0QkShXHZpUZH0/ehnTR0KgRWE5paEXe7mF
 EggiAz6ta289zFFkfUb+1NXkxEU3rJriVv3FUc4G4qazIiv0ZJ4DTEmWdMFrW81/zCAMVZmUZ
 elvYeK2tTSubMqUpZW721lnmP1KTs2LoTLYfKtgiUTvw6Ph27WoDzzMQnAMvF5xMK7s4WxAXA
 6NDenw3S8Vg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/2 =E4=B8=8B=E5=8D=883:59, Nikolay Borisov wrote:
>
>
> On 2.04.19 =D0=B3. 10:41 =D1=87., Qu Wenruo wrote:
>> Hi,
>>
>> I'm recently working on crafting a small bcc based script to show how
>> btrfs tree block concurrency.
>>
>> The prototype is here:
>> https://gist.github.com/adam900710/63db6cdc7d26c4744a53dfc7755fafda
>>
>> However it has some problems, and cannot be used directly on latest ker=
nel.
>>
>> - No way to pass btrfs headers into eBPF code.
>>   This is because the declaration of extent_buffer is in
>>   `fs/btrfs/extent_io.h`.
>>   No in the common kernel headers search path.
>>
>> - eBPF program can't access btrfs_header_owner() helper.
>>   Even we make eBPF code understand the headers, we can't
>>   access a lot of kernel functions, like btrfs_header_owner().
>>
>> So I'm wondering is it possible for us to export extent_buffer
>> declaration just for possible eBPF usage.
>  >
>> Or is bcc suit strong enough to handle such case?
>>
>> The diff would be something like this to make above bcc script work:
>>
>
>
> Hell no, that is _very_ ugly as hell. If you want to access such
> information why not introduce tracepoints which have enough context so
> that when they are used with ebpf you can query the data from the
> tracepoint? I *think* this ought to be made to work with ebpf?

The problem is, for kprobe/kretprobe, the only thing they can access is
limited C language.
I'm not sure if external function call is possible.

Another problem is, if using kprobe/kretprobe, entry and return point
are 2 separate functions, which means they are independent. Normally we
use a hash table and use pid+tgid as index to match return with entry
and get the execution time.

If using tracepoint, it's pretty static and either we record execution
time inside btrfs and export it using regular ftrace events, then the
start/end time overhead can't be skipped, it will always be there.

Any good idea on that?

Or bcc guys have better ideas on this?

Thanks,
Qu

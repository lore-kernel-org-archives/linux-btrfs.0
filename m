Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC3CC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 08:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1967E2070B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 08:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="H6WUIkyW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfDBIpV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 04:45:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:32889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfDBIpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 04:45:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554194716;
        bh=x/996ps7VHs5DdwL8hICoNOGl++aCvJu7TWObmaKi44=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=H6WUIkyWKqXLoVRkEx0ceUUTE3pziNnjF9UkeWFck2BA9KcHTjmxW1Dx/aZ/CEt0s
         GxUfd+mnd5PKME3hwCv5AI28OSr3tB4req/TiIkwQbaE7U2wNm6nWfPCgZh630ObKr
         IuarkWtaw/jDjasNIyCNqK9+LByWGQUBT6qPVPc4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MJngW-1hCLVP0uXc-0017FE; Tue, 02
 Apr 2019 10:45:16 +0200
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
Message-ID: <6f0d3510-41f3-26b1-2eee-e482d3c65f36@gmx.com>
Date:   Tue, 2 Apr 2019 16:45:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <c1b06936-ba94-4467-8744-886b41bea2b6@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tRj408ZuDN3JJ8MmQ8ICADD6m/IRG1CTHd8K8RqJepFESQwOrFe
 3ISJaoOv26KAxONmI+m6xXjgrNubmh6nKPhoJkjo+TKT2EWplNx+LtCFvNXdDx+XcPfT6V7
 w42O9I1hV2lDtYWAbEgw8ifmM8BhAWjtJ5S2UzckluZoUW+STOCMe/qzKQnVrp15oK/ulUu
 vVOYMUxmNqW/VLUVfSELw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GrDM2sDmlno=:TvlbGGSDSlj01sAKNs8gUe
 N63EU6/+6b08FQxm+7jdoNQ2IGxBqstVFb3L5UQ8CrrfDXu+zouKJ43CI2IEdPt423uSVkUGR
 z9anf5elUj05eprolRYB6VYu7cXoT/gS4S/6rUSV/CAdAZ6cmXKtjuWb1pFrD4uuat9Cumgsk
 dOtlSh426yxbdljn/wFY3TX4bY+KB+4w4PUbaOuAF8PYpiqk/wCA8zkLMwvk+UVRR0ziMV/dp
 DBgPN0IMuKb6UOw4AktQOyHRLhOEgYecL12l5IX2wD8nZLJbdVIXbWliT2W3RbLpJL4e6bh6s
 kWFaxNa8ZjBcNBdW56+NbkZ/jQpRj4GWaQS3yfFf1cDi6NmvfLimdivn3WJ8yeeV8bB6Bw/gG
 AksI8+W1EOIMyD70boBrfkKavhfTD4G0y6ASChg7zI5oQtfVtaRzcNGimv1r+vjojgjilY1UD
 jGEAvBs5MZGG+h3luPaCK+CyCxxILhqDw6svFnesAQ+A+fc+WltW+4oUj8tO0b1/S5jDleaYF
 P+JWLTJrtae28L50qLJ4CbtCdM0gNwOQTE9gcebOgjWTfJV5DZXyUwLbI7nwKVk7U2lk4fqJ0
 cHl9RMtKhYdY2VMXy9frKyZX5NfQFxCJCx8X7yrxOEMtjZodAQNoFhSWadHfqX0CGq8Ft/olr
 GDGtqdLOmNBv8zFEPFOVKnwuLMF2491hzrI7JVVf+YAzNgOMw2WxZO0ayOmQcnu6KLRzDHcyV
 8h1jHquEoIDXtCZfRTTVwTFeN74W/fwgbcBamUbYiLzM06Ms1L5iKwTlK3JkeRxVOFrV69tLt
 2H0b103mChxagiwt5gOIkm41t6h9TaNZ2PZKP3QWIZtWix9rb7dg3+qiQxSd/Z2st6uSsWXoz
 gm3dnnzcy6CNmyH5baVHEEZncVjiiKUEBvkjSW9xWwoKCZO3n+O4c+fnnKo3OqR96wzeM4Hhv
 0PGaaAu/q5g==
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

OK, after some though, the overhead for a new tracepoint is pretty small.
The only overhead when the tracepoint is disabled is, a ktimer_get_ns()
call at the beginning of btrfs_tree_lock() and btrfs_tree_read_lock().

The pairing ktimer_get_ns() call can be embedded into the trace events,
so it won't get triggered until that event is enabled.

In that case, I think the ebpf can handle it pretty well.


Any comment on this new idea?

Thanks,
Qu

Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37C3C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 06:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F53B2083E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 06:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="d6FqfXyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfDJG6b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:58:31 -0400
Received: from mout.gmx.net ([212.227.15.15]:57907 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbfDJG6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 02:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554879503;
        bh=u8PFZDyet6sfukYsSjCZ4wANRFQCylqb57AnXGjpIx4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=d6FqfXyBjMKtLRsH8Jks6v7h5/E7lMcoD61qgrlFnmVxdVa4zkvbXoEp2zqM8N1LW
         OWlRzD349sbMumt0iJbM7JRYBbDgbBebpYLxeBy1tO9rcON2ODK1VDcZkuSJg1GW/1
         LzI1NqljuKyFIxIfHfuWUdi3PLPHb1P83lOHF0WM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M5tof-1gyMit077B-00xpL1; Wed, 10
 Apr 2019 08:58:22 +0200
Subject: Re: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
 <b902732c-93e9-ddb5-231b-69012abf9d70@suse.com>
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
Message-ID: <fe4b2eea-40eb-4b47-3596-601086af3e9f@gmx.com>
Date:   Wed, 10 Apr 2019 14:58:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b902732c-93e9-ddb5-231b-69012abf9d70@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FmlWPlcPo68JKt8MwLYG/MkBg0dwzyffs+u67TFUOv4rvBIaKIE
 D2j9WbJCC0RCxpIA8da8tbdq1iX9q3/llwILMmS0P06Y+1QShD3nC8yKyhNFUE3fGEywdh0
 3feegcK/5kwf9ey+YMC/aqcq64Qp5pN73ow+zmsBwSvITqmbNhT4VEEdKGrePkab2+uRndt
 ytympkOvxBBx68ah7XnZw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RBjbTDYjcR0=:B0/O5ITnNOdGZSZC9uK3gZ
 l8pi8AHtB9wMAgihCay3v97ghq4uc+WY8g0tljWcwshGTHRIr0u9suuNQLME6Mp6/vxSbiAtt
 DfypSwi2Qyi4s5GnfBrwmQLz/pYA8biVKtXS0aTePiqxVz18d2MW/uiFoHL5LHGgpJsJC/2HX
 nM6QDBtTVhWgsvqMn7HZvZY7skCrJ5e1jCa8TYcK0MYDvWvMykYf99LKJySdyXU1PthfjzklQ
 bAV1z/MROFQ39Trrp/XdzoIfqypdhvO9APiRf+WzpR+RfPYQ57Eejz3vzZjRYDstFqjTomRDM
 cnByDVJ7NAaIqL58mZa+W+wAXcbGPA6kqaTdMZbKsa/53bmcoNYFiiyQRFHwwA35JXk0BMK+O
 5dx7UqxLl29YN3CxFbYPp9kKAv9q0FfT4ASTh6pQ7u4zfwQBRhucW+blBIU8+C4wrs0SV8E/U
 5BT/l6NpQCMtvQaSDy/j4FpgX/AR0tnaKUSQ6FZ6bhRS4Cmoj5YHQINpAWNlM7GLKzhSUM21s
 uYWqy4wED3Nsutpjs0K6n74cchdo8gPq7MJue7uAsaZTI7us5Xm1ZOu5MIfQeQNL6fPP9RNWp
 HxZMWz4TQAGiNpGnYaZhYXjCbZSNNkZxxYutB8j5KZK1w3xhYPa9NKzxULLPm7W3LhLwiPsbE
 OwzUvDDRYy1gZorzBLfMXxcJUp1vmTcZtK97vu9remgOh0xXtMprTy+JJnU/lmlsMDKf0ZlMv
 Y3dvwNbdHKJkIwfDtU7z7+1abBSn6/xpHDCcIgtJL+WAIhLOFVmF25t69hBGuFbsgyuDAasJa
 np7i47DTWioHNVQOZSaEAyP3KjcVK5dFaPo5Ncwo4PShwy2UAKcovrydYhpqdMVXvql+NCwBs
 QhCh64ulVMnvNFtxUK5qqi7Say1nxgpEe3ymNAK6T/o4hkV03+bNaGzMoDzfPrGnv1HIjkSaz
 9GwkvgRRjhQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/10 =E4=B8=8B=E5=8D=882:51, Nikolay Borisov wrote:
>
>
> On 10.04.19 =D0=B3. 9:34 =D1=87., Qu Wenruo wrote:
>> Hi,
>>
>> As we have memleak.py in bcc tools, and it provides better info
>> including the calling stack, I'm wondering if we should replace current
>> eb leakage check with bcc based one.
>>
>> Any idea on this?
>
> Why do you want to change it, given that the existing one is only
> activate if btrfs is compiled with debug enabled and is "seamless"?

Well, I don't want to change that part, but to enhance it by external tool=
s.

E.g, better call stack to mimic valgrind output. So when one developer
caused some leakage,  he or she can locate the problem easier.

Personally speaking, the external tool may be just an good enhancement,
but may not get much usage.

Thanks,
Qu

 What
> are we going to gain by introducing yet another tool or replacing an
> existing infrastructure with bcc (or whatever) based one?
>
>>
>> Thanks,
>> Qu
>>

Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8E6C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 09:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C682082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 09:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CE8w7CIu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfDBJiT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:38:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:42453 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfDBJiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 05:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554197891;
        bh=gCkW/xm4jHoHdUz3PbBGxsID/Ujb/vbN3Qk/JSPseoA=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=CE8w7CIu4sni8xH+I0renWUkV7IV6t6rtJaBqIohLRGDsTcrVyPUnH2dHNc8GWNHB
         Y+YbW1wULD9+Fgw8MIgzpadW65TJgMAi9LcXEdqddfKz3rFnxNKiDfcljnKuiTD2gL
         bBkzS6fCwe5LcKZElthBE32WJ9u4VIb5sbV6rDLY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MDQp3-1h9qhz3TrB-00Gtl8; Tue, 02
 Apr 2019 11:38:11 +0200
Subject: Re: Is it a good idea to export certain internal structure
 declaration to make bcc/ebpf happier?
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        iovisor-dev@lists.iovisor.org
References: <28e33708-6f0d-ec65-5565-4c41e741a87e@gmx.com>
 <c1b06936-ba94-4467-8744-886b41bea2b6@suse.com>
 <6f0d3510-41f3-26b1-2eee-e482d3c65f36@gmx.com>
 <3a471ec8-97a0-1d35-6448-a88526e5e105@suse.de>
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
Message-ID: <e78b8322-ac83-2f48-3193-d4abf0ba77e2@gmx.com>
Date:   Tue, 2 Apr 2019 17:38:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <3a471ec8-97a0-1d35-6448-a88526e5e105@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lVgXu8pENMANPQlV5GUWlBe22eo9v7+QU/0Dw1VK9sLen/B+//9
 tBJOpcc4Q/CqF8JIBydGmHA8UBlt5OhpeYiD6uhw7K5D1g732x5qbN4ql4Uu51EMNE3ROU7
 6WpuKkgxIKb1Z2KxmNmxogorzAbEIK8O22psN8PVWepG7xTe8cdbS3DE/ZLF8XLWkHyiu59
 fTrLJLSdaEQvPDiQmXMFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PEP6eWZNI8I=:2gTDBvkfaJ6EO8sycN3v4n
 6TXWUzMaE58WVKhrAIvrWfi63T6Z/pHWHOiV39afIs2fvvWDyQoG5mgWygqMsQgoRdSDnsBYa
 2VZm1GhG8DJjiAFr8FL8Sy1W32yWakSBuy5r27rVQHYX7aPKhqPe5WT2h+FUfUE0mUAzXvmwv
 GNg/J0+c85iNXLwHghKes+Xxj89FLCtHi78SGR7UtZgh5z+HEbBW2hGyfI+fdQIxuweL8Npkk
 xxrbxKInbket+iAEtZwkL98R4kpaP4jDtfC3PTsxiyHYfjrNmKMf5sH0CHhFRLnKH6XPxvK1E
 vJWyfttxt60d4FYF8vfCQKtASXOh16JRNEdYoIR6ukxn+EJT9+cBj/19ecM1jMk/zc4iySUZr
 VAPpsNg5d8kzB20ipf4FM2PMf7jQCnGLaeLR2QR7JhygC4hlUDPKqDQ9RkQAT0l1zD+raj8/A
 Y8mQZpQkonmBQUqYbEEQst/hRbw7vi2Atbi1g1j6XI3czmEaS1ESTXYEsC3/TbZM9S2ykjfQ1
 nqMuLY1U7hZHbSY9Y2JfGuisPJOJMmWNYlDvfe+cQ9YAM+9thGOA0gBivC6UYtspGbRlJoJME
 bfpdxFDtMBopmNdvfGovZj8PcqJB0hCd938NoxnTjEDhVnY7oYsjMYkp9TXcsZz2tsCm6Res8
 EddhSKPcwuzwFf6hM9q1OAdvPvg2/XjU6Tr39cTrYSWMNqrtrK6cVnAFn/LD9ObJWgKidvoFA
 dt0EzZJFwruF9Fl5PEt09va2ptz+l5pi77tREZc/Ewz/oHiJ/NBWglQ85hIAjVIbu/xd9se8w
 u9C2qY6ndqTGYsHzopkioMBlIKbouS+IIG7lfAnUbXIuG5itoczuebyTHPmza4BdIxLfggpsB
 J97PEDyGAOZiBnzIgklMwqEaFYTWeRiVALLsZOA1NUC+MlDHlKLTYKQ3ngSnOdvzL8UlW02IX
 Q8G9l4p3/owTTccyKkK0gZFNawuI9Gx8=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/2 =E4=B8=8B=E5=8D=885:34, Johannes Thumshirn wrote:
> On 02/04/2019 10:45, Qu Wenruo wrote:
>> OK, after some though, the overhead for a new tracepoint is pretty smal=
l.
>> The only overhead when the tracepoint is disabled is, a ktimer_get_ns()
>> call at the beginning of btrfs_tree_lock() and btrfs_tree_read_lock().
>
> If you only need the ktime_get_ns() call for the tracepoint, you can
> wrap it in sth. like this IIRC:
>
> if (trace_btrfs_tree_lock_enabled())
> 	start_time =3D ktime_get_ns();
>
> [...]
>
> trace_btrfs_tree_lock(start_time, end_time);

Oh, I just get your email seconds after I send out my initial patch.

This helps a lot!

I'll update the patch.

Thanks,
Qu

>
> Byte,
> 	Johannes
>

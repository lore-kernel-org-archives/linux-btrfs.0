Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B870C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0668C2173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="jbkP2Jro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfC1Xu2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:50:28 -0400
Received: from mout.gmx.net ([212.227.15.15]:56029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfC1Xu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 19:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553816996;
        bh=71GEjKvFYXGuC0ZhKNNdNJEGpjJDlNv3fJGFW+STDjQ=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=jbkP2Jro/Jf0xYTrsOlfmNj44XpCvvcttv4GhKBlMful6VLjKg4Yl0+QXvN/GanKP
         ivNzT5pniPfaL3NF2WUA/XnfK5nZczaOc8rlWW2doQt01xgojZqPrySrAe49Uhyzrz
         upRu3RD3S2N9b+LgzFU0qbvznL/yMHAHiHIRBMd0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MV5hN-1hS10g0emz-00YQbK; Fri, 29
 Mar 2019 00:49:56 +0100
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com> <20190328133806.GD29086@twin.jikos.cz>
 <ae0fe6da-a329-ceea-cac5-085595965511@suse.de>
 <20190328135714.GF29086@twin.jikos.cz>
 <70209af7-5948-4bfc-a3a0-06a258ad8ed9@suse.de>
 <20190328140747.GH29086@twin.jikos.cz>
 <e5de25af-6cec-fcaf-d3a6-5445ec0f45a5@gmx.com>
 <20190328142544.GJ29086@twin.jikos.cz>
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
Message-ID: <dac4c926-29b3-afd9-fc31-7f88fcc4f283@gmx.com>
Date:   Fri, 29 Mar 2019 07:49:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190328142544.GJ29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SPAVt05BSy9w7THQC/2dyEl3Rjt0rKHsi6go4Tvx0UriKUqcQUw
 l2Qzb+LeQAW1xH8BY5QowV4hXt5sa25bjPKqt3a4WJ5X2RQ1IkPzhHLxrThyhM+Sh6b/9TB
 ZSS38R/cX3uNQhST20VZA5SkUH40p6fuD3wycHyAXQvCWCUVEUbcpOlsgiAsaVg9A/9kbbD
 qjrgZNntucnyZogO1XKzg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3DF7MIOPSIA=:MDo7PfABQHEjsL/tEqVPea
 fymw83QGTb/UbkEvCcJpJV1oTIehkrJRsbINth9VwtozejY12ZkW6ftwsIUWcFcCQLfhtHMcm
 zpoFGzlebBh8JMXTMfHVWXYH4cOW2RASB710dIBxW4YywUmlmppw+2yb5Ul/QXTbfjj7nnVfE
 pz4upUAKndHToYtZSt8Jt9aqn1JzG/5zszYctyuZr9oCjSguW40wV4jqxp+0bbqFhP/vu24kx
 aRJHCntVHul0K4w5aYG1+lPGTbgyLd9jIgWTP9hhlYMMudoD2L9CrIrMNS70GqrPEyxGzU6PN
 CTKqw5Wd2j24kiu92pM6YaDU43G1E84x/FaHv6h7aalRYVhHnTJK9+bCpGlqtwEFgruqmp4+G
 vUMpfAvY+7M3XMTsLcenty4BJw1C1N0d1+ZfQBRMxT2ZYR+QhdCrwYcZ/80DB9ZWGUN385RAZ
 wUmuKHq/ARH4nQF7dNhCqV2tdA83jxoBbijsAkenYZVvqhF/zf4zdX9M/2HQ6GADW1RWsCiJp
 mCFJiWZY0cxO/w4c5ktcp1sSKGx5CPNBIL5fcad7c3Yx5+MyzMNDkY0787XeVw6aPzZLuWjF9
 sOHrd+1PEj9qO+CrptO08nt3etXc5bDZpV8Zc+nzt8sze5EQcjqne2LvukJYxCbKthiogV5T0
 Nsa8C+XLTs3gN8vvpbULuzwQaXNpCWmzM916xfyyN6Y0PypFldjUJ+cRRZrpKZTdjcJFU0Un6
 JmvYrMmNXrJD/RoG7XJQmcD+htcunhLWjwvyhwHaM7Ut36GeO1POLJe1A8m2kIOTXZbiBy69G
 r9QyNhfo3tWmDfAImSY06sQJVCmDT+JGIO203JNVxt+BnCqn3Tqq9cPDFgo/ynpBBlfRObKGU
 hUjPTNwmwqoxGbvWJPCZiP2o8kIEiZBFwGnv4bRxSR+cYihsyl/+wAMNI1KTeq6RJtp/wpsoF
 zPlIuqm+iaQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/28 =E4=B8=8B=E5=8D=8810:25, David Sterba wrote:
> On Thu, Mar 28, 2019 at 10:13:19PM +0800, Qu Wenruo wrote:
>>>>>> That means we have hard link for directories.
>>>>>
>>>>> Yes, hard links of directories are forbidden by VFS but that's not t=
he
>>>>> point here:
>>>>>
>>>>> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Track_link_cou=
nt_for_directories
>>>>>
>>>>> "The link count for directories is traditionally used to count the n=
umber
>>>>> of subdirectores iff the link count is >=3D 2."
>>>>
>>>> Oh, got it.
>>>>
>>>> But for that case, it would be much better to go for things like nbyt=
es
>>>> or size, as by all means, those two members are less meaningful than
>>>> nlinks for directory.
>>>
>>> size of a directory is currently 2 * sum of all names in the directory=
,
>>> ie. both files and directories.
>>
>> In fact that's not always the case for older kernels/progs.
>>
>> IIRC it's in recent years that we enhanced btrfs-progs to detect and fi=
x
>> that.
>>
>>> The nlink is used as an optimization
>>> during traversal by existing tools (find), we can't simply change that
>>> but would still like to update btrfs to provide support for that.
>>
>> But current nlinks is persistent against all inodes. It's always the th=
e
>> number of INODE_REF the inode has.
>>
>> While for size/nbytes, it doesn't make anything for directory inode at =
all.
>> Kernel doesn't care, it's mostly btrfs-check check and fix.
>>
>> Furthermore, only size is fixed to 2 * num_children.
>> nbytes is only instructive and at least in lowmem mode, nbytes is only
>> checked for alignment, even it's unaligned, lowmem check outputs warnin=
g
>> only, doesn't count as an error.
>>
>> So at least to me, directory nbytes is a better alternative, and it's
>> back compatible.
>
> The point here is to use nlinks of directories for the directory
> traversal, the size/nbytes is not relevant here for the reasons you
> state above.
>
> I don't see how you think the proposed nbytes alternative would be used,
> eg. by find.


In state() call or whatever syscall find is using, export nbytes instead
of nlink for dir.
Of course, this needs some compatibility check, e.g. nbytes should never
exceed size/2, or the nbytes must be old value (nodesize).

My point is, if we're going to give new meaning of an existing member,
at least choose a member that is unused and doesn't have persistent
meaning among all inodes, not to mention current btrfs check will
definitely complain about nlinks.

Thanks,
Qu


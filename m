Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA2CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E9E72075E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="I/pNRTTi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfC1ONi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:13:38 -0400
Received: from mout.gmx.net ([212.227.15.18]:37447 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfC1ONi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553782408;
        bh=TlD9FH0bk7oRvH/UwD8noK2Jz2Q834g5aBrafdJj12Y=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=I/pNRTTibgjOvRmAc+uWuivBFqKIUr77J2gdC9LNVzTVo6jLPWctLyqRWBiYgw4R6
         huI54SHO6m/LzeKeXyxyfrHqvWhZA6bexldva8LcCuiUVjjDygXOQhWm9rT2xEawGJ
         aqy2f3ZIWiQu3Ccis0RVN+lDr5QPVijt7ED/3ks0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Mdr7l-1hJbcQ0pIr-00Pb1i; Thu, 28
 Mar 2019 15:13:28 +0100
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com> <20190328133806.GD29086@twin.jikos.cz>
 <ae0fe6da-a329-ceea-cac5-085595965511@suse.de>
 <20190328135714.GF29086@twin.jikos.cz>
 <70209af7-5948-4bfc-a3a0-06a258ad8ed9@suse.de>
 <20190328140747.GH29086@twin.jikos.cz>
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
Message-ID: <e5de25af-6cec-fcaf-d3a6-5445ec0f45a5@gmx.com>
Date:   Thu, 28 Mar 2019 22:13:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190328140747.GH29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZnTCrEGiRGXZRzKviZd+TgvWXzyLX/Qdi5hIF4pn/cmtTL86neV
 xi/eXzD97PXjl/8PNKDDBHRakugDy/DJ+rLI/gcCdarwweDfK9cjzvsb7x1LWL9X6nMZlWO
 yrpcnrQ2p0xe0L3gkhKxCjalkzOZuWc2iPvaMXYRV9p2wEZRirNYFHDP3+zueC+Vpqj9CxI
 3KaYBCDGzVHq8ul3yIx0w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rAmU1+6ew7Y=:ZWlewk/uHXsVHhxdoEW2Ae
 T4tUL+zZ7cuIcIlXpV2HAYkeSkxZ/ntHV2qoiWF8fR5fp1QF+u3jvSbYbAVmxHmBHDEAG7mOf
 uOfnEVx2hP9/13NuzMyiH/Z66q4WZRY8SbkzCrpvo40ems4mdcGvukEenvWYEQ1cD1TqVrO+4
 3eb7zh7PPnMR2mf/4RR8UwkS3Eb6HTLZWFuUD7K7f1BT8yc7ulNfohcx1KLLxHFn1q1AddMU0
 yyoukjfDEPpB2o2Kg6dgoCvYWICq6FjCQjuEeTEcGu1xGVRjfuHjT2EndAKbWS+7oACEBwaoo
 lHaQeoLSXF4qz6823XnMxCZpGuVml1wkxIo4ZY5ATI4Vn1CyuCG+kJcCM244SQc2cDLGqcA5L
 HDjPwK8/hMCpt2CEIxvTcMiPYKp0zRxC4Fwb+sHTXei8ng0WuRBXSClKDlHu7tbphlC/lEMGl
 l/FC0/Vx+HlUDVm0bY5kiO+0OD1uPY2F0drZuovRU0Hs4+4z6T/u96SccmWysidjD1OBj6nIU
 roMXeriyX7/SWvYBc5FRexeKLAgBMZoj4ZLL1WK9LxUMDPLL3Q3/57f8CkHrqb71XsiRbmzRv
 k8qPAcLLx+9f+wmYqpbYI3eoITEz4F/uNqBi1nMwCfVqlFO60FcyBB6Tsu1AlpgbEbfH9R7mx
 EsrFn+xgbg3SeBGFQxTybwsQe5h9Ca+aPNcl2cBvg43ixFv2HsFAXxKVtwDztp1JtE7OO22wx
 AoOASkPLaQMx6WvoB7kFAWu0pgB8NyB3wNoQnVaggXYPxsRZtCVAFbrf9MglC+u5gz+161HuA
 gNmtH3eAw95/RGWZWzoqbcu5gMm2KexdrZ8JBuV4N8WUQTyZ+Uz7KMdpzgc5mWMCXBxUtLK8C
 5P/nsGph1o8kFaBmiM4G/1i19dLiP10fpGos5vtMYMzwGnYWepeaRLVhB1JN4USpk2X1PGfX8
 RbCPx2DvNmg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/28 =E4=B8=8B=E5=8D=8810:07, David Sterba wrote:
> On Thu, Mar 28, 2019 at 10:00:22PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/3/28 =E4=B8=8B=E5=8D=889:57, David Sterba wrote:
>>> On Thu, Mar 28, 2019 at 09:42:59PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/3/28 =E4=B8=8B=E5=8D=889:38, David Sterba wrote:
>>>>> On Wed, Mar 20, 2019 at 02:37:16PM +0800, Qu Wenruo wrote:
>>>>>> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
>>>>>> +		inode_item_err(fs_info, leaf, slot,
>>>>>> +			       "invalid nlink: has %u expect no more than 1 for dir",
>>>>>> +			btrfs_inode_nlink(leaf, iitem));
>>>>>> +		goto error;
>>>>>> +	}
>>>>>
>>>>> I'm not sure about this check, the number of links for a directory i=
s 1,
>>>>> but the exact count could be implemented (there's a project idea for
>>>>> that). I don't know if this will require an incompat bit or not.
>>>>
>>>> That means we have hard link for directories.
>>>
>>> Yes, hard links of directories are forbidden by VFS but that's not the
>>> point here:
>>>
>>> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Track_link_count=
_for_directories
>>>
>>> "The link count for directories is traditionally used to count the num=
ber
>>> of subdirectores iff the link count is >=3D 2."
>>
>> Oh, got it.
>>
>> But for that case, it would be much better to go for things like nbytes
>> or size, as by all means, those two members are less meaningful than
>> nlinks for directory.
>
> size of a directory is currently 2 * sum of all names in the directory,
> ie. both files and directories.

In fact that's not always the case for older kernels/progs.

IIRC it's in recent years that we enhanced btrfs-progs to detect and fix
that.


> The nlink is used as an optimization
> during traversal by existing tools (find), we can't simply change that
> but would still like to update btrfs to provide support for that.

But current nlinks is persistent against all inodes. It's always the the
number of INODE_REF the inode has.

While for size/nbytes, it doesn't make anything for directory inode at all=
.
Kernel doesn't care, it's mostly btrfs-check check and fix.

Furthermore, only size is fixed to 2 * num_children.
nbytes is only instructive and at least in lowmem mode, nbytes is only
checked for alignment, even it's unaligned, lowmem check outputs warning
only, doesn't count as an error.

So at least to me, directory nbytes is a better alternative, and it's
back compatible.

Thanks,
Qu
>
> On the wiki there's note that it's backward compatible, I don't recall
> the actual details why it's safe though.
>

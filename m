Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51618C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 09:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C7F2146F
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 09:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbeL1J21 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 04:28:27 -0500
Received: from mout.gmx.net ([212.227.17.20]:33389 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbeL1J21 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 04:28:27 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ldttv-1h3JgY4471-00j2sO; Fri, 28
 Dec 2018 10:28:18 +0100
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181228083745.3134-1-wqu@suse.com>
 <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
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
Message-ID: <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
Date:   Fri, 28 Dec 2018 17:28:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:BUpexVHK9ZkxAJEazyF5YPZXYqv5asDY91NPH+ck0MFcC3xdnd4
 ovzHM4s9GmF08rSZy4xzG5avbZ0KILZdDxldwTpMCPzsCHKryudBcmww4NLcDzArhpjoNjO
 ENkGLpCgjOVBvy37B+xSeLGLsb+Jz68F8p1KfpJSr1vE9ihsePQnPAoJvjZ8ZFR3VY8wCjk
 7XvwXs8h59dcsw/sQfl/A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:A5CJg+z++00=:ddshYgAdxexDK8vh+tjH29
 +6v0NjpzCzDPuSN1RiwtLIPzcMP9up3vjBCq4IzdC6gsYpBvpX+aWmrx3tLZxhhADwwMggvdF
 BGla4LbVYwRx5tUXGrzmkgPw2RCPFRri9LbQpszmlJA+YTE4f1PaPvUW2QbG2xMsi9UBe7KO9
 2ebkxYtrACF9hVo8Vh3PCEQyp5rXcX+2Jyj5xMR2ulmDxYf0aYRGrBbBHEJSzpvm0OpBP6J8t
 AyY3Mymf2raTBrdYb6iQkcbyC5q9MiVMTCcBqjClIZPU0g/YVKG3SeboBzWO7nnb2hUd3Oa6Q
 AeW1IjSlqovGMFDNFdKhpIOjRbQpcxr3XsXWWH+YQF5Mu9w0KGK1GJT2VE0r6DFqYdjQKdkKf
 eyf/N6BnhrkZL48kVazAKk09uAqrg0K2vGZGJEnSYw361dTgS/yWlhU7j8DEIfnkIDSY+GGcY
 +msOUS3fpOzbIDQN/FBESvFhk/CTqr0wLLnrwCBDKkBbtQFdCp+0wAIfz5gNMebvQbSSCTfBa
 tI+1AW9QCgcDOnivK86DKLqsGqVSmVRvt/PPfR6P8mC87FMPeJ0KpN26c45ApMt+TLOFwmBbk
 hUFBVHir27SeFYJmkuZsNI+qW76d/1BIc2+/mXjN5CityYXG9RSdPq/Oyv5aOF7HDK/GsTu6R
 Wrjs/yTUKbmI2cQWcA6cfawaCF7/zm3Z4t5HntX3ouqRVDYNjHExF2gvLz2mjkTXNIzmDPdaY
 pSW78qPxE2zVVKXSsB2MoVmjOrrPCdMDKYg1yzy5e4stsvXZl8KbwABMhVmvVnhWazr51LoFt
 KLz9aMzeBVxaj+3FTlT8UJCUrOrSqoKzxoQt88lFnpEujp7gYPy5GmbDDWYJ+GdLnjqS5rl6P
 33f36WtbshxrINLCGmcIDIFOqr69AreMd9RHn7XEffKRpfEWIR/XaY+zse7g+lDDNDdtp0xAN
 XOhlaqpUvHg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/28 下午5:15, Nikolay Borisov wrote:
> 
> 
> On 28.12.18 г. 10:37 ч., Qu Wenruo wrote:
>> This patchset can be fetched from:
>> https://github.com/adam900710/linux/tree/bg_tree
>> Which is based on v4.20-rc1 tag.
>>
>> This patchset will hugely reduce mount time of large fs by putting all
>> block group items into its own tree.
>>
>> The old behavior will try to read out all block group items at mount
>> time, however due to the key of block group items are scattered across
>> tons of extent items, we must call btrfs_search_slot() for each block
>> group.
>>
>> It works fine for small fs, but when number of block groups goes beyond
>> 200, such tree search will become a random read, causing obvious slow
>> down.
>>
>> On the other hand, btrfs_read_chunk_tree() is still very fast, since we
>> put CHUNK_ITEMS into their own tree and package them next to each other.
>>
>>
>> Following this idea, we could do the same thing for block group items,
>> so instead of triggering btrfs_search_slot() for each block group, we
>> just call btrfs_next_item() and under most case we could finish in
>> memory, and hugely speed up mount (see BENCHMARK below).
>>
>> The only disadvantage is, this method introduce an incompatible feature,
>> so existing fs can't use this feature directly.
>> Either specify it at mkfs time, or use btrfs-progs offline convert tool
>> (*).
> 
> What if we start recording block group items in the chunk tree?

Then chunk tree will be too hot.

Currently chunk tree is pretty stable, only get modified at bg
creation/deletion time.

Considering how important chunk tree is, I prefer to make chunk root as
cold as possible.

On the other hand, block group items are pretty hot (although less hot
compared to old extent tree), so it still makes sense to put them into
one tree, allow chunk tree to be as cold as ice, while keep block group
items relatively safe compared to old extent tree.


Thanks,
Qu

> Would
> that bring any benefit without creating yet another tree, though likely
> we'd still have to use an incompat flag? That way shouldn't BLOCK_GROUP
> items be chunked together?
> 
>>
>> *: Mkfs and convert tool are doing the same work, however I haven't
>> decide if I should put this feature to btrfstune.
>>
>> The RFC tag is for the comprehensive test and sysfs interface.
>> At least during my filling test it definitely works fine.
>>
>> [[Benchmark]]
>> Physical device:	HDD (7200RPM)
>> Nodesize:		4K  (to bump up tree height)
>> Used size:		250G
>> Total size:		500G
>> Extent data size:	1M
>>
>> All file extents on disk is in 1M size, ensured by using fallocate.
>>
>> Without patchset:
>> Use ftrace function graph:
>>
>>   3)               |  open_ctree [btrfs]() {
>>   3)               |    btrfs_read_chunk_tree [btrfs]() {
>>   3) * 69033.31 us |    }
>>   3)               |    btrfs_verify_dev_extents [btrfs]() {
>>   3) * 90376.15 us |    }
>>   3)               |    btrfs_read_block_groups [btrfs]() {
>>   2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
>>   2) $ 3168384 us  |  } /* open_ctree [btrfs] */
>>
>>  btrfs_read_block_groups() takes 87% of the total mount time,
>>
>> With patchset, and use -O bg-tree mkfs option:
>>   7)               |  open_ctree [btrfs]() {
>>   7)               |    btrfs_read_chunk_tree [btrfs]() {
>>   7) # 2448.562 us |    }
>>   7)               |    btrfs_verify_dev_extents [btrfs]() {
>>   7) * 19802.02 us |    }
>>   7)               |    btrfs_read_block_groups [btrfs]() {
>>   7) # 8610.397 us |    }
>>   7) @ 113498.6 us |  }
>>
>>   open_ctree() time is only 3% of original mount time.
>>   And btrfs_read_block_groups() only takes 7.6% of total open_ctree()
>>   execution time.
>>
>>
>>
>> Qu Wenruo (2):
>>   btrfs: Refactor btrfs_read_block_groups()
>>   btrfs: Introduce new incompat feature, BG_TREE
>>
>>  fs/btrfs/ctree.h                |   5 +-
>>  fs/btrfs/disk-io.c              |  13 ++
>>  fs/btrfs/extent-tree.c          | 300 ++++++++++++++++++++------------
>>  include/uapi/linux/btrfs.h      |   1 +
>>  include/uapi/linux/btrfs_tree.h |   3 +
>>  5 files changed, 206 insertions(+), 116 deletions(-)
>>

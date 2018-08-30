Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:33706 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbeH3F5c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 01:57:32 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AA4C4AC0110
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:57:40 +0900 (JST)
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
 <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
 <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <b4ea89fd-7cb0-6d8e-a60a-d90d3b22d3e0@jp.fujitsu.com>
Date: Thu, 30 Aug 2018 10:57:17 +0900
MIME-Version: 1.0
In-Reply-To: <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/28 14:21, Qu Wenruo wrote:
> On 2018/8/24 下午4:09, Misono Tomohiro wrote:
> [snip]
>>>
>>> BTW, what's the possibility of such problem in your test environment?
>>
>> It's like one in several times.
>> It may depend on hardware performance? (the machine is not so fast),
>>
>> I also noticed following warning happens too (not always):
>>
> 
> After digging into the case, it's more complex than just my patch.
> 
> Firstly, we lacks a lot of underflow check when modifying bytes_may_use.
> So we need to do all the underflow detection for every modifier of
> bytes_may_use.
> 
> Secondly, btrfs_cross_ref_exist() check makes NODATACOW check in
> __btrfs_buffered_write() unreliable.
> 
> For the following case, at __btrfs_buffered_write() time we're pretty
> sure we could do NODATACOW, but at sync time, due to cloned range,
> btrfs_cross_ref_exist() would detect reflinked prealloc extent, then
> falls back to CoW, and finally cause bytes_may_use underflow:
> 
> ---
> mkfs.btrfs -f $dev > $full_log
> 
> mount $dev $mnt -o nospace_cache
> btrfs quota enable $mnt
> btrfs quota rescan -w $mnt
> 
> xfs_io -f -c "falloc 0 2M" $mnt/file1 > /dev/null
> xfs_io -c "pwrite -b 1M 0 1M" $mnt/file1 > /dev/null
> xfs_io -c "reflink $mnt/file1 1M 4M 1M" $mnt/file1 > /dev/null
> sync
> ----

Thanks for the explanation. I will try to understand the relevant code.

> 
> Even without my patch, the "pwrite" command is still CoWed, which could
> be avoided.
> And that's the reason my patch is causing the underflow.
> 
> To fix this, we need more accurate btrfs_cross_ref_exist() check, not
> only for @disk_bytenr but also check @len.
> 
> Or we could try to flush the whole inode in clone_range() so we could go
> through NOCOW routine before clone really happens.

So as your RFC patch does not work, the option is first one?

Thanks,
Misono

> 
> Thanks,
> Qu
> 

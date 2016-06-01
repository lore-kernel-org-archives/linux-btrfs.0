Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8111 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754531AbcFABcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 21:32:50 -0400
Subject: Re: [PATCH] btrfs-progs: convert: Fix a bug that makes convert
 asserts at scan time
To: <dsterba@suse.cz>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20160531075113.24603-1-quwenruo@cn.fujitsu.com>
 <20160531165046.GL29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b85fabc4-2290-b8cc-5379-fe67d7507718@cn.fujitsu.com>
Date: Wed, 1 Jun 2016 09:32:41 +0800
MIME-Version: 1.0
In-Reply-To: <20160531165046.GL29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 12:50 AM, David Sterba wrote:
> On Tue, May 31, 2016 at 03:51:13PM +0800, Qu Wenruo wrote:
>> When a ext2 fs filled with a 57M file, it's possible that convert fails
>> with assert in add_merge_cache_extent().
>>
>> The problem is that the ext2 used space just takes some of the second
>> superblock.
>> And due to a bug in reserving superblock space, it corrupted used space
>> tree and cause assert.
>>
>> Fix in by doing better used space merging for case where superblock
>> range is inside the ext2 used space.
>>
>> Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> The reproduce seems easy, do you have an image or test script for that?
> Pach applied.
>
>
I'll modify the convert test script to make sure it will always have 
enough data to cover backup super blocks.

Thanks,
Qu



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33377 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbbBTOhq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 09:37:46 -0500
Date: Fri, 20 Feb 2015 09:37:32 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix allocation size calculations in
 alloc_btrfs_bio
To: <dsterba@suse.cz>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zhao Lei <zhaolei@cn.fujitsu.com>
Message-ID: <1424443052.23448.0@mail.thefacebook.com>
In-Reply-To: <20150220143526.GS8720@suse.cz>
References: <20150220015930.GA28726@ret.masoncoding.com>
	<20150220143526.GS8720@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 20, 2015 at 9:35 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Feb 19, 2015 at 08:59:30PM -0500, Chris Mason wrote:
>>  Since commit 8e5cfb55d3f (Btrfs: Make raid_map array be inlined in
>>  btrfs_bio structure), the raid map array is allocated along with the
>>  btrfs bio in alloc_btrfs_bio.  The calculation used to decide how 
>> much
>>  we need to allocate was using the wrong parameter passed into the
>>  allocation function.
>> 
>>  The passed in real_stripes will be zero if a target replace 
>> operation
>>  is not currently running.  We want to use total_stripes instead.
>> 
>>  Signed-off-by: Chris Mason <clm@fb.com>
>>  Reported-by: Dave Sterba <dsterba@suse.cz>
> 
> Tested-by: David Sterba <dsterba@suse.cz>
> 
> Current master + this patch with full slub_debug is now ok with
> btrfs/023.

Thanks Dave.  It also survived all night with raid6 and stress.sh.  I'm 
sending to Linus today.

-chris




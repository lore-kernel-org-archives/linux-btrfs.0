Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:29191
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1161130AbeBNRWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 12:22:06 -0500
Subject: Re: Status of FST and mount times
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <1cbc7011-d319-38fb-7783-d500588ceef8@panasas.com>
Date: Wed, 14 Feb 2018 12:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/14/2018 12:08 PM, Nikolay Borisov wrote:
> V1 for large filesystems is jut awful. Facebook have been experiencing
> the pain hence they implemented v2. You can view the spacecache tree as
> the complement version of the extent tree. v1 cache is implemented as a
> hidden inode and even though writes (aka flushing of the freespace
> cache) are metadata they are essentially treated as data. This could
> potentially lead to priority inversions if cgroups io controller is
> involved.
> 
> Furthermore, there is at least 1 known deadlock problem in freespace
> cache v1. So yes, if you want to use btrfs ona multi-tb system v2 is
> really the way to go.

Fantastic.  Thanks for the backstory.  That is what I will plan to use 
then.  I've been operating with whatever the default is (I presume v1 
based on the man page), but haven't yet populated any of our machines 
sufficiently enough to notice performance degradation due to space cache 
problems.

> No, the long mount times seems to be due to the fact that in order for a
> btrfs filesystem to mount it needs to enumerate its block_groups items
> and those are stored in the extent tree, which also holds all of the
> information pertaining to allocated extents. So mixing those
> data structures in the same tree and the fact that blockgroups are
> iterated linearly during mount (check btrfs_read_block_groups) means on
> spinning rust with shitty seek times this can take a while.
> 
> However, this will really depend on the amount of extents you have and
> having taken a look at the thread you referred to it seems there is not
> clear-cut reason why mounting is taking so long on that particular
> occasion.

Ok; thanks.  To phrase it somewhat more simply, should I expect for 
"normal" datasets (think home directory) that happen to be part of a 
very large BTRFS filesystem (tens of TBs) to take more than 60s to 
mount?  Let's presume there isn't extreme fragmentation or any media 
errors to keep things simple.

Best,

ellis

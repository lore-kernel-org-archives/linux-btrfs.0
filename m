Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18914 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075AbaGQMg5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 08:36:57 -0400
Message-ID: <53C7C361.8060205@fb.com>
Date: Thu, 17 Jul 2014 08:36:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix abnormal long waiting in fsync
References: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com> <1405584516-16881-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1405584516-16881-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2014 04:08 AM, Liu Bo wrote:
> xfstests generic/127 detected this problem.
> 
> With commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8, now fsync will only flush
> data within the passed range.  This is the cause of the above problem,
> -- btrfs's fsync has a stage called 'sync log' which will wait for all the
> ordered extents it've recorded to finish.
> 
> In xfstests/generic/127, with mixed operations such as truncate, fallocate,
> punch hole, and mapwrite, we get some pre-allocated extents, and mapwrite will
> mmap, and then msync.  And I find that msync will wait for quite a long time
> (about 20s in my case), thanks to ftrace, it turns out that the previous
> fallocate calls 'btrfs_wait_ordered_range()' to flush dirty pages, but as the
> range of dirty pages may be larger than 'btrfs_wait_ordered_range()' wants,
> there can be some ordered extents created but not getting corresponding pages
> flushed, then they're left in memory until we fsync which runs into the
> stage 'sync log', and fsync will just wait for the system writeback thread
> to flush those pages and get ordered extents finished, so the latency is
> inevitable.
> 
> This adds a flush similar to btrfs_start_ordered_extent() in
> btrfs_wait_logged_extents() to fix that.

I was able to trigger the stalls with plain fsx as well.  Thanks!

-chris

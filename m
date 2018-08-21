Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726872AbeHUVPe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 17:15:34 -0400
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.liu@linux.alibaba.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] address lock contention of btree root
Date: Tue, 21 Aug 2018 13:54:11 -0400
Message-ID: <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
In-Reply-To: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 Aug 2018, at 17:07, Liu Bo wrote:

> The lock contention on btree nodes (esp. root node) is apparently a
> bottleneck when there're multiple readers and writers concurrently
> trying to access them.  Unfortunately this is by design and it's not
> easy to fix it unless with some complex changes, however, there is
> still some room.
>
> With a stable workload based on fsmark which has 16 threads creating
> 1,600K files, we could see that a good amount of overhead comes from
> switching path between spinning mode and blocking mode in
> btrfs_search_slot().
>
> Patch 1 provides more details about the overhead and test results from
> fsmark and dbench.
> Patch 2 kills leave_spinning due to the behaviour change from patch 1.

This is really interesting, do you have numbers about how often we are 
able to stay spinning?

IOW, do we end up blocking every time?

-chris

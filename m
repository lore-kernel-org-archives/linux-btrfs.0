Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32492 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2JZCF6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 22:05:58 -0400
Message-ID: <5089F003.8080400@oracle.com>
Date: Fri, 26 Oct 2012 10:05:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] flush delalloc by multi-task
References: <5089045D.8050801@cn.fujitsu.com> <50892821.5010808@oracle.com> <5089EDB7.8030306@cn.fujitsu.com>
In-Reply-To: <5089EDB7.8030306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2012 09:56 AM, Miao Xie wrote:
>> I can see the potential improvements brought by flushing inodes this way.
>> > 
>> > But I don't think it makes much sense by making waiting process multi-task,
>> > since even we spread wait order extents into different cpus, they just occpied
>> > the cpu and went on waiting and scheduled then, I mean, the bottleneck is on
>> > what we're waiting for.
> Thanks for your comment, I think only btrfs_run_ordered_operations(root, 0) needn't
> wait for the works, the others must wait.
> 
> The first reason is to avoid changing the semantic of those tree function. The second
> reason is we have to wait for the completion of all works, if not, the file data in
> snapshots may be different with the source suvolumes because the flush may not end
> before the snapshot creation.
> 

Yes, it's right that they must wait for all workers to finish.

But I don't mean that(sorry for my confusing words).

IMO we don't need to let *btrfs_wait_ordered_extents()* run as multi-task.

thanks,
liubo




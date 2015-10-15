Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47445 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbJOH5a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 03:57:30 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 15 Oct 2015 17:57:27 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 39C2A2CE8052
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 18:57:25 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9F7vCvM22741042
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 18:57:20 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9F7uquB027527
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 18:56:52 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, chandan@mykolab.com
Subject: Re: [PATCH V2] Btrfs-progs: Do not force mixed block group creation unless '-M' option is specified
Date: Thu, 15 Oct 2015 13:26:33 +0530
Message-ID: <5143356.m2iRuWGxTk@localhost.localdomain>
In-Reply-To: <561F05F1.4030409@cn.fujitsu.com>
References: <1444844377-19776-1-git-send-email-chandan@linux.vnet.ibm.com> <561F05F1.4030409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 15 Oct 2015 09:48:33 Qu Wenruo wrote:
> The mount failure also remind me about btrfs minimal size check.
> 
> Mkfs has its device check against nodesize by btrfs_min_dev_size() function.
> So this also means currect btrfs_min_dev_size() check is not good enough.
> 
> 
> Current code uses a quite simple one,
> 2 *(MKFS_SYSTEM_BLOCK_GROUP_SIZE + leaf_size << 10).
> But it still fails to be mounted.
> 
> Although not related to your patch, do you have any good calculation on
> the minimum device size?
>
Qu, Thanks for pointing this out. I missed out on this one. Currently I
have not got any numbers on arriving at a minimum device size. Will work on
that and post the results.

-- 
chandan


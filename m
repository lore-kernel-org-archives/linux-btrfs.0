Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7998 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbcD1OdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:33:16 -0400
Subject: Re: [PATCH RFC 00/16] Introduce low memory usage btrfsck mode
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <4635a8ca-0b56-223d-479c-0177ae7d197c@fb.com>
Date: Thu, 28 Apr 2016 10:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> The branch can be fetched from my github:
> https://github.com/adam900710/btrfs-progs.git low_mem_fsck_rebasing
>
> Original btrfsck checks extent tree in a very efficient method, by
> recording every checked extent in extent record tree to ensure every
> extent will be iterated for at most 2 times.
>
> However extent records are all stored in heap memory, and consider how
> large a btrfs file system can be, it can easily eat up all memory and
> cause OOM for TB-sized metadata.
>
> Instead of such heap memory usage, we introduce low memory usage fsck
> mode.
>
> In this mode, we will use btrfs_search_slot() only and avoid any heap
> memory allocation.
>
> The work flow is:
> 1) Iterate extent tree (backref check)
>    And check whether the referencer of every backref exists.
>
> 2) Iterate other trees (forward ref check)
>    And check whether the backref of every tree block/data exists in
>    extent tree.
>
> So in theory, every extent is iterated twice just as original one.
> But since we don't have extent record, but use btrfs_search_slot() every
> time we check, it will cause extra IO.
>
> I assume the extra IO is reasonable and should make btrfsck able to
> handle super large fs.
>
> TODO features:
> 1) Repair
>    Repair should be the same as old btrfsck, but still need to determine
>    the repair principle.
>    Current repair sometimes uses backref to repair data extent,
>    sometimes uses data extent to fix backref.
>    We need a consistent principle, or we will screw things up.
>
> 2) Replace current fsck code
>    We assume the low memory mode has less lines of code, and may be
>    easier for review and expand.
>
>    If low memory mode is stable enough, we will consider to replace
>    current extent and chunk tree check codes to free a lot of lines.
>
> 3) Further code refining
>    Reduce duplicated codes
>
> 4) Unify output
>    Make the output of low-memory mode same as the normal one.
>
> Lu Fengqi (16):
>   btrfs-progs: fsck: Introduce function to check tree block backref in
>     extent tree
>   btrfs-progs: fsck: Introduce function to check data backref in extent
>     tree
>   btrfs-progs: fsck: Introduce function to query tree block level
>   btrfs-progs: fsck: Introduce function to check referencer of a backref
>   btrfs-progs: fsck: Introduce function to check shared block ref
>   btrfs-progs: fsck: Introduce function to check referencer for data
>     backref
>   btrfs-progs: fsck: Introduce function to check shared data backref
>   btrfs-progs: fsck: Introduce function to check an extent
>   btrfs-progs: fsck: Introduce function to check dev extent item
>   btrfs-progs: fsck: Introduce function to check dev used space
>   btrfs-progs: fsck: Introduce function to check block group item
>   btrfs-progs: fsck: Introduce function to check chunk item
>   btrfs-progs: fsck: Introduce hub function for later fsck
>   btrfs-progs: fsck: Introduce function to speed up fs tree check
>   btrfs-progs: fsck: Introduce traversal function for fsck
>   btrfs-progs: fsck: Introduce low memory mode
>

I made it halfway through before I realized you are returning negative 
values for flag related errors.  Please don't do that.  Once you fix 
that up I'll review the rest of the series, and don't put my Reviewed-by 
tags on anything until you fix up the negative return value thing.  Thanks,

Josef


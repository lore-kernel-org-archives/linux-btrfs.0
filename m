Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33138 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbcDZNj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:39:28 -0400
Received: by mail-io0-f175.google.com with SMTP id f89so15895506ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 06:39:28 -0700 (PDT)
Subject: Re: [PATCH RFC 00/16] Introduce low memory usage btrfsck mode
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <571F6F45.9040201@gmail.com>
Date: Tue, 26 Apr 2016 09:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-25 23:48, Qu Wenruo wrote:
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
>     And check whether the referencer of every backref exists.
>
> 2) Iterate other trees (forward ref check)
>     And check whether the backref of every tree block/data exists in
>     extent tree.
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
>     Repair should be the same as old btrfsck, but still need to determine
>     the repair principle.
>     Current repair sometimes uses backref to repair data extent,
>     sometimes uses data extent to fix backref.
>     We need a consistent principle, or we will screw things up.
>
> 2) Replace current fsck code
>     We assume the low memory mode has less lines of code, and may be
>     easier for review and expand.
>
>     If low memory mode is stable enough, we will consider to replace
>     current extent and chunk tree check codes to free a lot of lines.
>
> 3) Further code refining
>     Reduce duplicated codes
>
> 4) Unify output
>     Make the output of low-memory mode same as the normal one.
>
> Lu Fengqi (16):
>    btrfs-progs: fsck: Introduce function to check tree block backref in
>      extent tree
>    btrfs-progs: fsck: Introduce function to check data backref in extent
>      tree
>    btrfs-progs: fsck: Introduce function to query tree block level
>    btrfs-progs: fsck: Introduce function to check referencer of a backref
>    btrfs-progs: fsck: Introduce function to check shared block ref
>    btrfs-progs: fsck: Introduce function to check referencer for data
>      backref
>    btrfs-progs: fsck: Introduce function to check shared data backref
>    btrfs-progs: fsck: Introduce function to check an extent
>    btrfs-progs: fsck: Introduce function to check dev extent item
>    btrfs-progs: fsck: Introduce function to check dev used space
>    btrfs-progs: fsck: Introduce function to check block group item
>    btrfs-progs: fsck: Introduce function to check chunk item
>    btrfs-progs: fsck: Introduce hub function for later fsck
>    btrfs-progs: fsck: Introduce function to speed up fs tree check
>    btrfs-progs: fsck: Introduce traversal function for fsck
>    btrfs-progs: fsck: Introduce low memory mode
>
>   Documentation/btrfs-check.asciidoc |    2 +
>   cmds-check.c                       | 1667 +++++++++++++++++++++++++++++++++---
>   ctree.h                            |    2 +
>   extent-tree.c                      |    2 +-
>   4 files changed, 1536 insertions(+), 137 deletions(-)
>
I don't really have a stock of broken FS images to test this with, but 
I've checked it against known good ones and it correctly identifies them 
as good (I've tested all the profiles except raid5 and raid6 in both 
normal and mixed-bg variants, with all combinations of profiles between 
data and metadata, and with 2-8 devices for the multi-device levels, 
most of the involved filesystems were on LVM thinp storage with mostly 
sparse files), and it properly repairs the couple of broken filesystems 
I can make by hand (mostly stuff with orphaned inodes or bad ref-counts) 
in the same way the existing code repairs them, all while using 
measurably less memory as advertised, so you can add:

Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

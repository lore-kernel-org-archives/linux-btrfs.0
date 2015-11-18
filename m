Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35939 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbbKRNl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 08:41:59 -0500
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 18 Nov 2015 19:11:56 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 1AA293940049
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 19:11:55 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAIDfrw261931688
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 19:11:53 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAIDfqhi027008
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 19:11:52 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V12 00/14] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size.
Date: Wed, 18 Nov 2015 19:11:49 +0530
Message-ID: <1747594.t1uFRQtHSi@localhost.localdomain>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 16 Nov 2015 12:38:27 Chandan Rajendra wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
> 
> This patchset continues with the work posted previously at
> https://lwn.net/Articles/646937/.
> 
> I have reverted the upstream commit "btrfs: fix lockups from
> btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
> since this led to soft-lockups when the patch "Btrfs:
> subpagesize-blocksize: Prevent writes to an extent buffer when
> PG_writeback flag is set" is applied.
> 
> The commits for the Btrfs kernel module can be found at
> https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.
> 
> The commits for Btrfs-progs can be found at
> https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.
> 
> Changes from V11:
> 1. Addressed the review comments provided by Liu Bo for version V11.
> 2. Fixed file defragmentation code to work in subpagesize-blocksize
>    scenario.
> 3. Many "hard to reproduce" bugs were fixed.
> 
> fstests run status:
> 1. On x86_64, all the tests (i.e. both generic and btrfs specific
>    tests) pass
>    - With 2k and 4k data blocksize combinations.
>    - With and without nodatacow option.
> 2. On ppc64, generic tests were run with 4k data block size and 16k
>    metadata block size. generic/300 fails because of an issue with the
>    fio tool. The failure is seen even when running the test for other
>    filesystems (i.e. ext4 and xfs).

One more mistake from my side. On x86_64, For 2k block size, only generic
tests were run (since the goal was to get regular I/O upstreamed first and
then get the features upstreamed in subsequent releases).

However, On x86_64, with 4k block size, all the tests (i.e. generic and btrfs
specific) pass indicating that the changes do not cause any regression in
other Btrfs features.

-- 
chandan


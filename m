Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932124AbcI1ND2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 09:03:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SD35Or114242
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 09:03:28 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25r7khkas3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 09:03:27 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 28 Sep 2016 23:03:24 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
        by d23dlp02.au.ibm.com (Postfix) with ESMTP id 42A6A2BB0059
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 23:03:22 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u8SD3MGv3473806
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 23:03:22 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u8SD3LkW023408
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Sep 2016 23:03:22 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Date: Wed, 28 Sep 2016 18:33:16 +0530
In-Reply-To: <cover.1474580472.git.osandov@fb.com>
References: <cover.1474580472.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2118496.9cv27FvD1a@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, September 22, 2016 05:22:31 PM Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This is v2 of my earlier series "Btrfs: fix free space tree
> bitmaps+tests on big-endian systems" [1]. Patches 1, 4, and 5 are the
> same as patches 1, 2, and 3 from the original series. I've added patch 2
> to fix another bug I noticed (an xfstest went out earlier). Patch 3 is
> the result of the earlier discussion here [2]. Finally, patch 6 was
> necessary to get the sanity tests to run on my MIPS emulator.
> 
> This series applies to v4.8-rc7. The sanity tests pass on both x86-64
> and MIPS, and there are no xfstests regressions. Chandan and Anatoly,
> could you test these out as well?

Hello Omar,

I have executed xfstests on a big endian ppc64 guest with 'MOUNT_OPTIONS="-o
space_cache=v2"' config option. I have also executed generic/127 on a
filesystem created using "fragment-free-space-tree.py" that you had provided
sometime ago. I did not notice any regressions during the test runs.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

> 
> I'm working on the btrfs-progs follow up, but these patches are safe
> without that -- the new FREE_SPACE_TREE_VALID bit will stop all versions
> of btrfs-progs from mounting read-write.
> 
> Thanks!
> 
> 1: http://marc.info/?l=linux-btrfs&m=146853909905570&w=2
> 2: http://marc.info/?l=linux-btrfs&m=147448992301110&w=2
> 
> Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Cc: Anatoly Pugachev <matorola@gmail.com>
> 
> Omar Sandoval (6):
>   Btrfs: fix free space tree bitmaps on big-endian systems
>   Btrfs: fix mount -o clear_cache,space_cache=v2
>   Btrfs: catch invalid free space trees
>   Btrfs: fix extent buffer bitmap tests on big-endian systems
>   Btrfs: expand free space tree sanity tests to catch endianness bug
>   Btrfs: use less memory for delalloc sanity tests
> 
>  fs/btrfs/ctree.h                       |   3 +-
>  fs/btrfs/disk-io.c                     |  33 ++++---
>  fs/btrfs/extent_io.c                   |  64 +++++++++----
>  fs/btrfs/extent_io.h                   |  22 +++++
>  fs/btrfs/free-space-tree.c             |  19 ++--
>  fs/btrfs/tests/extent-io-tests.c       |  95 +++++++++++--------
>  fs/btrfs/tests/free-space-tree-tests.c | 164 +++++++++++++++++++--------------
>  include/uapi/linux/btrfs.h             |  10 +-
>  8 files changed, 261 insertions(+), 149 deletions(-)
> 
> 

-- 
chandan


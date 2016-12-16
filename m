Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44343 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751664AbcLPGMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 01:12:07 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBG691ja081045
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 01:12:06 -0500
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [125.16.236.3])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27c9usuh1n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 01:12:06 -0500
Received: from localhost
        by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 16 Dec 2016 11:42:02 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
        by d28dlp01.in.ibm.com (Postfix) with ESMTP id 0756BE0045
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 11:42:38 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
        by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBG6C0YI29098082
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 11:42:00 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
        by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBG6Bv0d024811
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2016 11:41:59 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, t-itoh@jp.fujitsu.com
Subject: Re: [PATCH v2 2/3] btrfs-progs: convert: Rework rollback to handle new convert image
Date: Fri, 16 Dec 2016 11:41:49 +0530
In-Reply-To: <20161215090331.27486-3-quwenruo@cn.fujitsu.com>
References: <20161215090331.27486-1-quwenruo@cn.fujitsu.com> <20161215090331.27486-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3301134.NkFMPhqS6q@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, December 15, 2016 05:03:30 PM Qu Wenruo wrote:
> Although commit 9c4b820412746b3 tried to make the rollback condition
> less restrict, to co-operate with new rollback behavior, it's still too
> restrict.
> 
> If btrfs allocates a new data chunk, it's highly possible that the new
> chunk will not be 1:1 mapped anymore.
> 
> And this makes old rollback check fails, and refuse to rollback.
> 
> This patch rework it by checking rollback condition more accurately.
> 
> 1) Rollback condition
>    Unlike old chunk level check, we use file extent level check.
>    So we manually check every file extents of convert image file.
> 
>    Only when all file extents except ones in btrfs relocated ranges(*)
>    are mapped 1:1 we allow rollback.
> 
>    This behavior make both old and new behavior happy.
> *:
>    [0, 1M)
>    [btrfs_sb_offset(1), +64K)
>    [btrfs_sb_offset(2), +64K)
> 
> 2) Rollback method
>    Old rollback method is quite complex, using extent_io tree to mark
>    every checked ranges.
>    And do extra chunk tree operation before rollback.
> 
>    The new rollback method is quite simple.
>    1) open btrfs
>    2) read and save relocated data
>    3) close btrfs
>    4) write relocated into place.
> 
> Such rework fixes the following problem
> 1) rollback failure after new data chunk allocation
> 2) rollback failure after correct NO_HOLES convert

Hi Qu,

With this patch applied, I get the following on an x86_64 machine,

[root@localhost]~/btrfs-progs# btrfs-convert -r /dev/loop0
ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 1
btrfs-convert(btrfs_search_slot+0x117)[0x40c906]
btrfs-convert(btrfs_lookup_dir_item+0x70)[0x41d902]
btrfs-convert(main+0x5e2)[0x43af50]
/lib64/libc.so.6(__libc_start_main+0xf0)[0x7f7fb6168700]
btrfs-convert(_start+0x29)[0x408a69]
extent buffer leak: start 67305472 len 16384
rollback complete

The same error occurs on a ppc64 machine when using 64k sectorsize.

The three 'rollback' patches were applied on top of commit
9ce512ac57cb08edf2f742da085c383834f804dd (i.e. btrfs-progs: check: Fix false
alert on generation mismatch for tree reloc tree) that is available on David's
devel branch.

-- 
chandan


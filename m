Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34775 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751897AbdFSKTq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:19:46 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5JADawE088727
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 06:19:45 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b5uhbj58v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 06:19:45 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 19 Jun 2017 20:19:42 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5JAJeKZ61931576
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 20:19:40 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5JAJd3x003487
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 20:19:39 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH V21 00/19] Allow I/O on blocks whose size is less than page size
Date: Mon, 19 Jun 2017 15:49:58 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2455370.yFnDnVSDiF@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, October 2, 2016 6:54:09 PM IST Chandan Rajendra wrote:
> Btrfs assumes block size to be the same as the machine's page
> size. This would mean that a Btrfs instance created on a 4k page size
> machine (e.g. x86) will not be mountable on machines with larger page
> sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
> incompatibility.
> 
> This patchset continues with the work posted previously at
> http://marc.info/?l=linux-btrfs&m=146760691422240&w=2
> 
> This patchset is based on top of Josef's
> 1. Metadata throttling in writeback patches
> 2. Kill the btree inode patches

Hi Josef,

Did you get any chance to work on the above listed patchsets? 

Please let me know when you get a fairly working solution uploaded on your 
Linux git tree. I could use it to rebase my patchset and start testing the
code base.

I have put in a lot of time & effort to get the subpage-blocksize
patchset in its current form. Rebasing and retesting the
subpage-blocksize patchset across various kernel releases also would
consume time. It would be great to have it merged into the mainline
kernel. Once that is done, I will have to get other features of Btrfs
(scrub, compression, etc) to work in subpage-blocksize scenario.

It would be great to have it merged into the mainline kernel
soon. Once that is done, I will have to get other features of Btrfs
(scrub, compression, etc) to work in subpage-blocksize scenario.

> The major change in this version is the usage of kmalloc()-ed memory for
> holding metadata blocks whose size is less than the machine's page size. This
> vastly reduces the complexity of extent buffer mangement (Thanks to Josef's
> "Kill the btree inode patches").
> 
> When writing back dirty extent buffers, we currently track the corresponding
> extent buffers using the pointer at page->private. With kmalloc-ed() memory
> this isn't possible and hence we track the first extent buffer under writeback
> using bio->bi_private. Also, For kmalloc-ed() extent buffers this patchset
> currently limits the number of dirty extent buffers in a "write" bio to
> 1. This limit will be removed in a future patchset.
> 

-- 
chandan


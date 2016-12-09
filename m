Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39529 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751701AbcLIEgd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 23:36:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB94Y5IX024615
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Dec 2016 23:36:31 -0500
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [125.16.236.5])
        by mx0a-001b2d01.pphosted.com with ESMTP id 277gu61eyw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 23:36:30 -0500
Received: from localhost
        by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 10:06:27 +0530
Received: from d28relay08.in.ibm.com (d28relay08.in.ibm.com [9.184.220.159])
        by d28dlp02.in.ibm.com (Postfix) with ESMTP id D1A103940062
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Dec 2016 10:06:24 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
        by d28relay08.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uB94ZlWa15007810
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 10:05:47 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
        by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uB94aKJ9030864
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 10:06:24 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 1/2] btrfs-progs: btrfs-convert: Prevent accounting blocks beyond end of device
Date: Fri, 09 Dec 2016 10:06:14 +0530
In-Reply-To: <799009dd-e227-4c84-ab6a-08883e6a32c7@cn.fujitsu.com>
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com> <799009dd-e227-4c84-ab6a-08883e6a32c7@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <5627774.NPeg28U8hM@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 09, 2016 09:03:57 AM Qu Wenruo wrote:
> Hi Chandan,
> 
> Thanks for the patch.
> 
> At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> > When looping across data block bitmap, __ext2_add_one_block() may add
> > blocks which do not exist on the underlying disk. This commit prevents
> > this from happening by checking the block index against the maximum
> > block count that was present in the ext4 filesystem instance that is
> > being converted.
> 
> The patch looks good to me.
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Just curious about if such image can pass e2fsck.
> And would you please upload a minimal image as btrfs-progs test case?
> 

Hi Qu,

Such an ext4 filesystem can be consistently created on ppc64 with 64k as the
blocksize of the filesystem. Also, the filesystem thus created passes e2fsck.

-- 
chandan


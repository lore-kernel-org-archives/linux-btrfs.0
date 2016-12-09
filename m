Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35827 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752637AbcLIFPP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Dec 2016 00:15:15 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB95Dh6G041325
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 00:15:14 -0500
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 277gu43gja-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Dec 2016 00:15:13 -0500
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 15:15:11 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id 2C5C13578056
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Dec 2016 16:15:09 +1100 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uB95F9wl52494494
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 16:15:09 +1100
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uB95F8hf005373
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 16:15:08 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 2/2] btrfs-convert: Fix migrate_super_block() to work with 64k sectorsize
Date: Fri, 09 Dec 2016 10:45:01 +0530
In-Reply-To: <c861f566-09fd-3f41-ddfa-da5a9d08c04b@cn.fujitsu.com>
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com> <1481205380-22978-2-git-send-email-chandan@linux.vnet.ibm.com> <c861f566-09fd-3f41-ddfa-da5a9d08c04b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2489836.PUOOGX6Bkg@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 09, 2016 09:09:29 AM Qu Wenruo wrote:
> 
> At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> > migrate_super_block() uses sectorsize to refer to the size of the
> > superblock. Hence on 64k sectorsize filesystems, it ends up computing
> > checksum beyond the super block length (i.e.
> > BTRFS_SUPER_INFO_SIZE). This commit fixes the bug by using
> > BTRFS_SUPER_INFO_SIZE instead of sectorsize of the underlying
> > filesystem.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> BTW would you please enhance the convert tests?
> Current convert tests only uses 4K as block size.
> So adding 64K blocksize would definitely improve the tests.
>

Thanks for the hint. I just executed btrfs/012 with 64k blocksize hardcoded
and found that 'btrfs rollback' failed. I will fix rollback first and then
work on getting btrfs/012 to support 64k blocksize.

-- 
chandan


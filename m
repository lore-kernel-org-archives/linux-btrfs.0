Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932312AbcLMM5I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 07:57:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBDCsJUb052724
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 07:57:07 -0500
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27acdaqy3e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 07:57:06 -0500
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 13 Dec 2016 22:57:04 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
        by d23dlp02.au.ibm.com (Postfix) with ESMTP id 9D9662BB0055
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 23:57:02 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBDCv3vm54526150
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 23:57:03 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBDCv2iR028409
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 23:57:02 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges
Date: Tue, 13 Dec 2016 18:26:59 +0530
In-Reply-To: <20161202020307.6025-2-quwenruo@cn.fujitsu.com>
References: <20161202020307.6025-1-quwenruo@cn.fujitsu.com> <20161202020307.6025-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <16662538.OxiIrCRCJe@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 02, 2016 10:03:07 AM Qu Wenruo wrote:
> [BUG]
> For the following case, btrfs can underflow qgroup reserved space
> at error path:
> (Page size 4K, function name without "btrfs_" prefix)
> 
>          Task A                  |             Task B
> ----------------------------------------------------------------------
> Buffered_write [0, 2K)           |
> |- check_data_free_space()       |
> |  |- qgroup_reserve_data()      |
> |     Range aligned to page      |
> |     range [0, 4K)          <<< |
> |     4K bytes reserved      <<< |
> |- copy pages to page cache      |
>                                  | Buffered_write [2K, 4K)
>                                  | |- check_data_free_space()
>                                  | |  |- qgroup_reserved_data()
>                                  | |     Range alinged to page
>                                  | |     range [0, 4K)
>                                  | |     Already reserved by A <<<
>                                  | |     0 bytes reserved      <<<
>                                  | |- delalloc_reserve_metadata()
>                                  | |  And it *FAILED* (Maybe EQUOTA)
>                                  | |- free_reserved_data_space()
>                                       |- qgroup_free_data()
>                                          Range aligned to page range
>                                          [0, 4K)
>                                          Freeing 4K
> (Special thanks to Chandan for the detailed report and analyse)
> 
> [CAUSE]
> Above Task B is freeing reserved data range [0, 4K) which is actually
> reserved by Task A.
> 
> And at write back time, page dirty by Task A will go through writeback
> routine, which will free 4K reserved data space at file extent insert
> time, causing the qgroup underflow.
> 
> [FIX]
> For btrfs_qgroup_free_data(), add @reserved parameter to only free
> data ranges reserved by previous btrfs_qgroup_reserve_data().
> So in above case, Task B will try to free 0 byte, so no underflow.
>

The changes look good to me. Also, I did not notice any regressions when
executing fstests with the patch applied.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


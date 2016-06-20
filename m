Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44357 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbcFTNZk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 09:25:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5KDDeS4089742
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 09:24:59 -0400
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23n2u61vv2-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 09:24:58 -0400
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 20 Jun 2016 18:54:55 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 1FF051258063
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 18:57:29 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5KDOll112779874
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 18:54:47 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5KDOpLe003184
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 18:54:53 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [PATCH V19 05/19] Btrfs: subpage-blocksize: Read tree blocks whose size is < PAGE_SIZE
Date: Mon, 20 Jun 2016 18:54:46 +0530
In-Reply-To: <20160620115405.GN4915@twin.jikos.cz>
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com> <1465888276-30670-6-git-send-email-chandan@linux.vnet.ibm.com> <20160620115405.GN4915@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <20090822.rsoLvuiIVa@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, June 20, 2016 01:54:05 PM David Sterba wrote:
> On Tue, Jun 14, 2016 at 12:41:02PM +0530, Chandan Rajendra wrote:
> > In the case of subpage-blocksize, this patch makes it possible to read
> > only a single metadata block from the disk instead of all the metadata
> > blocks that map into a page.
> 
> This patch has a conflict with a next pending patch
> 
> "Btrfs: fix eb memory leak due to readpage failure"
> https://patchwork.kernel.org/patch/9153927/
>

I will fix this and also the merge conflict in the patch " [PATCH V19 11/19]
Btrfs: subpage-blocksize: Prevent writes to an extent buffer when PG_writeback
flag is set" and resend the patchset.

-- 
chandan


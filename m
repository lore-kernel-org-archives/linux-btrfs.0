Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27520 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbcG0OuE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 10:50:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6REmoGk051098
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 10:50:04 -0400
Received: from e28smtp06.in.ibm.com (e28smtp06.in.ibm.com [125.16.236.6])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24e27dxg04-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 10:50:03 -0400
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 27 Jul 2016 20:20:00 +0530
Received: from d28relay09.in.ibm.com (d28relay09.in.ibm.com [9.184.220.160])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 278763940066
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 20:19:57 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay09.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6REnuqw30277870
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 20:19:56 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6REntFK022000
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 20:19:56 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <jbacik@fb.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V20 04/19] Btrfs: subpage-blocksize: Define extent_buffer_head
Date: Wed, 27 Jul 2016 20:19:49 +0530
In-Reply-To: <99c633e7-38b8-3147-aca8-3be34dd32295@fb.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com> <1467606879-14181-5-git-send-email-chandan@linux.vnet.ibm.com> <99c633e7-38b8-3147-aca8-3be34dd32295@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2038528.NqA4dD0tmx@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, July 26, 2016 01:42:08 PM Josef Bacik wrote:
> On 07/04/2016 12:34 AM, Chandan Rajendra wrote:
> > In order to handle multiple extent buffers per page, first we need to create a
> > way to handle all the extent buffers that are attached to a page.
> >
> > This patch creates a new data structure 'struct extent_buffer_head', and moves
> > fields that are common to all extent buffers from 'struct extent_buffer' to
> > 'struct extent_buffer_head'
> >
> > Also, this patch moves EXTENT_BUFFER_TREE_REF, EXTENT_BUFFER_DUMMY and
> > EXTENT_BUFFER_IN_TREE flags from extent_buffer->ebflags  to
> > extent_buffer_head->bflags.
> >
> > Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> I'm sorry Chandan I'm still having problems with this one.  XFS kmalloc()'s its 
> sub pagesize ranges for it's metadata buffers, how about we do that instead of 
> doing the extent_buffer_head.  Look at xfs_buf_allocate_memory() for what I'm 
> thinking.  Thanks,
> 

Ok. I will look into the xfs metadata buffer allocation code. Thanks for the
guidance.

-- 
chandan


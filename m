Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35897 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750795AbdEIGTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 02:19:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4969nDf008454
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 02:19:41 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2aaky76ph8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 May 2017 02:19:41 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 9 May 2017 16:19:39 +1000
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v496JSJb2425154
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:19:36 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v496J4Vs024650
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:19:04 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/3] Btrfs: replace tree->mapping with tree->private_data
Date: Tue, 09 May 2017 11:48:41 +0530
In-Reply-To: <1493999835-26731-2-git-send-email-jbacik@fb.com>
References: <1493999835-26731-1-git-send-email-jbacik@fb.com> <1493999835-26731-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2739487.yeMUBoeZhI@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, May 05, 2017 11:57:13 AM Josef Bacik wrote:
> For extent_io tree's we have carried the address_mapping of the inode around in
> the io tree in order to pull the inode back out for calling into various tree
> ops hooks.  This works fine when everything that has an extent_io_tree has an
> inode.  But we are going to remove the btree_inode, so we need to change this.
> Instead just have a generic void * for private data that we can initialize with,
> and have all the tree ops use that instead.  This had a lot of cascading changes
> but should be relatively straightforward.
>

The changes look fine,

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


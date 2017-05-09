Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52393 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750723AbdEIG0N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 02:26:13 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v496AFW8019932
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 02:26:12 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2aahm9v50q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 May 2017 02:26:12 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 9 May 2017 16:26:09 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v496Px8I65273876
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:26:07 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v496PSC3018928
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:25:29 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/3] btrfs: remove inode argument from repair_io_failure
Date: Tue, 09 May 2017 11:55:17 +0530
In-Reply-To: <1493999835-26731-3-git-send-email-jbacik@fb.com>
References: <1493999835-26731-1-git-send-email-jbacik@fb.com> <1493999835-26731-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <5662924.YjcH1cXGKv@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, May 05, 2017 11:57:14 AM Josef Bacik wrote:
> Once we remove the btree_inode we won't have an inode to pass anymore, just pass
> the fs_info directly and the inum since we use that to print out the repair
> message.
>
The changes look fine,

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


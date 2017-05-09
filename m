Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55511 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750969AbdEIG1W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 02:27:22 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v496A5Tx106635
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 02:27:22 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2aap5hqdv2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 May 2017 02:27:21 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 9 May 2017 16:27:19 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v496R81v65601566
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:27:16 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v496Qc8Y021028
        for <linux-btrfs@vger.kernel.org>; Tue, 9 May 2017 16:26:38 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/3] Btrfs: don't pass the inode through clean_io_failure
Date: Tue, 09 May 2017 11:56:21 +0530
In-Reply-To: <1493999835-26731-4-git-send-email-jbacik@fb.com>
References: <1493999835-26731-1-git-send-email-jbacik@fb.com> <1493999835-26731-4-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1602559.yReBo4IrkG@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, May 05, 2017 11:57:15 AM Josef Bacik wrote:
> Instead pass around the failure tree and the io tree.
>
The changes look fine,

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


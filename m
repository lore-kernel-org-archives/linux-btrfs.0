Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47037 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750753AbdAXJBy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 04:01:54 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0O8waER076759
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 04:01:53 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28607jfpp9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 04:01:53 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 24 Jan 2017 09:01:51 -0000
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/1] btrfs lockdep annotation
Date: Tue, 24 Jan 2017 10:01:46 +0100
In-Reply-To: <20161126134638.GA79987@clm-mbp.masoncoding.com>
References: <20161126134638.GA79987@clm-mbp.masoncoding.com>
Message-Id: <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

since my bug report about this did not result in any fix and since
this disables lockdep before the the code that I want to debug runs
here is my attempt to fix it.
Please double check if the subclass looks right. It seems to work
for me but I do not know enough about btrfs to decide if this is
right or not.

Christian Borntraeger ():
  btrfs: add lockdep annotation for btrfs_log_inode

 fs/btrfs/tree-log.c    | 2 +-

-- 
2.7.4


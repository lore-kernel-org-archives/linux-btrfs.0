Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751769AbcLMMzk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 07:55:40 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBDCtMmd040634
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 07:55:39 -0500
Received: from e28smtp01.in.ibm.com (e28smtp01.in.ibm.com [125.16.236.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27afuj4jv1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 07:55:35 -0500
Received: from localhost
        by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 13 Dec 2016 18:24:37 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
        by d28dlp03.in.ibm.com (Postfix) with ESMTP id 3ECAD1258026
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 18:25:48 +0530 (IST)
Received: from d28av06.in.ibm.com (d28av06.in.ibm.com [9.184.220.48])
        by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBDCsZUF31719592
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 18:24:35 +0530
Received: from d28av06.in.ibm.com (localhost [127.0.0.1])
        by d28av06.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBDCsZw0027269
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 18:24:35 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
Date: Tue, 13 Dec 2016 18:24:34 +0530
In-Reply-To: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
References: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <12571184.mBYZ8QYGcb@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, December 02, 2016 10:03:06 AM Qu Wenruo wrote:
> Introduce a new parameter, struct extent_changeset for
> btrfs_qgroup_reserved_data() and its callers.
> 
> Such extent_changeset was used in btrfs_qgroup_reserve_data() to record
> which range it reserved in current reserve, so it can free it at error
> path.
> 
> The reason we need to export it to callers is, at buffered write error
> path, without knowing what exactly which range we reserved in current
> allocation, we can free space which is not reserved by us.
> 
> This will lead to qgroup reserved space underflow.

The changes look good to me.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


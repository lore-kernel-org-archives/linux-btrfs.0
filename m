Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751367AbcLHOc1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 09:32:27 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB8EVDYL063082
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Dec 2016 09:32:26 -0500
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0b-001b2d01.pphosted.com with ESMTP id 277857vpw4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 09:32:25 -0500
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 00:32:22 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp01.au.ibm.com (Postfix) with ESMTP id C96BF2CE8046
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Dec 2016 01:32:20 +1100 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uB8EWKbI50004132
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 01:32:20 +1100
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uB8EWKRT022261
        for <linux-btrfs@vger.kernel.org>; Fri, 9 Dec 2016 01:32:20 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
Date: Thu, 08 Dec 2016 19:59:02 +0530
In-Reply-To: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
References: <20161202020307.6025-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <10093188.Rk5diOXqMO@localhost.localdomain>
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
>

Hi Qu,

On which git tree are these patches based off? This patch fails to apply
cleanly on kdave/for-next branch that is available as of today.

-- 
chandan


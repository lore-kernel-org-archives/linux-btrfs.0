Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39935 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750714AbcLTFhH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 00:37:07 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBK5Y6xN136537
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 00:37:07 -0500
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27eu7242hs-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 00:37:07 -0500
Received: from localhost
        by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 20 Dec 2016 11:07:03 +0530
Received: from d28relay07.in.ibm.com (d28relay07.in.ibm.com [9.184.220.158])
        by d28dlp01.in.ibm.com (Postfix) with ESMTP id 9BA47E005B
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 11:07:38 +0530 (IST)
Received: from d28av07.in.ibm.com (d28av07.in.ibm.com [9.184.220.146])
        by d28relay07.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uBK5aGcc23855280
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 11:06:16 +0530
Received: from d28av07.in.ibm.com (localhost [127.0.0.1])
        by d28av07.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uBK5atlU008575
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 11:06:56 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/6] btrfs-progs: convert: Switch to new rollback function
Date: Tue, 20 Dec 2016 11:06:45 +0530
In-Reply-To: <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com> <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2378890.0M2mVh5Brl@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, December 19, 2016 02:56:41 PM Qu Wenruo wrote:
> Since we have the whole facilities needed to rollback, switch to the new
> rollback.
> 
> The new rollback function can handle the following things that old
> rollback either can't handle or just refuse to rollback:
> 
> 1) New converted btrfs which allocates new data chunk
>    This is due to the too restrict may_roll_back() condition, which is
>    never a good friend for new convert behavior.
> 
>    The new rollback behavior fixes it by not checking data chunks, but
>    only to check the file extents of the convert image file.
> 
>    If all file extents except the ones in reserved ranges, then we allow
>    rollback.
> 
> 2) New converted btrfs which enabled NO_HOLES feature
>    Thanks to previous patches, we can convert to real NO_HOLES btrfs.
> 
>    And since old rollback assumes that file extents and holes covers the
>    whole image file, it will fail due to the non-exists holes.
> 
>    Fix it by iterating file extents of convert image, and only compare
>    the size we checked against file size if NO_HOLES is not enabled.
> 
> And makes rollback function simpler:
> 
> 1) Read-n-write vs extra chunk tree relocation
>    Since converted btrfs only has 3 ranges that are not 1:1 mapped, just
>    read this data out, and close btrfs, finally write them into position
>    will be good enough, for both new convert and old convert.
>    (To be more specific, old convert is just a subset of more universal
>     new convert behavior)
> 
>    No extra work is needed any more, and we can even open the btrfs RO.

Thanks for fixing this. The patchset works fine on ppc64 and x86_64.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan


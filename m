Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27711C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB9DB214FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EKQXPSiA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB9DB214FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbeJJHaN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeJJHaM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08ir7119775;
        Wed, 10 Oct 2018 00:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=EwpExZkig2pk5zdSUywkHCsBn4AvIvIdP/tZHlnRRak=;
 b=EKQXPSiA1kBBDN5FnnNjNOfG82n/5TMHQLfm+rSHzEyjKalDy3HjJj13G1o92f4xeDuA
 B20y4W90AlizGaV11meHzNAQd1wyoC9x5b8kbQxNPOBZbMnVi7bjeecIGYU56k/SIwla
 VSyhB5FUdXIjgWk1DMVKdp1Pk8exFH12LbInokoLzVGGXithUIL51dO8Qu38QqmIuF8K
 o5fnkhYNIratRaKfKU24Jb1xthoRibXG2s/mi5f3geJSAYCxu23AigP7rU4Lno5jFMAj
 yFpbJEo4moHapkvHJ/3QfdICbrcFCGm/wCDyLi+G0DkmhHYGXaYaWhnM2DCcpyTZpV0K XQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2mxmftrvfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0Af7L024746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:41 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0AetQ002669;
        Wed, 10 Oct 2018 00:10:40 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:10:40 +0000
Subject: [PATCH v2 00/25] fs: fixes for serious clone/dedupe problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:10:38 -0700
Message-ID: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=733
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

Dave, Eric, and I have been chasing a stale data exposure bug in the XFS
reflink implementation, and tracked it down to reflink forgetting to do
some of the file-extending activities that must happen for regular
writes.

We then started auditing the clone, dedupe, and copyfile code and
realized that from a file contents perspective, clonerange isn't any
different from a regular file write.  Unfortunately, we also noticed
that *unlike* a regular write, clonerange skips a ton of overflow
checks, such as validating the ranges against s_maxbytes, MAX_NON_LFS,
and RLIMIT_FSIZE.  We also observed that cloning into a file did not
strip security privileges (suid, capabilities) like a regular write
would.  I also noticed that xfs and ocfs2 need to dump the page cache
before remapping blocks, not after.

In fixing the range checking problems I also realized that both dedupe
and copyfile tell userspace how much of the requested operation was
acted upon.  Since the range validation can shorten a clone request (or
we can ENOSPC midway through), we might as well plumb the short
operation reporting back through the VFS indirection code to userspace.

So, here's the whole giant pile of patches[1] that fix all the problems.
The patch "generic: test reflink side effects" recently sent to fstests
exercises the fixes in this series.  Tests are in [2].

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

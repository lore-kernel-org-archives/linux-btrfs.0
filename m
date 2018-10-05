Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA17C64EBC
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A16BC20834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkT+nJtZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A16BC20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbeJEHkt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:40:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbeJEHkt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:40:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iJKF046870;
        Fri, 5 Oct 2018 00:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=EwpExZkig2pk5zdSUywkHCsBn4AvIvIdP/tZHlnRRak=;
 b=dkT+nJtZjz4UJ5PfuoWEJOhZpIYJXNMhY9tesisim7H78azhqEnNq0+WVQ5H6fuMU/mx
 y2Jc5V2FprUBMSDN8vhyYr+Y9NnGNxbst+C8MbN5/ZsN7RJhc0Dcy+4lEUijvWIb7aLe
 FLYTrxBdSpCvB+ty7V8Lt53+KsIUsXga0btImBi/cl5cSYAb1Z51TF86rcrVBOBsEuXl
 9dvrUw8DuOkB3CMoiKtFIDyvTaMy2m1ZL4/wMu/P8QvzS7N/jDqBT4I0HKMUdSJW45Wd
 opi3eG2AxASvULvktQjDfUKtpoZCEvQRDznulVtzFiEPCTjbj1BSZ3TukzZK8MxZIYgW Qg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mt1bqfkte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:44:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950iaD3003150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:44:36 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w950iZHc014162;
        Fri, 5 Oct 2018 00:44:35 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Oct 2018 17:44:35 -0700
Subject: [PATCH 00/15] fs: fixes for serious clone/dedupe problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:44:34 -0700
Message-ID: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=778
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
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

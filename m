Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DBFC71134
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2942089E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 15:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cdtMq74q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B2942089E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbeJOXSl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 19:18:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJOXSl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 19:18:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9FFPHLV049096;
        Mon, 15 Oct 2018 15:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VqCNfBszl9KoWUzC7oYrokhqLyA1pGP7T5IvmajnL5I=;
 b=cdtMq74qUlV3/Ds96bIb4fjlRpA+5QKHIeSHm8V6yM0Uurg2JDOvnNTlAq1M91mTiYXG
 A4N82KnYa5mrTZVT8RVjEJAiuFhYgO7vXTu7cnN3ONS0RPAMTBwqgJi+N9jWpjYvBV77
 9W5tpSm+sd/HzuTIkwAJZA87UeyaPecsZISaYujvihHTQ2vMREHQdvZTR1c39Ex6jYYb
 116cJzMO48FTeMEHGs+4XlBBhHE1znKHNxCtFKHUobD54LfOJgZbsoZWnUU75+ZqxLbh
 YIzoC3S3YxbgEKY1zIbZngCUz6bf3yno07mMthv62FcEheQjL9ZOVyFtovTiOOIMt044 lg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2n39br32xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 15:32:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9FFWMi0009136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 15:32:23 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9FFWMhH021861;
        Mon, 15 Oct 2018 15:32:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 08:32:22 -0700
Date:   Mon, 15 Oct 2018 08:32:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 16/25] vfs: make remapping to source file eof more
 explicit
Message-ID: <20181015153219.GG28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938925737.8361.3995899966552253527.stgit@magnolia>
 <20181014172433.GG30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014172433.GG30673@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810150138
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:24:33AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 12, 2018 at 05:07:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> > the remap implementation to remap to the end of the source file, once
> > the files are locked.
> 
> The name looks like a cat threw up on your keyboard :)

Yeah... :(

> From reading the code this seems to ask for a whole file remap, right?

Nope.  In the original btrfs clonerange ioctl, length == 0 meant "to EOF".
If you made a call like this:

struct btrfs_ioctl_clone_range_args x = {
	.src_offset = 16384,
	.src_length = 0,
	.dest_offset = 0,
	.src_fd = whatever,
};
ftruncate(dest_fd, 0);
ioctl(dest_fd, BTRFS_IOC_CLONE, &x);

Then dest_fd ends up with the contents of [16k...EOF] from src_fd.
It's annoying to have the magic length number (and no flags?) but we're
stuck with this quirk of the interface.

> Why not put that in the name to make it more descriptive?

I'm all ears for better suggestions. :)

--D

Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF8EC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 19:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EED52085B
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 19:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ixVu2YBu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EED52085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbeJICN2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 22:13:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbeJICN2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 22:13:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w98Irtsg010531;
        Mon, 8 Oct 2018 18:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=qMt4eNw5J2hTSYw6eri4uEkuo7pnoGU4chE+sBoQY/E=;
 b=ixVu2YBuA1lzdit6EbD0rSrhavK3VHSWG6ix8iNBcxfC7DS+n6RBxvwIv/z/T0U08guo
 TNDbLalIFtX9FeF/Fka6oiFbK66zKqP4NBN1g5z1XLZQPOsDRZz3v/K3sJR2iFZoHurK
 PUoCwVW+/lT29dgcpOX7xGNtdL4e8aUgSCB9hwMZ+Kz/febCkpfPDZn8/ovoO7dPWB/u
 RvF0bXylKlTFwowVQUUba2zUuVQt629yScqw9IfOstVUAJDJxtL3SWUNEASg+NOfJl9W
 La1EKFTO1zna1/0yMGqg7Z9z6fEZNrAGmj5kpUuNj5ePX2OQFvXAKbENZif3i7ldLB10 sw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0prnqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Oct 2018 18:59:53 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w98IxqKg025883
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Oct 2018 18:59:52 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w98Ixqkk012484;
        Mon, 8 Oct 2018 18:59:52 GMT
Received: from localhost (/10.159.224.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Oct 2018 18:59:52 +0000
Date:   Mon, 8 Oct 2018 11:59:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sandeen@redhat.com
Subject: Re: [PATCH 08/15] vfs: change clone and dedupe range function
 pointers to return bytes completed
Message-ID: <20181008185951.GF28243@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870033496.29072.3660384210745578982.stgit@magnolia>
 <20181006104134.GF25747@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006104134.GF25747@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9040 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=571
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810080178
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 06, 2018 at 03:41:34AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 05:45:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Change the clone_file_range and dedupe_file_range functions to return
> > the number of bytes they operated on.  This is the precursor to allowing
> > fs implementations to return short clone/dedupe results to the user,
> > which will enable us to obey resource limits in a graceful manner.
> 
> For clone this doesn't make any sense, as we don't allow 'short clones'.

That's correct.  The overall goal is that copy_file_range will be able
to call ->clone_file_range with a "I can handle a short clone" flag so
that the fs (and the prep functions) know that they're allowed to
shorten the request length, and we have a way to communicate the actual
results back to userspace.

Neither FS_IOC_CLONE nor FS_IOC_CLONERANGE will be able to take
advantage of this, of course.  They won't pass in the flag, and any
implementation that wants to shorten the length will pass back -EINVAL
instead.

--D

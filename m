Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E55C67872
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B1BF20865
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wM58N5tT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B1BF20865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbeJLXlW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:41:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbeJLXlW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 19:41:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9CG4Pe4129877;
        Fri, 12 Oct 2018 16:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KAR7OYuFAjtHlv9r2LOLtPrr0QdeIDUrggnp8sIGTdU=;
 b=wM58N5tTq/pLgZ0SuvpMAdlYXVYG6qeLcBcEJy1aQdTbDqKa/nG1fKtfpCnSLCRUOMZ2
 wVELj1FV5s9i8kTPv3sKQiZ3Pvv8SUZVZoo6anaHvE3L610/wVoQBOtrgsGeNoEJDtA5
 PQVWX9V9B3hAmAzm4qPxWHADPoVyITosVPFiUbqpvLLQcD28mq3Wu2mnkgP4IIbpNow2
 RdYyLUuf83UK3xMRKJ+W+HrnujX8TIuaOvAo5YdT3xY2BhjK443ynFlzp125sGaXV4XL
 AEDN5MJKlaIqVoHdqVv/xQDyrD4oCvzyHZS/jU1v36I0nvyghcQGn1EEG/5PXokNUQDS Cg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0qkj66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Oct 2018 16:08:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9CG81mG011696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Oct 2018 16:08:02 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9CG81S5012109;
        Fri, 12 Oct 2018 16:08:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Oct 2018 16:08:00 +0000
Date:   Fri, 12 Oct 2018 09:07:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
Message-ID: <20181012160759.GF28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923117420.5546.13317703807467393934.stgit@magnolia>
 <20181012001615.GR6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012001615.GR6311@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=651
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810120157
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 11:16:16AM +1100, Dave Chinner wrote:
> On Wed, Oct 10, 2018 at 09:12:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A deduplication data corruption is exposed by fstests generic/505 on
> > XFS. It is caused by extending the block match range to include the
> > partial EOF block, but then allowing unknown data beyond EOF to be
> > considered a "match" to data in the destination file because the
> > comparison is only made to the end of the source file. This corrupts the
> > destination file when the source extent is shared with it.
> > 
> > The VFS remapping prep functions only support whole block dedupe, but
> > we still need to appear to support whole file dedupe correctly.  Hence
> > if the dedupe request includes the last block of the souce file, don't
> > include it in the actual dedupe operation. If the rest of the range
> > dedupes successfully, then reject the entire request.  A subsequent
> > patch will enable us to shorten dedupe requests correctly.
> 
> Ok, so this patch rejects whole file dedupe requests, and then a
> later patch adds support back in for it?
> 
> Doesn't that leave a bisect landmine behind? Why separate the
> functionality like this?

Heh, it's a leftover from when I was trying to undo the behavior that
bytes_deduped == len even if we rounded down.  I gave up on that, so
this can match the xfs patch.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

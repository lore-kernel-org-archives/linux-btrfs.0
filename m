Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43514C64EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14962087D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ueGCForC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E14962087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbeJFRhK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:37:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33222 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeJFRhJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fCamliP5bTbGofLRZL6bwqm6ZWga6SbDTPkNcW/jzh8=; b=ueGCForCLjMRn6g/8aPX4xk++
        SXifzrwARbn6+mlM+dA97CWgsDPROJG2Yl74qZDgfXU7tPX6dUrE8TleWFL/ATIzYMsadsETsWJZc
        8MkNCa9JtkSXtNfSX707i6ZpyP+8IpbD42vRDGWHBHLsJTAHjsEbrsQjHRtsr+wqMw0NeRLwApXjd
        gcxK0xEZd9tVaxdRFglJR+YByd9MYG9g1sX+zYpVzuxJN4n0N1Pd4iAQlj5FPhjgR8Dl97bn1ypVK
        m8zrZn3cI5zDoe7d8ZWs15MYZ4f2HupsFiPSI3kqfFCc8e0YF1elW3F/XkQf6ultuC7kp9CRDwpdu
        7SI6rTizQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8juh-0008Cg-M0; Sat, 06 Oct 2018 10:34:23 +0000
Date:   Sat, 6 Oct 2018 03:34:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181006103423.GB25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870029414.29072.6572683664719818617.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.

But I think we should still drop speculative delalloc preallocations 
instead of zeroing them in addition to zeroing of any real blocks in
the data fork.

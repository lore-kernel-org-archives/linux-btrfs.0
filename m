Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F3FECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4D6214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bf6iPlGg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B4D6214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJQQcR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:32:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQcR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K6wb0xjTmhvUQrQcuIRzOX1ZIQfCeZdpAJexvtg0ysg=; b=bf6iPlGga7tezf25bjOufRvf2
        JGGeK2WjojvX6ZYM+xcpyKB5uWCC1w2TPpLnEMHFEyL4Ai14ovp5GguuNpgRmcNoq1Kf9y9OcUrSh
        i7a3RjEY7W10q5MHlQmU4x0oWLvl2yYYPndmaWSyHCmL/zd8c5+wS3WpDCZ+C2/ClejhyBm0sApKR
        Cy2Axw8Ra1dhEilKL9IPAKkbuOZyxN2MZ3v2WBgPnwC9/M0wVNb6LAi2biX7Zmn+WsLCSlQc6SMKd
        V02494lGFj2tpTL5Miv60bWmKwBBk48faurzGFAwACgfTOdRopLhCVP1ype6NIl/hwwWLcB+8MajS
        Gfstt364w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChKk-0001DE-HC; Wed, 17 Oct 2018 08:37:38 +0000
Date:   Wed, 17 Oct 2018 01:37:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 24/26] xfs: fix pagecache truncation prior to reflink
Message-ID: <20181017083738.GH16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966004854.3607.15187709452762502392.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966004854.3607.15187709452762502392.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:20:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prior to remapping blocks, it is necessary to remove pages from the
> destination file's page cache.  Unfortunately, the truncation is not
> aggressive enough -- if page size > block size, we'll end up zeroing
> subpage blocks instead of removing them.  So, round the start offset
> down and the end offset up to page boundaries.  We already wrote all
> the dirty data so the larger range shouldn't be a problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

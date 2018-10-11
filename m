Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1EEC4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0936920652
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o6b7IsJe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0936920652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbeJKVLO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:11:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbeJKVLO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v8819EttYxOvTmgTpUHdv0GZSNWbIsLeBMFrLt7b8AM=; b=o6b7IsJeWiGyakuspAevLxBak
        7yhcppPoNs7yXoVoAnC5q02WjkqlDyohh9XzEq//nZTfpJ5fYciQBVMTfIEKalspMUfpRayCz67+D
        4u/EHAVGK0pzXoHetr62J8Ww6c3LsPLxGskpVB7CE0TD1ZR/FsPqlFC/L1W5I9fBJFh3+78SErEzy
        KLVBpBqXfAYSmoWUpyiSHUA57HjrYMLKBi5WQKB5LN483i8fhc1DJvdjAP2XgYLAuEoblaCsV7z1M
        E+GJBudXdHKVOXYi8/zI2iwgXKsY86KOPs1MpRWw+rHsgfyZiZqhoAeKmD0DKeubWsReoUYB1r/mV
        T2goiVs9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gAbFt-00087P-4W; Thu, 11 Oct 2018 13:43:57 +0000
Date:   Thu, 11 Oct 2018 06:43:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 04/25] vfs: strengthen checking of file range inputs to
 generic_remap_checks
Message-ID: <20181011134356.GD23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923116686.5546.8711942394464060950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923116686.5546.8711942394464060950.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:12:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> File range remapping, if allowed to run past the destination file's EOF,
> is an optimization on a regular file write.  Regular file writes that
> extend the file length are subject to various constraints which are not
> checked by range cloning.
> 
> This is a correctness problem because we're never allowed to touch
> ranges that the page cache can't support (s_maxbytes); we're not
> supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
> set; and we must obey resource limits (RLIMIT_FSIZE).
> 
> Therefore, add these checks to the new generic_remap_checks function so
> that we curtail unexpected behavior.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

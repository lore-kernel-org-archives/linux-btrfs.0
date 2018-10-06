Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45524C64EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B59021486
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FzLqLHwl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B59021486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbeJFRiS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:38:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33264 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJFRiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dx8dvFNgCCd/g7WfilYQykhODL3pbc8RNuajkAexHqg=; b=FzLqLHwleBWkrLnJXfWWDBese
        0+dlqmob4Id4opFJ0JVHGSzVOw+pUS/dr+tI1rctk8f3kmRAMKnuA5tv/i/m0By/0Ch40xRL6WxzG
        bILJYKdgczmygpmiO8eFYaxuFCoR6PC5JE5Twry6AwupvOYlOioWgOEZgXpo4pTsSrveibQ5b0IxI
        7dbC86F16dOsu6gxSWyqJRpxHnQdHzbpFUcO9SnK9Z141Cxzb/F9FdCraCtu5St7yRuhRAkUaRF06
        oY6U9j8fupGbeihTFX/G4DzXQW9TefCCGCkHXSMGEh2itDK3YNWuioDusF3Bo43lcmlLHaEmlveGB
        LmSnCAV2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8jvn-00016D-Ll; Sat, 06 Oct 2018 10:35:31 +0000
Date:   Sat, 6 Oct 2018 03:35:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sandeen@redhat.com
Subject: Re: [PATCH 04/15] xfs: update ctime and remove suid before cloning
 files
Message-ID: <20181006103531.GC25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030069.29072.11055871953561649172.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030069.29072.11055871953561649172.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>  STATIC int
>  xfs_reflink_remap_prep(
> @@ -1302,6 +1303,30 @@ xfs_reflink_remap_prep(
>  	/* Zap any page cache for the destination file's range. */
>  	truncate_inode_pages_range(&inode_out->i_data, pos_out,
>  				   PAGE_ALIGN(pos_out + len) - 1);
> +
> +	/* If we're altering the file contents... */
> +	if (!is_dedupe) {

Nipick - even a clone might not alter the file content, we just have
no guarantee.  So maybe change the comment to:

	/* If we may alter the file contents.. */

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

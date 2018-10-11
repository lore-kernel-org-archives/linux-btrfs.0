Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C404CC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802A420652
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zfgpz1EP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 802A420652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbeJKVHq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:07:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeJKVHq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P7COITyrxEs5bt7fNDF85R1dtoyNGCvwYS6KugQ3VX4=; b=Zfgpz1EPRa7gWjHBUh82224B9
        WUJK18c5wyQ1eHqFThjGZulJqr6BzRehpIwEGacf82zcy3cWSa84T0FwLSOUsUpev5aMF2m9BGH9I
        oSKD/C6zjQe34up3QopUxN9QtyXktx3A8OLsQ4dmcs7/gmjugbqqQyOASqmcR5YhesAi+Akw9Bq/k
        frFAWBUKPtrJ6JWl65Yw9DAQk2AbzZ3VJ84mqn3NM13KdQ1veAkaTpannjAzYAiZNirk71uiljBHE
        tuvdf4by6UbMxUIRBHOGm4O47TF1iWQERfFHimHnc1mOKGDneDRNhY566tVBbMTbKjJAEyu84HmzP
        3rRhc0Vug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gAbCX-0007Zt-Ca; Thu, 11 Oct 2018 13:40:29 +0000
Date:   Thu, 11 Oct 2018 06:40:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 02/25] vfs: vfs_clone_file_prep_inodes should return
 EINVAL for a clone from beyond EOF
Message-ID: <20181011134029.GB23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115041.5546.14464512857556875980.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923115041.5546.14464512857556875980.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:12:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> vfs_clone_file_prep_inodes cannot return 0 if it is asked to remap from
> a zero byte file because that's what btrfs does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Maybe it would be a good time to switch btrfs to use
vfs_clone_file_prep_inodes so that we don't have any discrepancies?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

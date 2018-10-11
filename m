Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62BCC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8940A2085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sp4X15G8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8940A2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbeJKVKO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:10:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbeJKVKO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tQp8Ve5Ah0tg22kqpInAW/HD/TdG/Afl8h9QhEXS2e8=; b=sp4X15G8YUUgTQ9/g5npVFEYM
        rQ/SlbADrPgPyJ4UQvQGe+j+ifk0CuPIPWodOOTMs5+kFVF1/24IfqFxkLtKGMxEZtpH0CkoS085w
        FzhTS388bnacMFrLL5Iqt7NvM80jfoAV1OGvMVthlcA+KiCf1/Ug9rSgINXdWVIVriSfzk9XwXqXD
        EuPfa9f/0R2HWV7s9Jh+FGcNZaQqw+oPKaZO7HRtM/UJi61AdVF7KB2c3qxMhSx/wV1o9Rpm7F6pF
        VGXLMHZjbxKnBnSNa1Vmt3b8WQ9dKh85CoJ0YQjHxcnLKC+Ceyw445i+0O6clZGYLGflMc1LY2tc4
        c/Jg/yKbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gAbEu-00082T-Vc; Thu, 11 Oct 2018 13:42:56 +0000
Date:   Thu, 11 Oct 2018 06:42:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 03/25] vfs: check file ranges before cloning files
Message-ID: <20181011134256.GC23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115968.5546.9927577186377570573.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923115968.5546.9927577186377570573.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> -EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
> +EXPORT_SYMBOL(vfs_clone_file_prep);

Btw, why isn't this EXPORT_SYMBOL_GPL?  It is rather Linux internal
code, including some that I wrote which you lifted into the core
in "vfs: refactor clone/dedupe_file_range common functions".

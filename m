Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71E5C65BD0
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900772147D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DlN20ChP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 900772147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbeJFRl1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:41:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJFRl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j8j47jgWBblsWPr/AHo3QpKYa0od+Ir7yyaDN7kB5L0=; b=DlN20ChPdcmDZdiKVSlZlb5pS
        A+ymr270571JzkOU1cSMj+cbyQL8pd90R4Zrb3d4XhbAi91V4WVAuHWuVK5Q3BxeftEbD+wbqGZN7
        69qyo4YHu6/kIYA84bWCoZ+Eoz2OlOSX1lWqsmfCfV1pdgefOWueoNEVyCVlGxWPM4ErdMMz2Y0C9
        4gHoqGcV29racN6+SwCnxKTWFeGnRJcRxL1XP3yngi72tZvir90juiD/hyIYuk1nPC/STdPUb8xJt
        nCkZdEnbK/k3aOP2pPecdlAHiBuEBphYB/d5WpCwJdS24q3+fGjgUXz01hbzKX2oUWoyROVLF6oTe
        ejuj0lrDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8jys-0001FF-2I; Sat, 06 Oct 2018 10:38:42 +0000
Date:   Sat, 6 Oct 2018 03:38:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sandeen@redhat.com
Subject: Re: [PATCH 05/15] vfs: check file ranges before cloning files
Message-ID: <20181006103841.GD25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030868.29072.14603423813271148877.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030868.29072.14603423813271148877.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +EXPORT_SYMBOL(generic_clone_checks);

There doesn't seem to be any need to export this function.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

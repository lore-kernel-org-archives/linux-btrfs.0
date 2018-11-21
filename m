Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55446C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 13:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E0C52146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 13:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="di97X2gW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E0C52146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbeKVAdo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 19:33:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbeKVAdo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aCpM8O44TpcfxbgrCpIjUUinsfY0nw8Lwh4bPHbsg7w=; b=di97X2gWXrJCyn3cBywKryrzS
        TRhdqDPHO0LoDzXPnPd09zAoMXVsXHnn9eEyckMJxPe+5vBkezJrV1PCiet8AcEPHSXnFhkZ33guA
        kdCVTeQQa/qK4L7HY8MekLQaI8tZiBrn2jd1sWJ2b4LK5+qbDxV9hHXbabMV6TyKl+Fh8Ix+d8Lac
        qjF82gpwhZkEBlZtNIjeLcGnCrmQ7GaTT02LqlIcYNYDQhurWEi7ySFhX+EKOfy5a7amDrOTXWUEz
        MzGBBlt/LlG/qPtMwoWb/9h52uLX7IuhDTzL9OVrdzTp9Hz1DhG0yxUM+F+KmqSuywWNbD1UOYt7B
        /WI5IZEVQ==;
Received: from 089144201193.atnat0010.highway.a1.net ([89.144.201.193] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPT27-0006gM-QE; Wed, 21 Nov 2018 13:59:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        linux-block@vger.kernel.org
Subject: btrfs bio usage cleanups for multi-page bvec enabledment
Date:   Wed, 21 Nov 2018 14:59:06 +0100
Message-Id: <20181121135908.4720-1-hch@lst.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi btrfs maintainers,

can you review and ACK these two btrfs patches that clean up some
interactions with the bio code?  I'd like to get these in as the
base of Mings multi-page bio_vec work, which currently contain some
not quite as nice workaround in this area.

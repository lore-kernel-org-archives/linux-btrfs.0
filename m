Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A360EC71122
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C8B20876
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AcfvIdZt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C8B20876
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbeJOBT0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:19:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBTZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YkbwO18pwESX5zhjrkTsp1s9Ywlxv1nkNQYbMp+ZRus=; b=AcfvIdZtwjKmtNatc5OGB2zwi
        /Of9iTNEOv0gLbcvpFBo6CrIn3t6i6nmz3iL6iBtmOPQ7hDnRqxDZT2ghsGxjun3+jqMXj+xxpzVk
        oh162v95BIcCKonu4RjuSauq+yT4lWGxIquOycLvUx4rmtt6uoZBn6Wp8a60q+Bsn/l45y8fbCpRK
        B8dc3dxB0eJdJhfldIm4MGIvFfifwy8cUL1JfEjcjkn+yqZJBTDFUEUUSdeM2yuZo6YXKr7wbbjhG
        IJ518P+VfeXlVdp9LQ4bXai/HYE1ZiLZR+SGEoCUypw+eG7N4b4X+lGCIHggmmTwYJZPnxL0mMP69
        /ivuaJ7nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gBkKg-0001w3-Pc; Sun, 14 Oct 2018 17:37:38 +0000
Date:   Sun, 14 Oct 2018 10:37:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 11/25] vfs: pass remap flags to
 generic_remap_file_range_prep
Message-ID: <20181014173738.GA6400@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921860.8361.1983470639945895613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938921860.8361.1983470639945895613.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +	bool is_dedupe = (remap_flags & RFR_SAME_DATA);

Btw, I think the code would be cleaner if we dropped this variable.

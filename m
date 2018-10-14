Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C0AC71122
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4CFC20876
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hgaSe+qO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4CFC20876
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbeJOBGT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:06:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52822 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBGT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xpBkBhwniHeEn09x5fmbeoMgc6XsukJZyf3Tf3s1DeA=; b=hgaSe+qOn9hhD13G00ZtxAW7u
        zoLdp/+AtAWHfEeA68KuixA4czuxKRF6t7k56vLyqL65fJa8xjGgu+9Ilj71Vz0Q2F1/UyMntWKQ3
        6n6dAxcfuNu5uP8j+zx978nxT1Ds2iU3ui7lwvs7kFVwA+zfTw61M3e2+jxa4c3hjqCy7X1B4verK
        7qdWeySB5YsdAiOxYwyc6SD8ctPJusmfH+/CaLFYbZLraqO/OjwoUGjEDEBP/T51ugTr1wo1hngFX
        P6eijCN/ufpBy+xzoUAH3uTUWU4Ey4Cx19+j8M5hvncCSMryZ+0XwFEidIDDP38cGMzbBURBvrCK2
        qA03nLsXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gBk81-0005V5-Uc; Sun, 14 Oct 2018 17:24:33 +0000
Date:   Sun, 14 Oct 2018 10:24:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 16/25] vfs: make remapping to source file eof more
 explicit
Message-ID: <20181014172433.GG30673@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938925737.8361.3995899966552253527.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938925737.8361.3995899966552253527.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 05:07:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> the remap implementation to remap to the end of the source file, once
> the files are locked.

The name looks like a cat threw up on your keyboard :)

From reading the code this seems to ask for a whole file remap, right?
Why not put that in the name to make it more descriptive?

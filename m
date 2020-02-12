Return-Path: <SRS0=4+pS=4A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47465C2BA83
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Feb 2020 07:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D395206DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Feb 2020 07:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QkI7bISX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgBLHaH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 02:30:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgBLHaH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Feb 2020 02:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=QkI7bISXL5VfZAOS3GMw/sWpi8
        vFGiJOF7VByLnGG/ln0lqGdijC6SVS3uKqDxDtyrzIk3HYjYuH0tpDUB4/0Aej1Ql8rMG6eH2bK3g
        IauKDbmsnsKZgi0fForVPC9f/WFAcwrCYfiCXLVzUvzdjlbor2SiPP3sWhpcMqtsYrtx4NG0ZT7Ok
        j9Cbyfil5w943kv2Gk8S6ZHMH5TxikCQ3jeKgMDAZ9BE6bSnes/kk7WAuXpvREKdjPecQSbXTzdWI
        9Rp9TOZZfvjXtlCKuxQQsFAX/uchpa4+j4BHWZ/P0xlnV4NxovMbPb4sjhITd2lQt7pcVzCHnqTAu
        8Deaochw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j1mTG-0001mm-1q; Wed, 12 Feb 2020 07:30:06 +0000
Date:   Tue, 11 Feb 2020 23:30:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v7 5/8] btrfs: use BIOs instead of buffer_heads from
 superblock writeout
Message-ID: <20200212073006.GD30977@infradead.org>
References: <20200212071704.17505-1-johannes.thumshirn@wdc.com>
 <20200212071704.17505-6-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212071704.17505-6-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104EAC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1FFE2082A
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JCKVJFDb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfDJHoV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:44:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfDJHoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 03:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5b1L2OGJmVvmcol4TQo39KM6FcKIWrT3vlUA8KGiFOY=; b=JCKVJFDb6s8f0Bzg1I4iHPXCS
        Kfy1D7s2nJ28SNKkTJ4v3ZAcpy2TTjN2rH9TN6fmNuUz9/vTGQEHj+CPJ1hFHinm6l28CPa4x7vsq
        7f+wTsdvBxkct606/RDs+2mqMV7J/GhOPqVj7Cathh4L5losvUEsjB0+YIIMcIvim8ih8D8EavR1w
        5pLolDQ3kfNcLTyzcHyoIuDyN0LjVZYhw0D9JrRMbNSM10MIK31XjLLLLkM0JxDYUUnwOQdTr+IfT
        4FN4HcKpZ6iLGVqOP4dIwPaTUuLfJifYFotUlIZF/lVY3WYYzXcF1LS8TveuX19hcXEgrLUSoaVzE
        TEg4OUE3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hE7u8-0007Io-Ul; Wed, 10 Apr 2019 07:44:20 +0000
Date:   Wed, 10 Apr 2019 00:44:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] block: Add new BLK_STS_UCLEAN status
Message-ID: <20190410074420.GA23039@infradead.org>
References: <20190410074149.26646-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410074149.26646-1-wqu@suse.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Please keep linux-block and fsdevel in Cc.

Also as mentioned before UCLEAN is a horrible name, please use
the FSCORRUPTED one actually in use in the file systems that
actually describes what is going on.  Bonus points for also
moving the EFSCORRUPTED definition to common code.

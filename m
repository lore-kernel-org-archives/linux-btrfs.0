Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53ED7ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111AC21523
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uCyowjYP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 111AC21523
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbeJQQXh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:23:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQQXh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SwaEOEVMdiW0RXHhPtruL00DxekJC6UZTMD+F36ERbQ=; b=uCyowjYPwXH00fF7D74mWuRYH
        rL/rAucP7HEvbIx/FRDlDjHzu9oTo81QDXTIwiO5wQNt9eNUoW4ZSRUXvJCeBO4A1EnXCA8ouuK4C
        lW2CU/B33sNhphie7YFlKnmjXJa8lvghgxZLAQinTP9XeXz4DVYGZsQrPjxl4w8YTfQKTKHit5jO0
        LOxHI0fnxhCG+Z6AwdWRusAo9pK7Cvxy+bK8+X0iSW2280AhbqsOkqtwfywasiv7aIyEPJ65oum3S
        2SVfRfWFLtZ+mRRjba1vj+cP0bO8lfwRhuPc68wRAx3A/hCMKNghD/z8xH4oQYgsybZc/DnRdzBvM
        CwuWGrEng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChCM-0006Ac-Li; Wed, 17 Oct 2018 08:28:58 +0000
Date:   Wed, 17 Oct 2018 01:28:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 11/26] vfs: pass remap flags to
 generic_remap_file_range_prep
Message-ID: <20181017082858.GC16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965947208.1256.13169150057249233851.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965947208.1256.13169150057249233851.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:11:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb the remap flags through the filesystem from the vfs function
> dispatcher all the way to the prep function to prepare for behavior
> changes in subsequent patches.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

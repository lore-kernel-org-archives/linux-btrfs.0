Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2C2ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D6E21529
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hFrcBgkQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17D6E21529
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbeJQQcB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:32:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQcB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qRhJ535hi/QWylCVGhUigoBAxumc3LQjbi0ChGwojfc=; b=hFrcBgkQ7bOLo2h6eU3I7rR7H
        YQiVEwf/p9upyRX+t6cxJiXvw+rhvATZIfptU8UkCl8jQG9fsznKF7mX0AUgfMLtWcZClSzkBRxTc
        CMJCNbRWkJpj75IgnutGaDjA1NKJtKU1mfLDU0RroWljQbiWNuf7QqfH8XIrtFDgBnbEGgeZ12RGz
        eey64Fcc9Tb8oNyfHRMHggYQK6v3zv24JALO4WsY1s2UtSOyIp9k45L82nDgNCIHfE07UJtP/qIHP
        PaYTL7qBUhplcgfZ0rT5Tg+qOzEjp8zhboV+XiFArxFN756CMXnoXuMLQ/Xk8ujePihUMQNq9FDnT
        zL+byPmaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChKU-0001Ah-4Y; Wed, 17 Oct 2018 08:37:22 +0000
Date:   Wed, 17 Oct 2018 01:37:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 19/26] vfs: clean up generic_remap_file_range_prep return
 value
Message-ID: <20181017083721.GG16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966001458.3607.5940191707393894977.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966001458.3607.5940191707393894977.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:20:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the remap prep function can update the length of the remap
> request, we can change this function to return the usual return status
> instead of the odd behavior it has now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040E9ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACD5A214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uGFBGk3p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACD5A214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJQQfA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:35:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:34:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p2srIvdYWmw8xzN0t5Tz8LKHIyDiv6n6NwKOEl3YP98=; b=uGFBGk3pxDNzxjE55QXqkulBY
        BWiITMxD/7h72THiQQnFgsfNYGCw7GXpS449KP+NdUZvZJIjk7l/XsV6nmZaBb9cA5Pq3bBqEWrpg
        /JEE4H+TkFW6yHcRtqbszJmVCI2oxanYNERCnX1nCQirFuGSJKgatmLBtZ5bKcHmOFGZxn2YsgDbh
        TKddwylwPsD+0FTnz+iTS0CbDmznfhMgtbcRxE0XQ9A+PFfxHzBOaA6znPHIQ+G9Fy5l9VzTvhsER
        iG0g1/sjsUFEnWvUo9fgy5CMxkjITRc4JDCRD3I+IjY1qLMu3erHyVUPuwTzV0FzzywShw2Y3gnYa
        7S3wPsUgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChNM-0003He-Nc; Wed, 17 Oct 2018 08:40:20 +0000
Date:   Wed, 17 Oct 2018 01:40:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 26/26] xfs: remove redundant remap partial EOF block
 checks
Message-ID: <20181017084020.GJ16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966006214.3607.15131077363912605792.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966006214.3607.15131077363912605792.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:21:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've moved the partial EOF block checks to the VFS helpers, we
> can remove the redundant functionality from XFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

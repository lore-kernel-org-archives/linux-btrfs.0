Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AB0C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B3F20652
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 13:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g3wNS6Im"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3B3F20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbeJKVGu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:06:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeJKVGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=btLZV7qwgXElo2ZnAVUFnqmAsEnkHQV1Yox0FtN/U34=; b=g3wNS6ImqdQVw3gUH0dv0xnhi
        8NEzh2eNseKB9ppnJnFrCk57mBYkV5dZYVlGAMynJ0aGjhvPeA2MV9lhlpuZysHGRGBbcB5vCYgpQ
        fcwgUu/g43S0olFMkTZ8FPLP/P1kn+BHg6Rog99KOj0j8f9+9R8sZedAIkJGOMf3/ZRqv76cODosU
        TWCyqltPeuxoFOG/45vylsWtBHQvmI9XK2AlBHjqAKOsatKR9HrUB9HLWEzb2JkU12MqAZiEQ9tYu
        HZeRp7UN5LfD+s2t6re4W9/Nq+kfvq03QkWhLHqVcSjViSp+9l2N6jChfwOh9t1yIeNzSwz1XGELx
        HSZ9xTx4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gAbBe-0006Dq-Nw; Thu, 11 Oct 2018 13:39:34 +0000
Date:   Thu, 11 Oct 2018 06:39:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 01/25] xfs: add a per-xfs trace_printk macro
Message-ID: <20181011133934.GA23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923114361.5546.11838344265359068530.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923114361.5546.11838344265359068530.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:12:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a "xfs_tprintk" macro so that developers can use trace_printk to
> print out arbitrary debugging information with the XFS device name
> attached to the trace output.

I can't say I'm a fan of this.  trace_printk is a debugging aid,
and opencoding the file system name really isn't much of a burden.

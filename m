Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147E3ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48DF21526
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iR9A7HqX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C48DF21526
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbeJQQUh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:20:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45736 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQQUh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LlCyFDN3uIWbnAgJhRtznQ4+EK1rlhaWLsNY+vzUHMo=; b=iR9A7HqX3yRc8VLhfuO4pUSFj
        rgi1F+rlRTe9XFzRKVX7EMWli8Z/nEdLnrefQpIP+BRqXG9rjqKOFMjvRSUN43IPRLY8gMLtVfEZc
        /Gtuv3PSi3KpUnM19AU9JUCARpj/X7PLvZExR9ZRVS2pfzHD7+QcnbsdiwwboKII2HdhRRaxOSIYL
        NEtNPDBzHwje/rH0QtSMvGxCwoTOlVHoskqj5WRgfgCVpqhFEgh+vyhnYVU/bjU7PLTKNR5pyEa1o
        aNCN+1E5nKWlxKVmVIjdirgyh1OQyx9YlFy87KFj9mFjHDS8oB3/5hO7iqmAjkJlFDuWIRrzyKBSn
        4dtJjlZlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gCh9U-00061n-Q5; Wed, 17 Oct 2018 08:26:00 +0000
Date:   Wed, 17 Oct 2018 01:26:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 04/26] vfs: exit early from zero length remap operations
Message-ID: <20181017082600.GA16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965942391.1256.1491987046439132016.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965942391.1256.1491987046439132016.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:10:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a remap caller asks us to remap to the source file's EOF and the
> source file has zero bytes, exit early.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

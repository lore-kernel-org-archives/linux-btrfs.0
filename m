Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0877AC64EB8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A542147D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NPr3eE/u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8A542147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbeJFRmb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:42:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeJFRmb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IVZt2f6bLumiZ/c7qji9/gyZRxjtOPosfztTROJ/yUw=; b=NPr3eE/u2kelPlRs0GtHYB8jp
        K8nKlJvtp7NidukNLpwW2uWT+AXrNmzdMolDcnDILgXoysDh7KK1ZsxLXrko3f2gXYVwo76++0Diy
        vpa8MQJKdlLtZXXacmQX5R59VCIP4SMUjUHct/PYchlSd9zjjR2Wf9mXkNyD9GX//xMWiDexiEyCV
        dsMURB7zSqVmVOe8mUEQTBlBUfOkxZVdiLcW9Q1eAm1pffQVy0Bo2G0b6KBwW8Qbx9gPU/U77DqlS
        NS/kSiEWQZM1pwlXx5NL9mh3DLSYTr+9Z6r65zQYVt77rH8/Hecn/I+/00wtgZGAeSMyaaKoHv/WR
        OImZ/iC1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8jzt-0001JP-MY; Sat, 06 Oct 2018 10:39:45 +0000
Date:   Sat, 6 Oct 2018 03:39:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sandeen@redhat.com
Subject: Re: [PATCH 07/15] vfs: skip zero-length dedupe requests
Message-ID: <20181006103945.GE25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870032167.29072.11158511021942868400.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870032167.29072.11158511021942868400.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:45:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't bother calling the filesystem for a zero-length dedupe request;
> we can return zero and exit.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

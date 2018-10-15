Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC24C71130
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A16920881
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kouKP7Ok"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A16920881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJOUcc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 16:32:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOUcc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 16:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1hm/SgMvrxSIJf2CdZ+Rh7VxfG95sawf4o4UhBNziBQ=; b=kouKP7OkupEmjvMwVqZTaxzsB
        suxsmh7Kd/68N7isnADczAa3AKagH1kWzC/9M30FnXhykWF+b+zAcDH2aVPes4rLKNSEI7FtvH3wm
        JXuFuaETA8EozziOlF/8rW466EwjnrLV2s27yJj/beUmDNvlXFgTLNK+m4Hf8kR2lxOJUvGYQwmCa
        /LLNreXQJASLEmxKUNncruorImNgwoma8I/WGLOTHIGvcMmyklSoaSBU58GKZAq6ZxL2XWp9hWxCl
        mKLDW3YVzhVU27t0wNAtREYvxaRdCYNVeIaciM9h4Xlk5DdfFngSG8J0rEymPIWuGWhMaG/qUx1vl
        4a+GhIbpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gC2HH-0007Rs-CY; Mon, 15 Oct 2018 12:47:19 +0000
Date:   Mon, 15 Oct 2018 05:47:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181015124719.GA15379@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
 <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 09:04:13AM +0300, Amir Goldstein wrote:
> I supposed you figured out the reason already.

No, I hadn't.

> It makes it appearance in patch 16/25 as RFR_VFS_FLAGS.
> All those "advisory" flags, we want to pass them in to filesystem as FYI,
> but we don't want to explicitly add support for e.g. RFR_CAN_SHORTEN
> to every filesystem, when vfs has already taken care of the advice.

I don't think this model makes sense.  If they really are purely
handled in the VFS we can mask them before passing them to the file
system, if not we need to check them, or the they are avisory and
we can have a simple #define instead of the helper.

RFR_TO_SRC_EOF is checked in generic_remap_file_range_prep,
so the file system should know about it  Also looking at it again now
it seems entirely superflous - we can just pass down then len == we
use in higher level code instead of having a flag and will side step
the issue here.

RFR_CAN_SHORTEN is advisory as no one has to shorten, but that can
easily be solved by including it everywhere.

RFR_SHORT_DEDUPE is as far as I can tell entirely superflous to
start with, as RFR_CAN_SHORTEN can be used instead.

So something like this in fs.h:

#define REMAP_FILE_ADVISORY_FLAGS	REMAP_FILE_CAN_SHORTEN

And then in the file system:

	if (flags & ~REMAP_FILE_ADVISORY_FLAGS)
		-EINVAL;

or

	if (flags & ~(REMAP_FILE_ADVISORY_FLAGS | REMAP_FILE_DEDUP))
		-EINVAL;

should be all that is needed.

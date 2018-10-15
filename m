Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23947C71133
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 18:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE9D20881
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 18:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DJTS06J0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDE9D20881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbeJPCSb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 22:18:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbeJPCSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 22:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V6fsNJqyfrKjJIemBQHD3EiJ09wQXvqa/Rf1w8TKHHY=; b=DJTS06J042RAPiYpi7DzyfYR6
        pKKcarnluVL2n7SsVtpCAE2ex3bioqdnYaO5I8SjoUEHmneRm/fJIMIq+40IgYuEWdIOeF31yHA5/
        ZeLt1oSUHR6PU+pk2uJ9WGLmm3Xrg6pUUdV+jugL4QPDmVIxqLzmEHailpWNdjvy5eZ8+KsPb5cQD
        Q0hPq1N4t3nyhRs76sCuvsfHAEtpfB7KPYp5/kuUa7Ty1nDjOUytdJNfoOWKZc2998Ok9Y/F00G6h
        9yo4VF3U6PsAqwDLyw3Qn4EozrgPS3mmuAh/NNlhfaKyFi6FWz6NDd8hdVJxYjdFPML97jx/XBhHK
        SES4MqJ5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gC7eu-0002Dh-L3; Mon, 15 Oct 2018 18:32:04 +0000
Date:   Mon, 15 Oct 2018 11:32:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
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
Message-ID: <20181015183204.GB20655@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
 <CAOQ4uxiReFJRxKJbsoUgWWNP75_Qsoh1fWC_dLYV_zBU_jaGbA@mail.gmail.com>
 <20181015124719.GA15379@infradead.org>
 <20181015171317.GM28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015171317.GM28243@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 10:13:17AM -0700, Darrick J. Wong wrote:
> > RFR_TO_SRC_EOF is checked in generic_remap_file_range_prep,
> > so the file system should know about it  Also looking at it again now
> > it seems entirely superflous - we can just pass down then len == we
> > use in higher level code instead of having a flag and will side step
> > the issue here.
> 
> I'm not a fan of hidden behaviors like that, particularly when we
> already have a flags field where callers can explicitly ask for the
> to-eof behavior.

This just means we have a flag to mean ken is 0 and needs to be filled,
rather than encoding that in the field itself.  If you fell better we
can replace 0 with 0xffffffff and still encode it in the field.

> > RFR_CAN_SHORTEN is advisory as no one has to shorten, but that can
> > easily be solved by including it everywhere.
> 
> CAN_SHORTEN isn't included everywhere

Include it everywhere as in allow it in ever ->remap_file instance.

> I sort of thought about introducing a new copy_file_range flag that
> would just do deduplication and allow for opportunistic "dedup as much
> as you can" but ... meh.  Maybe I'll just drop the patch instead; we can
> revisit that when anyone wants a better dedupe interface.

Sounds fine to me.  The btrfs ioctl is really ugly, but then again
there is no pressing need for something better.

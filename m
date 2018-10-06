Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89577C65BD0
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43A7A21486
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 10:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BbPD/yhH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43A7A21486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbeJFRqu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:46:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeJFRqu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 13:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MVw2bZ/7x7j6BCNneeVJJDXZJWSiCNHkwiJgpXjIYp8=; b=BbPD/yhH19DCnCC85DVBip476
        ZB8uCZ8iQ3m5+IaNLAwYKj52Jk9yo7KXZ29CQk9kHFvMJu2KH4dnM3f7lkFtL2YWQi/d6ZUz+sEXc
        NNVVhATDsXi/4tJVXN25yuRdZkTc0SIADL4scmXvfCazQVSky7Z+zoYKBl9dEySCBr1Aw5K58uEfO
        iUJJ2gp2+epeKzsHYnvnBsBXfcjmcJKEjkos2n9uqXJ2wrDn5m5YA+LuKfxhOxv63cCT7E0/ha56w
        N67nTaZE7Rt75G5ynp2bsLAqQmWBNG9F5RMlohQ/NxkT2vwXehmZsFJnqHEO+shEf+sXsiXUIws/K
        n3bQTDRYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g8k42-000310-Ep; Sat, 06 Oct 2018 10:44:02 +0000
Date:   Sat, 6 Oct 2018 03:44:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
Message-ID: <20181006104402.GG25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870034158.29072.8943691140742142494.stgit@magnolia>
 <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
 <20181005175008.GY19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005175008.GY19324@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 10:50:08AM -0700, Darrick J. Wong wrote:
> > That's cool. But you know what's going to be the next step, right?
> > Merging the 3 file operation interfaces into a single one.
> > copy_file_range() already has the flags arg for future extensions
> > and as you wrote somewhere, clone is really an optimized copy.
> > ovl_copyfile() already does that internally.
> > 
> > So the only take away for this patch series, please use constant
> > names COPYRANGE_* and also explicitly define:
> > 
> > /* Operation is actually clone, not copy. */
> > #define COPYRANGE_CLONE      (1 << 2)
> > /* Operation is actually dedupe, not copy. */
> > #define COPYRANGE_DEDUPE      (1 << 3)
> 
> Yeah, I was too tired to try to throw that one on top of the flaming
> garbage pile.  But I guess since I have a bunch more work to do to the
> previous patch I might as well do that...

I'm not totally sold on just merging everything, but I very much despise
what is done in this patch, as it creates a completely confusing
interface.

Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AAEC10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39642084F
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfDIK0B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:26:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:50992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726091AbfDIK0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 06:26:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4F51CADC7;
        Tue,  9 Apr 2019 10:25:59 +0000 (UTC)
Date:   Tue, 9 Apr 2019 12:25:58 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190409102558.GC5099@linux-x5ow.site>
References: <20190406215428.3131-1-ming.lei@redhat.com>
 <20190407065205.GA8799@lst.de>
 <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
 <20190408141203.GT22763@bombadil.infradead.org>
 <20190409094839.GA6827@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190409094839.GA6827@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 09, 2019 at 11:48:39AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 08, 2019 at 07:12:04AM -0700, Matthew Wilcox wrote:
> > On Mon, Apr 08, 2019 at 08:07:55AM +0200, Hannes Reinecke wrote:
> > > Oh yes, please do.
> > > The macros are fast becoming unparseable :-)
> > 
> > I think something that would help is removing the mandatory 'i' parameter
> > to this iterator.  Most of the users don't use it, and the ones that do
> > can implement it themselves.  eg:
> 
> Yeah, I quickly hacked this up during a meeting yesterday and we have
> exactly two users of the iterator.  Patch against the for-linus tree
> below, although it conflicts with some of the 5.2 work.  Maybe it is
> best to merge this just after the next rc1..
> 
> --
> From 6a872f0186846a64a898b149be54d385f9f03f8b Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 8 Apr 2019 18:11:44 +0200
> Subject: block: remove the i argument to bio_for_each_segment_all
> 
> We only have two callers that need the simple loop iterator, and
> they can easily do it themselves.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

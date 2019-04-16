Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3176FC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 09:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACD220675
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 09:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfDPJQe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:16:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:36786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbfDPJQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 05:16:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CC82AE1D
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 09:16:33 +0000 (UTC)
Date:   Tue, 16 Apr 2019 11:16:33 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: simplify read_extent_buffer_pages a bit
Message-ID: <20190416091632.GA4226@linux-x5ow.site>
References: <20190411164059.4981-1-jthumshirn@suse.de>
 <20190411165935.GA3476@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190411165935.GA3476@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


On Thu, Apr 11, 2019 at 06:59:35PM +0200, David Sterba wrote:
> On Thu, Apr 11, 2019 at 06:40:59PM +0200, Johannes Thumshirn wrote:
> > Currently read_extent_buffer_pages() uses a 4 pass algorithm to read an
> > extent buffer's pages from disk, all 4 stages looping over all pages of
> > the extent buffer.
> > 
> > 1) Loop over all pages and lock them.
> > 2) Loop over all pages and see if one is not marked as PageUptodate, so we
> >    can break out of the function early.
> > 3) Loop over all pages and if the page is !PageUptodate read the page,
> >    otherwise unlock the page.
> > 4) Loop over all pages and wait for stable pages.
> > 
> > Unify the 1st two for loops, we can count the number of uptodate pages
> > after we have locked them without the need for re-starting the loop.
> 
> Effectively reverting 2571e739677f1e4c0c63f5ed49adcc0857923625 that
> fixed a bug. Please have a look if something has really changed so that
> the split loops are no longer necessary.

After starring at the .s and .lst files GCC produces I cannot say whether this
holds true or not.

But as it was fixing a bug back then, I'll take back this patch.

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

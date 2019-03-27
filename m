Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207EAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DEC2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 23:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfC0XbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 19:31:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:42780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbfC0XbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 19:31:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82C98AE25;
        Wed, 27 Mar 2019 23:31:22 +0000 (UTC)
Date:   Wed, 27 Mar 2019 18:31:20 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190327233120.ykjmdvedr4gsdyhr@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190326191001.GP10344@bombadil.infradead.org>
 <20190327110052.pvn5dag2xwy2tnkv@merlin>
 <20190327120031.GR10344@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327120031.GR10344@bombadil.infradead.org>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  5:00 27/03, Matthew Wilcox wrote:
> On Wed, Mar 27, 2019 at 06:00:52AM -0500, Goldwyn Rodrigues wrote:
> > On 12:10 26/03, Matthew Wilcox wrote:
> > > On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > > > This sets S_DAX in inode->i_flags, which can be used with
> > > > IS_DAX().
> > > > 
> > > > The dax option is restricted to non multi-device mounts.
> > > > dax interacts with the device directly instead of using bio, so
> > > > all bio-hooks which we use for multi-device cannot be performed
> > > > here. While regular read/writes could be manipulated with
> > > > RAID0/1, mmap() is still an issue.
> > > > 
> > > > Auto-setting free space tree, because dealing with free space
> > > > inode (specifically readpages) is a nightmare.
> > > > Auto-setting nodatasum because we don't get callback for writing
> > > > checksums after mmap()s.
> > > 
> > > Congratulations on getting the bear to dance.  But why?
> > 
> > Why not ? ;)
> 
>  18 files changed, 662 insertions(+), 77 deletions(-)
> 
> I want to know what advantage we're getting for that.

So the prime advantages are btrfs filesystem snapshots on the dax device.
Leveraging btrfs features, reflinks works just as well.
(In addition to all the advantages dax has to offer)



-- 
Goldwyn

Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DBAC10F00
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90F72087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HBOGRXtW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfC0MAc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:00:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfC0MAc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8UwcpcqaP8ZhHswLLo1/ZfvVHoz/qtIhN4RZjhfBKN0=; b=HBOGRXtWom6XXXTXi/OhNRxA1
        C0ISWjCZaaFZskeTvAGowoxsDQcW16ZEC5H+7ri6b4TpkbJRPWNf0rgwqw2qLWtiSLubyVMnfBpUo
        Id0BD3qqC3bEc/LpOo/cTLM0UMwogmQt8WwXLoSV2mOQasiRHV9zjdgSL9puByknBlu+x3za+LgQf
        NwRWF8uuQ0YmZChZt+7q0xl3CT5F2bIQd/NU3gJcVaU0Vt3U9GObom3ezm3523CN9skm0F0oNwGrA
        v6KHJCu+M+Ds2hVjV3IrZGfWv8i9nP7j6ma6SJQrIGF00CUSK9d9LV6OUyhiaeFIErEURy+o2otnQ
        hSRBZcw6A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h97EO-0004h7-0C; Wed, 27 Mar 2019 12:00:32 +0000
Date:   Wed, 27 Mar 2019 05:00:31 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: create a mount option for dax
Message-ID: <20190327120031.GR10344@bombadil.infradead.org>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-2-rgoldwyn@suse.de>
 <20190326191001.GP10344@bombadil.infradead.org>
 <20190327110052.pvn5dag2xwy2tnkv@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327110052.pvn5dag2xwy2tnkv@merlin>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 06:00:52AM -0500, Goldwyn Rodrigues wrote:
> On 12:10 26/03, Matthew Wilcox wrote:
> > On Tue, Mar 26, 2019 at 02:02:47PM -0500, Goldwyn Rodrigues wrote:
> > > This sets S_DAX in inode->i_flags, which can be used with
> > > IS_DAX().
> > > 
> > > The dax option is restricted to non multi-device mounts.
> > > dax interacts with the device directly instead of using bio, so
> > > all bio-hooks which we use for multi-device cannot be performed
> > > here. While regular read/writes could be manipulated with
> > > RAID0/1, mmap() is still an issue.
> > > 
> > > Auto-setting free space tree, because dealing with free space
> > > inode (specifically readpages) is a nightmare.
> > > Auto-setting nodatasum because we don't get callback for writing
> > > checksums after mmap()s.
> > 
> > Congratulations on getting the bear to dance.  But why?
> 
> Why not ? ;)

 18 files changed, 662 insertions(+), 77 deletions(-)

I want to know what advantage we're getting for that.

> > To me, the point of btrfs is all the cool stuff it does with built-in
> > checksumming and snapshots and RAID and so on.  DAX doesn't let you do
> > any of that, so why would somebody want to use btrfs to manage DAX?
> 
> There are users who are asking for advantages of dax on btrfs.

There are also people asking for perpetual motion machines.  Do these
users understand the tradeoffs?

> I have tried to make it work with snapshots in this series.
> Checksumming should be possible, but would require some more hacks. I am
> looking into it.
> multi-device is an issue for mmap() and I don't think we can work around
> it.
> 
> I agree there is a price to pay to use dax, but I am sure the users
> would know about that.

I really doubt it, to be honest.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B010C001DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Aug 2023 15:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjHAP3S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 11:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjHAP3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2023 11:29:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE3CFD
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Aug 2023 08:29:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A2F86732D; Tue,  1 Aug 2023 17:29:12 +0200 (CEST)
Date:   Tue, 1 Aug 2023 17:29:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: small writeback fixes v2
Message-ID: <20230801152911.GA12035@lst.de>
References: <20230724132701.816771-1-hch@lst.de> <20230727170622.GH17922@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727170622.GH17922@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 27, 2023 at 07:06:22PM +0200, David Sterba wrote:
> On Mon, Jul 24, 2023 at 06:26:52AM -0700, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series has various fixes for bugs found in inspect or only triggered
> > with upcoming changes that are a fallout from my work on bound lifetimes
> > for the ordered extent and better confirming to expectations from the
> > common writeback code.
> 
> I've so far merged patches 1-3, the rest will be in for-next as it's
> quite risky and I'd appreciate more reviews.

So who would be a suitable reviewer for this code in addition to Josef?

Any volunteers?

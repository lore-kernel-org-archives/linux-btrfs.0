Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFBFC43217
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Apr 2022 21:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244632AbiDEVNE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444156AbiDEPk4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2022 11:40:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D41877F1
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Apr 2022 07:03:27 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5E2B2210FD;
        Tue,  5 Apr 2022 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649167406;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f0eJ49yoNBnUnyjDek8J3Yq/icoEjeUa+hIZvd5oZAM=;
        b=XA3QySrLkyeQEr9U/+16cgxQLhpGxuXzlg08pEhqIpwBPf2FaWklCSScuvKjPGkrgMuU7I
        9tpDWoM/PXxxB4JQj9Gyw8SkAGIrRSjB7m7f6+LURNTB6kMx34UhfufDeUdWkAYap0eVqB
        usdLvA1kE44UOCC4L2sAFEww6L3uMN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649167406;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f0eJ49yoNBnUnyjDek8J3Yq/icoEjeUa+hIZvd5oZAM=;
        b=XLII9P5FRC2wYMRHzZYEM9royvY5A03Q3SQJJFz6XoKK/pfH1fjcg4FB9P2u0gh1hENANC
        /34/iUFNKokzKHDg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 545FBA3B9B;
        Tue,  5 Apr 2022 14:03:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 31EEDDA80E; Tue,  5 Apr 2022 15:59:25 +0200 (CEST)
Date:   Tue, 5 Apr 2022 15:59:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: replace a wrong memset() with memzero_page()
Message-ID: <20220405135924.GW15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <8d6f911a0282eba76f9e05d6f1e7c6f091d4870b.1648199349.git.wqu@suse.com>
 <Yj3v+MnFOXeeAU9d@infradead.org>
 <YkvMcoK5m7tZ3GUM@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkvMcoK5m7tZ3GUM@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 04, 2022 at 09:58:26PM -0700, Christoph Hellwig wrote:
> On Fri, Mar 25, 2022 at 09:38:16AM -0700, Christoph Hellwig wrote:
> > > -	memset(kaddr + pgoff, 1, len);
> > > +	memzero_page(page, pgoff, len);
> > >  	flush_dcache_page(page);
> > 
> > memzero_page already takes care of the flush_dcache_page.
> 
> David, you've picked this up with the stay flush_dcache_page left in
> place.  Plase try to fix it up instead of spreading the weird cargo cult
> flush_dcache_page calls.

Good point, flush_dcache_page is in memzero_page so it should have been
removed within the patch. I've grepped and there are still 14 calls,
some of them next to memzero_page so that'll go away too.

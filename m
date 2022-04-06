Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43966C433EF
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Apr 2022 19:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiDFTdE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 15:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiDFTcv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2022 15:32:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9440F12AC8;
        Wed,  6 Apr 2022 11:04:27 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 471261F856;
        Wed,  6 Apr 2022 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649268266;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ObRx/ixLhOv9tUVvgwIL58okbeieSFDn4fU3xy2XX9k=;
        b=BFBgN0kJwVoEZH3+LRKv0s8HSEZhObV608IjIFx9STMbJ2uGQ3h5q1PhQZwykhUa4leJWB
        xnQln+8IfR1wCJI7cYTyG7BHi0HMfe9NLF+4pKzYxu2zZIL5JlUrkYEjXV3n19n2xZLSx7
        Cqth1Hwagrea37lxEFHYFl3IyYJPuTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649268266;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ObRx/ixLhOv9tUVvgwIL58okbeieSFDn4fU3xy2XX9k=;
        b=aOevRpJFbhW/UZONWWZTBfL4JbyvXm9avtKhF1j5GrwPKQsh8YfjM6jL263HXCZ578j4vP
        EblEvk/rLnxqwQCg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 1019AA3B82;
        Wed,  6 Apr 2022 18:04:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 47295DA80E; Wed,  6 Apr 2022 20:00:24 +0200 (CEST)
Date:   Wed, 6 Apr 2022 20:00:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: cleanup btrfs bio handling, part 1
Message-ID: <20220406180023.GC15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220404044528.71167-1-hch@lst.de>
 <20220405145626.GY15609@twin.jikos.cz>
 <20220405150956.GA16714@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405150956.GA16714@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 05, 2022 at 05:09:56PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 05, 2022 at 04:56:26PM +0200, David Sterba wrote:
> > On Mon, Apr 04, 2022 at 06:45:16AM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series  moves btrfs to use the new as of 5.18 bio interface and
> > > cleans up a few close by areas.  Larger cleanups focussed around
> > > the btrfs_bio will follow as a next step.
> > 
> > I've looked at the previous batch of 40 patches which was doing some
> > things I did not like (eg. removing the worker) but this subset are just
> > cleanups and all seem to be fine. I'll add the series as topic branch to
> > for-next and move misc-next. Thanks.
> 
> If it helps can rebase.  And it would be really helpful to start
> a discussion on the things you did not like on the patches already
> on the list if you have a little time to spare.

I was able to resolve all the merge conflicts either manually or using
the tool wiggle, no need to rebase. Regarding the whole patchset, I'll
reply there. Right now I'm trying to merge all the easy or short series
first, from the lower layers up in case there's a need to rebase.

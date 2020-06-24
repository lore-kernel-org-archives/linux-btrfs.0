Return-Path: <SRS0=nWHZ=AF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E32C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 11:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD76A2088E
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 11:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbgFXLAe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 07:00:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgFXLAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jun 2020 07:00:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 03DC7ADE0;
        Wed, 24 Jun 2020 11:00:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1A114DA79B; Wed, 24 Jun 2020 13:00:20 +0200 (CEST)
Date:   Wed, 24 Jun 2020 13:00:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: start deprecation of mount option inode_cache
Message-ID: <20200624110019.GP27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20200623185032.14983-1-dsterba@suse.com>
 <b8fe50cc-02ed-4170-c84c-d994fd489a98@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8fe50cc-02ed-4170-c84c-d994fd489a98@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 24, 2020 at 07:27:46AM +0800, Qu Wenruo wrote:
> > Remaining issues:
> > 
> > - if the option was enabled, new inodes created, the option disabled
> >   again, the cache is still stored on the devices and there's currently
> >   no way to remove it
> 
> What about "btrfs rescue remove-deprecated-feature inode_cache"?
> I really don't want kernel to do the hassle.

Most likely we'll need both, the kernel part is for cases where it's not
so easy to access the filesystem unmounted to do the change. Like a root
partition. How to do that to be least intrusive is the open.

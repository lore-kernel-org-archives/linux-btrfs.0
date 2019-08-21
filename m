Return-Path: <SRS0=+t5r=WR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB08C3A59E
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Aug 2019 16:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9948022DD3
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Aug 2019 16:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfHUQSx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 12:18:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:42026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727464AbfHUQSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Aug 2019 12:18:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FDC2AED5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2019 16:18:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 45B02DA7DB; Wed, 21 Aug 2019 18:19:15 +0200 (CEST)
Date:   Wed, 21 Aug 2019 18:19:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] btrfs: sysfs: export supported checksums
Message-ID: <20190821161914.GE2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <cover.1564046812.git.jthumshirn@suse.de>
 <e377ded65e4f2799776596ead308658710e4c8c1.1564046812.git.jthumshirn@suse.de>
 <20190730171904.GE28208@twin.jikos.cz>
 <20190807141005.GB28023@x250.microfocus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807141005.GB28023@x250.microfocus.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 07, 2019 at 04:10:05PM +0200, Johannes Thumshirn wrote:
> On Tue, Jul 30, 2019 at 07:19:04PM +0200, David Sterba wrote:
> > On Thu, Jul 25, 2019 at 11:33:51AM +0200, Johannes Thumshirn wrote:
> > > From: David Sterba <dsterba@suse.com>
> > > 
> > > Export supported checksum algorithms via sysfs.
> > 
> > I wonder if we should also export the implementation that would be used.
> > This could be crross referenced with /proc/crypto, but having it in one
> > place would be IMHO convenient.  Also for the case when the kernel
> > module is missing.
> > 
> > Currently the hash names are printed as comma separated values so we'd
> > need bit something structured:
> > 
> > crc32c: crc32c-intel
> > xxhash64: xxhash-generic
> 
> I thought a bit more about it and it's not quite that easy as I would need to
> have access to the respective "struct crypto_shash". For the currently used
> checksum this isn't much of a problem, as I get it via "struct btrfs_fs_info".
> 
> But this sysfs attribute lists all the checksumming algorithms the current
> btrfs version is able to use irrespectively of the currently mounted
> file-systems.
> 
> So yes I can do it but I think this is for another sysfs attribute which shows
> the used checksumming algorithm for this FS, not the supported checksumming
> algorithms.

I see. We can't know which implementation would be used until we
actually try to use it, so two sysfs files would make more sense. Plain
list for all supported algos and one with the implementation for a given
mounted filesystem.

Return-Path: <SRS0=y2QO=76=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A729C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 20:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E472F20897
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 20:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFQUEv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 16:04:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQUEv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jun 2020 16:04:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2ACDAAB3D;
        Wed, 17 Jun 2020 20:04:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4AE6BDA728; Wed, 17 Jun 2020 22:04:40 +0200 (CEST)
Date:   Wed, 17 Jun 2020 22:04:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     A L <mail@lechevalier.se>
Cc:     linux-btrfs Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: Should "btrfs filesystem defrag -r" follow symlinks?
Message-ID: <20200617200438.GS27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, A L <mail@lechevalier.se>,
        linux-btrfs Mailinglist <linux-btrfs@vger.kernel.org>
References: <852f6e36-6adc-0455-5c2b-0477b0c72270@lechevalier.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <852f6e36-6adc-0455-5c2b-0477b0c72270@lechevalier.se>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jun 14, 2020 at 03:22:34PM +0200, A L wrote:
> It is not clear from the man page at 
> https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-filesystem if 
> `btrfs filesystem defrag -r` should follow symbolic links or not. 
> Perhaps the man-page should mention which behaviour is default.
> 
> I did some basic tests and it seems that on my setup it does not follow 
> symlinks.

That's right, -r does not follow directory symlinks. I think it's a good
default as 'find' does not do that either. We're using the 'nftw'
library function with FTW_PHYS, help says "If set, do not follow
symbolic links.  (This is what you want.)"

> Perhaps improve defragment with an option to follow symlinks and/or 
> subvolumes should be added?

I'll clarify the manual page regarding the default behaviour. Mount
points are skipped but recursion goes to subvolumes.

Adding the options to choose the follow mode would be good, I'll open
issues for that. Thanks.

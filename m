Return-Path: <SRS0=c8Io=V3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3012C433FF
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 12:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B15802087F
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 12:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfG3MTt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:19:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:50976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfG3MTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jul 2019 08:19:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8DB0FAD1E;
        Tue, 30 Jul 2019 12:19:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 58851DA7C5; Tue, 30 Jul 2019 14:20:21 +0200 (CEST)
Date:   Tue, 30 Jul 2019 14:20:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 5.2.1
Message-ID: <20190730122021.GA28208@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Baruch Siach <baruch@tkos.co.il>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190726155847.12970-1-dsterba@suse.com>
 <87tvb3wz43.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tvb3wz43.fsf@tarshish>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 30, 2019 at 02:17:16PM +0300, Baruch Siach wrote:
> Hi David,
> 
> On Fri, Jul 26 2019, David Sterba wrote:
> > btrfs-progs version 5.2.1 have been released. This is a bugfix release.
> >
> > Changes:
> >   * scrub status: fix ETA calculation after resume
> >   * check: fix crash when using -Q
> >   * restore: fix symlink owner restoration
> >   * mkfs: fix regression with mixed block groups
> >   * core: fix commit to process all delayed refs
> >   * other:
> >     * minor cleanups
> >     * test updates
> >
> > Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> > Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> 
> The last commit in this repo's master branch is 608fd900ca45 ("Btrfs
> progs v5.2"). Where can I find the updated git repo?

My bad, sorry, I forgot to push.

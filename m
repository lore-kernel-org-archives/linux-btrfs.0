Return-Path: <SRS0=o+mG=3Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3E5C35254
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 13:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4117A21741
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 13:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBENdI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 08:33:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:46530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgBENdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Feb 2020 08:33:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2CD8AFBB;
        Wed,  5 Feb 2020 13:33:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D6DD3DA7E6; Wed,  5 Feb 2020 14:32:52 +0100 (CET)
Date:   Wed, 5 Feb 2020 14:32:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3][v2] Add comments describing how space reservation
 works
Message-ID: <20200205133251.GJ2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200204181856.765916-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204181856.765916-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 04, 2020 at 01:18:53PM -0500, Josef Bacik wrote:
> v1->v2:
> - Fixed spelling mistakes, discovered you can use ':set spell' for files other
>   than git commit messages.
> - Reworked some of the explanations to be more visual to describe the general
>   flow.
> 
> --------------- Original email ------------------
> In talking with Nikolay about the data reservation patches it became clear that
> there's way more about the space reservation system that exists soley in my head
> than I thought.  I've written three big comments on the different sections of
> the space reservation system to hopefully help people understand how the system
> works generally.  Again this is from my point of view, and since I'm the one who
> wrote it I'm not sure where the gaps in peoples understanding is, so if there's
> something that is not clear here now is the time to bring it up.  Hopefully this
> will make reviewing patches I submit to this system less scary for reviewers.
> Thanks,
> 

Thanks, added to misc-next.

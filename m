Return-Path: <SRS0=3R9D=U6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C300C0650E
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jul 2019 11:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2AE206A3
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jul 2019 11:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfGALIE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jul 2019 07:08:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:48400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727645AbfGALIC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jul 2019 07:08:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26AFEAC9A;
        Mon,  1 Jul 2019 11:08:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 58A0BDA8A9; Mon,  1 Jul 2019 13:08:45 +0200 (CEST)
Date:   Mon, 1 Jul 2019 13:08:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Graham Cobb <g.btrfs@cobb.uk.net>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs pre-release 5.2-rc1
Message-ID: <20190701110845.GI20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Graham Cobb <g.btrfs@cobb.uk.net>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190628174032.3382-1-dsterba@suse.com>
 <5f8d8f28-7d43-e96f-6982-59a584f5f74b@cobb.uk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8d8f28-7d43-e96f-6982-59a584f5f74b@cobb.uk.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 28, 2019 at 11:37:40PM +0100, Graham Cobb wrote:
> On 28/06/2019 18:40, David Sterba wrote:
> > Hi,
> > 
> > this is a pre-release of btrfs-progs, 5.2-rc1.
> > 
> > The proper release is scheduled to next Friday, +7 days (2019-07-05), but can
> > be postponed if needed.
> > 
> > Scrub status has been reworked:
> > 
> >   UUID:             bf8720e0-606b-4065-8320-b48df2e8e669
> >   Scrub started:    Fri Jun 14 12:00:00 2019
> >   Status:           running
> >   Duration:         0:14:11
> >   Time left:        0:04:04
> >   ETA:              Fri Jun 14 12:18:15 2019
> >   Total to scrub:   182.55GiB
> >   Bytes scrubbed:   141.80GiB
> >   Rate:             170.63MiB/s
> >   Error summary:    csum=7
> >     Corrected:      0
> >     Uncorrectable:  7
> >     Unverified:     0
> 
> Is it possible to include my recently submitted patch to scrub to
> correct handling of last_physical and fix skipping much of the disk on
> scrub cancel/resume?

Yes, I'll add it to the branch.

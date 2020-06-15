Return-Path: <SRS0=tCue=74=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAACC433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Jun 2020 12:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 528412076A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Jun 2020 12:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgFOM5M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:57:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:34212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgFOM5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jun 2020 08:57:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5FF10ACB8;
        Mon, 15 Jun 2020 12:57:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D7C14DA7C3; Mon, 15 Jun 2020 14:57:01 +0200 (CEST)
Date:   Mon, 15 Jun 2020 14:57:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 5.8, part 2
Message-ID: <20200615125701.GY27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1592135316.git.dsterba@suse.com>
 <CAHk-=whbO-6zmwfQaX2=cDfsq_sN1PZ6_CAbqLgw3DUptnFrPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whbO-6zmwfQaX2=cDfsq_sN1PZ6_CAbqLgw3DUptnFrPg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jun 14, 2020 at 09:50:17AM -0700, Linus Torvalds wrote:
> On Sun, Jun 14, 2020 at 4:56 AM David Sterba <dsterba@suse.com> wrote:
> >
> > Reverts are not great, but under current circumstances I don't see
> > better options.
> 
> Pulled. Are people discussing how to make iomap work for everybody?
> It's a bit sad if we can't have the major filesystems move away from
> the old buffer head interfaces to a common more modern one..

Yes, it's fixable and we definitely want to move to iomap. The direct to
buffered fallback would fix one of the problems, but this would also
mean that xfs would start doing that. Such change should be treated more
like a feature development than a bugfix, imposed by another filesystem,
and xfs people rightfully complained.

It's quite possible that there's a better way to fix it on the iomap API
level but I haven't looked into that yet. We get support from iomap
people to add what we need for btrfs, so it's just a matter of time and
testing.

Return-Path: <SRS0=qoLa=DN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D403C4363A
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Oct 2020 03:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1704F206F4
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Oct 2020 03:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJFDLC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 23:11:02 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47766 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJFDLC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2020 23:11:02 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 1010883E6B8; Mon,  5 Oct 2020 23:11:00 -0400 (EDT)
Date:   Mon, 5 Oct 2020 23:11:00 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Casey Matson-deKay <caseymdk@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Best way to break RAID5/6?
Message-ID: <20201006031100.GL5890@hungrycats.org>
References: <CAG8D92WMf8x8YX-tMd48ZS0aEABxc2keBukwh1VeS9nryExk0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG8D92WMf8x8YX-tMd48ZS0aEABxc2keBukwh1VeS9nryExk0A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 05, 2020 at 06:46:53PM -0700, Casey Matson-deKay wrote:
> Hi all,
> 
> I'm new to the community, but love the work being done here. I'm an
> embedded C developer and PCB designer, and would like to get involved
> in btrfs.
> 
> I, like many, am frustrated at the mystery of raid5/6 functionality.
> More for the learning experience than anything, I was wondering about
> the best known methods to break raid5/6 in a test setup, in order to
> understand the patterns by which it breaks, and eventually, play
> around with the kernel code to understand what's going on more in
> depth.

Welcome to btrfs!

Here's a list of known raid5 bugs with background references:

	https://lore.kernel.org/linux-btrfs/20200627030614.GW10769@hungrycats.org/

> My initial thought, taking 3 USB drives, configuring them in RAID5,
> and pulling one out during a write, seems a bit simplistic. Are there

Just pulling one out is sufficient to hit the first bug:  some reads
fail in degraded mode.  

> known raid failure modes that would be more apt for learning and
> understanding where the raid bugs lie in btrfs, and how to trigger and
> explore them?
> 
> Thank you!
> 
> Casey

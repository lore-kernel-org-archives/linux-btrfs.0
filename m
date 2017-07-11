Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51506 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755512AbdGKQsQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 12:48:16 -0400
Date: Tue, 11 Jul 2017 09:48:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 10:00:40AM -0600, Chris Murphy wrote:
> > ---[ end trace feb4b95c83ac065f ]---
> > BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
> > BTRFS info (device dm-2): forced readonly
> 
> You've already had this same traceback, not sure whether it's the same
> file system or not, but it was 4.7.2 kernel.
 
You have better memory than me. I'll admit that I'm kind of overwhelmed
by all the time I'm currently spending/wasting on btrfs recovery and
that came almost out of nowwhere and hit me in 3 different places :-/
 
> Probably fixed in 4.9, no idea when. I would just use the most recent
> 4.9 kernel you can get or build. Less chance of regressions in
> longterm, greater chance of bug fixes. Same for 4.4.

Fair suggestion. I jumped from 4.8 to 4.11. I'll build a 4.9 then.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47506 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeGCVkr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 17:40:47 -0400
Date: Tue, 3 Jul 2018 14:40:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180703214041.4cywam4m4ivipgau@merlins.org>
References: <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
 <20180703042241.GI5567@merlins.org>
 <704a82af-7cef-7981-b620-0e63a35620b3@cn.fujitsu.com>
 <CAJCQCtSN7AzrdJ7owg3fki-yu_3t_6RWC6t+s3U_w3u-2tLjJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSN7AzrdJ7owg3fki-yu_3t_6RWC6t+s3U_w3u-2tLjJw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 03:34:45PM -0600, Chris Murphy wrote:
> On Tue, Jul 3, 2018 at 2:34 AM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
> 
> > Yes, extent tree is the hardest part for lowmem mode. I'm quite
> > confident the tool can deal well with file trees(which records metadata
> > about file and directory name, relationships).
> > As for extent tree, I have few confidence due to its complexity.
> 
> I have to ask again if there's some metadata integrity mask opion Marc
> should use to try to catch the corruption cause in the first place?
> 
> His use case really can't afford either mode of btrfs check. And also
> check is only backward looking, it doesn't show what was happening at
> the time. And for big file systems, check rapidly doesn't scale at all
> anyway.
> 
> And now he's modifying his layout to avoid the problem from happening
> again which makes it less likely to catch the cause, and get it fixed.
> I think if he's willing to build a kernel with integrity checker
> enabled, it should be considered but only if it's likely to reveal why
> the problem is happening, even if it can't repair the problem once
> it's happened. He's already in that situation so masked integrity
> checking is no worse, at least it gives a chance to improve Btrfs
> rather than it being a mystery how it got corrupt.

Yeah, I'm fine waiting a few more ays with this down and gather data if
that helps.
But due to the size, a full btrfs image may be a bit larger than we
want, not counting some confidential data in some filenames.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

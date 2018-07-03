Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:43184 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbeGCVeq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 17:34:46 -0400
Received: by mail-oi0-f46.google.com with SMTP id b15-v6so6723514oib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 14:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <704a82af-7cef-7981-b620-0e63a35620b3@cn.fujitsu.com>
References: <20180629061001.kkmgvdgqfhz23kll@merlins.org> <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
 <20180703042241.GI5567@merlins.org> <704a82af-7cef-7981-b620-0e63a35620b3@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 3 Jul 2018 15:34:45 -0600
Message-ID: <CAJCQCtSN7AzrdJ7owg3fki-yu_3t_6RWC6t+s3U_w3u-2tLjJw@mail.gmail.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 3, 2018 at 2:34 AM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:

> Yes, extent tree is the hardest part for lowmem mode. I'm quite
> confident the tool can deal well with file trees(which records metadata
> about file and directory name, relationships).
> As for extent tree, I have few confidence due to its complexity.

I have to ask again if there's some metadata integrity mask opion Marc
should use to try to catch the corruption cause in the first place?

His use case really can't afford either mode of btrfs check. And also
check is only backward looking, it doesn't show what was happening at
the time. And for big file systems, check rapidly doesn't scale at all
anyway.

And now he's modifying his layout to avoid the problem from happening
again which makes it less likely to catch the cause, and get it fixed.
I think if he's willing to build a kernel with integrity checker
enabled, it should be considered but only if it's likely to reveal why
the problem is happening, even if it can't repair the problem once
it's happened. He's already in that situation so masked integrity
checking is no worse, at least it gives a chance to improve Btrfs
rather than it being a mystery how it got corrupt.

-- 
Chris Murphy

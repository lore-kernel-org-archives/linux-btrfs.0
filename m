Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35057 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbeGCVrA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 17:47:00 -0400
Received: by mail-oi0-f49.google.com with SMTP id i12-v6so6811833oik.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 14:47:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e72a5fe6-a6fc-ee70-870e-f98d4c7b8221@gmx.com>
References: <20180629061001.kkmgvdgqfhz23kll@merlins.org> <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
 <20180703042241.GI5567@merlins.org> <e72a5fe6-a6fc-ee70-870e-f98d4c7b8221@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 3 Jul 2018 15:46:59 -0600
Message-ID: <CAJCQCtQVQryoycCORen=m26AtN+5__f2RnsjVP4vupSb9+0Tkw@mail.gmail.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 3, 2018 at 2:50 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> There must be something wrong, however due to the size of the fs, and
> the complexity of extent tree, I can't tell.

Right, which is why I'm asking if any of the metadata integrity
checker mask options might reveal what's going wrong?

I guess the big issues are:
a. compile kernel with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y is necessary
b. it can come with a high resource burden depending on the mask and
where the log is being written (write system logs to a different file
system for sure)
c. the granularity offered in the integrity checker might not be enough.
d. might take a while before corruptions are injected before
corruption is noticed and flagged.

So it might be pointless, no idea.


-- 
Chris Murphy

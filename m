Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeERQXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 12:23:34 -0400
Date: Fri, 18 May 2018 18:20:51 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Any chance to get snapshot-aware defragmentation?
Message-ID: <20180518162051.GS6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 05:22:26PM +0200, Niccolò Belli wrote:
> I'm waiting for this feature since years and initially it seemed like 
> something which would have been worked on, sooner or later.
> A long time had passed without any progress on this, so I would like to 
> know if there is any technical limitation preventing this or if it's 
> something which could possibly land in the near future.

Josef started working on that in 2014 and did not finish it. The patches
can be still found in his tree. The problem is in excessive memory
consumption when there are many snapshots that need to be tracked during
the defragmentation, so there are measures to avoid OOM. There's
infrastructure ready for use (shrinkers), there are maybe some problems
but fundamentally is should work.

I'd like to get the snapshot-aware working again too, we'd need to find
a volunteer to resume the work on the patchset.

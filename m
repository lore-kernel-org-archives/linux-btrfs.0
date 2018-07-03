Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33974 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbeGCOi4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 10:38:56 -0400
Date: Tue, 3 Jul 2018 07:38:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180703143851.GK5567@merlins.org>
References: <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com> <20180703042241.GI5567@merlins.org> <e72a5fe6-a6fc-ee70-870e-f98d4c7b8221@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e72a5fe6-a6fc-ee70-870e-f98d4c7b8221@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 04:50:48PM +0800, Qu Wenruo wrote:
> > It sounds like there may not be a fix to this problem with the filesystem's
> > design, outside of "do not get there, or else".
> > It would even be useful for btrfs tools to start computing heuristics and
> > output warnings like "you have more than 100 snapshots on this filesystem,
> > this is not recommended, please read http://url/"
> 
> This looks pretty doable, but maybe it's better to add some warning at
> btrfs progs (both "subvolume snapshot" and "receive").

This is what I meant to say, correct.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

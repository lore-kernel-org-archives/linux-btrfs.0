Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750718AbdAXQh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 11:37:57 -0500
Date: Tue, 24 Jan 2017 17:37:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/6] btrfs-progs: convert: Switch to new rollback
 function
Message-ID: <20170124163737.GW11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
 <20170123175419.GQ11951@twin.jikos.cz>
 <87a1cb17-05ed-4192-44ad-f0d3cb17d067@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a1cb17-05ed-4192-44ad-f0d3cb17d067@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 08:44:00AM +0800, Qu Wenruo wrote:
> 
> 
> At 01/24/2017 01:54 AM, David Sterba wrote:
> > On Mon, Dec 19, 2016 at 02:56:41PM +0800, Qu Wenruo wrote:
> >> Since we have the whole facilities needed to rollback, switch to the new
> >> rollback.
> >
> > Sorry, the change from patch 4 to patch 5 seems too big to grasp for me,
> > reviewing is really hard and I'm not sure I could even do that. My
> > concern is namely about patch 5/6 that throws out a lot of code that
> > does not obviously map to the new code.
> >
> > I can try again to see if there are points where the patch could be
> > split, but at the moment the patchset is too scary to merge.
> >
> 
> So this implies the current implementation is not good enough for review.

I'd say the code hasn't been cleaned up for a long time so it's not good
enough for adding new features and doing broader fixes. The v2 rework
has fixed quite an important issue, but for other issues I'd rather get
smaller patches that eg. prepare the code for the final change.
Something that I can review without needing to reread the whole convert
and refresh memories about all details.

> I'll try to extract more more set operation and make the core part more 
> refined, with more ascii art comment for it.

The ascii diagrams help, the overall convert design could be also better
documented etc. At the moment I'd rather spend some time on cleaning up
the sources but also don't want to block the fixes you've been sending.
I need to think about that more.

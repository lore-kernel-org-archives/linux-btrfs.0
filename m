Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753584AbdA3PO0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 10:14:26 -0500
Date: Mon, 30 Jan 2017 15:55:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/6] btrfs-progs: convert: Switch to new rollback
 function
Message-ID: <20170130145534.GP11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
 <20170123175419.GQ11951@twin.jikos.cz>
 <87a1cb17-05ed-4192-44ad-f0d3cb17d067@cn.fujitsu.com>
 <20170124163737.GW11951@twin.jikos.cz>
 <0c98477a-6f39-81c5-bbac-18f99417819d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0c98477a-6f39-81c5-bbac-18f99417819d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 08:42:01AM +0800, Qu Wenruo wrote:
> >> So this implies the current implementation is not good enough for review.
> >
> > I'd say the code hasn't been cleaned up for a long time so it's not good
> > enough for adding new features and doing broader fixes. The v2 rework
> > has fixed quite an important issue, but for other issues I'd rather get
> > smaller patches that eg. prepare the code for the final change.
> > Something that I can review without needing to reread the whole convert
> > and refresh memories about all details.
> >
> >> I'll try to extract more more set operation and make the core part more
> >> refined, with more ascii art comment for it.
> >
> > The ascii diagrams help, the overall convert design could be also better
> > documented etc. At the moment I'd rather spend some time on cleaning up
> > the sources but also don't want to block the fixes you've been sending.
> > I need to think about that more.
> 
> Feel free to block the rework.
> 
> I'll start from sending out basic documentations explaining the logic 
> behind convert/rollback, which should help review.

FYI, I've reorganized the convert files a bit, this patchset does not
apply anymore, but I'm expecting some more changes to it so please adapt
it to the new file structure.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbcDAQlu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 12:41:50 -0400
Date: Fri, 1 Apr 2016 18:41:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v9 00/19] Btrfs dedupe framework
Message-ID: <20160401164113.GC9918@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331161201.GD6230@twin.jikos.cz>
 <56FDC043.50902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FDC043.50902@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 08:26:43AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/03/31 18:12 +0200:
> > On Wed, Mar 30, 2016 at 03:55:55PM +0800, Qu Wenruo wrote:
> >> This March 30th patchset update mostly addresses the patchset structure
> >> comment from David:
> >> 1) Change the patchset sequence
> >>     Not If only apply the first 14 patches, it can provide the full
> >>     backward compatible in-memory only dedupe backend.
> >>
> >>     Only starts from patch 15, on-disk format will be changed.
> >>
> >>     So patch 1~14 is going to be pushed for next merge window, while I'll
> >>     still submit them all for review purpose.
> >
> > I'll buy 1-10 with the ioctl hidden under the BTRFS_DEBUG config option
> > until the interface is settled.
> >
> >
> Nice to hear that.
> 
> I'll add BTRFS_DEBUG config then.

Independent of the next merge window, I'll add them to my for-next after
you send the updated version. I'll also try to review them next week,
but I don't remember any critical issue during first reading, so there's
no blocker.

> BTW, any comment on btrfs-convert rewrite?

This not the right place to ask, better to ping as reply to the thread
as I could miss it. Nevertheless, the answer is that it's going to devel
branch, the convert tests passed (as required minimum), but the patchset
is still not reviewed up to my satisfaction.

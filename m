Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34789 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaHaPlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 11:41:16 -0400
Date: Sun, 31 Aug 2014 23:40:51 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
Message-ID: <20140831154050.GA17362@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
 <53FC855F.2060904@fb.com>
 <6660868.gHr8BxRfi4@merkaba>
 <5987063.Et4MtoWL1c@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5987063.Et4MtoWL1c@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 31, 2014 at 01:48:36PM +0200, Martin Steigerwald wrote:
> Am Dienstag, 26. August 2014, 15:20:21 schrieb Martin Steigerwald:
> > Am Dienstag, 26. August 2014, 09:02:23 schrieb Chris Mason:
> > > On 08/26/2014 06:20 AM, Martin Steigerwald wrote:
> > > > Am Montag, 25. August 2014, 10:58:13 schrieb Chris Mason:
> > > >> On 08/15/2014 11:36 AM, Liu Bo wrote:
> > > >>> This has been reported and discussed for a long time, and this hang
> > > >>> occurs
> > > >>> in both 3.15 and 3.16.
> > > >> 
> > > >> [ great description ]
> > > >> 
> > > >> I ran this through tests last week, and an overnight test over the
> > > >> weekend.  It's in my for-linus branch now, along with everything else I
> > > >> plan on sending for rc3.
> > > >> 
> > > >> Please double check my merge, I had to undo your rebase onto Miao's
> > > >> patches.>
> > > > 
> > > > I would like to test this on 3.17-rc2, what do I need to do to make it
> > > > apply cleanly? That function in disk-io.c looks quite different from
> > > > what
> > > > the patch assumes at the beginning, so I am not sure how to merge this.
> > > 
> > > You can just pull my for-linus branch, Liu Bo's fix is on top.
> > 
> > Thanks, I put the commit on top of your for-linus branch on top of 3.17-rc2.
> > Lets see how it goes.
> 
> So far this appears to work well.
> 
> I have experienced no hangs.
> 
> Tested-By: Martin Steigerwald <martin@lichtvoll.de>
> 
> But I bet Linus took it already anyways :). Looking forward to rc3.
> 
> Thanks for digging into and fixing this long standing annoying bug.

Thanks for your feedback!

thanks,
-liubo

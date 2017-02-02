Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34490 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdBBOZ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 09:25:26 -0500
Date: Thu, 2 Feb 2017 15:25:21 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Message-ID: <20170202142521.nfiy73ye6bi5smjv@angband.pl>
References: <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
 <20170201115530.l2ce5afcqld2kzi4@angband.pl>
 <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
 <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 07:49:50AM -0500, Austin S. Hemmelgarn wrote:
> This is a severe bug that makes a not all that uncommon (albeit bad) use
> case fail completely.  The fix had no dependencies itself and

I don't see what's bad in mounting a RAID degraded.  Yeah, it provides no
redundancy but that's no worse than using a single disk from the start.
And most people not doing storage/server farm don't have a stack of spare
disks at hand, so getting a replacement might take a while.

Being able to continue to run when a disk fails is the whole point of RAID
-- despite what some folks think, RAIDs are not for backups but for uptime.
And if your uptime goes to hell because the moment a disk fails you need to
drop everything and replace the disk immediately, why would you use RAID?

> > I /thought/ the immediate benefit was obvious enough that it
> > would be mainline-merged by now, not hoovered-up into some long-term
> > project with no real hint as to /when/ it might be merged.  Oh, well...
> I think (although I'm not sure about it) that this:
> http://www.spinics.net/lists/linux-btrfs/msg47283.html
> is the first posting of the patch series.

Is there a more recent version somewhere?  Mechanically rebasing+resolving
conflicts doesn't work, I'd need to do a more involved refresh, which would
be a waste of time if it's already done by someone with an actual clue about
this code.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fep23.mx.upcmail.net ([62.179.121.43]:49068 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900AbbJHWQt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 18:16:49 -0400
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
Date: Fri, 9 Oct 2015 00:16:43 +0200
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <201510052226.47051.pisa@cmp.felk.cvut.cz> <561657D5.1070809@gmail.com> <20151008211352.GC25907@carfax.org.uk>
In-Reply-To: <20151008211352.GC25907@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201510090016.43759.pisa@cmp.felk.cvut.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo,

On Thursday 08 of October 2015 23:13:52 Hugo Mills wrote:
> On Thu, Oct 08, 2015 at 07:47:33AM -0400, Austin S Hemmelgarn wrote:
> > On 2015-10-08 04:28, Pavel Pisa wrote:
> > >I go to use "btrfs replace" because there has not been any reply to my
> > > inplace correction question. But I expect that clarification if
> > > possible/how to resync RAID1 after one drive temporal disappear is
> > > really important to many of BTRFS users.
> >
> > As of right now, there is no way that I know of to safely re-sync a
> > drive that's been disconnected for a while.  The best bet is
> > probably to use replace, but for that to work reliably, you would
> > need to tell it to ignore the now stale drive when trying to read
> > each chunk.
>
>    Scrub is officially what you need there. I can confirm that it
> works correctly, having used it myself after accidentally unplugging
> the wrong drive.
>

Thanks for the reply.

I have tried to run scrub after reconnect but it counted errors in
its console output and write errors has been logged by kernel as crazy.
I have to admit I have not wait to finish it because I have not good
feeling from it.
May it be it was result of not fully correct reconnect.
But other partition worked with ext4 has no problems to write.

But if mount/unmount (in my case requiring reboot) and then scrub
worked it would be much simpler than replaces series.

I hope I would not need that (at least soon/in years) but I
give try to scrub again.

May it be problem is my btrfs tools old version on the server --
Wheezy Btrfs v3.17 backport. Kernel is Linux 4.1.2 #1 SMP PREEMPT.

Thanks,

         Pavel

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:60867 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJYTQM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 15:16:12 -0400
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20141025110339.NNVR31475.eastrmfepo201.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 25 Oct 2014 07:03:39 -0400
Date: Sat, 25 Oct 2014 04:03:38 -0700
From: Duncan <j.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Subject: Fw: Heavy nocow'd VM image fragmentation
Message-ID: <20141025040338.05963ed9@ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Begin forwarded message (forgot to send to list):

Date: Sat, 25 Oct 2014 03:57:41 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: Heavy nocow'd VM image fragmentation


On Fri, 24 Oct 2014 21:48:56 -0700
Marc MERLIN <marc@merlins.org> wrote:

> On Oct 25, 2014 11:28 AM, "Duncan" <1i5t5.duncan@cox.net> wrote:
> 
> > Yes, but the OP said he hadn't snapshotted since creating the file,
> > and MM's a regular that actually wrote much of the wiki
> > documentation on raid56 modes, so he better know about the
> > snapshotting problem too.
> 
> Yes and no. I use btrfs send receive, so I have to use snapshots on
> the subvolume my VM file is on.

That kinds screws things, since you can delete the snapshots afterward,
but if anything changed while it was there it still forces a 1cow on
it.  As long as the send doesn't take "forever" the time in question
can be reasonably short, but if the VM must remain active over that
period, there's likely to still be /some/ effect.

The only thing you can do about that, I guess, is periodically defrag
them, but of course without snapshot-aware-defrag that breaks any
snapshot sharing, multiplying the space required.  And with
send/receive requiring a reference snapshot for incrementals, there's
the snapshot, thus space-doubling on anything actually defragged is
unfortunately a given. =:^(

> Can you reply to this post to show my reply to others since my
> Android post to the list will get rejected?

Dug out of the trash here too due to the HTML, but OK... 

-- 
Duncan - HTML messages treated as spam
"They that can give up essential liberty to obtain a little
temporary safety, deserve neither liberty nor safety." --
Benjamin Franklin

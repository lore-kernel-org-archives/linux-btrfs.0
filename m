Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36106 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaDFRUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 13:20:41 -0400
Date: Sun, 6 Apr 2014 10:20:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <20140406172030.GF5006@merlins.org>
References: <1396624841-1363-1-git-send-email-fdmanana@gmail.com>
 <20140406001838.GA9485@merlins.org>
 <CAL3q7H7Em8hX1CeARSjoZHwjvEjiQNs9Ni_ofH5aVbjQ04j0fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7Em8hX1CeARSjoZHwjvEjiQNs9Ni_ofH5aVbjQ04j0fQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: send, add calculate data size flag to allow
 for progress estimation
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 06, 2014 at 05:57:38PM +0100, Filipe David Manana wrote:
> > I looked around and found nothing that looked similar enough.
> > Obviously it's an assert, so I can run without it, but my source being
> > very different from yours just made me want to check that this was most
> > likely ok to run with 3.14.0.
> 
> This is based on top of btrfs-next plus previous send patches sent to
> this list but not yet in btrfs-next.
 
Right, I figured. It otherwise applied to 3.14, so I'm hopeful it'll
work since only the assert was missing.

> > 2) I saw the concerns about protocol incompatibility. Is it an issue if you run without -o
> > too?
> 
> No. See the discussion above. Using a send stream created with the new
> flag won't work with an old btrfs receive. But to be able to get a
> send stream with the new flag you need the patched btrfs receive
> (unless you plan to write your own code to call the send ioctl
> directly).

Thanks for confirming. Given that, it sounds more than fine to me.

> > 3) Do you have a patch for btrfs-tools so that I can try it, or a git
> > tree of btrfs-tools with this that I should pull?
> 
> Yes, without it I couldn't test it and it would be pointless. There's
> a patch in the list for btrfs-progs.  I've also pasted a link to it
> (and this one too) in reply to the thread you started days ago.

So yes I knew you had a patch obviously :) but I missed the Email where
you sent it, and just found it now
"[RFC PATCH] Btrfs-progs: send, calculate and report progress based on the new flag"

> > 4) Can I run btrfs send -o snap1 snap2 >/dev/null to get quick stats
> > on the changes between the 2 snapshots, or is it still going to walk
> > through all the data blocks and send them to /dev/null afterwards?
> 
> No, but it's doable and implies only extending the user space tools.
> What is implemented is explained in the commit log for the btrfs-progs
> patch.

Yes, I just read that now, my apologies for missing that other Email.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

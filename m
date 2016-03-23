Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbcCWRSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 13:18:36 -0400
Date: Wed, 23 Mar 2016 18:18:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Fuhry <dan@fuhry.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Add support for RENAME_{EXCHANGE,WHITEOUT}
Message-ID: <20160323171805.GN29764@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAO8L9g6EpXMNjWVunz2A-EPwGHBo=18T_a+3xovqMbHux3aHsw@mail.gmail.com>
 <20160321174914.GC8095@twin.jikos.cz>
 <CAO8L9g5R_v7UMtiop6KogdPZ7=sK6Q75atPPgPcvpaedwVbitg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO8L9g5R_v7UMtiop6KogdPZ7=sK6Q75atPPgPcvpaedwVbitg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 06:43:55PM -0400, Dan Fuhry wrote:
> > The patch style looks, I've briefly tested it in fstests and it blows
> > very quickly, the stacktraces are unreadable. So I could mismerge it or
> > there's another reason. Anyway, I'm going to pick this patch for 4.7 and
> > will add it to my for-next after the crashes are resolved.
> 
> Thanks for looking at this. I will test against for-linus-4.6 tomorrow
> (unless there's a better branch to build against - I'm a noob here)
> and see if I can find anything obvious.
> 
> I've had success with a rudimentary test that evaluates only the two
> new rename modes, and does not test behavior when subvolumes are
> involved, but have yet to subject it to a larger test suite such as
> xfstests. So it wouldn't surprise me if it breaks down there. I'll try
> and get that going on my system and see if I can reproduce.

I'm sorry for the confusion, the crashes were caused by overlayfs tests
that I mistakenly mixed together with the rename patch.

After re-evaluation, generic/024 025 and 078 (the RENAME_*) passes, the
rest seems to be ok as well.

IOW, the patch is in state to be added to for-next. The fstests should
need to be extended to add the cross rename involving subvolumes.

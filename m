Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbbFZOVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 10:21:36 -0400
Date: Fri, 26 Jun 2015 16:21:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20150626142133.GV726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150523000905.GA16230@ret.masoncoding.com>
 <CA+5PVA7yA-q3V_KHp-zL+4G_bO9Fp4i0jH_UXdez0r+4D4KqYQ@mail.gmail.com>
 <55646D1F.6000506@fb.com>
 <CA+5PVA4b5N-xcnDUd3ECNw5TM7Am+jjyq6nwjG+Wnme+FQWbqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+5PVA4b5N-xcnDUd3ECNw5TM7Am+jjyq6nwjG+Wnme+FQWbqQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 02, 2015 at 10:02:49AM -0400, Josh Boyer wrote:
> >>> Chris Mason (1) commits (+18/-0):
> >>>     Btrfs: fix regression in raid level conversion
> >>
> >> Shouldn't this be CC'd to stable since it fixes a broken commit in 4.0?
> >
> > Yes, I'm retesting two of these against 4.0
> 
> Did you finish up testing the two commits?  I might have missed it,
> but I haven't seen anything being requested to the 4.0.y stable tree
> yet.

JFYI, fixed in 4.0.6 .

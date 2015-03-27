Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbC0UoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 16:44:03 -0400
Date: Fri, 27 Mar 2015 13:44:00 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Hugo Mills <hugo@carfax.org.uk>, Martin <m_btrfs@ml1.co.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Message-ID: <20150327204400.GE17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <meq6hm$lbh$1@ger.gmane.org>
 <20150323232212.GL31762@carfax.org.uk>
 <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 09:30:52PM -0400, Rich Freeman wrote:
> On Mon, Mar 23, 2015 at 7:22 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Mon, Mar 23, 2015 at 11:10:46PM +0000, Martin wrote:
> >> As titled:
> >>
> >>
> >> Does btrfs have dedup (on raid1 multiple disks) that can be enabled?
> >
> >    The current state of play is on the wiki:
> >
> > https://btrfs.wiki.kernel.org/index.php/Deduplication
> >
> 
> I hadn't realized that bedup was deprecated.
> 
> This seems unfortunate since it seemed to be a lot smarter about
> detecting what has and hasn't already been scanned, and it also
> supported defragmenting files while de-duplicating them.

Hi just FYI, only rescanning files that have changed since the last scan is
a feature I've been working on in duperemove for some time now. I have some
rudimentary code that works which will be going into master branch in a week
or so (I wanted to finish it this week but other things have kept me busy).

But anyway that should help with the lack of intelligence on what files to
scan.
	--Mark

--
Mark Fasheh

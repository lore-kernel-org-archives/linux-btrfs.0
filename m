Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbcAWWWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 17:22:06 -0500
Date: Sat, 23 Jan 2016 14:22:05 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Message-ID: <20160123222205.GE24672@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <loom.20160116T132316-196@post.gmane.org>
 <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
 <CAGfcS_mepN3bcgSo6qgjVAyROoRpX3G05dAm=-g-eOhSkv+GZA@mail.gmail.com>
 <569CD935.4030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <569CD935.4030708@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 18, 2016 at 07:23:17AM -0500, Austin S. Hemmelgarn wrote:
> On 2016-01-16 13:07, Rich Freeman wrote:
> >On Sat, Jan 16, 2016 at 9:10 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> >>Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
> >>
> >>>Is there any urgency for dedup? What's wrong with storing the hash on
> >>>disk with the block and having a separate process dedup the written data
> >>>over time;
> >>
> >>There's actually uses for both inline and out-of-line[1] aka delayed
> >>dedup.  Btrfs already has a number of independent products doing various
> >>forms of out-of-line dedup, so what's missing and being developed now is
> >>the inline dedup option, which being directly in the write processing,
> >>must be handled by btrfs itself -- it can't be primarily done by third
> >>parties with just a few kernel calls, like out-of-line dedup can.
> >
> >Does the out-of-line dedup option actually utilize stored hashes, or
> >is it forced to re-read all the data to compute hashes?  If it is
> >collecting checksums/etc is this done efficiently?
> AFAIK, duperemove has the option to store block hashes in a database
> to save them between runs (I'm pretty sure that it invalidates
> hashes if the file containing the block changed, but I'm not
> certain).

Yes, duperemove can use a hashfile (this is the recommened way of running
it). right now they're more or less temporary storage for one run (though as
you noted you can reuse the hashfile later).

The feature to rescan only the changed parts of a filesystem (and reuse the
hashfile) is in development and will be available with the next major
release.


> >I think he is actually suggesting a hybrid approach where a bit of
> >effort is done during operations to greatly streamline out-of-line
> >deduplication.  I'm not sure how close we are to that already, or if
> >any room for improvement remains.
> There isn't any implementation I know of that does this.  In theory,
> it would be pretty easy if we could somehow get block checksums
> from BTRFS in userspace.

btrfs block checksums are there for us to see if a block was corrupted.
It is generally agreed that they will be colliding a lot which would cause
unnecessary file reads during the dedupe ioctl.

Also, if we get them from the FS we can only get them in blocksized chunks
which at 4K make dedupe expensive. Duperemove for example, defaults to 128K
chunks for this reason.
	--Mark

--
Mark Fasheh

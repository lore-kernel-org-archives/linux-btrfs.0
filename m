Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:43015 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbcLHPbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 10:31:00 -0500
Date: Thu, 8 Dec 2016 16:30:04 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs, balance convert: warn about RAID5/6
 in fiery letters
Message-ID: <20161208153004.GA31795@angband.pl>
References: <20161128185153.14908-1-kilobyte@angband.pl>
 <20161130151245.GO12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161130151245.GO12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 04:12:46PM +0100, David Sterba wrote:
> On Mon, Nov 28, 2016 at 07:51:53PM +0100, Adam Borowski wrote:
> > People who don't frequent IRC nor the mailing list tend to believe RAID 5/6
> > are stable; this leads to data loss.  Thus, let's do warn them.
> > 
> > At this point, I think fiery letters that won't be missed are warranted.
> > 
> > Kernel 4.9 and its -progs will be a part of LTS of multiple distributions,
> > so leaving experimental features without a warning is inappropriate.
> 
> I'm ok with adding the warning about raid56 feature, but I have some
> comments to how it's implemented.
> 
> Special case warning for the raid56 is ok, as it corresponds to the
> 'mkfs_features' table where the missing value for 'safe' should lead to
> a similar warning. This is planned to be more generic, so I just want to
> make sure we can adjust it later without problems.

There are at least two tools that can make a raid56: mkfs and balance
convert.  mkfs_features is used for the former but not for the latter.  It
doesn't appear to be machine-parseable as well (but that's a matter of
editing the #define).

Of course, making this generic is doable, I just don't know how do you plan
to do that.

Should I try to use mkfs_features somehow, or do it as a variant of the
current patch for now?

> The warning should go last, after the final summary (and respect verbosity
> level).

and for balance convert, before the output.

> The colors seem a bit too much to me, red text or just emphasize
> 'warning' would IMHO suffice.

(in the paragraph before:)
> If the message were not colored, I'd completely miss the warning.

... which means the color works!  It _is_ intended to be offensive, so
people can't possibly miss it.

XFS uses something far more tame: black text on red background (\e[0;30;41m)
but I want something that conveys the message appropriately.

Obviously I'm not married to a particular color for this bikeshed, I just
want a color that makes the neighbours complain :p


English lacks a proper word for this, something akin to
https://en.wiktionary.org/wiki/oczojebny

-- 
u-boot problems can be solved with the help of your old SCSI manuals, the
parts that deal with goat termination.  You need a black-handled knife, and
an appropriate set of candles (number and color matters).  Or was it a
silver-handled knife?  Crap, need to look that up.

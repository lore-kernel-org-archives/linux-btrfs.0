Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaHAS4A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 14:56:00 -0400
Date: Fri, 1 Aug 2014 11:55:59 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs offline deduplication
Message-ID: <20140801185559.GG2203@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com> <53DB6948.3000009@gmail.com> <20140801132308.GF1553@twin.jikos.cz> <53DBA128.8060605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53DBA128.8060605@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 01, 2014 at 10:16:08AM -0400, Austin S Hemmelgarn wrote:
> On 2014-08-01 09:23, David Sterba wrote:
> > On Fri, Aug 01, 2014 at 06:17:44AM -0400, Austin S Hemmelgarn wrote:
> >> I do think however that having the option of a background thread doing
> >> deduplication asynchronously is a good idea, but then you would have to
> >> have some way to trigger it on individual files/trees, and triggering on
> >> writes like the autodefrag thread does doesn't make much sense.  Having
> >> some userspace program to tell it to run on a given set of files would
> >> probably be the best approach for a trigger.  I don't remember if this
> >> kind of thing was also included in the online deduplication patches that
> >> got posted a while back or not.
> > 
> > IIRC the proposed implementation only merged new writes with existing
> > data.
> > 
> > For the out-of-band ("off-line") dedup there's bedup
> > (https://github.com/g2p/bedup) or Mark's duperemove tool
> > (https://github.com/markfasheh/duperemove) that work on a set of files.
> > 
> Something kernel-side to do the work asynchronously would be nice,
> especially if it could leverage the check-sums that BTRFS already stores
> for the blocks.  Having a userspace interface for offline deduplication
> similar to that for scrub operations would even better.

Why does this have to be kernel side? There's userspace software already to
dedupe that can be run on a regular basis. Exporting checksums is a
differnet story (you can do that via ioctl) but running the dedupe software
itself inside the kernel is exactly what we want to avoid by having the
dedupe ioctl in the first place.
	--Mark

--
Mark Fasheh

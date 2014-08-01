Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbaHAUSK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 16:18:10 -0400
Date: Fri, 1 Aug 2014 13:18:09 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs offline deduplication
Message-ID: <20140801201809.GH2203@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com> <53DB6948.3000009@gmail.com> <20140801132308.GF1553@twin.jikos.cz> <53DBA128.8060605@gmail.com> <20140801185559.GG2203@wotan.suse.de> <53DBE816.9050209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53DBE816.9050209@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 01, 2014 at 03:18:46PM -0400, Austin S Hemmelgarn wrote:
> > Why does this have to be kernel side? There's userspace software already to
> > dedupe that can be run on a regular basis. Exporting checksums is a
> > differnet story (you can do that via ioctl) but running the dedupe software
> > itself inside the kernel is exactly what we want to avoid by having the
> > dedupe ioctl in the first place.
> > 	--Mark
> > 
> > --
> > Mark Fasheh
> > 
> Based on the same logic however, we don't need scrub to be done kernel
> side, as it wouldn't take but one more ioctl to be able to tell it which
> block out of a set to treat as valid.  I'm not saying that things need
> to be done in the kernel, but duperemove doesn't use the ioctl interface
> even if it exists, and bedup is buggy as hell (unless it's improved
> greatly in the last two weeks), and neither of them is at all efficient.

Duperemove absolutely *does* use the ioctl interface for offline dedupe.


>  I do understand that this isn't something that is computationally
> simple (especially on x86 with it's defficiency of registers), but rsync
> does almost the same thing for data transmission over the network, and
> it does so seemingly much more efficiently than either option available
> at the moment.

None of the problems you mentioned get solved by pushing the entirety of
offline deduplication into the kernel. If anything, it's more dangerous tod
o that as bugs tend to be far more critical when we hit them from kernel.

Regarding duperemove there's a series to fix up some performance issues that
I'm working on importing at the moment.
	--Mark

--
Mark Fasheh

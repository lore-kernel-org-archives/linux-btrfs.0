Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaKXWf6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 17:35:58 -0500
Date: Mon, 24 Nov 2014 14:35:27 -0800
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com,
        clm@fb.com, dm-devel@redhat.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
Message-ID: <20141124223527.GB32205@lenny.home.zabbo.net>
References: <1416607231-8588-1-git-send-email-jbacik@fb.com>
 <20141124184534.GA24398@lenny.home.zabbo.net>
 <54738154.9010203@fb.com>
 <20141124195749.GA27597@lenny.home.zabbo.net>
 <547391DD.30406@fb.com>
 <20141124221015.GA32205@lenny.home.zabbo.net>
 <5473AF4F.2080408@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5473AF4F.2080408@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >>That is way complicated, I was just going to take two devices, one that's a
> >>linear mapping and the other that's the log, and then write to the log the
> >>sector+data that was written in order that it completes, and then have
> >>userspace do the replay.  So basically do the flush tracking like I am, then
> >>write out chunks to the log device to keep a semblance of how the flushing
> >>would have affected stuff, something like this
> >>
> >>write a, write b, a complete, flush, b complete, flush complete
> >>
> >>would log out
> >>
> >>wrote a, flush, write b, <other writes>, <next flush>
> >>
> >>and then we have a userspace thing that could do something like replay all
> >>writes to a flush, do fs consistency and data consistency checks, walk to
> >>the next flush, rinse repeat, and that way we could be sure that we always
> >>have a consistent fs.
> >
> >I guess that'd be an ok start, but I don't think you need any clever
> >kernel code to do that.  I've hacked up something like this in bash with
> >blktrace, loopback files, and dd :/.
> 
> I don't think blktrace gives us the data being written though does it? If it
> does then hooray I'm done playing a device mapper developer.

Right, that script was only working with the dumb simple case of using
manual double buffering and simple test loads that wouldn't overwrite
blocks.

> With the logging approach then it is completely up to us how we replay the
> log, so we can always go back and do more horrible things with the replay,
> like replay for a while, skip a flush and write some of the next random crap
> and see what happens.  Doing horrible things is awesome and that is what I
> want, but I also want to make sure we're not failing in the simple things
> too.  Thanks,

Sure, that's fair.  So maybe expand blktrace to include the data
payloads? :).

- z

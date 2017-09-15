Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51055 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751463AbdIOTBA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 15:01:00 -0400
Date: Fri, 15 Sep 2017 20:59:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.cz>
Subject: Re: \o/ compsize
Message-ID: <20170915185929.GB29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170904151154.vkhshc57t2mi2sze@angband.pl>
 <CAGqmi762p8wKRv3Gz0Z5BABUvKLn7-8XhB6=v-gbdqsGMV8rUg@mail.gmail.com>
 <20170904184229.cjarg6p7tbgy7gka@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170904184229.cjarg6p7tbgy7gka@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 08:42:29PM +0200, Adam Borowski wrote:
> On Mon, Sep 04, 2017 at 07:07:25PM +0300, Timofey Titovets wrote:
> > 2017-09-04 18:11 GMT+03:00 Adam Borowski <kilobyte@angband.pl>:
> > > Here's an utility to measure used compression type + ratio on a set of files
> > > or directories: https://github.com/kilobyte/compsize
> > >
> > > It should be of great help for users, and also if you:
> > > * muck with compression levels
> > > * add new compression types
> > > * add heurestics that could err on withholding compression too much
> > 
> > Packaged to AUR:
> > https://aur.archlinux.org/packages/compsize-git/
> 
> Cool!  I'd wait until people say the code is sane (I don't really know these
> ioctls) but if you want to make poor AUR folks our beta testers, that's ok.
> 
> However, one issue: I did not set a license; your packaging says GPL3. 
> It would be better to have something compatible with btrfs-progs which are
> GPL2-only.  What about GPL2-or-higher?
> 
> After adding some related info (like wasted space in pinned extents, reuse
> of extents), it'd be nice to have this tool inside btrfs-progs, either as a
> part of "fi du" or another command.

I've now implemented a prototype that calculates the compressed size of
extents per-file. As 'fi du' knows about what extents are shared, the
compression can be also calculated shared/exclusive.

There's no summary like compsize does, this would need a bit more
precise tracking of the extents, not just the compressed size but also
which algo was used. I can imagine all sorts of output enhancements,
like summarize the inline-compressed extents or print the algo summary
per-file. This should be easy once the calclation code is there. I
haven't reused compsize.c, as I needed only the ioctl part and wire it
to 'fi du', but the search ioctl is the same.

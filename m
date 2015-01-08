Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:54965 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbbAHQxY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 11:53:24 -0500
Date: Thu, 8 Jan 2015 17:53:21 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150108165321.GA23339@gardel-login>
References: <20150107174315.GA21865@gardel-login>
 <20150108155610.GA12859@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150108155610.GA12859@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 08.01.15 10:56, Zygo Blaxell (ce3g8jdj@umail.furryterror.org) wrote:

> On Wed, Jan 07, 2015 at 06:43:15PM +0100, Lennart Poettering wrote:
> > Heya!
> > 
> > Currently, systemd-journald's disk access patterns (appending to the
> > end of files, then updating a few pointers in the front) result in
> > awfully fragmented journal files on btrfs, which has a pretty
> > negative effect on performance when accessing them.
> > 
> > Now, to improve things a bit, I yesterday made a change to journald,
> > to issue the btrfs defrag ioctl when a journal file is rotated,
> > i.e. when we know that no further writes will be ever done on the
> > file. 
> > 
> > However, I wonder now if I should go one step further even, and use
> > the equivalent of "chattr -C" (i.e. nocow) on all journal files. I am
> > wondering what price I would precisely have to pay for
> > that. Judging by this earlier thread:
> > 
> >         http://www.spinics.net/lists/linux-btrfs/msg33134.html
> > 
> > it's mostly about data integrity, which is something I can live with,
> > given the conservative write patterns of journald, and the fact that
> > we do our own checksumming and careful data validation. I mean, if
> > btrfs in this mode provides no worse data integrity semantics than
> > ext4 I am fully fine with losing this feature for these files.
> 
> This sounds to me like a job for fallocate with FALLOC_FL_KEEP_SIZE.

We already use fallocate(), but this is not enough on cow file
systems. With fallocate() you can certainly improve fragmentation when
appending things to a file. But on a COW file system this will help
little if we change things in the beginning of the file, since COW
means that it will then make a copy of those blocks and alter the
copy, but leave the original version unmodified. And if we do that all
the time the files get heavily fragmented, even though all the blocks
we modify have been fallocate()d initially...

> This would work on ext4, xfs, and others, and provide the same benefit
> (or even better) without filesystem-specific code.  journald would
> preallocate a contiguous chunk past the end of the file for appends,
> and

That's precisely what we do. But journald's write pattern is not
purely appending to files, it's "append something to the end, then
link it up in the beginning". And for the "append" part we are
fine with fallocate(). It's the "link up" part that completely fucks
up fragmentation so far.

Lennart

-- 
Lennart Poettering, Red Hat

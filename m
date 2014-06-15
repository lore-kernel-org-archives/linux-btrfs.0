Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:51187 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFOWeX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 18:34:23 -0400
Date: Mon, 16 Jun 2014 00:34:21 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, kreijack@inwind.it,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140615223421.GF24386@tango.0pointer.de>
References: <5398CA16.3030609@libero.it>
 <20140612012104.GO9508@dastard>
 <20140612013728.GP4453@dastard>
 <5E3380D5-FF9F-4152-B115-7D16CD8CC215@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5E3380D5-FF9F-4152-B115-7D16CD8CC215@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 11.06.14 20:32, Chris Murphy (lists@colorremedies.com) wrote:

> > systemd has a very stupid journal write pattern. It checks if there
> > is space in the file for the write, and if not it fallocates the
> > small amount of space it needs (it does *4 byte* fallocate calls!)

Not really the case. 

http://cgit.freedesktop.org/systemd/systemd/tree/src/journal/journal-file.c#n354

We allocate 8mb at minimum.

> > and then does the write to it.  All this does is fragment the crap
> > out of the log files because the filesystems cannot optimise the
> > allocation patterns.

Well, it would be good if you'd tell me what to do instead...

I am invoking fallocate() in advance, because we write those files with
mmap() and that of course would normally triggered SIGBUS already on the
most boring of reasons, such as disk full/quota full or so. Hence,
before we do anything like that, we invoke fallocate() to ensure that
the space is actually available... As far as I can see, that pretty much
in line with what fallocate() is supposed to be useful for, the man page
says this explicitly:

     "...After a successful call to posix_fallocate(), subsequent writes
      to bytes in the specified range are guaranteed not to fail because
      of lack of disk space."

Happy to be informed that the man page is wrong. 

I am also happy to change our code, if it really is the wrong thing to
do. Note however that I generally favour correctness and relying on
documented behaviour, instead of nebulous optimizations whose effects
might change with different file systems or kernel versions...

> > Yup, it fragments journal files on XFS, too.
> > 
> > http://oss.sgi.com/archives/xfs/2014-03/msg00322.html
> > 
> > IIRC, the systemd developers consider this a filesystem problem and
> > so refused to change the systemd code to be nice to the filesystem
> > allocators, even though they don't actually need to use fallocate...

What? No need to be dick. Nobody ever pinged me about this. And yeah, I
think I have a very good reason to use fallocate(). The only reason in
fact the man page explicitly mentions.

Lennart

-- 
Lennart Poettering, Red Hat

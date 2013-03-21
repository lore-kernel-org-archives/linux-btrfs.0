Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49778 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3CUXGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 19:06:24 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 585AA7C0446
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 17:06:24 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>, Alexandre Oliva <oliva@gnu.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130321180614.30044.29961@localhost.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
 <20130318225245.25964.22219@localhost.localdomain>
 <orzjy0dkz9.fsf@livre.home>
 <20130319120940.29898.80124@localhost.localdomain>
 <ora9pzdwdw.fsf@livre.home> <or1ubaesrx.fsf@livre.home>
 <ord2utb4xx.fsf@livre.home>
 <20130321180614.30044.29961@localhost.localdomain>
Message-ID: <20130321230621.30044.80640@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Thu, 21 Mar 2013 19:06:21 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Chris Mason (2013-03-21 14:06:14)
> Quoting Alexandre Oliva (2013-03-21 03:14:02)
> > On Mar 19, 2013, Alexandre Oliva <oliva@gnu.org> wrote:
> > 
> > > On Mar 19, 2013, Alexandre Oliva <oliva@gnu.org> wrote:
> > >>> that is being processed inside the snapshot.
> > 
> > >> This doesn't explain why the master database occasionally gets similarly
> > >> corrupted, does it?
> > 
> > > Actually, scratch this bit for now.  I don't really have proof that the
> > > master database actually gets corrupted while it's in use
> > 
> > Scratch the “scratch this”.  The master database actually gets
> > corrupted, and it's with recently-created files, created after earlier
> > known-good snapshots.  So, it can't really be orphan processing, can it?
> 
> Right, it can't be orphan processing.
> 
> > 
> > Some more info from the errors and instrumentation:
> > 
> > - no data syncing on the affected files is taking place.  it's just
> >   memcpy()ing data in <4KiB-sized chunks onto mmap()ed areas,
> >   munmap()ing it, growing the file with ftruncate and mapping a
> >   subsequent chunk for further output
> > 
> > - the NULs at the end of pages do NOT occur at munmap/mmap boundaries as
> >   I suspected at first, but they do coincide with the end of extents
> >   that are smaller than the maximum compressed extent size.  So,
> >   something's making btrfs flush pages to disk before the pages are
> >   completely written (which is fine in principle), but apparently
> >   failing to pick up subsequent changes to the pages (eek!)
> 
> With mmap the kernel can pick any given time to start writing out dirty
> pages.  The idea is that if the application makes more changes the page
> becomes dirty again and the kernel writes it again.
> 
> So the question is, can you trigger this without snapshots being done
> at all?  I'll try to make an mmap tester here that hammers on the
> related code.  We usually test this with fsx, which catches all kinds of
> horrors.

So my test program creates an 8GB file in chunks of 1MB each.  Using
truncate to extend the file and then mmap to write into the new hole.
It is writing in 1MB chunks, ever so slightly not aligned.  After
creating the whole file, it reads it back to look for errors.

I'm running this with heavy memory pressure, but no snapshots.  No
corruptions yet, but I'll let it run a while long.

-chris


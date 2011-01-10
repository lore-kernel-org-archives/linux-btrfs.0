From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Mon, 10 Jan 2011 10:39:56 -0500
Message-ID: <1294673931-sup-2167@think>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net> <1294276285-sup-9136@think> <4D2B258E.7010706@gmail.com> <20110110153730.GB2533@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110110153730.GB2533@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-01-10 10:37:31 -0500:
> On Mon, Jan 10, 2011 at 10:28:14AM -0500, Ric Wheeler wrote:
> >
> > I think that dedup has a variety of use cases that are all very dependent 
> > on your workload. The approach you have here seems to be a quite 
> > reasonable one.
> >
> > I did not see it in the code, but it is great to be able to collect 
> > statistics on how effective your hash is and any counters for the extra 
> > IO imposed.
> >
> 
> So I have counters for how many extents are deduped and the overall file
> savings, is that what you are talking about?
> 
> > Also very useful to have a paranoid mode where when you see a hash 
> > collision (dedup candidate), you fall back to a byte-by-byte compare to 
> > verify that the the collision is correct.  Keeping stats on how often 
> > this is a false collision would be quite interesting as well :)
> >
> 
> So I've always done a byte-by-byte compare, first in userspace but now its in
> kernel, because frankly I don't trust hashing algorithms with my data.  It would
> be simple enough to keep statistics on how often the byte-by-byte compare comes
> out wrong, but really this is to catch changes to the file, so I have a
> suspicion that most of these statistics would be simply that the file changed,
> not that the hash was a collision.  Thanks,

At least in the kernel, if you're comparing extents on disk that are
from a committed transaction.  The contents won't change.  We could read
into a private buffer instead of into the file's address space to make
this more reliable/strict.

-chris

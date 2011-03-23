From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 23 Mar 2011 16:52:06 +0100
Message-ID: <20110323155206.GD12003@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2011 at 08:48:01AM -0700, Linus Torvalds wrote:
> On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Currently, mutex_trylock() doesn't use adaptive spinning. =A0It tri=
es
> > just once. =A0I got curious whether using adaptive spinning on
> > mutex_trylock() would be beneficial and it seems so, at least for
> > btrfs anyway.
>=20
> Hmm. Seems reasonable to me. The patch looks clean, although part of
> that is just the mutex_spin() cleanup that is independent of actually
> using it in trylock.

Oh, I have two split patches.  Posted the combined one for comments.

> So no objections from me.

Awesome.  Peter, what do you think?  Are there some other tests which
can be useful?

Thanks.

--=20
tejun

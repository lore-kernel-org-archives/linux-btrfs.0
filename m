From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 23 Mar 2011 08:48:01 -0700
Message-ID: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
References: <20110323153727.GB12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110323153727.GB12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Currently, mutex_trylock() doesn't use adaptive spinning. =A0It tries
> just once. =A0I got curious whether using adaptive spinning on
> mutex_trylock() would be beneficial and it seems so, at least for
> btrfs anyway.

Hmm. Seems reasonable to me. The patch looks clean, although part of
that is just the mutex_spin() cleanup that is independent of actually
using it in trylock.

So no objections from me.

                    Linus

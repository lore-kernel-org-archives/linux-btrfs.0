From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 23 Mar 2011 22:46:56 +0300
Message-ID: <AANLkTiktmhP6-JGTKHf+wZhdJRd3Eb-PYzMRR=CyRsUP@mail.gmail.com>
References: <20110323153727.GB12003@htj.dyndns.org> <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2011 at 6:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> Currently, mutex_trylock() doesn't use adaptive spinning. =C2=A0It t=
ries
>> just once. =C2=A0I got curious whether using adaptive spinning on
>> mutex_trylock() would be beneficial and it seems so, at least for
>> btrfs anyway.
>
> Hmm. Seems reasonable to me.

TAS/spin with exponential back-off has been preferred locking approach
in Postgres (and I believe other DBMSes) for years, at least since '04
when I had last touched Postgres code. Even with 'false negative' cost
in user-space being much higher than in the kernel, it's still just a
question of scale (no wonder measurable improvement here is reported
from dbench on SSD capable of few dozen thousand IOPS).

Regards,
Andrey

> The patch looks clean, although part of that is just the mutex_spin()
> cleanup that is independent of actually using it in trylock.
>
> So no objections from me.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

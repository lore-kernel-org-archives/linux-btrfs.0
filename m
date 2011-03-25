From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Fri, 25 Mar 2011 14:13:14 +0300
Message-ID: <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org> <20110325033956.GB9313@home.goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110325033956.GB9313@home.goodmis.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2011 at 6:39 AM, Steven Rostedt <rostedt@goodmis.org> w=
rote:
> On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
>> Adaptive owner spinning used to be applied only to mutex_lock(). =C2=
=A0This
>> patch applies it also to mutex_trylock().
>>
>> btrfs has developed custom locking to avoid excessive context switch=
es
>> in its btree implementation. =C2=A0Generally, doing away with the cu=
stom
>> implementation and just using the mutex shows better behavior;
>> however, there's an interesting distinction in the custom implementi=
on
>> of trylock. =C2=A0It distinguishes between simple trylock and tryspi=
n,
>> where the former just tries once and then fail while the latter does
>> some spinning before giving up.
>>
>> Currently, mutex_trylock() doesn't use adaptive spinning. =C2=A0It t=
ries
>> just once. =C2=A0I got curious whether using adaptive spinning on
>> mutex_trylock() would be beneficial and it seems so, for btrfs anywa=
y.
>>
>> The following results are from "dbench 50" run on an opteron two
>> socket eight core machine with 4GiB of memory and an OCZ vertex SSD.
>> During the run, disk stays mostly idle and all CPUs are fully occupi=
ed
>> and the difference in locking performance becomes quite visible.
>>
>> SIMPLE is with the locking simplification patch[1] applied. =C2=A0i.=
e. it
>> basically just uses mutex. =C2=A0SPIN is with this patch applied on =
top -
>> mutex_trylock() uses adaptive spinning.
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 USER =C2=A0 SYSTEM =C2=A0 SIRQ =C2=A0 =C2=
=A0CXTSW =C2=A0THROUGHPUT
>> =C2=A0SIMPLE 61107 =C2=A0354977 =C2=A0 =C2=A0217 =C2=A08099529 =C2=A0=
845.100 MB/sec
>> =C2=A0SPIN =C2=A0 63140 =C2=A0364888 =C2=A0 =C2=A0214 =C2=A06840527 =
=C2=A0879.077 MB/sec
>>
>> On various runs, the adaptive spinning trylock consistently posts
>> higher throughput. =C2=A0The amount of difference varies but it outp=
erforms
>> consistently.
>>
>> In general, using adaptive spinning on trylock makes sense as tryloc=
k
>> failure usually leads to costly unlock-relock sequence.
>>
>> [1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9658
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> I'm curious about the effects that this has on those places that do:
>
> again:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(A);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mutex_trylock(B)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(A=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto again;
>
>
> Where the normal locking order is:
> =C2=A0B -> A
>
> If another location does:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(B);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0[...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(A);
>
> But another process has A already, and is running, it may spin waitin=
g
> for A as A's owner is still running.
>
> But now, mutex_trylock(B) becomes a spinner too, and since the B's ow=
ner
> is running (spinning on A) it will spin as well waiting for A's owner=
 to
> release it. Unfortunately, A's owner is also spinning waiting for B t=
o
> release it.
>
> If both A and B's owners are real time tasks, then boom! deadlock.

Turning try_lock into indefinitely spinning one breaks its semantics,
so deadlock is to be expected. But what's wrong in this scenario if
try_lock spins a bit before giving up?

Regards,
Andrey

>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

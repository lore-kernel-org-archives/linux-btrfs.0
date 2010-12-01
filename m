From: Matt <jackdachef@gmail.com>
Subject: Re: dm-crypt barrier support is effective
Date: Wed, 1 Dec 2010 18:35:10 +0100
Message-ID: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
References: <20101107194547.GA12521@basil.fritz.box>
	<4CD71C8B.1050604@redhat.com>
	<20101107230508.GB17592@basil.fritz.box>
	<20101108145809.GD29714@redhat.com>
	<1289238930-sup-9765@think>
	<20101114205925.GA20451@redhat.com>
	<AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
	<4CE05A9E.9090204@redhat.com>
	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
	<AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101201165229.GC13415@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 5:52 PM, Mike Snitzer <snitzer@redhat.com> wrote=
:
> On Wed, Dec 01 2010 at 11:05am -0500,
> Matt <jackdachef@gmail.com> wrote:
>
>> On Mon, Nov 15, 2010 at 12:24 AM, Matt <jackdachef@gmail.com> wrote:
>> > On Sun, Nov 14, 2010 at 10:54 PM, Milan Broz <mbroz@redhat.com> wr=
ote:
>> >> On 11/14/2010 10:49 PM, Matt wrote:
>> >>> only with the dm-crypt scaling patch I could observe the data-co=
rruption
>> >>
>> >> even with v5 I sent on Friday?
>> >>
>> >> Are you sure that it is not related to some fs problem in 2.6.37-=
rc1?
>> >>
>> >> If it works on 2.6.36 without problems, it is probably problems s=
omewhere
>> >> else (flush/fua conversion was trivial here - DM is still doing f=
ull flush
>> >> and there are no other changes in code IMHO.)
>> >>
>> >> Milan
>> >>
>> >
>> > Hi Milan,
>> >
>> > I'm aware of your new v5 patch (which should include several
>> > improvements (or potential fixes in my case) over the v3 patch)
>> >
>> > as I already wrote my schedule unfortunately currently doesn't all=
ow
>> > me to test it
>> >
>> > * in the case of no corruption it would be nice to have 2.6.37-rc*=
 running :)
>> >
>> > * in the case of data corruption that would mean restoring my syst=
em -
>> > since it's my production box and right now I don't have a fallback=
 at
>> > reach
>> > at earliest I could give it a shot at the beginning of December. T=
hen
>> > I could also test reiserfs and ext4 as a system partition to rule =
out
>> > that it's
>> > a ext4-specific thing (currently I'm running reiserfs on my system=
-partition).
>> >
>> > Thanks !
>> >
>> > Matt
>> >
>>
>>
>> OK guys,
>>
>> I've updated my system to latest glibc 2.12.1-r3 (on gentoo) and gcc
>> hardened 4.5.1-r1 with 1.4 patchset which also uses pie (that one
>> should fix problems with graphite)
>>
>> not much system changes besides that,
>>
>> with those it worked fine with 2.6.36 and I couldn't observe any
>> filesystem corruption
>
> So dm-crypt cpu scalability v5 with 2.6.36 worked fine.
>
>> the bad news is: I'm again seeing corruption (!) [on ext4, on the /
>> (root) partition]:
>
> ...
>
>> =3D=3D=3D> so the No.1 trigger of this kind of corruption where file=
s are
>> empty, missing or the content gets corrupted (at least for me) is
>> compiling software which is part of the system (e.g. emerge -e
>> system);
>>
>> the system is Gentoo ~amd64; with binutils 2.20.51.0.12 (afaik this
>> one has changed from 2.20.51.0.10 to 2.20.51.0.12 from my last
>> report); gcc 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5) <--
>> works fine with 2.6.36 and 2.6.36.1
>>
>> I'm not sure whether benchmarks would have the same "impact"
>
> Seems this emerge is a good test if it reliably enduces the corruptio=
n.
>
>> the kernel currently running is 2.6.37-rc4 with the [PATCH v5] dm
>> crypt: scale to multiple CPUs
>>
>> besides that additional patchsets are applied (I apologize that it's
>> not only plain vanilla with the dm-crypt patch):
>> * Prevent kswapd dumping excessive amounts of memory in response to
>> high-order allocation
>> * ext4: coordinate data-only flush requests sent by fsync
>> * vmscan: protect executable page from inactive list scan
>> * writeback livelock fixes v2
>
> Have you actually experienced any of the issues the above patches are
> meant to address? =A0Seems you're applying patches guessing/hoping
> that they'll fix the dm-crypt corruption.
>
>> I originally had hoped that the mentioned patch in "ext4: coordinate
>> data-only flush requests sent by fsync", namely: "md: Call
>> blk_queue_flush() to establish flush/fua" and additional changes &
>> fixes to 2.6.37-rc4 would once and for all fix problems but it didn'=
t
>
> That md patch doesn't help DM at all. =A0And the ext4 coordination pa=
tch
> is completely bleeding and actually broken (especially as it relates =
to
> DM -- but that breakage is ony a concern for request-based DM,
> e.g. DM-mapth), anyway see:
> https://www.redhat.com/archives/dm-devel/2010-November/msg00185.html
>
> I'm not sure which patches you're using for the ext4 fsync changes bu=
t
> please don't use them at all. =A0It is purely an optimization for
> extremely heavy fsync workloads and is only getting in the way at thi=
s
> point.
>
>> I'm also using the the writeback livelock fixes and the dm-crypt sca=
le
>> to multiple CPUs with 2.6.36 so those generally work fine
>>
>> so it has be something that changed from 2.6.36->2.6.37 within
>> dm-crypt or other parts that gets stressed and breaks during usage o=
f
>> the "[PATCH v5] dm crypt: scale to multiple CPUs" patch
>>
>> the other included patches surely won't be the cause for that (100%)=
=2E
>>
>> Filesystem corruption only seems to occur on the / (root) where the
>> system resides -
>
> We need better fault isolation; you've introduced enough change that =
it
> isn't helping zero in on what your particular problem is. =A0Milan ha=
s
> tested he latest version of the dm-crypt cpu scalability patch quite =
a
> bit and hasn't seen any corruption -- but clearly the corruption you'=
re
> seeing is a real concern and we need to get to the bottom of it.
>
> I'd really appreciate it if you could just use Linus' latest linux-2.=
6
> tree plus Milan's latest patch (technically v6 even though it wasn't
> labeled as such): https://patchwork.kernel.org/patch/365542/
>
> Porting that same v6 patch to 2.6.36 would also be nice (to verify yo=
u
> still don't see any corruption there).
>
> Mike
>

Hi Mike,

those other patches were for other problems I was seeing: e.g.
interactivity/latency problems I was experiencing during heavy
flushing, etc. and some more - so I speculated that those would
improve it


OK, enough of that additional stuff which distracts from this issue -
I'll leave them out for now ...

Thanks for the info !

To console you: I was using v5 from Milan's patch up until now and I
haven't noticed any corruption with it in conjunction with 2.6.36

I modified it according to Milan's mail:

>On 11/15/2010 08:25 AM, Heinz Diehl wrote:
>> On 15.11.2010, Milan Broz wrote:
>
>> drivers/md/dm-crypt.c: In function crypt_ctr':
>> drivers/md/dm-crypt.c:1408: error: WQ_MEM_RECLAIM' undeclared (first=
 use in this function)
>> drivers/md/dm-crypt.c:1408: error: (Each undeclared identifier is re=
ported only once
>> drivers/md/dm-crypt.c:1408: error: for each function it appears in.)

>It should be enough to just replace WQ_MEM_RECLAIM to WQ_RESCUER for 2=
=2E6.36.
>(that define is new in 2.6.37)

>Milan

http://www.redhat.com/archives/dm-devel/2010-November/msg00099.html

and that worked fine

Thanks for pointing to v6 ! I hadn't noticed that there was a new one :=
)

Well, so I'll restore my box to a working/productive state and will
try out v6 (I'm pretty confident that it'll work without problems).

After that I'll see what info Tejun and the others need when the next
corruption might occur with vanilla 2.6.37-rc* and v6 so that there's
something to investigate

Thanks & Regards

Matt

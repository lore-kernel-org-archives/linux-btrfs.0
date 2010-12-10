From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Fri, 10 Dec 2010 00:52:01 -0600
Message-ID: <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V__6438.96322367272$1291963965$gmane$org@mail.gmail.com>
References: <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org> <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
 <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com> <20101210023852.GB3059@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101210023852.GB3059@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 9, 2010 at 8:38 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 10, 2010 at 02:53:30AM +0100, Matt wrote:
>>
>> Try a kernel before 5a87b7a5da250c9be6d757758425dfeaf8ed3179
>>
>> from the tests I've done that one showed the least or no corruption =
if
>> you count the empty /etc/env.d/03opengl as an artefact
>
> Yes, that's a good test. =C2=A0Also try commit bd2d0210cf. =C2=A0The =
patch
> series that is most likely to be at fault if there is a regression in
> between 5a87b7a5d and bd2d0210cf inclusive.
>
> I did a lot of testing before submitting it, but that wa a tricky
> rewrite. =C2=A0If you can reproduce the problem reliably, it might be=
 good
> to try commit 16828088f9 (the commit before 5a87b7a5d) and commit
> bd2d0210cf. =C2=A0If it reliably reproduces on bd2d0210cf, but is cle=
an on
> 16828088f9, then it's my ext4 block i/o submission patches, and we'll
> need to either figure out what's going on or back out that set of
> changes.
>
> If that's the case, a bisect of those changes (it's only 6 commits, s=
o
> it shouldn't take long) would be most appreciated.

I observed the behavior on bd2d0210cf in a qemu-kvm install of
openSUSE 11.3 (x86_64) on *totally* different host - an AMD quad-core.

I did /not/ observe the behavior on 16828088f9 (yet). I'll run the
test a few more times on 1682..

Additionally, I am building a bisected kernel now (
cb20d5188366f04d96d2e07b1240cc92170ade40 ), but won't be able to get
back at it for a while.

I hope this helps.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

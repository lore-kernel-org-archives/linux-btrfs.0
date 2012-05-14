From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Mon, 14 May 2012 08:38:22 +0000 (UTC)
Message-ID: <pan.2012.05.14.08.38.20@cox.net>
References: <4FAAE94D.4010103@pocock.com.au>
	<pan.2012.05.11.02.18.22@cox.net> <201205111858.05972.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Fri, 11 May 2012 18:58:05 +0200 as excerpt=
ed:

Martin Steigerwald posted on Fri, 11 May 2012 18:58:05 +0200 as excerpt=
ed:

> Am Freitag, 11. Mai 2012 schrieb Duncan:
>> Daniel Pocock posted on Wed, 09 May 2012 22:01:49 +0000 as excerpted=
:
>> > There is various information about - enterprise-class drives

>> This isn't a direct answer to that, but expressing a bit of concern
>> over  the implications of your question, that you're planning on usi=
ng
>> btrfs in an enterprise class installation.

>> [In] mainline Linux kernel terms, btrfs remains very much an
>> experimental filesystem

>> On an experimental filesystem under as intense continued development=
 as
>> btrfs, by contrast, it's best to consider your btrfs copy an extra
>> "throwaway" copy only intended for testing.  You still have your
>> primary copy, along with all the usual backups, on something less
>> experimental, since you never know when/where/ how your btrfs testin=
g
>> will screw up its copy.
>=20
> Duncan, did you actually test BTRFS? Theory can=C2=B4t replace real l=
ife
> experience.

I /had/ been waiting until the n-way-mirrored-raid1 roadmapped for afte=
r
raid5/6 mode (which should hit 3.5, I believe), but hardware issues
intervened and I'm no longer using those older 4-way md/raid drives as
primary.

And now that I have it, present personal experience does not contradict
what I posted.  btrfs does indeed work reasonably well under reasonably
good, non-stressful, conditions.  But my experience so far aligns quite
well with the "consider the btrfs copy a throw-away copy, just in case"
recommendation.  Just because it's a throw-away copy doesn't mean you'l=
l
have to have to resort to the "good" copy elsewhere, but it DOES hopefu=
lly
mean that you'll have both a "good" copy elsewhere, and a backup for th=
at
supposedly good copy, just in case btrfs does go bad,
and that supposedly good primary copy, ends up not being good after all=
=2E

> From all of my personal BTRFS installations not one has gone corrupt =
-
> and I have at least four, while more of them are in use at my employe=
r.
> Except maybe a scratch data BRTFS RAID 0 over lots of SATA disks. But
> maybe it would have been fixable by btrfs-zero-log which I didn=C2=B4=
t know
> of back then. Another one needed a btrfs-zero-log, but that was quite
> some time ago.
>=20
> Some of the installations are in use for more than a year AFAIR.
>=20
> While I would still be reluctant with deploying BTRFS for a customer =
for
> critical data

This was actually my point in this thread.  If someone's asking questio=
ns
about enterprise quality hardware, they're not likely to run into some =
of
the bugs I've been having recently that have been exposed by hardware
issues.  However, they're also far more likely to be considering btrfs =
for
a row-of-nines uptime application, which is, after all, where some of
btrfs' features are normally found.  Regardless of whether btrfs is pas=
t
the "throw away data experimental class" stage or not, I think we both
agree it isn't ready for row-of-nines-uptime applications just yet.  If
he's just testing btrfs on such equipment for possible future
row-of-nines-uptime deployment a year or possibly two out, great.  If h=
e's
looking at such a deployment two-months-out, no way, and it looks like =
you
agree.

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

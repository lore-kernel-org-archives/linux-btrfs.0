Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36795 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756558AbcIOBF5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 21:05:57 -0400
Received: by mail-it0-f44.google.com with SMTP id o3so72334394ita.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 18:05:55 -0700 (PDT)
Date: Wed, 14 Sep 2016 21:05:52 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160915010552.GC32452@DigitalMercury.dynalias.net>
References: <57D51BF9.2010907@online.no>
 <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba>
 <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no>
 <20160911130221.GE7138@carfax.org.uk>
 <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
In-Reply-To: <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 12, 2016 at 08:20:20AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-11 09:02, Hugo Mills wrote:
> >On Sun, Sep 11, 2016 at 02:39:14PM +0200, Waxhead wrote:
> >>Martin Steigerwald wrote:
> >>>Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwa=
ld:
> >>>>>>Thing is: This just seems to be when has a feature been implemented
> >>>>>>matrix.
> >>>>>>Not when it is considered to be stable. I think this could be done =
with
> >>>>>>colors or so. Like red for not supported, yellow for implemented and
> >>>>>>green for production ready.
> >>>>>Exactly, just like the Nouveau matrix. It clearly shows what you can
> >>>>>expect from it.
> >>>I mentioned this matrix as a good *starting* point. And I think it wou=
ld be
> >>>easy to extent it:
> >>>
> >>>Just add another column called "Production ready". Then research / ask=
 about
> >>>production stability of each feature. The only challenge is: Who is
> >>>authoritative on that? I=C2=B4d certainly ask the developer of a featu=
re, but I=C2=B4d
> >>>also consider user reports to some extent.
> >>>
> >>>Maybe thats the real challenge.
> >>>
> >>>If you wish, I=C2=B4d go through each feature there and give my own es=
timation. But
> >>>I think there are others who are deeper into this.
> >>That is exactly the same reason I don't edit the wiki myself. I
> >>could of course get it started and hopefully someone will correct
> >>what I write, but I feel that if I start this off I don't have deep
> >>enough knowledge to do a proper start. Perhaps I will change my mind
> >>about this.
> >
> >   Given that nobody else has done it yet, what are the odds that
> >someone else will step up to do it now? I would say that you should at
> >least try. Yes, you don't have as much knowledge as some others, but
> >if you keep working at it, you'll gain that knowledge. Yes, you'll
> >probably get it wrong to start with, but you probably won't get it
> >*very* wrong. You'll probably get it horribly wrong at some point, but
> >even the more knowledgable people you're deferring to didn't identify
> >the problems with parity RAID until Zygo and Austin and Chris (and
> >others) put in the work to pin down the exact issues.
> FWIW, here's a list of what I personally consider stable (as in, I'm will=
ing
> to bet against reduced uptime to use this stuff on production systems at
> work and personal systems at home):
> 1. Single device mode, including DUP data profiles on single device witho=
ut
> mixed-bg.
> 2. Multi-device raid0, raid1, and raid10 profiles with symmetrical devices
> (all devices are the same size).
> 3. Multi-device single profiles with asymmetrical devices.
> 4. Small numbers (max double digit) of snapshots, taken at infrequent
> intervals (no more than once an hour).  I use single snapshots regularly =
to
> get stable images of the filesystem for backups, and I keep hourly ones of
> my home directory for about 48 hours.
> 5. Subvolumes used to isolate parts of a filesystem from snapshots.  I use
> this regularly to isolate areas of my filesystems from backups.
> 6. Non-incremental send/receive (no clone source, no parent's, no
> deduplication).  I use this regularly for cloning virtual machines.
> 7. Checksumming and scrubs using any of the profiles I've listed above.
> 8. Defragmentation, including autodefrag.
> 9. All of the compat_features, including no-holes and skinny-metadata.
>=20
> Things I consider stable enough that I'm willing to use them on my person=
al
> systems but not systems at work:
> 1. In-line data compression with compress=3Dlzo.  I use this on my laptop=
 and
> home server system.  I've never had any issues with it myself, but I know
> that other people have, and it does seem to make other things more likely=
 to
> have issues.
> 2. Batch deduplication.  I only use this on the back-end filesystems for =
my
> personal storage cluster, and only because I have multiple copies as a
> result of GlusterFS on top of BTRFS.  I've not had any significant issues
> with it, and I don't remember any reports of data loss resulting from it,
> but it's something that people should not be using if they don't understa=
nd
> all the implications.
>=20
> Things that I don't consider stable but some people do:
> 1. Quotas and qgroups.  Some people (such as SUSE) consider these to be
> stable.  There are a couple of known issues with them still however (such=
 as
> returning the wrong errno when a quota is hit (should be returning -EDQUO=
T,
> instead returns -ENOSPC)).
> 2. RAID5/6.  There are a few people who use this, but it's generally agre=
ed
> to be unstable.  There are still at least 3 known bugs which can cause
> complete loss of a filesystem, and there's also a known issue with rebuil=
ds
> taking insanely long, which puts data at risk as well.
> 3. Multi device filesystems with asymmetrical devices running raid0, raid=
1,
> or raid10.  The issue I have here is that it's much easier to hit errors
> regarding free space than a reliable system should be.  It's possible to
> avoid with careful planning (for example, a 3 disk raid1 profile with 1 d=
isk
> exactly twice the size of the other two will work fine, albeit with more
> load on the larger disk).
>=20
=2E..
> As far as documentation though, we [BTRFS] really do need to get our act
> together.  It really doesn't look good to have most of the best
> documentation be in the distro's wikis instead of ours.  I'm not trying to
> say the distros shouldn't be documenting BTRFS, but the point at which
> Debian (for example) has better documentation of the upstream version of
> BTRFS than the upstream project itself does, that starts to look bad.

I would have loved to have this feature-to-stability list when I
started working on the Debian documentation!  I started it because I
was saddened by number of horror story "adventures with btrfs"
articles and posts I had read about, combined with the perspective of
certain members within the Debian community that it was a toy fs.

Are my contributions to that wiki of a high enough quality that I
can work on the upstream one?  Do you think the broader btrfs
community is interested in citations and curated links to discussions?

eg: if a company wants to use btrfs, they check the status page, see a
feature they want is still in the yellow zone of stabilisation, and
then follow the links to familiarise themselves with past discussions.
I imagine this would also help individuals or grad students more
quickly familiarise themselves with the available literature before
choosing a specific project.  If regular updates from SUSE, STRATO,
Facebook, and Fujitsu are also publicly available the k.org wiki would
be a wonderful place to syndicate them!

Sincerely,
Nicholas

> >
> >   So, go for it. You have a lot to offer the community.
> >
> >   Hugo.
> >
> >>>I do think for example that scrubbing and auto raid repair are stable,=
 except
> >>>for RAID 5/6. Also device statistics and RAID 0 and 1 I consider to be=
 stable.
> >>>I think RAID 10 is also stable, but as I do not run it, I don=C2=B4t k=
now. For me
> >>>also skinny-metadata is stable. For me so far even compress=3Dlzo seem=
s to be
> >>>stable, but well for others it may not.
> >>>
> >>>Since what kernel version? Now, there you go. I have no idea. All I kn=
ow I
> >>>started BTRFS with Kernel 2.6.38 or 2.6.39 on my laptop, but not as RA=
ID 1 at
> >>>that time.
> >>>
> >>>See, the implementation time of a feature is much easier to assess. Ma=
ybe
> >>>thats part of the reason why there is not stability matrix: Maybe no o=
ne
> >>>*exactly* knows *for sure*. How could you? So I would even put a footn=
ote on
> >>>that "production ready" row explaining "Considered to be stable by dev=
eloper
> >>>and user oppinions".
> >>>
> >>>Of course additionally it would be good to read about experiences of c=
orporate
> >>>usage of BTRFS. I know at least Fujitsu, SUSE, Facebook, Oracle are us=
ing it.
> >>>But I don=C2=B4t know in what configurations and with what experiences=
=2E One Oracle
> >>>developer invests a lot of time to bring BTRFS like features to XFS an=
d RedHat
> >>>still favors XFS over BTRFS, even SLES defaults to XFS for /home and o=
ther non
> >>>/-filesystems. That also tells a story.
> >>>
> >>>Some ideas you can get from SUSE releasenotes. Even if you do not want=
 to use
> >>>it, it tells something and I bet is one of the better sources of infor=
mation
> >>>regarding your question you can get at this time. Cause I believe SUSE
> >>>developers invested some time to assess the stability of features. Cau=
se they
> >>>would carefully assess what they can support in enterprise environment=
s. There
> >>>is also someone from Fujitsu who shared experiences in a talk, I can s=
earch
> >>>the URL to the slides again.
> >>By all means, SUSE's wiki is very valuable. I just said that I
> >>*prefer* to have that stuff on the BTRFS wiki and feel that is the
> >>right place for it.
> >>>
> >>>I bet Chris Mason and other BTRFS developers at Facebook have some ide=
a on
> >>>what they use within Facebook as well. To what extent they are allowed=
 to talk
> >>>about it=E2=80=A6 I don=C2=B4t know. My personal impression is that as=
 soon as Chris went
> >>>to Facebook he became quite quiet. Maybe just due to being busy. Maybe=
 due to
> >>>Facebook being concerned much more about the privacy of itself than of=
 its
> >>>users.
> >>>
> >>>Thanks,
> >>
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJX2fPwAAoJEFqIMEdffRBhO2QP/jzQNJrwKBbQrV/UcQJrePr0
cg6H7dOnJ/XsiHGlNogtIrE4aMyMKf6oMn/H1I17c2Hna2pVZK2HuWinfZCjvqRE
ySJT38nCR+5RGQoBvkH8yaMC4fiejSpGxOsOrsXs8XgzASJ00RKCYOitBejj7sTE
VeEgqOO51R0TPdIRRmzd5OdRmDIau053hFPriQiG1rer0yA9wT4E396Yyepl0evA
4zdCM5RLYJfLGDmb3V2GPWuYNs8qmLOkfZtBIr/RjQiKkZSy0ZcKZppoA90aScDL
INZMdf5fOYpeMDz3XELyICDMenRjsrbtiPqz/DhiVXG6214Jc221kPVoYZvMhFau
3/NSRjHVA8wy4PvGHZhtVq3jS2AidZQTZo4udEcWv3jadJMSWYUk775Ts3yYyhje
rZyuAH81R1IfPjs10Ib1jJ+8ICJzUDOUuxZ4Oeu2WY0twfCFELQOrsBa62akP+gP
tIOABUUY2bn0E4jAVUKfOO2ce4n6z+xUriUgU78IgwwKmZK8ouqL25CjpqaYs21j
fsYkcFgavd5RPLOMFQHkXDW/GEynB7/KclOct0gS2kPx3W+L4oK0Dc0A9oO+fjBL
kekXhsEm98B/miiEoWeSZD79ixK8zkrKmawhoZOml/zYL1dby3lIR1drg8m2o5jJ
q9hhB/n8/CO3J8JpOtWV
=ggeY
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--

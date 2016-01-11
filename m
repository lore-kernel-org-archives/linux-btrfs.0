Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59303 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbcAKXH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 18:07:28 -0500
Date: Mon, 11 Jan 2016 23:07:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160111230727.GF422@carfax.org.uk>
References: <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk>
 <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
 <20160111221056.GD422@carfax.org.uk>
 <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
 <20160111223017.GE422@carfax.org.uk>
 <CAJCQCtQBUFkPc_Tqfx5HCbVvNEhBbGhxRzHAZ+j75e1f74NUjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
In-Reply-To: <CAJCQCtQBUFkPc_Tqfx5HCbVvNEhBbGhxRzHAZ+j75e1f74NUjg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 11, 2016 at 03:39:43PM -0700, Chris Murphy wrote:
> On Mon, Jan 11, 2016 at 3:30 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Mon, Jan 11, 2016 at 03:20:36PM -0700, Chris Murphy wrote:
> >> On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
> >> >> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> >> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
> >> >> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> >> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> >> >> >> >> OK. How do we track down that bug and get it fixed?
> >> >> >> >
> >> >> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
> >> >> >> >
> >> >> >> >    It's been around for a number of years. None of the devs has, I
> >> >> >> > think, had the time to look at it. When Josef was still (publicly)
> >> >> >> > active, he had it second on his list of bugs to look at for many
> >> >> >> > months -- but it always got trumped by some new bug that could cause
> >> >> >> > data loss.
> >> >> >>
> >> >> >>
> >> >> >> Interesting. I did not know of this bug. It's pretty rare.
> >> >> >
> >> >> >    Not really. It shows up maybe on average once a week on IRC. It
> >> >> > gets reported much less on the mailing list.
> >> >>
> >> >> Is there a pattern? Does it only happen at a 2TiB threshold?
> >> >
> >> >    No, and no.
> >> >
> >> >    There is, as far as I can tell from some years of seeing reports of
> >> > this bug, no correlation with RAID level, hardware, OS, kernel
> >> > version, FS size, usage of the FS at failure, or allocation level of
> >> > either data or metadata at failure.
> >> >
> >> >    I haven't tried correlating with the phase of the moon or the
> >> > losses on Lloyds Register yet.
> >>
> >> Huh. So it's goofy cakes.
> >>
> >> This is specifically where btrfs_free_extent produces errno -28 no
> >> space left, and then the fs goes read-only?
> >
> >    The symptoms I'm using for a diagnosis of this bug are that the FS
> > runs out of (usually data) space when there's still unallocated space
> > remaining that it could use for another block group.
> >
> >    Forced RO isn't usually a symptom, although the FS can get into a
> > state where you can't modify it (as distinct from being explicitly
> > read-only).
> >
> >    Block-group level operations, like balance, device delete, device
> > add sometimes seem to have some kind of (usually small) effect on the
> > point at which the error occurs. If you hit the problem and run a
> > balance, you might end up making things worse by a couple of
> > gigabytes, or making things better by the same amount, or having no
> > effect at all.
> 
> Are there any compile time options not normally set that would help find it?
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> # CONFIG_BTRFS_ASSERT is not set
> 
> Once it starts to happen, it sounds like it's straightforward to
> reproduce in a short amount of time. I'm kinda surprised I've never
> run into this.

   It does sometimes have a repeating nature: I'm reasonably sure
we've seen a few people get it repeatedly on different filesystems.
This might point at a particular workload needed to trigger it. (Or
just bad luck / statistical likelihood). Some people have never hit
it.

   There is (or at least, was) an ENOSPC debugging option. I think
that's a mount option. That's probably the most useful one, but the
range of usefulness of existing debug output may be very small. :)

   (Sorry for the vague nature of this reply -- it's been a very long
day).

   Hugo.

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWlDWvAAoJEFheFHXiqx3k33YP/iZ7ewLKCtgn/P/TlTps+U+i
NxMuFRyCPIY/ANgDRgVsC0trHUqziTUVEHCOggQQhF/UgH4+NSXBY7EWFYUu2uzU
gXuIIB4TfykUQT6xc5+1ainL2TVB7bk01HFZXUFfIhEUySlE+CKCJq2Jyc+T9riu
jqMvF2ApTZeOrbojEG4zuSnlTFTGGBa/eq3PITTy0DYItmXq27MbthjbT1HmW99T
TiY7W+gROZPOSUlfwbDS2B1EeFVy2O0TIpKmgsPIqJ9gr311sdcEIa5BhlHwz12A
BQdBDFZwNhXZnFetSPPW0PMk9t85oAzCWEf9Ex9OJl7KToZpFfQM+sLy4IdR38u5
o9cRbV4VGV9YxCvJV03JPQNlXOBTc54qmVXESrLErcXyPjQ4YXFZsw3MVhEk6M1q
H6BPvA+qIHRpLoErSvZs8By1ffjfOGC4v7Z1ewgoPwYt2AerLHeF306L4fGrrhn0
ZbHUOIWOyEIKLB4u10r1B7RXJFgFa1TbkH8us55QvFq9MAk27nuK7aiD7Qv3ILMb
6pDv6r0Q+5BQ+ycqJZAs1UWHx6/pWzvnNFx4GALvFFWdvFGcdiP9y6RJh2hoeMP5
PPcHjhJGcLYyLzQ83afBagc1tIcL1WHxL4e2CFRD95ivGcwqnfilQJgOImD1NNuG
eKaVooeIMX+0iVrIX83f
=PnVF
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--

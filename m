Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36188 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaEDScH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 14:32:07 -0400
Date: Sun, 4 May 2014 19:31:55 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org,
        Russell Coker <russell@coker.com.au>
Subject: Re: copies= option
Message-ID: <20140504183155.GK24298@carfax.org.uk>
References: <201405041216.54348.russell@coker.com.au>
 <pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
 <xjTK1n01B308YdQ01jTMAf>
 <20140504111238.197768d6@ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
In-Reply-To: <20140504111238.197768d6@ws>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 04, 2014 at 11:12:38AM -0700, Duncan wrote:
> On Sun, 04 May 2014 09:27:10 +0200
> Brendan Hide <brendan@swiftspirit.co.za> wrote:
> 
> > On 2014/05/04 05:27 AM, Duncan wrote:
> > > Russell Coker posted on Sun, 04 May 2014 12:16:54 +1000 as
> > > excerpted:
> > >
> > >> Are there any plans for a feature like the ZFS copies= option?
> > >>
> > >> I'd like to be able to set copies= separately for data and
> > >> metadata.  In most cases RAID-1 provides adequate data protection
> > >> but I'd like to have RAID-1 and copies=2 for metadata so that if
> > >> one disk dies and another has some bad sectors during recovery I'm
> > >> unlikely to lose metadata.
> > > Hugo's the guy with the better info on this one, but until he
> > > answers...
> > >
> > > The zfs license issues mean it's not an option for me and I'm thus
> > > not familiar with its options in any detail, but if I understand
> > > the question correctly, yes.
> > >
> > > And of course since btrfs treats data and metadata separately, it's
> > > extremely unlikely that any sort of copies= option wouldn't be
> > > separately configurable for each.
> > >
> > > There was a discussion of a very nice multi-way-configuration
> > > schema that I deliberately stayed out of as both a bit above my
> > > head and far enough in the future that I didn't want to get my
> > > hopes up too high about it yet.  I already want N-way-mirroring so
> > > bad I can taste it, and this was that and way more... if/when it
> > > ever actually gets coded and committed to the mainline kernel
> > > btrfs.  As I said, Hugo should have more on it, as he was active in
> > > that discussion as it seemed to line up perfectly with his area of
> > > interest.
> > >
> > The simple answer is yes, this is planned. As Duncan implied,
> > however, it is not on the immediate roadmap. Internally we appear to
> > be referring to this feature as "N-way redundancy" or "N-way
> > mirroring".
> > 
> > My understanding is that the biggest hurdle before the primary devs
> > will look into N-way redundancy is to finish the Raid5/6
> > implementation to include self-healing/scrubbing support - a critical
> > issue before it can be adopted further.
> 
> Well, there's N-way-mirroring, which /is/ on the roadmap for fairly
> soon (after raid56 completion), and which is the feature I've been
> heavily anticipating ever since I first looked into btrfs and realized
> that raid1 didn't include it already, but what I was referring to above
> was something much nicer than that.
> 
> As I said I don't understand the full details, Hugo's the one that can
> properly answer there, but the general idea (I think) is the ability to
> three-way specify N-copies, M-parity, S-stripe, possibly with
> near/far-layout specification like md/raid's raid10, as well.  But Hugo
> refers to it with three different letters, cps copies/parity/stripes,
> perhaps?  That doesn't look quite correct...

   My proposal was simply a description mechanism, not an
implementation. The description is N-copies, M-device-stripe,
P-parity-devices (NcMsPp), and (more or less comfortably) covers at
minimum all of the current and currently-proposed replication levels.
There's a couple of tweaks covering description of allocation rules
(DUP vs RAID-1).

   I think, as you say below, that it's going to be hard to make this
completely general in terms of application, but we've already seen
code that extends the available replication capabilities beyond the
current terminology (to RAID-6.3, ... -6.6), which we can cope with in
the proposed nomenclature -- NsP3 to NsP6. There are other things in
the pipeline, such as the N-way mirroring, which also aren't
describable in traditional RAID terms, but which the "csp" notation
will handle nicely.

   It doesn't deal with complex nested configurations (e.g. the
difference between RAID-10 and RAID-0+1), but given btrfs's more
freewheeling chunk allocation decisions, those distinctions tend to go
away.

   So: don't expect to see completely general usability of csp
notation, but do expect it to be used in the future to describe the
increasing complexity of replication strategies in btrfs. There may
even be a shift internally to csp-style description of replication;
I'd probably expect that to arrive with per-object RAID levels, since
if there's going to be a big overhaul of that area, it would make
sense to do that change at the same time.

   [It's worth noting that when I mooted extending the current
RAID-level bit-field to pack in csp-style notation, Chris was mildly
horrified at the concept. The next best implementation would be to use
the xattrs for per-object RAID for this.]

   Hugo.

> But that at least has the potential to be /so/ nice, and possibly
> also /so/ complicated, that I'm deliberately avoiding looking too much
> at the details as it's far enough out and may in fact never get fully
> implemented that I don't want to spoil my enjoyment of
> (relatively, compared to that) simple N-way-mirroring when it comes.
> 
> And more particularly, I really /really/ hope they don't put off a
> reasonably simple and (hopefully) fast implementation of
> N-way-mirroring as soon as possible after raid56 completion, because I
> really /really/ want N-way-mirroring, and this other thing would
> certainly be extremely nice, but I'm quite fearful that it could also be
> the perfect being the enemy of the good-enough, and btrfs already has a
> long history of features repeatedly taking far longer to implement than
> originally predicted, which with something that potentially complex,
> I'm very afraid could mean a 2-5 year wait before it's actually usable.
> 
> And given how long I've been waiting for the simple-compared-to-that
> N-way-mirroring thing and how much I anticipate it, I just don't know
> what I'd do if I were to find out that they were going to work on this
> "perfect" thing instead, with N-way-mirroring being one possible option
> with it, but that as a result, given the btrfs history to date, it'd
> very likely be a good five years before I could get the comparatively
> simple N-way-mirroring (or even, for me, just a specific
> 3-way-mirroring to compliment the specific 2-way-mirroring that's
> already there) that's all I'm really asking for.
> 
> So I guess you can see why I don't want to get into the details of the
> more fancy solution too much, both as a means of protecting my own
> sanity, and to hopefully avoid throwing the 3-way-mirroring that's my
> own personal focal point off the track.  So Hugo's the one with the
> details, to the extent they've been discussed at least, there.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2aHm1heFHXiqx3kAQKbDw/+PT5QlPcEeYhFvmRvv1pWseyg2k43Y2rM
83Xk05YolVVkuVe00DuHPwWsjoBffQQfeXIbCj0hYndSx3i6tRElgyj6zY/xmX7W
nXMi5K+EsGpSBNDVjP/IX5moqbPiDq0dNvS2pA+reiPwgdy293F88hYt/6Spubvq
owqBMwZvmSNG44jiGzkZ9xmSZs+Y3h++isuIqp3kwMCQdvbyXejEcYWECz/am0Fj
v3XDXoUOBluMlzbskMs6+aIA686xHyVz3+6esxnGgFAi3B0HGNPvxhH/2E1ZYqIU
/DVX9p1JyG1fgd7zRVAN53BQI787w2Ri/yBVBdPklR3Rvl/erdGHRYYGQes9jOBx
hZ+c8BfnLkNuZaslTfdmIj98QP5o6X6zTVRAhOPcZl9y/EFLkrXZS20TAxW/3iw4
1j8g08RSIdtXgKUyhROgQqa+5Dize5sKy/8mwhK7Oq/3ZFX7cmGzVyIUK3oIHQ/Y
Libdd8RGEk9C+Ja80v7jMzbxfAAav5EbObani0vVqcMpUTecoAZTZRKbgx+8gY7J
XhOZ2lkPBTtT8XFjMWhPx9iO4ezBjLleN3qE04deeYaeywxNJdXX4/6iHGypIIaX
1ifid7cnlFLc/0kuIgmnKt3ugsSoop+HHCOR7s3c35B5iswygA+QZw3HvJ6M5iuX
wttZ4nfRp6c=
=lG4j
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--

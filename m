Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49160 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbbIHU2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:28:43 -0400
Date: Tue, 8 Sep 2015 20:28:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ian Kumlien <ian.kumlien@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs tools] ability to fail a device...
Message-ID: <20150908202839.GO23944@carfax.org.uk>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk>
 <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
 <CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
 <CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com>
 <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
 <CAA85sZueV2NuTeUdvWjEJKc8L1u6h7Tbdne0vPtd75zxshPBgw@mail.gmail.com>
 <CAJCQCtSz7YAEyTGtga73Ze29qtsgDCHLsrsWtqP_-r4YwhxhEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="THYEXwetZJOK3OLY"
In-Reply-To: <CAJCQCtSz7YAEyTGtga73Ze29qtsgDCHLsrsWtqP_-r4YwhxhEA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--THYEXwetZJOK3OLY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 08, 2015 at 02:17:55PM -0600, Chris Murphy wrote:
> On Tue, Sep 8, 2015 at 2:13 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > On 8 September 2015 at 22:08, Chris Murphy <lists@colorremedies.com> wrote:
> >> On Tue, Sep 8, 2015 at 2:00 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> >
> > [--8<--]
> >
> >>> Someone thought they were done too early, only one disk => read only
> >>> mount. But, readonly mount => no balance.
> >>>
> >>> I think something is wrong....
> >>>
> >>> btrfs balance start -dconvert=single -mconvert=single /mnt/disk/
> >>> ERROR: error during balancing '/mnt/disk/' - Read-only file system
> >>>
> >>> btrfs dev delete missing /mnt/disk/
> >>> ERROR: error removing the device 'missing' - Read-only file system
> >>>
> >>> Any mount without ro becomes:
> >>> [  507.236652] BTRFS info (device sda2): allowing degraded mounts
> >>> [  507.236655] BTRFS info (device sda2): disk space caching is enabled
> >>> [  507.325365] BTRFS: bdev (null) errs: wr 2036894, rd 2031380, flush
> >>> 705, corrupt 0, gen 0
> >>> [  510.983321] BTRFS: too many missing devices, writeable mount is not allowed
> >>> [  511.006241] BTRFS: open_ctree failed
> >>>
> >>> And one of them has to give! ;)
> >>
> >>
> >> You've run into this:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=92641
> >
> > Ah, I thought it might not be known - I'm currently copying the files
> > since a read only mount is "good enough" for that
> >
> > -o degraded should allow readwrite *IF* the data can be written to....
> > My question is also, would this keep me from "adding devices"?
> > I mean, it did seem like a catch 22 earlier, but that would really
> > make a mess of things...
> 
> It is not possible to add a device to an ro filesystem, so effectively
> the fs read-writeability is broken in this case.

   I thought this particular issue had already been dealt with in 4.2?
(i.e. you can still mount an FS RW if it's degraded, but there are
still some single chunks on it).

   Ian: If you can still mount the FS read/write with both devices in
it, then it might be worth trying to balance away the problematic
single chunks with:

btrfs bal start -dprofiles=single -mprofiles=single /mountpoint

   Then unmount, pull the dead drive, and remount -odegraded.

   Hugo.

-- 
Hugo Mills             | The early bird gets the worm, but the second mouse
hugo@... carfax.org.uk | gets the cheese.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--THYEXwetZJOK3OLY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV70T3AAoJEFheFHXiqx3km0UP/AvbzWaDOD2oGBbUczVIuASF
rrsaur6SZHuvhJ/Cb+8dN4MwgFWPavypwXinKqhtDaiorTwpAn2wyr7C2eiqxqiw
w9ILOToIALEh5ZOWm8XPG625djfyu6gE7dPAuxiiLbE9f9EzdxR+RPb/+IZedhiQ
uOZWUmSKiaK2Nu1YbDJj0sH2oESP16ScM/FZluImbdIw0XjcomutMSKugqV6kfIK
t8mmquFKoRSe/WsNDwaJMFV+ad/rVHQfBrWSzf1qdOkvmfTkGxSOFje+19n3C/pE
nG0A34AT4ngevH7vJXEyt04B5BUZUG3617K6cYKeh6ac8dtJd4DsJemiuNhgIFCX
UNqnOopO6CYOwt8EzC+5qFTyTvHnpwWPPzYpfN03GlX0ZaTcamX0dm4CS2JFSn9O
QOmrtXgbiqI9Scr3CZvVhk53R3Knv+AIGUgd1KMmh40wfXkR5lwLJKv4Fqrc8uA0
fyAs7GtOBwfzOmC1AIoA5BUUx99vrPl0W7X2K5X/bOE1cpR/rGOm6vMNn+rGKvLI
4pL0/aTEeZK05/ynkBCYRCplNUI9rqN2J/mP5rwrMOHyprWSf9VMEEwRhGj5VoWr
dJj+JCQLpzLXPvZVBhgVWXUMC9WfVGLN9yX7jGevRQwawZNMlnu1UC0aWnZmXilA
fwv6+dWoCS/lMjcrlCW7
=HCpP
-----END PGP SIGNATURE-----

--THYEXwetZJOK3OLY--

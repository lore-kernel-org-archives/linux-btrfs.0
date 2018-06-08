Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45966 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752443AbeFHDYI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 23:24:08 -0400
Date: Thu, 7 Jun 2018 23:23:59 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Brad Templeton <bradtem@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 refuses to balance large drive
Message-ID: <20180608032359.GA19315@hungrycats.org>
References: <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
 <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
 <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
 <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
In-Reply-To: <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 26, 2018 at 06:27:57PM -0700, Brad Templeton wrote:
> A few years ago, I encountered an issue (halfway between a bug and a
> problem) with attempting to grow a BTRFS 3 disk Raid 1 which was
> fairly full.   The problem was that after replacing (by add/delete) a
> small drive with a larger one, there were now 2 full drives and one
> new half-full one, and balance was not able to correct this situation
> to produce the desired result, which is 3 drives, each with a roughly
> even amount of free space.  It can't do it because the 2 smaller
> drives are full, and it doesn't realize it could just move one of the
> copies of a block off the smaller drive onto the larger drive to free
> space on the smaller drive, it wants to move them both, and there is
> nowhere to put them both.
>=20
> I'm about to do it again, taking my nearly full array which is 4TB,
> 4TB, 6TB and replacing one of the 4TB with an 8TB.  I don't want to
> repeat the very time consuming situation, so I wanted to find out if
> things were fixed now.   I am running Xenial (kernel 4.4.0) and could
> consider the upgrade to  bionic (4.15) though that adds a lot more to
> my plate before a long trip and I would prefer to avoid if I can.
>=20
> So what is the best strategy:
>=20
> a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic" str=
ategy)
> b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks
> from 4TB but possibly not enough)
> c) Replace 6TB with 8TB, resize/balance, then replace 4TB with
> recently vacated 6TB -- much longer procedure but possibly better

d) Run "btrfs balance start -dlimit=3D3 /fs" to make some unallocated
space on all drives *before* adding disks.  Then replace, resize up,
and balance until unallocated space on all disks are equal.  There is
no need to continue balancing after that, so once that point is reached
you can cancel the balance.

A number of bad things can happen when unallocated space goes to zero,
and being unable to expand a raid1 array is only one of them.  Avoid that
situation even when not resizing the array, because some cases can be
very difficult to get out of.

Assuming your disk is not filled to the last gigabyte, you'll be able
to keep at least 1GB unallocated on every disk at all times.  Monitor
the amount of unallocated space and balance a few data block groups
(e.g. -dlimit=3D3) whenever unallocated space gets low.

A potential btrfs enhancement area:  allow the 'devid' parameter of
balance to specify two disks to balance block groups that contain chunks
on both disks.  We want to balance only those block groups that consist of
one chunk on each smaller drive.  This redistributes those block groups
to have one chunk on the large disk and one chunk on one of the smaller
disks, freeing space on the other small disk for the next block group.
Block groups that consist of a chunk on the big disk and one of the
small disks are already in the desired configuration, so rebalancing
them is just a waste of time.  Currently it's only possible to do this
by writing a script to select individual block groups with python-btrfs
or similar--much faster than plain btrfs balance for this case, but more
involved to set up.

> Or has this all been fixed and method A will work fine and get to the
> ideal goal -- 3 drives, with available space suitably distributed to
> allow full utilization over time?
>=20
> On Sat, May 26, 2018 at 6:24 PM, Brad Templeton <bradtem@gmail.com> wrote:
> > A few years ago, I encountered an issue (halfway between a bug and a
> > problem) with attempting to grow a BTRFS 3 disk Raid 1 which was fairly
> > full.   The problem was that after replacing (by add/delete) a small dr=
ive
> > with a larger one, there were now 2 full drives and one new half-full o=
ne,
> > and balance was not able to correct this situation to produce the desir=
ed
> > result, which is 3 drives, each with a roughly even amount of free spac=
e.
> > It can't do it because the 2 smaller drives are full, and it doesn't re=
alize
> > it could just move one of the copies of a block off the smaller drive o=
nto
> > the larger drive to free space on the smaller drive, it wants to move t=
hem
> > both, and there is nowhere to put them both.
> >
> > I'm about to do it again, taking my nearly full array which is 4TB, 4TB=
, 6TB
> > and replacing one of the 4TB with an 8TB.  I don't want to repeat the v=
ery
> > time consuming situation, so I wanted to find out if things were fixed =
now.
> > I am running Xenial (kernel 4.4.0) and could consider the upgrade to  b=
ionic
> > (4.15) though that adds a lot more to my plate before a long trip and I
> > would prefer to avoid if I can.
> >
> > So what is the best strategy:
> >
> > a) Replace 4TB with 8TB, resize up and balance?  (This is the "basic"
> > strategy)
> > b) Add 8TB, balance, remove 4TB (automatic distribution of some blocks =
=66rom
> > 4TB but possibly not enough)
> > c) Replace 6TB with 8TB, resize/balance, then replace 4TB with recently
> > vacated 6TB -- much longer procedure but possibly better
> >
> > Or has this all been fixed and method A will work fine and get to the i=
deal
> > goal -- 3 drives, with available space suitably distributed to allow fu=
ll
> > utilization over time?
> >
> > On Fri, Mar 25, 2016 at 7:35 AM, Henk Slager <eye1tm@gmail.com> wrote:
> >>
> >> On Fri, Mar 25, 2016 at 2:16 PM, Patrik Lundquist
> >> <patrik.lundquist@gmail.com> wrote:
> >> > On 23 March 2016 at 20:33, Chris Murphy <lists@colorremedies.com> wr=
ote:
> >> >>
> >> >> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com>
> >> >> wrote:
> >> >> >
> >> >> > I am surprised to hear it said that having the mixed sizes is an =
odd
> >> >> > case.
> >> >>
> >> >> Not odd as in wrong, just uncommon compared to other arrangements b=
eing
> >> >> tested.
> >> >
> >> > I think mixed drive sizes in raid1 is a killer feature for a home NA=
S,
> >> > where you replace an old smaller drive with the latest and largest
> >> > when you need more storage.
> >> >
> >> > My raid1 currently consists of 6TB+3TB+3*2TB.
> >>
> >> For the original OP situation, with chunks all filled op with extents
> >> and devices all filled up with chunks, 'integrating' a new 6TB drive
> >> in an 4TB+3TG+2TB raid1 array could probably be done in a bit unusual
> >> way in order to avoid immediate balancing needs:
> >> - 'plug-in' the 6TB
> >> - btrfs-replace  4TB by 6TB
> >> - btrfs fi resize max 6TB_devID
> >> - btrfs-replace  2TB by 4TB
> >> - btrfs fi resize max 4TB_devID
> >> - 'unplug' the 2TB
> >>
> >> So then there would be 2 devices with roughly 2TB space available, so
> >> good for continued btrfs raid1 writes.
> >>
> >> An offline variant with dd instead of btrfs-replace could also be done
> >> (I used to do that sometimes when btrfs-replace was not implemented).
> >> My experience is that btrfs-replace speed is roughly at max speed (so
> >> harddisk magnetic media transferspeed) during the whole replace
> >> process and it does in a more direct way what you actually want. So in
> >> total mostly way faster device replace/upgrade than with the
> >> add+delete method. And raid1 redundancy is active all the time. Of
> >> course it means first make sure the system runs up-to-date/latest
> >> kernel+tools.
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWxn2yQAKCRCB+YsaVrMb
nJoQAKCL7MQioac7Yr+HNNdya8T9oHUBYwCgoBr/2i0oQ1t60ymd6h5Qi2Lkacg=
=WM0L
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

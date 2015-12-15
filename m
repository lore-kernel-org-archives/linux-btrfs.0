Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36537 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbLOOmN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 09:42:13 -0500
Date: Tue, 15 Dec 2015 14:42:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Message-ID: <20151215144210.GH26782@carfax.org.uk>
References: <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net>
 <566EC2D7.3000101@gmail.com>
 <CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
 <56701B79.8030105@gmail.com>
 <20151215141813.GG26782@carfax.org.uk>
 <56702340.2090908@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
In-Reply-To: <56702340.2090908@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 15, 2015 at 09:27:12AM -0500, Austin S. Hemmelgarn wrote:
> On 2015-12-15 09:18, Hugo Mills wrote:
> >On Tue, Dec 15, 2015 at 08:54:01AM -0500, Austin S. Hemmelgarn wrote:
> >>On 2015-12-14 16:26, Chris Murphy wrote:
> >>>On Mon, Dec 14, 2015 at 6:23 AM, Austin S. Hemmelgarn
> >>><ahferroin7@gmail.com> wrote:
> >>>>
> >>>>Agreed, if yo9u can't substantiate _why_ it's bad practice, then you aren't
> >>>>making a valid argument.  The fact that there is software that doesn't
> >>>>handle it well would say to me based on established practice that that
> >>>>software is what's broken, not common practice.
> >>>
> >>>The automobile is invented and due to the ensuing chaos, common
> >>>practice of doing whatever the F you wanted came to an end in favor of
> >>>rules of the road and traffic lights. I'm sure some people went
> >>>ballistic, but for the most part things were much better without the
> >>>brokenness or prior common practice.
> >>Except for one thing:  Automobiles actually provide a measurable
> >>significant benefit to society.  What specific benefit does
> >>embedding the filesystem UUID in the metadata actually provide?
> >
> >    That one's easy to answer. It deals with a major issue that
> >reiserfs had: if you have a filesystem with another filesystem image
> >stored on it, reiserfsck could end up deciding that both the metadata
> >blocks of the main filesystem *and* the metadata blocks of the image
> >were part of the same FS (because they're on the same block device),
> >and so would splice both filesystems into one, generally complaining
> >loudly along the way that there was a lot of corruption present that
> >it was trying to fix.
> IIRC, that was because of the way the SB was designed, and is why
> other filesystems have a UUID in the superblock.
> 
> I probably should have been clearer with my statement, what I meant was:
> What specific benefit does using the UUID for multi-device
> filesystems to identify the various devices provide?

   Well, given a bunch of block devices, how do you identify which
ones to use for each of the (unknown number of) filesystems in the
system?

   You can either use some kind of config file, which is going to get
out of date as device enumeration orders change or as devices are
added/deleted from the FS, or you can try to identify the devices that
belong together automatically in some way. btrfs uses the latter
option (with the former option kind of supported using the device=
mount option). The use of a UUID isn't fundamental to the latter
process, but anything that you replaced the UUID with would have the
same issues that we're seeing here -- make a duplicate of the device
at the block level, and you get additional devices that look like they
should be part of the FS.

   The question is not how you avoid duplicating the UUIDs, but how
you identify that there are duplicates present, and how you deal with
that issue once you've detected them. This is complicated by the fact
that it's perfectly legitimate to have two block devices in the system
that identify themselves as the same device for the same filesystem --
this happens when they're different views of the same underlying
storage through multipathing.

   I would suggest trying to migrate to a state where detecting more
than one device with the same UUID and devid is cause to prevent the
FS from mounting, unless there's also a "mount_duplicates_yes_i_
know_this_is_dangerous_and_i_know_what_im_doing" mount flag present,
for the multipathing people. That will break existing userspace
behaviour for the multipathing case, but the migration can probably be
managed. (e.g. NFS has successfully changed default behaviour for one
of its mount options in the last few(?) years).

   Hugo.

-- 
Hugo Mills             | I think that everything darkling says is actually a
hugo@... carfax.org.uk | joke. It's just that we haven't worked out most of
http://carfax.org.uk/  | them yet.
PGP: E2AB1DE4          |                                                Vashka

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWcCbCAAoJEFheFHXiqx3kk9gP/1xZ1lxkMG7pcYQdK9JV2X3j
zKeIzCKvdjc/LB/YDMA6Oh1c5lFZnBP+4cdGOS+yEcb+/BUr7Jf9qp3XxBEz0vob
/jO2VLpVu/joFl5/i2ULGm7kbBfo3/cinm3q5Evb22hqq3F7Ep9b7bFNV+14SCjp
tVOpwbBbvsYKOZC7+YJzF++CHYxCyXn/0mbDllKWODxKyUJICqs6BORXczN0ISFc
YmeviRuaTNDpF2uWk0k1dQHkEGZBmbwn07RZBruSkj464zBywvtVYoemz85PPYnK
JuF9L02uaZpxRnBhqVzGLoBRRw7uT/fyqq7hABMc7ia1wpKVZpqOoYba4tbHyUZe
JmEzpdHlphtndu8xf1WffkTwnzolBL6nukqSDOs6W86YdmhUbcygt6Q0XDA0C/wg
N3QQ+7351DAu6DFwJY4DMmY+IZWvgyXdWaAFJzoEmFQEta5bLbzmASOuA0rYYA6p
mjis/6q1UvQRIshaj6jC50MZO4nwSs7OJHIkbAK5+TBTy5v5mNIpv4LJxjNALmqR
wh7Qg2h4tHZB+1nOLZ8olXe6zORHlspebrkKnlRdpG7AgaBcuMTYIN8jAY72mnal
yOY72Msvf1B0e/ktAF7TCnxhfSXBrfLO/nW/cTOOrD+8avH0yF2uickYhOWRgeRm
mDO8e9c9ffYNBoHW3D64
=4xzl
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--

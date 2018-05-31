Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60955 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbeEaG6S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 02:58:18 -0400
Subject: Re: btrfs device replace can cause silent or noisy corruption on
 compressed NOCOW/NODATASUM
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6519aedf-66e7-1af6-4a89-3c0b610d9426@gmx.com>
Date: Thu, 31 May 2018 14:58:08 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nmOjZOkCMXzUk0ZEWSIB53cfW93wyvECD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nmOjZOkCMXzUk0ZEWSIB53cfW93wyvECD
Content-Type: multipart/mixed; boundary="EVzj39o6KjyvvNK1Dd0F3wxYNqlCtzZRm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6519aedf-66e7-1af6-4a89-3c0b610d9426@gmx.com>
Subject: Re: btrfs device replace can cause silent or noisy corruption on
 compressed NOCOW/NODATASUM
References: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>
In-Reply-To: <CA+X5Wn7pOa0+1ur9Twr7MoQCweaX7BXtWuWwfECW6z+=be44_w@mail.gmail.com>

--EVzj39o6KjyvvNK1Dd0F3wxYNqlCtzZRm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8817=E6=97=A5 17:46, james harvey wrote:
> Looks like Qu may have taken care of corrupted compressed data with
> NODATASUM from causing causing random kernel memory corruption.
>=20
> As long as the compressed data was valid and could be uncompressed,
> there were no problems, even on data marked NOCOW/NODATASUM.  If the
> data being sent to be uncompressed was invalid and failed
> decompression, it would sometimes give an I/O error, and sometimes
> cause random kernel memory corruption.
>=20
> I retraced my steps to try to figure out how my data got corrupted in
> the first place.  The pattern of corruption didn't make any sense for
> this to be hardware related, or a user-caused badly executed dd.
>=20
> In short, "btrfs device replace" caused it.  When it copies data to a
> new drive, and encounters NOCOW/NODATASUM compressed data, it copies
> the data in uncompressed form to the new drive, leaving it in
> compressed form on the other mirror, leaving it all marked as
> compressed.  I don't know how it handles the longer length.  I don't
> know if it only writes out the compressed length, if it writes out the
> uncompressed length possibly overwriting other data its writing out or
> even worse other file extents, etc.
>=20
> To rule out anything else, I started in a fresh VM with the May 1,
> 2018, Arch installation ISO.  That's kernel 4.16.5, btrfs-progs 4.16.
>=20
> Starting with a freshly partitioned disk with (3) 10GB partitions, a
> fairly minimal reproducing case with lots of explaining comments can
> be read here:
>=20
> https://pastebin.com/VvNk90Wa

Thanks for the reproducer.

After digging into the code, the bug is more or less straightforward now.=


The direct cause is, for any data extent without csum, btrfs just goes
to copy_nocow_pages(), which will try to use pages of inode to write it
back to disk.

While for pages of an inode, all the data is uncompressed.
Thus it explains why it writes uncompressed data back to disk.

And this is not the only place where scrub will try to use uncompressed
data to write back to disk.

For scrub_fixup_readpage() will also try to do the same thing.


I'll try to fix it since it affects all compression user with nodatasum,
but it is a little tricky to fix.
(And if we have defined how compression should work with nodatasum, all
these hassle can be avoided.)

Thanks,
Qu

>=20
> I of course don't know the extent of this.  I don't know all of the
> situations where NOCOW/NODATASUM extents are compressed anyway.  In my
> real world case, it was journald logs.  We know journald/systemd
> submits those for defragmentation.  I haven't verified if it submits
> the defragmentation asking for compression.  In my reproducing example
> linked above, I had to defragment the file asking for compression to
> cause the file to be compressed.  If that's the extent of the bug,
> probably lots of journald logs out there that have been through a
> replace have corruption, but hopefully no databases.  I don't think
> any databases, and not many database administrators, are going to
> submit the files for defragmentation with compression.  But, if
> compression can be triggered in more situations than this, it's
> possible there's a lot of corruption (sometimes silent) out there on
> important things like databases.
>=20
> Obviously, btrfs device replace or something it depends on needs
> fixing.  It's above my pay grade on if some type of alert should be
> sent out saying not to use replace on btrfs-progs less than a new
> version that hasn't come out yet.  Probably depends on how big the
> extent of the bug is.
>=20
> I also submit that even with corrupted compressed data no longer being
> submitted for decompression, and even with btrfs device replace soon
> being patched, that there should be a way for all NODATASUM data that
> is mirrored to have the mirrored copies compared, regardless of if
> compression is involved.  I think check or scrub should gain this
> functionality.  Obviously, without a checksum, no automatic repair can
> happen, but the user can at least be alerted that something is wrong.
> As the example will show, if the corruption happens on the mirrored
> copy that isn't read, it's silent corruption, unless that good copy
> goes bad someday.  Btrfs has a chance to give NODATASUM data extra
> protection over other filesystems, somewhere between mirrored copies
> just really protecting against a disk failure like most
> implementations and like btrfs does with NODATASUM data now, and
> between btrfs' checksummed mirrors that guard against bit rot and
> one-mirror accidental corruption.
>=20
> I'd even be interested in writing such an addon to check or scrub, if
> it would be accepted, assuming it was written well and worked of
> course.  If someone else wants to do it, that's OK too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--EVzj39o6KjyvvNK1Dd0F3wxYNqlCtzZRm--

--nmOjZOkCMXzUk0ZEWSIB53cfW93wyvECD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsPnQAACgkQwj2R86El
/qjcfAf/Z+0O+/Ek1NA8/ZXmvk1Ljy3yuk5WbL7WEAycO9JODRh9iQYfSOpEvVAp
VLoI8SPO2DKdAxnYd8Pz89YeetwxGgXhqz7wIf2dzWcGrSX+8F8GovlRR/fUpZaP
BYKq2COumDLLCMBDBimwUGxQSHUYI3TaemffjeM5Evy/Yb766oRNKQhBUJfzHvWL
XX6cKwOxV3mUYANJBGbQXRYYMKtwuVCDFg1eCH1ZRg5S26pwHLL+5TYOG9HdKN7F
/nBGntnoBIhN35CqvAgqwNEn9tFz3R789IGJX8mSI2kuYJAxrzFZp9XcBTBF1f3B
UbsUMMADBb1ubsvT+nP8Dh/ARt46oQ==
=4Bhe
-----END PGP SIGNATURE-----

--nmOjZOkCMXzUk0ZEWSIB53cfW93wyvECD--

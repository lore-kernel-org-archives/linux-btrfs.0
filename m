Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58043 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767987AbcHROgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 10:36:16 -0400
Date: Thu, 18 Aug 2016 14:36:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Sanidhya Solanki <lkml.page@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Change RAID stripesize to a user-configurable
 option
Message-ID: <20160818143610.GI20440@carfax.org.uk>
References: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
 <20160728113227.GS30795@twin.jikos.cz>
 <20160728114255.0e7559ef@ad>
 <20160818132658.GE16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvF4niNJ+uBMJnEh"
In-Reply-To: <20160818132658.GE16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gvF4niNJ+uBMJnEh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 18, 2016 at 03:26:58PM +0200, David Sterba wrote:
> On Thu, Jul 28, 2016 at 11:42:55AM -0400, Sanidhya Solanki wrote:
> > > I'll comment on the overall approach and skip code-specific comments.
> > >=20
> > > The changelog does not explain why there's a need for a new blockgroup
> > > type and what's the relation to the existing types. It seems that it
> > > extends the data/metadata/system group, but I think this is totally
> > > wrong.
> >=20
> > I agree in principle, but I did not want to modify the existing balance
> > targets, but, instead, piggyback on the existing balance implementation
> > to re-balance the data.
>=20
> But this is not about balance. The stripe size is more like node size,
> ie. something that gets set at the mkfs time and stays for the
> filesystem lifetime. Multiple stripesize values would be hard to
> implement at least, not something that we'd do for the first
> implementation.
>=20
> > This approach was recommended to be by an experienced BTrFS developer
> > on the IRC as the right way to implement the change.
>=20
> I want his name. I remember talking to you about that patch but
> dismissed the 'another raid group' approach.

   It may have been me. I pointed out that the idea as initially
presented, simply changing the global value on an existing FS (at
runtime, no less!), would break the FS badly if you wanted to be able
to convert from one size to another at runtime (because when you
change the value, you immediately invalidate the existing on-disk
data, and your data gets... interestingly rearranged).

   I said that the approach I'd take would be to add the stripe size
as a parameter to the block group, so that BGs know their own stripe
size. Then implement a balance filter so that you can read a BG (in
the old stripe size, which it knows about), and write a new BG with
the new stripe size and the old data (now restriped).

   It was a long and somewhat struggling conversation, and I may not
have got the point across very well.

   Hugo.

--=20
Hugo Mills             | If the first-ever performance is the premi=E8re, is
hugo@... carfax.org.uk | the last-ever performance the derri=E8re?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gvF4niNJ+uBMJnEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXtcfaAAoJEFheFHXiqx3ksrAQAKL2FaYdIRa1OI7jXwEb9V8g
ieqTOCLmrLttZiq+Vf6c7LIoAnqhHGenkmSz9jGO3tnHHScIRNU/q87LdvDq1P3s
dX/ljVdzq8+gLMTctmW/tshsUYA7VDrl4szr1YVJZJnvlQC3u6MB1h0cfFgfsq7n
BVAknIG9Vt6NLbGjTCdme/PjWCuUN8K9Ba4wnVCngw6tlvteGpc5zI2GUSDliEvw
6zsrhtRlvzCoRzqn0aHSpRlx2x9rV9UokpsWa9xBghgSy7BIo4PfSDa1/jvtnyD8
v6eX/L+j6SHw/Dn3RrwHuECdTIBOW9lJN4KluUvNa+Fnv28ZIS4+i64OHsTZYo9l
chUqq0sRKWY/gBHfIV8IBhwtpoSP32soak/7rRi63ELiB8Y6w7DIIGmCMJALvr+2
k3q1b/d36UV8OBFO0DPSrgzyX2TnLx4xRXA2W5tOGbVbeWhTP4dG6B/oareAekZH
s4fPsJ1S9Iy5DVzlaTgm+8ALrLrLPth9hTMFBwTwjN3FpINhtX1+CaLGpFUvZgUE
3AcQor48zkP8qKaoVz/6LIe/INDwAs1DRvyCy1TGHkDQxZV5FHz2KpnyhiDObh/x
Jz7JW9CvY0j8VJAf0iepR4TROMRzcz/pQkgPs2tt/eib/F067SvAWuMFXjoI6r3s
JTyZ57aFjhuBwLIaeDtz
=qJR3
-----END PGP SIGNATURE-----

--gvF4niNJ+uBMJnEh--

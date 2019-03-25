Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA9EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1651B20830
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbfCYWz2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:55:28 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:50985 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbfCYWz2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 18:55:28 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1h8YV4-0000hC-3T; Mon, 25 Mar 2019 22:55:26 +0000
Date:   Mon, 25 Mar 2019 22:55:25 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: parent transid verify failed / FS wont mount / help please!
Message-ID: <20190325225525.GD27856@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        berodual_xyz <berodual_xyz@protonmail.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
 <20190325223842.GC27856@carfax.org.uk>
 <kxQglfkZm7A_i8CXh0JVrJ9H0MF4vFVJWiT8BWRBc8NPM24nZC-vc6sIrts3ZR4T8HEvRTfPv1yz4lPotIuO1JiPYOk60cHMQqHcTFkDfZ4=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Content-Disposition: inline
In-Reply-To: <kxQglfkZm7A_i8CXh0JVrJ9H0MF4vFVJWiT8BWRBc8NPM24nZC-vc6sIrts3ZR4T8HEvRTfPv1yz4lPotIuO1JiPYOk60cHMQqHcTFkDfZ4=@protonmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2019 at 10:44:15PM +0000, berodual_xyz wrote:
> Thank you very much Hugo,
>=20
> the underlying devices are based on HW raid6 and effectively "stitched" t=
ogether. Loosing any of those would mean loosing all data, so much is clear.
>=20
> My concern was not so much bitrod / silent data corruption but I would no=
t have expected disabled data checksumming to be a disadvantage at recoveri=
ng from the supposed corruption now.

   OK, so it's not quite as bad a case as I painted. Turning off all
of the btrfs data-protection features still isn't something you'd do
to data you're friends with. However, it shouldn't directly affect the
recoverability of the data (assuming you had RAID-1 metadata).

   The main problem is that you've had a transid error, which is
pretty much universally fatal. There's a description of what that
means in the FAQ here:
https://btrfs.wiki.kernel.org/index.php/FAQ#What_does_.22parent_transid_ver=
ify_failed.22_mean.3F

> Does anyone have any input on how to restore files based on inode no. fro=
m the tree dump that I have?

   I'm not sure what you mean by "tree dump". Do you mean
btrfs-debug-tree? Or btrfs-image? Or something else? In any case, none
of those are likely to help all that much. The metadata is
corrupted in a way that shouldn't ever happen, and where it's really
hard to work out how to fix it, even with an actual human expert
involved.  (It's why there's no btrfs check fix for this situation --
you simply can't take the metadata broken in this way and make much
sense out of it).

   Hugo.

> "usebackuproot,ro" did not succeed either.
>=20
> Much appreciate the input!
>=20
>=20
> Sent with ProtonMail Secure Email.
>=20
> =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original =
Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> On Monday, March 25, 2019 11:38 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> > On Mon, Mar 25, 2019 at 10:26:29PM +0000, berodual_xyz wrote:
> >
> > > Dear all,
> > > on a large btrfs based filesystem (multi-device raid0 - all devices o=
kay, nodatacow,nodatasum...)
> >
> > Ouch. I think the only thing you could have done to make the FS
> > more fragile is mounting with nobarrier(). Frankly, anything you're
> > getting off it is a bonus. RAID-0 gives you no duplicate copy,
> > nodatacow implies nodatasum, and nodatasum doesn't even give you the
> > ability to detect data corruption, let alone fix it.
> > With that configuration, I'd say pretty much by definition the
> > contents of the FS are considered to be discardable.
> > Restoring from backups is the recommended approach with transid
> > failures.
> > () Don't do that.
> >
> > > I experienced severe filesystem corruption, most likely due to a hard=
 reset with inflight data.
> > > The system cannot mount (also not with "ro,nologreplay" / "nospace_ca=
che" etc.).
> >
> > Given how close the transids are, have you tried
> > "ro,usebackuproot"? That's about your only other option at this
> > point. But, if btrfs restore isn't working, then usebacuproot probably
> > won't either.
> >
> > > Running "btrfs restore" I got a reasonable amount of data backed up, =
but a large chunk is missing.
> > > "btrfs check" gives the following error:
> > >

--=20
Hugo Mills             | I gave up smoking, drinking and sex once. It was t=
he
hugo@... carfax.org.uk | scariest 20 minutes of my life.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcmVxdAAoJEFheFHXiqx3k5qEQAKI9gAboDzMiYdCw+j8U7tgJ
8QQ0FPpqiR9mvYRNvkrRZOW67DIftE+l3h7FTOtXIfzNLXNa3KypBSd3n0ZRQi9u
f9T5hWpF0PrwN46lcCImDlDFORuUmWlU5TQyFb/MnHeGWboZWz3qzxt0p+KkT53M
p/QUE/2rLZey9NM8PTMip/CZRB4vA6ZumxgZYuQoltp4RPKlWWPDctN8sg2SS+vq
a1FVfAMnptmOf8EZufOtAdawlEhvKM8/AL10KCCN2y+um/Pqk3YbdnMkGiF2X2J0
jqmrIypKovlsqcY4uwQzkKQCoWBKcCkgTSgPyqXsTPI48SA2S6EEGxEA/ERIoA2g
g/jxKawH4ZSSm+SwiuucqOUvo1L32MULeyP97NbLQ/qF4SZSpvhJDwgqaz+PTbgN
xJbJV5r4u8qNjyQOWtqn8LNYSKwq1P85DsKHM/VPf8G3mlVlrpFC4Yt2OH/rTQHb
muaZi9bJnRmrg3LZtMY2Jk9sOHsPWP/CWndJI53Pw/omk+ExlTFt4/UGWcW0zK4V
G+Ad7fJmaX51JsS4UJ2bF1am8mHDrbbQBJugqL3aJxGWfp3gs02uVGm7c4LdvG40
Bva9WteuF/hReQfRynCTIJwkotZS8l/gK2YieaTHZGsh7ElaV66C8RpZ/RsXfjTs
CrUBX3wMc6OCMYM/19uR
=3Cpp
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--

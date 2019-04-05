Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4079DC282CE
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 19:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1126D2146F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 19:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbfDETcV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 15:32:21 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:33568 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731611AbfDETcU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 15:32:20 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hCUZW-000564-FS; Fri, 05 Apr 2019 19:32:18 +0000
Date:   Fri, 5 Apr 2019 19:32:18 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: corrupt leaf, bad key order on kernel 5.0
Message-ID: <20190405193218.GC1084@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2019 at 10:11:57PM +0300, Nazar Mokrynskyi wrote:
> NOTE: I do not need help with recovery, I have fully automated snapshots,=
 backups and restoration mechanisms, the only purpose of this email is to h=
elp developers find the reason of yet another filesystem corruption and hop=
efully fix it.

   That's good news, at least.

> Yet another corruption of my root BTRFS filesystem happened today.
> Didn't bother to run scrub, balance or check, just created disk image for=
 future investigation and restored everything from backup.
>=20
> Here is what corruption looks like:
> [=A0 274.241339] BTRFS info (device dm-0): disk space caching is enabled
> [=A0 274.241344] BTRFS info (device dm-0): has skinny extents
> [=A0 274.283238] BTRFS info (device dm-0): enabling ssd optimizations
> [=A0 310.436672] BTRFS critical (device dm-0): corrupt leaf: root=3D268 b=
lock=3D42044719104 slot=3D123, bad key order, prev (1240717 108 41447424) c=
urrent (1240717 76 41451520)

   "Bad key order" is usually an indicator of faulty RAM -- a piece of
metadata gets loaded into RAM for modification, a bit gets flipped in
it (because the bit is stuck on one value), and then the csum is
computed for the page (including the faulty bit), and written out to
disk. In this case, it's not obvious, but I'd suggest that the second
field of the key has been flipped, as 108 is 0x6c, and 76 is 0x4c --
one bit away from each other.

   I recommend you check your hardware thoroughly before attempting to
rebuild the FS.

   Hugo.

> [=A0 310.449304] BTRFS critical (device dm-0): corrupt leaf: root=3D268 b=
lock=3D42044719104 slot=3D123, bad key order, prev (1240717 108 41447424) c=
urrent (1240717 76 41451520)
> [=A0 310.449309] BTRFS: error (device dm-0) in btrfs_dropa_snapshot:9250:=
 errno=3D-5 IO failure
> [=A0 310.449311] BTRFS info (device dm-0): forced readonly
> [=A0 311.266789] BTRFS info (device dm-0): delayed_refs has NO entry
> [=A0 311.277088] BTRFS error (device dm-0): cleaner transaction attach re=
turned -30
>=20
> My system just freezed when I was not looking at it and this is the state=
 it is in now.
> File system survived from March 8th til April 05, one of the fastest corr=
uptions in my experience.
>=20
> Looks like this happened during sending incremental snapshot to the other=
 BTRFS filesystem, since last snapshot on that one was not read-only as it =
should have been otherwise.
>=20
> I'm on Ubuntu 19.04 with Linux kernel 5.0.5 and btrfs-progs v4.20.2.
>=20
> My filesystem is on top of LUKS on NVMe SSD (SM961), I have 3 snapshots c=
reated every 15 minutes from 3 subvolumes with rotation of old snapshots (c=
an be from tens to hundreds of snapshots at any time).
>=20
> Mount options: compress=3Dlzo,noatime,ssd
>=20
> I have full disk image with corrupted filesystem and will create Qcow2 sn=
apshots of it, so if you want me to run any experiments, including potentia=
lly destructive, including usage of custom patches to btrfs-progs to find o=
ut the reason of corruption, would be happy to help as much as I can.
>=20
> P.S. I'm riding latest stable and rc kernels all the time and during last=
 6 months I've got about as many corruptions of different BTRFS filesystems=
 as during 3 years before that, really worrying if you ask me.
>=20

--=20
Hugo Mills             | I'm always right.
hugo@... carfax.org.uk | But I might be wrong about that.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcp61CAAoJEFheFHXiqx3kySIQAJT2NLmDBfg3o1NljqX+ItNv
nhNPPFfYyiYLfzCJazpwA1oWDLT4fQj45sH6KEhlKTgAIP6+Jw14zFtsS+dKWuWP
7oZAwzrbstz/+S2JnfWrsUKmVJxHfq/sJYrtE0ruwJjpO6WFCdLNcy+IMIVMG03a
Bn5AwJqYr1YYmr8ygRaAazmBCWhsB3uqxJdUlHi9OmtAWBHI+G/1RMdn6TlUBaR+
xXqe3PJG1qtp7jtB686bpcpR/kCKppnOmH6Jt0K6swWwm27q2O2F4Zz8gj4RT8Cl
LBIB2qzTu+cxZ3C1AAu3KpS1dS+qTB3WFxOorLaNHQOVzyYOVeenGpsfO4kkJTGG
canlQbPa01TFi3g2ePes9pDXLaNo0snZ5f3bXz0hdtRg3MMlSjKOQrPzLS/Vbc7T
jaSce13DaTNLKWRISDvP+ciRqY5rDUEbWw4ycsUAAMMU2aBQgRQU1o84suOSMmeG
VyiKqIT82BSIXqWA2Y/MsAIScZgs4CEB1wS2aMg85GfUoaF1YpgJ4Zd5xqtL7ipD
B5s1BzHm1VRZPC/SFHf66e+uxZ2Zf0BdbhGMMHSJyUxtSp506UOeighhwvLwg3jr
NCM+sGhLwk339e7FDv2WyJsqzpw2hrwe4iwGx4ma/XlmqZhvXoXERGFwMN+DJpCW
MesyUyKfJUeZMQlsAhFi
=9le7
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--

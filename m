Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFF9C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ADC6206C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfCYW47 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:56:59 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:51020 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfCYW47 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 18:56:59 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1h8YWX-0000iI-Hx; Mon, 25 Mar 2019 22:56:57 +0000
Date:   Mon, 25 Mar 2019 22:56:57 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: parent transid verify failed / FS wont mount / help please!
Message-ID: <20190325225657.GE27856@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
 <20190325223842.GC27856@carfax.org.uk>
 <kxQglfkZm7A_i8CXh0JVrJ9H0MF4vFVJWiT8BWRBc8NPM24nZC-vc6sIrts3ZR4T8HEvRTfPv1yz4lPotIuO1JiPYOk60cHMQqHcTFkDfZ4=@protonmail.com>
 <dJY4taBczsTC2XpF8mBue4O5brHguT2KuDS-bRHGA0fJ6m0o9z7bjHv0s2F6uvb0JZGISF-qkTWJT9bvl9ntyPbvq-FoOyQYCi0ZQ8_ShOw=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Content-Disposition: inline
In-Reply-To: <dJY4taBczsTC2XpF8mBue4O5brHguT2KuDS-bRHGA0fJ6m0o9z7bjHv0s2F6uvb0JZGISF-qkTWJT9bvl9ntyPbvq-FoOyQYCi0ZQ8_ShOw=@protonmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2019 at 10:51:24PM +0000, berodual_xyz wrote:
> Running "btrfs check" on the 3rd of the 4 devices the volume consists of =
crashes with a trace:

   Just for the record, it doesn't matter which device you use for
btrfs check. You're running it on the whole filesystem, not just one
device. The device just serves to identify which FS you're running it
on. (The btrfs check code will scan all the available block devices
for the other pieces of the FS).

   Hugo.

> ##
> $ btrfs check --readonly /dev/sdd
> Opening filesystem to check...
> parent transid verify failed on 1048576 wanted 60234 found 60230
> parent transid verify failed on 1048576 wanted 60234 found 60230
> Ignoring transid failure
> volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
> btrfs[0x426fdc]
> btrfs(btrfs_chunk_readonly+0x98)[0x429acd]
> btrfs(btrfs_read_block_groups+0x1c1)[0x41cd44]
> btrfs(btrfs_setup_all_roots+0x368)[0x416540]
> btrfs[0x416a8a]
> btrfs(open_ctree_fs_info+0xd0)[0x416bcc]
> btrfs(cmd_check+0x591)[0x45f431]
> btrfs(main+0x24a)[0x40ca02]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fa320a44b35]
> btrfs[0x40c509]
> [1]    22848 abort      btrfs check --readonly /dev/sdd
> ##
>=20
> Trying to mount "ro,usebackuproot" shows bad superblock and following err=
ors in /var/log/messages:
>=20
> ##
> 33814.360633] BTRFS info (device sdd): trying to use backup root at mount=
 time
> [33814.360637] BTRFS info (device sdd): using free space tree
> [33814.360638] BTRFS info (device sdd): has skinny extents
> [33814.361708] BTRFS error (device sdd): parent transid verify failed on =
1048576 wanted 60234 found 60230
> [33814.361764] BTRFS error (device sdd): failed to read chunk root
> [33814.373140] BTRFS error (device sdd): open_ctree failed
> ##
>=20
>=20
> Again, thank you very much for all help!
>=20
>=20
>=20
> Sent with ProtonMail Secure Email.
>=20
> =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original =
Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> On Monday, March 25, 2019 11:44 PM, berodual_xyz <berodual_xyz@protonmail=
=2Ecom> wrote:
>=20
> > Thank you very much Hugo,
> >
> > the underlying devices are based on HW raid6 and effectively "stitched"=
 together. Loosing any of those would mean loosing all data, so much is cle=
ar.
> >
> > My concern was not so much bitrod / silent data corruption but I would =
not have expected disabled data checksumming to be a disadvantage at recove=
ring from the supposed corruption now.
> >
> > Does anyone have any input on how to restore files based on inode no. f=
rom the tree dump that I have?
> >
> > "usebackuproot,ro" did not succeed either.
> >
> > Much appreciate the input!
> >
> > Sent with ProtonMail Secure Email.
> >
> > =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Origina=
l Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> > On Monday, March 25, 2019 11:38 PM, Hugo Mills hugo@carfax.org.uk wrote:
> >
> > > On Mon, Mar 25, 2019 at 10:26:29PM +0000, berodual_xyz wrote:
> > >
> > > > Dear all,
> > > > on a large btrfs based filesystem (multi-device raid0 - all devices=
 okay, nodatacow,nodatasum...)
> > >
> > > Ouch. I think the only thing you could have done to make the FS
> > > more fragile is mounting with nobarrier(). Frankly, anything you're
> > > getting off it is a bonus. RAID-0 gives you no duplicate copy,
> > > nodatacow implies nodatasum, and nodatasum doesn't even give you the
> > > ability to detect data corruption, let alone fix it.
> > > With that configuration, I'd say pretty much by definition the
> > > contents of the FS are considered to be discardable.
> > > Restoring from backups is the recommended approach with transid
> > > failures.
> > > () Don't do that.
> > >
> > > > I experienced severe filesystem corruption, most likely due to a ha=
rd reset with inflight data.
> > > > The system cannot mount (also not with "ro,nologreplay" / "nospace_=
cache" etc.).
> > >
> > > Given how close the transids are, have you tried
> > > "ro,usebackuproot"? That's about your only other option at this
> > > point. But, if btrfs restore isn't working, then usebacuproot probably
> > > won't either.
> > >
> > > > Running "btrfs restore" I got a reasonable amount of data backed up=
, but a large chunk is missing.
> > > > "btrfs check" gives the following error:

--=20
Hugo Mills             | I gave up smoking, drinking and sex once. It was t=
he
hugo@... carfax.org.uk | scariest 20 minutes of my life.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcmVy5AAoJEFheFHXiqx3kOD0P/2CdQEL9/9Q8j52OOBkMk3r+
db++yIbcGgcUYCjz6cmK3//cpAvh7/6tKpwMCtCiBJHVPNcmM6s9yp5/4FDJL6Ig
dE8RDUWq5K8ttUNB5uDbbQkq5GGYCnTZf3RUv1Yhwjq1B5zr9XQtB4ZP4y1dbKv9
zVgBcuVJgLd3qt5LAxJDvUngXOYMWTYr1n4zx+zUsk9GhEaNfjnuKrqbz3wjZIfA
9vtPPcdKPPhSs10RsIbMwgeNBV5spQEfGO48EQ2ugG0E3DVNfIpZ51p8YgF0jUeC
NHm+QwrERSRS2P9E87PrpTTPWxVO4Wq13kDtPg3n22QxiuJoOqOtqi2M7E8dtnGt
aG93YFGjNrQz11ZMFi+cJ3Vk/0ATsDhq/EvQs1fvwJsLsSBPh1Q1pecwU8j/p54X
orxkWg7wL1iyQRbwj1+5YOUGngavpC7cjp88uEo1rhKR6Jd7XzNbJB6/m/jKA5Gm
mtv+Bu4RujHJKSuqxcnXcnFa2vMPfIgTMubzI/cWxNnIvTDL2kUyHph5Sa1k/XoM
F2tV9uxLK3f2FplCBShgZstB0ScrnYXbzD4vCfPJiqxXqt3rwWidUOUEg51+jENM
4PO24C8nt9qPDu90GGEpchZdKGlsqMINOXCZEsbew56v32g+wW1kVlr4SzbS25Z8
ZKKyS3/QUydoNMHUuERw
=CRL1
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--

Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F136C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF0A2229F
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438527AbfBNMfv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:35:51 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:55847 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfBNMfv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 07:35:51 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1guGF1-0007uy-RM; Thu, 14 Feb 2019 12:35:47 +0000
Date:   Thu, 14 Feb 2019 12:35:47 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Jesper Utoft <jesper.utoft@gmail.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
Message-ID: <20190214123547.GH31308@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Jesper Utoft <jesper.utoft@gmail.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
 <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vjQsMS/9MbKYGLq"
Content-Disposition: inline
In-Reply-To: <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--5vjQsMS/9MbKYGLq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2019 at 08:25:26PM +0800, Qu Wenruo wrote:
> On 2019/2/14 =E4=B8=8B=E5=8D=887:58, Jesper Utoft wrote:
> > Hello Fellow BTRFS users.
> >=20
> > I have run into the bad key order issue.
> > corrupt leaf: root=3D1 block=3D57567265079296 slot=3D83, bad key order,=
 prev
> > (18446744073709551605 0 57707594776576) current (18446726481523507189
> > 0 57709742260224)
> > The lines repeats over and over..
> >=20
> > I read a thread between Hugo Mills and Eric Wolf about a similar issue
> > and i have gathered the same info.=20
> Now we have all the needed info.
>=20
> >=20
> > I understand that it probably is hardware related, i have been running
> > memtest for 60h+ to see if i could reproduce it.
> > I also tried to run btrfs check --recover but it did not help.
> >=20
> > My questions is if it can be fixed?
>=20
> Yes, but only manual patching is possible yet.

   David: What needs to be done to get the bitflip-in-key patches
added to btrfs check? They've been lurking in some patch stack for
literally years, and would have dealt with this one easily.

[snip]
> Thankfully, all keys around give us a pretty good idea what the original
> value should be: (FREE_SPACE UNTYPED 57709742260224).
>=20
> And for the raw value:
> bad:  0xffffeffffffffff5
> good: 0xfffffffffffffff5
>             ^
> e->f, one bit get flipped.
> (UNTYPED is the same value for UNKNOWN.0, so don't worry about that).
>=20
> I have created a special branch for you:
> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>=20
> Just compile that btrfs-progs, no need to install, then excute the
> following command inside btrfs-progs directory:
>=20
> # ./btrfs-corrupt-block -X <device>

   BUT, don't do it until you've found and replaced the bad RAM that
broke it in the first place.

> And your report just remind me to update the write time tree block
> checker....

   Looking forward to dealing with a whole new type of "btrfs is
broken!" complaints on IRC (followed by "can't I just let it carry on
regardless?"). ;)

   Hugo.

--=20
Hugo Mills             | Hickory Dickory Dock,
hugo@... carfax.org.uk | Three mice ran up the clock.
http://carfax.org.uk/  | The clock struck one,
PGP: E2AB1DE4          | The other two escaped with minor injuries

--5vjQsMS/9MbKYGLq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcZWCjAAoJEFheFHXiqx3k8IAP/RcYAghd3fo2tEQfxu7HVDYD
Ctmi1pQO/B4GrKSvPWWb7VQJ5wJdL1O2xlEEMSfrHIPK9zgWeFGY4wt8Ua0OfskB
2zp5O5FOWsJmqQ8JhCZz/dTMip7dlMsCXlJZ/KgRDK0xRyegY+2hmW/OtyU0T5HA
U8lp4aD1lirz7HufAuDSCenhJ4SyVan8ZHJY5jTt98LevYTH9l3e9Tu4hTbaArZL
q39OfhUz0EoT4SPMjRm9AnJKoJvIdYRwTmjTCNAcqkvYiljLi1xf1audSbDwGYE6
ReB5VQHdm0XhhWb84lMyU88o9pWBTvs1ln0jMBsOBFSCDNYEnvYB2Z9I8+TLeSTU
NQVvSp0vrQALwtylfOL80+MGLo8plgjfCfyk0NXamEab05J2K0l7Ya2yDGZ6HY20
47NCpkORK/SnBXKNszvQkqJ88fnTt2cUoplsSTqocw3XRCiKvpkKobdW4terGsTm
Ki3gHuZDXrwiFVtQteJoNN+Eo3CajdLd2qXBFRMNWPjHeldFzNXAtgiPoQ2VKUIi
IRQMzqIJGi8LVPdzYe2PTC0KHJ67q6wUHuuVcYUo7SAIUsjclQhoQQblaZpWhchT
4WO+M1vGmJBQ7sTIZ4W/WOBSfEht8uih/ZKXDDmHLjo9YGcb8720t8sXt29TMKVt
fZQTbKsWhwsuAokjkUpj
=9XO4
-----END PGP SIGNATURE-----

--5vjQsMS/9MbKYGLq--

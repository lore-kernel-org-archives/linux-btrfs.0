Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:40704 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932320AbcJLTfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 15:35:30 -0400
Date: Thu, 13 Oct 2016 00:33:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161013003331.5e33c006@natsu>
In-Reply-To: <20161012191915.GF26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
        <20161011160601.GI7683@carfax.org.uk>
        <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
        <20161012122551.27d949ee@natsu>
        <20161012173141.GX21290@hungrycats.org>
        <20161012191915.GF26140@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ws1AFzh8twodZzjm=+3YgZP"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/ws1AFzh8twodZzjm=+3YgZP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2016 15:19:16 -0400
Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:

> I'm not even sure btrfs does this--I haven't checked precisely what
> it does in dup mode.  It could send both copies of metadata to the
> disks with a single barrier to separate both metadata updates from
> the superblock updates.  That would be bad in this particular case.

It would be bad in any case, including a single physical disk and no RAID, =
and
I don't think there's any basis to speculate that mdadm doesn't implement
write barriers properly.

> In degraded RAID5/6 mode, all writes temporarily corrupt data, so if there
> is an interruption (system crash, a disk times out, etc) in degraded mode,

Moreover, in any non-COW system writes temporarily corrupt data. So again,
writing to a (degraded or not) mdadm RAID5 is not much different than writi=
ng
to a single physical disk. However I believe in the Btrfs case metadata is
always COW, so this particular problem may be not as relevant here in the
first place.

--=20
With respect,
Roman

--Sig_/ws1AFzh8twodZzjm=+3YgZP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlf+kA4ACgkQTLKSvz+PZwj0TwCgk+baIxumpDlwS3WfWNLgScKw
LnAAn2BT8N+ka+1x89R9hCvhuvcJJPli
=8J4h
-----END PGP SIGNATURE-----

--Sig_/ws1AFzh8twodZzjm=+3YgZP--

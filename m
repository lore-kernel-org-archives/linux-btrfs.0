Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD02C10F14
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 00:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502C720833
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 00:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfDVAJD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Apr 2019 20:09:03 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38306 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfDVAJD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Apr 2019 20:09:03 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id BDD982C647F; Sun, 21 Apr 2019 20:07:26 -0400 (EDT)
Date:   Sun, 21 Apr 2019 20:05:23 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Juergen Sauer <juergen.sauer@automatix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Raid 5 Space missing - ideas ?
Message-ID: <20190422000520.GA11530@hungrycats.org>
References: <cac3618d-8153-66c1-446a-0040b7142c6a@automatix.de>
 <20190420201913.GA3306@angband.pl>
 <02b7c96d-8ac6-ec2d-e2b8-8fa46d4e310b@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <02b7c96d-8ac6-ec2d-e2b8-8fa46d4e310b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 21, 2019 at 07:39:59AM +0300, Andrei Borzenkov wrote:
> 20.04.2019 23:19, Adam Borowski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Sat, Apr 20, 2019 at 12:46:16PM +0200, Juergen Sauer wrote:
> >> I wish a happy Easer Days before :)
> >=20
> > Same to you!
> >=20
> >> During my tests with BTRFS as Raid5 setup, I found a courious little
> >> "problem".
> >=20
> >>         Total devices 3 FS bytes used 9.98TiB
> >>         devid    1 size 9.09TiB used 4.99TiB path /dev/sdb1
> >>         devid    2 size 5.46TiB used 4.99TiB path /dev/sdc1
> >>         devid    3 size 5.46TiB used 4.99TiB path /dev/sde1
> >=20
> >> All patitioins sdb1 sdc1 sde1 are the same size: 9.0 TiB. But BTRFS ist
> >> not using the bigger space on sdc1, sde1, there is only 5.46 TiB used,
> >> even there are 9.0 Tib Avaible, so 4.0 TiB are unused.
> >=20
> > It's working as expected: while btrfs does RAID per block group rather =
than
> > per whole block device, there's no way to place a raid5 block group in =
a way
> > that doesn't require at least 3 devices.  This means with a 3-disk setu=
p the
> > space utilized will be only as big as the smallest one.
> >=20
>=20
> But as reported, all drives were replaced by larger ones but only one
> drive shows increased size: "All patitioins sdb1 sdc1 sde1 are the same
> size".

Did you do:

	btrfs fi resize 2:max /path/to/fs
	btrfs fi resize 3:max /path/to/fs

It looks like you only did

	btrfs fi resize 1:max /path/to/fs


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXL0EhwAKCRCB+YsaVrMb
nAo2AKCNgliuzT6c8yq3gtHiLq4Tb8FY6QCfdm7AGoE/vZJUMpopcbq7u0oLIo0=
=MuXI
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

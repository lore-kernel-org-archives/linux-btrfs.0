Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9ADC432C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 03:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40512064B
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 03:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfK0Dsm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 22:48:42 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48102 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfK0Dsm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 22:48:42 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 028604F84B3; Tue, 26 Nov 2019 22:48:39 -0500 (EST)
Date:   Tue, 26 Nov 2019 22:48:39 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Christopher Staples <mastercatz@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: bad sector / bad block support
Message-ID: <20191127034838.GL22121@hungrycats.org>
References: <CAGsZeXsEZ8EqPsuU9O+7d+suxBVNQAobASJaLNMZB9LhUe6Q7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ELMKpCVvjiB+uwRu"
Content-Disposition: inline
In-Reply-To: <CAGsZeXsEZ8EqPsuU9O+7d+suxBVNQAobASJaLNMZB9LhUe6Q7A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ELMKpCVvjiB+uwRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2019 at 01:30:04PM +1000, Christopher Staples wrote:
> will their ever be a better way to handle bad sectors ?  I keep
> getting silent corruption from random bad sectors
> scrubs keep passing with out showing any errors , but if I do a
> ddrescue backup to a new drive I find the bad sectors

That is a typical symptom of host RAM corruption.  Make sure your memory
and CPU are OK.

A similar test you can do is to copy a large file or group of files
(say a few GB) and compare the copy with the original.  If there are
differences but no btrfs csum errors, chances are good that you are
looking at some kind of host RAM failure.

> the only thing I can do for now is mark I/O error files as bad buy
> renaming them and make another file copy onto the file system ,
>=20
>=20
> I like btrfs for the snapshot ability , but when it comes to keeping
> data safe ext4 seems better ? at least it looks for bad sectors and
> marks them , btrfs just seems to write and assumes its written ..

--ELMKpCVvjiB+uwRu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXd3yEgAKCRCB+YsaVrMb
nGqaAKDa3txsn/m/zd0b+qy+kXdm2qa+2QCcDNqnIQFGF98hR5HgULIVKFJ0HaQ=
=i6y6
-----END PGP SIGNATURE-----

--ELMKpCVvjiB+uwRu--

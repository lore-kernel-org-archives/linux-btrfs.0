Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3E4C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 21:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2AD217D4
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 21:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfAYV1g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 16:27:36 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36228 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfAYV1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 16:27:35 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2019 16:27:35 EST
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 541211DCD3F; Fri, 25 Jan 2019 16:22:22 -0500 (EST)
Date:   Fri, 25 Jan 2019 16:22:22 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Tobias Reinhard <trtracer@gmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Retrieving
Message-ID: <20190125212222.GA9995@hungrycats.org>
References: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <4472aad4-86cb-7ce2-6055-1ff8d6955969@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 13, 2019 at 11:19:04AM +0100, Tobias Reinhard wrote:
> I want to read the complete CSUM-Tree from userspace. I tried it via the
> ioctl. This is what the code looks like:
>=20
> struct btrfs_sv2_args sv2_args;
> int fd =3D open(filename, O_RDONLY);
> sv2_args.key.tree_id =3D BTRFS_CSUM_TREE_OBJECTID;
> sv2_args.key.min_objectid =3D 0;
> sv2_args.key.max_objectid =3D -1;
> sv2_args.key.min_offset =3D 0;
> sv2_args.key.max_offset =3D -1;
> sv2_args.key.min_transid =3D 0;
> sv2_args.key.max_transid =3D -1;
> sv2_args.key.min_type =3D BTRFS_CSUM_ITEM_KEY;
> sv2_args.key.max_type =3D BTRFS_CSUM_ITEM_KEY;
> sv2_args.key.nr_items =3D -1;
> sv2_args.buf_size =3D sizeof(sv2_args.buf);
> ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, &sv2_args);
>=20
> But the device is not small and I hit the limit of the btrfs_sv2_args.buf
> which seems to be 16 MB.
>=20
> How can I get the *complete* CSUM-Tree?
>=20
> Limiting to offset does not work (My first idea was to do it this way and
> get it in chunks).

The search key is (objectid, BTRFS_CSUM_ITEM_KEY, offset) and the key is
treated as a single 136-bit integer for filtering and sorting purposes.
According to key order:

	(123, BTRFS_CSUM_ITEM_KEY, 456) < (124, BTRFS_CSUM_ITEM_KEY, 234)

You must iterate by objectid (the extent bytenr), key, and offset (the
length of the csum data).  In many btrfs trees you will get extra data
in the search results with different type fields which you will have
to discard.

> Limiting to a single transid does not work as well because even one trans=
id
> is larger than the limit.
>=20
> Kernel is 4.15.
>=20
> Any help would be appreciated.
>=20
> Best Regards
>=20
> Tobias
>=20

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXEt+CwAKCRCB+YsaVrMb
nAp5AKCe6p2oWdiWFv/VJsknNoa+pS31+QCgmqcEczXVOMDQhxzu4ycG+zkisWI=
=8NUy
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--

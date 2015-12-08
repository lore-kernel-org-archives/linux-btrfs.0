Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:42106 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbbLHGb4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 01:31:56 -0500
Date: Tue, 8 Dec 2015 11:31:52 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Introduce new mount option to disable tree
 log replay
Message-ID: <20151208113152.5f8edeaf@natsu>
In-Reply-To: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f.wqig0sX/+fW3zbFwbRHRV"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/f.wqig0sX/+fW3zbFwbRHRV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  8 Dec 2015 14:10:33 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> option to get real readonly mount, like "norecovery" in ext* and xfs.

Maybe name it "norecovery" too, for simplicity and consistency?

The actual effect of "norecovery" in ext* and xfs is to also disable log
replay, but that's an under-the-hood detail not relevant to the user.

---
Mount options for ext3

       norecovery/noload
              Don't load the journal on mounting.  Note that if the filesys=
tem
              was not unmounted cleanly, skipping the journal replay will l=
ead
              to  the  filesystem  containing inconsistencies that can lead=
 to
              any number of problems.
---
Mount options for xfs

       norecovery
              The filesystem will be mounted without running log recovery. =
 If
              the filesystem was not cleanly unmounted, it  is  likely  to =
 be
              inconsistent  when  mounted  in  norecovery mode.  Some files=
 or
              directories may not be accessible because of this.   Filesyst=
ems
              mounted  norecovery  must be mounted read-only or the mount w=
ill
              fail.
---

--=20
With respect,
Roman

--Sig_/f.wqig0sX/+fW3zbFwbRHRV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZmeVgACgkQTLKSvz+PZwhf4QCgjL/O9GMvXEV+vFErag62PgQG
4tcAoIJD+AD71Ov61HG47sXvk3LTV1nW
=jIab
-----END PGP SIGNATURE-----

--Sig_/f.wqig0sX/+fW3zbFwbRHRV--

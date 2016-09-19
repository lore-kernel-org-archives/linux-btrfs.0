Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43180 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbcISWbh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 18:31:37 -0400
Date: Mon, 19 Sep 2016 18:31:22 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Alex Elsayed <eternaleye@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160919223119.GK21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916011213.GV22388@dastard>
 <nrg4mh$bkn$1@blaine.gmane.org>
 <20160917043829.GC21290@hungrycats.org>
 <nrioas$da6$1@blaine.gmane.org>
 <20160919180805.GG21290@hungrycats.org>
 <nrpg62$g72$2@blaine.gmane.org>
 <CAJCQCtR=6_cLa_f2BdcfhkfWGB_4kHSG-JfFh4w+40R7zOMtWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yr6OvWOSyJed8q4v"
In-Reply-To: <CAJCQCtR=6_cLa_f2BdcfhkfWGB_4kHSG-JfFh4w+40R7zOMtWQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yr6OvWOSyJed8q4v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 04:25:55PM -0600, Chris Murphy wrote:
> >> Files are modified by creating new extents (using parameters inherited
> >> from the inode to fill in the extent attributes) and updating the inode
> >> to refer to the new extent instead of the old one at the modified
> >> offset. Cloned extents are references to existing extents associated
> >> with a different inode or at a different place within the same inode (=
if
> >> the extent is not compatible with the destination inode, clone fails
> >> with an error).  A snapshot is an efficient way to clone an entire
> >> subvol tree at once, including all inodes and attributes.
> >
> > There is the caveat of chattr +C, which would need hard-disabled for
> > extent-level encryption (vs block level).
>=20
> What about raid56 partial stripe writes? Aren't these effectively nocow?

Those are a straight-up bug that should be fixed.  They are mixing committed
data with uncommitted data from two different transactions, and the stripe
temporarily contains garbage.  Combine that with unclean shutdown in degrad=
ed
mode and the data is gone.

--yr6OvWOSyJed8q4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgZzcACgkQgfmLGlazG5zlRQCgu/Jcm/4DoVbrNfyp1Fo3dwhh
3/sAoLmps7+5tzx3nZpGXuwu5z8yhAeH
=+Lc1
-----END PGP SIGNATURE-----

--yr6OvWOSyJed8q4v--

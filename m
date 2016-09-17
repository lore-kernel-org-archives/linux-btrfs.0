Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45972 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750774AbcIQCSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 22:18:08 -0400
Date: Fri, 16 Sep 2016 22:18:06 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160917021806.GB21290@hungrycats.org>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <bce627a8-7dcc-71f6-dd44-0444f7993725@gmail.com>
 <69c23d9b-c1be-41ba-1382-3505ba88fdf9@oracle.com>
 <ee07da59-9c9d-10f8-8cf5-6dc86a8e3eab@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
In-Reply-To: <ee07da59-9c9d-10f8-8cf5-6dc86a8e3eab@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 15, 2016 at 10:24:02AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-15 10:06, Anand Jain wrote:
> >>How does this handle cloning of extents?  Can extents be cloned across
> >>subvolume boundaries when one of the subvolumes is encrypted?
> >
> > Yes only if both the subvol keys match.
> OK, that makes sense.
> >
> >>Can they
> >>be cloned within an encrypted subvolume?
> >
> > Yes. That's things as usual.
> Glad to see that that still works.  Most people I know who do batch
> deduplication do so within subvolumes but not across them, so that still
> working with encrypted subvolumes is a good thing.

I do continual filesystem-wide deduplication across subvolumes, but I
don't think this is a problem.

There are already a number of conditions when IOC_FILE_EXTENT_SAME might
fail and deduplicators must tolerate those failures.  Cross-subvol dedup
has to loop over all duplicate block references (including those in
other subvols) until all references to one of the blocks are eliminated.
So dedup should still work by sheer brute force, banging extents together
until they stick, but it would be noisy and slower if it was not aware
of encrypted subvols.

If there's a way to look at the subvolume properties and figure out
whether the extents are clonable (e.g. equal key IDs =3D=3D clonable) then
it should be easy to avoid submitting FILE_EXTENT_SAME extent pairs
belonging to incompatibly encrypted subvols.  They can also be stored in
separate DDT entries (e.g. by extending the hash field) so that blocks
=66rom incompatibly encrypted subvols won't have matching extended hashes.


--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfcp94ACgkQgfmLGlazG5yYmACfc1JHg/FJtusyydAKM7mEM4ZW
QW0AoMQyMiErlRMPmdK73gYqGyF/bj/D
=hpAr
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44771 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750715AbdHWWbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:31:48 -0400
Subject: Re: [RFC v3 0/2] vfs / btrfs: add support for ustat()
To: Al Viro <viro@ZenIV.linux.org.uk>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: clm@fb.com, jbacik@fb.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
 <20140815092950.GZ18016@ZenIV.linux.org.uk>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c3b0feac-327c-15db-02c1-4a25639540e4@suse.com>
Date: Wed, 23 Aug 2017 18:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140815092950.GZ18016@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6F2gEO71gLnuXBPvxQCojo9wUbf78GHGV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6F2gEO71gLnuXBPvxQCojo9wUbf78GHGV
Content-Type: multipart/mixed; boundary="V0gxlC1CvowiXodUXCsDllS1WQudECd45";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
 "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: clm@fb.com, jbacik@fb.com, hch@infradead.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, fdmanana@suse.com,
 "Luis R. Rodriguez" <mcgrof@suse.com>
Message-ID: <c3b0feac-327c-15db-02c1-4a25639540e4@suse.com>
Subject: Re: [RFC v3 0/2] vfs / btrfs: add support for ustat()
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
 <20140815092950.GZ18016@ZenIV.linux.org.uk>
In-Reply-To: <20140815092950.GZ18016@ZenIV.linux.org.uk>

--V0gxlC1CvowiXodUXCsDllS1WQudECd45
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/15/14 5:29 AM, Al Viro wrote:
> On Thu, Aug 14, 2014 at 07:58:56PM -0700, Luis R. Rodriguez wrote:
>=20
>> Christoph had noted that this seemed associated to the problem
>> that the btrfs uses different assignments for st_dev than s_dev,
>> but much as I'd like to see that changed based on discussions so
>> far its unclear if this is going to be possible unless strong
>> commitment is reached.

Resurrecting a dead thread since we've been carrying this patch anyway
since then.

> Explain, please.  Whose commitment and commitment to what, exactly?
> Having different ->st_dev values for different files on the same
> fs is a bloody bad idea; why does btrfs do that at all?  If nothing els=
e,
> it breaks the usual "are those two files on the same fs?" tests...

It's because btrfs snapshots would have inode number collisions.
Changing the inode numbers for snapshots would negate a big benefit of
btrfs snapshots: the quick creation and lightweight on-disk
representation due to metadata sharing.

The thing is that ustat() used to work.  Your commit 0ee5dc676a5f8
(btrfs: kill magical embedded struct superblock) had a regression:
Since it replaced the superblock with a simple dev_t, it rendered the
device no longer discoverable by user_get_super.  We need a list_head to
attach for searching.

There's an argument that this is hacky.  It's valid.  The only other
feedback I've heard is to use a real superblock for subvolumes to do
this instead.  That doesn't work either, due to things like freeze/thaw
and inode writeback.  Ultimately, what we need is a single file system
with multiple namespaces.  Years ago we just needed different inode
namespaces, but as people have started adopting btrfs for containers, we
need more than that.  I've heard requests for per-subvolume security
contexts.  I'd imagine user namespaces are on someone's wish list.  A
working df can be done with ->d_automount, but the way btrfs handles
having a "canonical" subvolume location has always been a way to avoid
directory loops.  I'd like to just automount subvolumes everywhere
they're referenced.  One solution, for which I have no code yet, is to
have something like a superblock-light that we can hang things like a
security context, a user namespace, and an anonymous dev.  Most file
systems would have just one.  Btrfs would have one per subvolume.

That's a big project with a bunch of discussion.  So for now, I'd like
to move this patch forward while we (I) work on the bigger issue.

BTW, in this same thread, Christoph said:> Again, NAK.  Make btrfs
report the proper anon dev_t in stat and
> everything will just work.

We do.  We did then too.  But what doesn't work is a user doing stat()
and then using the dev_t to call ustat().

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--V0gxlC1CvowiXodUXCsDllS1WQudECd45--

--6F2gEO71gLnuXBPvxQCojo9wUbf78GHGV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZ4CTh57S2MheeWyAQi6HQ/8CSQh9HaYn8EeBwKJvzx6GUWWWYMwoflV
P2GNSoyRuvRVJ3LHqeScvCKj7LW0qRmYq0rk4DLy1L0UrHc/m8vZLTlLgJmf5vS1
BY9gDLSqJwZSqdRslc9IWlleC/qzndknTabtYRFd/IxDZSLXGY5Y08kvjrCEq7Fg
wbWmmuBEwkAVnkiaPioj/zTV5FttI47kWy3dWZMADSEUsXS9XQlwOADWdU6YB6Zu
6zyIm1f9Qh029vKbA2OllFVDAjhW49dS0snu2QRBwYuWlFzmTensMKokXnrbtn1+
tfmeByrwjsV6Z3YU7EQDYPftoLJISg6lOOctplURjNH/CcD2row+6aDslyVEZN5Z
81LnSvjXVuvL9JSxwzEYV1/MzZJdUKckmvpPAAiq2n4iuODgD+FAOm4x/zDN15Pv
c5W3pVOOKlQfkoeKMF1EqZhODXWlLhcZaFc4WbNXjstDjeQ9YJ2mOIzmh0HiXV0x
Y2h/cf+/xWbb86/Me6GFWn9o7z+8mRcPaCS3JaEmqUDCoKULz6cWokA8e4ckvkSr
H1obSQ8eqOSd7CqeUGRFKRsghrgO72lxcpLBf0FeVLyT916PKoYLKHA0zL8BwLLg
C4tHR6MGQweBOLslTx00JUQfzIv+vsF9e1KUnStfbM/tw0rW6CU0ant8a84z4hLg
XiEVnnOuEUI=
=crap
-----END PGP SIGNATURE-----

--6F2gEO71gLnuXBPvxQCojo9wUbf78GHGV--

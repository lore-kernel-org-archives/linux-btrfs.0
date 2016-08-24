Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:32796 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753819AbcHXAsX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 20:48:23 -0400
Received: by mail-qk0-f169.google.com with SMTP id z190so1453986qkc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 17:48:22 -0700 (PDT)
From: Jeff Mahoney <jeffm@jeffm.io>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <126611471805976@web2j.yandex.ru> <57BB5D1B.8040305@suse.com>
 <20160822230613.GA8256@birch.djwong.org>
Cc: Tomokhov Alexander <alexoundos@ya.ru>, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Message-ID: <57BCEED4.8070703@jeffm.io>
Date: Tue, 23 Aug 2016 20:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160822230613.GA8256@birch.djwong.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uQIoxH0kHfj7JMLfBewI0TR2A6Wo4pJw5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uQIoxH0kHfj7JMLfBewI0TR2A6Wo4pJw5
Content-Type: multipart/mixed; boundary="jLol872wbGP5v4vXGQSdHTkdiHqLsjf0m"
From: Jeff Mahoney <jeffm@jeffm.io>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Tomokhov Alexander <alexoundos@ya.ru>, linux-btrfs@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Message-ID: <57BCEED4.8070703@jeffm.io>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
References: <126611471805976@web2j.yandex.ru> <57BB5D1B.8040305@suse.com>
 <20160822230613.GA8256@birch.djwong.org>
In-Reply-To: <20160822230613.GA8256@birch.djwong.org>

--jLol872wbGP5v4vXGQSdHTkdiHqLsjf0m
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/22/16 7:06 PM, Darrick J. Wong wrote:
> [add Dave and Christoph to cc]
>=20
> On Mon, Aug 22, 2016 at 04:14:19PM -0400, Jeff Mahoney wrote:
>> On 8/21/16 2:59 PM, Tomokhov Alexander wrote:
>>> Btrfs wiki FAQ gives a link to example Python script: https://github.=
com/stsquad/scripts/blob/master/uncow.py
>>>
>>> But such a crucial and fundamental tool must exist in stock btrfs-pro=
gs. Filesystem with CoW technology at it's core must provide user suffici=
ent control over CoW aspects. Running 3rd-party or manually written scrip=
ts for filesystem properties/metadata manipulation is not convenient, not=
 safe and definitely not the way it must be done.
>>>
>>> Also is it possible (at least in theory) to "uncow" files being curre=
ntly opened in-place? Without the trickery with creation & renaming of fi=
les or directories. So that running "chattr +C" on a file would be suffic=
ient. If possible, is it going to be implemented?
>>
>> XFS is looking to do this via fallocate using a flag that all file
>> systems can choose to honor.  Once that lands, it would make sense for=

>> btrfs to use it as well.  The idea is that when you pass the flag in, =
we
>> examine the range and CoW anything that has a refcount !=3D 1.
>=20
> There /was/ a flag to do that -- FALLOC_FL_UNSHARE_RANGE.  However,
> Christoph and Dave felt[1] that the fallocate call didn't need to have
> an explicit 'unshare' mode because unsharing shared blocks is
> necessary to guarantee that a subsequent write will not ENOSPC.  I
> felt that was sufficient justification to withdraw the unshare mode
> flag.  If you fallocate the entire length of a shared file on XFS, it
> will turn off CoW for that file until you reflink/dedupe it again.

Is that a flag or just that it's reverting to "normal" XFS operation?
We have a nocow flag for btrfs, but it's more like nocow* because it's
still possible to create new references to the extents and those must be
CoW'd later.  I think that's about all we can offer since the nocow flag
set otherwise would imply that /every/ snapshot does a full copy of
anything marked nocow and I don't think that's the expectation either.

> At the time I wondered whether or not the btrfs developers (the list
> was cc'd) would pipe up in support of the unshare flag, but nobody
> did.  Consequently it remains nonexistent.  Christoph commented a few
> months ago about unsharing fallocate over NFS atop XFS blocking for a
> long time, though nobody asked for 'unshare' to be reinstated as a
> separate fallocate mode, much less a 'don't unshare' flag for regular
> fallocate mode.
>=20
> (FWIW I'm ok with not having to fight for more VFS changes. :))

Agreed. :)

>> That code hasn't landed yet though.  The last time I saw it posted was=

>> June.  I don't speak with knowledge of the integration plan, but it
>> might just be queued up for the next merge window now that the reverse=

>> mapping patches have landed in 4.8.
>=20
> I am going to try to land XFS reflink in 4.9; I hope to have an eighth
> patchset out for review at the end of the week.
>=20
> So... if the btrfs folks really want an unshare flag I can trivially
> re-add it to the VFS headers and re-enable it in the XFS
> implementation <cough> but y'all better speak up now and hammer out an
> acceptable definition.  I don't think XFS needs a new flag.

Thanks for the explanation, Darrick.  I'm not advocating for a flag.
That was just the last state of the implementation as I remember it.  I
missed the discussion turning to not needing it at all.

I suppose the only thing missing, and this applies to both XFS and a
future btrfs implementation, is documentation for the user explaining
that the guarantees fallocate makes about ENOSPC not failing are voided
by operations that can re-share extents.

-Jeff

--=20
Jeff Mahoney
SUSE Labs



--jLol872wbGP5v4vXGQSdHTkdiHqLsjf0m--

--uQIoxH0kHfj7JMLfBewI0TR2A6Wo4pJw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXvO7UAAoJEB57S2MheeWyjaYP/1UiOouIjQppz5FWSnBStPUQ
VryXior5q1pjhlBXJCvi4QZke4Fx5boBWt/ohqIr7Qwp8OBSuA+GCLDIaqV856N2
xz9EuFHwXsPy5NDEeX799nwGv0xsue3bGfo509jOBdCvj3EU2xWZzCcddLB/sq8Q
z5sOQAat/t1KJACddU14PHWhR0/7s/ScdOmx/YD/Q1H59pI2pqXg+nbgx0OpXYwE
cQZJWgc02XP/9CHiFI2d/6EkcfddAytKNUshSjFS9AdhvdW7T6CfVUG5VyHg5WRY
ph0Rxm5BDkahFcux1lz9hNmYI4xc21hRkgFl7Odm+/+RY3BtFM8wIKdf1NywZn38
hJ2WDcG9uu8a9e/y1hHhVJSEtHrG0U+xvV4B4NDZBVR/Z9PGpWQ8Ym0y6ThOX46+
Ywl4SR/KoY8UMkyywbnOyfkiyxZS9GZDmjLg8y7lKh5no9l/TgfwXb2r0Jo+KDEd
HvVzr+VpY0nM/XYEAlf6oKnXUn+gfaWgyIaXQTFd5XAbLuLyb+SoNwADukGguL7g
9eSexlvQru2qKDhQRehED8da1fYyd4B3FgnZHLcchb3b1EGEpin16ia5f2UZA6m1
dBACHHCGReITrSnqVq9sVTd4OCZ5fV+4azpFUZ0/izgFlU4RU1Ncby71emQ0DX4v
2naTixE0ZJzknFxV3yPL
=jdQh
-----END PGP SIGNATURE-----

--uQIoxH0kHfj7JMLfBewI0TR2A6Wo4pJw5--

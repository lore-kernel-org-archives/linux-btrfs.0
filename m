Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbaGPTNV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 15:13:21 -0400
Date: Wed, 16 Jul 2014 21:13:19 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, viro@zeniv.linux.org.uk,
        clm@fb.com, jbacik@fb.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffm@suse.com, fdmanana@suse.com
Subject: Re: [RFC 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140716191319.GN10393@wotan.suse.de>
References: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com> <20140716052919.GA3486@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
In-Reply-To: <20140716052919.GA3486@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 10:29:19PM -0700, Christoph Hellwig wrote:
> Isn't this the problem again the btrfs uses different assignments for
> st_dev than s_dev?  I don't even want to think about a mess like this
> before that is fixed.

As much as I'd like to see that happen based on discussions so far its unclear
if this is going to be possible unless strong commitment is reached... so what
this tried to do was to take the other way around the problem, by slowly
shifting out junk. Although I'm frankly new to this -- I think this approach might
be more feasible over time. As I see it this is an extension to Al's original
commit 0ee5dc676 but more in line with how they are really are used and exposes
more information to the VFS. As it stands now other filesystems can pop up and
do similar things, this at least extends the original API to fit the use case a
bit more closely to how its used and allows more room to grow.

  Luis

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTxs7PAAoJEPep4JnvMe6zxT4P+wTBzy3cElHo2NgkR36hwjBP
J1GhcgKZvrnlTaI4g3NtMlypCgC7fyhccNsEqSWJYUZqPJz75mHbTFVuQH3Uvoxi
MYn6ULD3dUtX0Inpp5HxbEw7SxNPWXFev+ERetwPZC8+YO+2zlzGh98GX1L3mX/q
Pj3Vn7rrAHn3cSD8aYr6cm8eW538dGG68OhcwJQ7MKmI8xTQgmw+t+fmjfXh1unj
aneDgbrnON14zl82WVKhC/JRrcdP8MFpV1W/yjdieHILnFImSLW8bzJ+SoZRtDmW
cQZUa8/1jR8D70/ZH42YZnaACSi59j5UKv9rhodqxSg/ZA8HqufKiG9Zvl/PZJuK
3UsSgzroiQe7/xYxLmR7JCloq7bSkg8cO9XZWVAlNkzMH2VJnDWJ1kqQC7EZzdY5
Z3sgL0rZLJzFYWlCdj1p/iVCfbx+FXSA4kArIjDe1kgPIWeirWEPkhxvoKpY1QVW
WOI+V2c7RWYol793QXSUsc02YCc6XVO75wfCOgUzBGMODCUk+4N35mgO8CFhKJ+z
bSKJCQXDPlJnv47m3G3Dgc5d4PVDorL6kG6Y+m4kTbzUmgT9HKdze49cxTYiIHr7
Gj/7e9jXjJGfV3RxlErXGjuqoTS1PTZYTcesNtQkB2W7w5QjsI1HJF0UZqAPh98D
p3lWcfpn7KvL8mg72nL9
=mNLj
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--

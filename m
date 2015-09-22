Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43999 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbbIVN2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:28:16 -0400
Date: Tue, 22 Sep 2015 13:28:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150922132809.GG5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
In-Reply-To: <560150CD.6070301@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 22, 2015 at 08:59:57AM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
[snip]
> So if they way we want to prevent the loss of raid type info is by
> maintaining the last block group allocated with that raid type, fine,
> but that's a separate discussion.  Personally, I think keeping 1GB
> allocated as a placeholder is a bit much.  Beyond that, I've been
> thinking casually about ways to direct the allocator to use certain
> devices for certain things (e.g. in a hybrid system with SSDs and
> HDDs, always allocate metadata on the SSD) and there's some overlap
> there.  As it stands, we can fake that in mkfs but it'll get stomped
> by balance nearly immediately.

   In terms of selecting the location of chunks within the allocator,
I wrote up a design for a pretty generic way of doing it some time ago
[1]. It would allow things like metadata to SSDs, but also defining
failure domains for replication (i.e. "I want two copies of my data in
RAID-1, but I want each copy to go on a different storage array"). It
would also give us the ability to handle different allocation
strategies, such as filling up one device at a time.

   I got as far as some python to demonstrate the algorithms and
structure (also in that mail thread). I started trying to work out how
to rewrite the allocator in the kernel to support it, but I got lost
in the code fairly rapidly, particularly about how to store the
relevant policy metadata (for the FS as a whole, and, later, on a
per-subvolume basis).

   Hugo.

[1] http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg33499.html

> - -Jeff
> 
> > If we delete all blockgroup for a raidtype, it not only cause above
> > bug, but also may change filesystem to all-single in some case.
> > 
> > Test: Test by above script, and confirmed the logic by debug
> > output.
> > 
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com> --- 
> > fs/btrfs/extent-tree.c | 3 ++- 1 file changed, 2 insertions(+), 1
> > deletion(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> > 5411f0a..35cf7eb 100644 --- a/fs/btrfs/extent-tree.c +++
> > b/fs/btrfs/extent-tree.c @@ -10012,7 +10012,8 @@ void
> > btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info) bg_list); 
> > space_info = block_group->space_info; 
> > list_del_init(&block_group->bg_list); -		if (ret ||
> > btrfs_mixed_space_info(space_info)) { +		if (ret ||
> > btrfs_mixed_space_info(space_info) || +		    block_group->list.next
> > == block_group->list.prev) { btrfs_put_block_group(block_group); 
> > continue; }
> > 
> 
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
> 
> iQIcBAEBAgAGBQJWAVDNAAoJEB57S2MheeWyCwoQAId9IK0vYX01W20SeLt5E5ql
> cabIeN3JCLcmtEbJzhNxQtcjvB7Rgq/r3BRDV0n0Z71dyv8WV8vau4Qka8xUVtLL
> l+sbuRIEBUR3UHOvqjV7MxSZeZrQZLWeGuCRH9El059hDn/JFsF9n3wJx8YsgXKe
> dma2RG6MHFVXY08jYkLc6nexBbYlc3Dj2jbd2Jr7gHy4YwFTCM9YncR+STV2K47Q
> N/pfRwiVHFHHVTju5lg3wzp+xvFPeU52cfWHL05axe8l75pU6Ywwrk406QxyrTvx
> 2Rh8tXBJItUeMA/D8mRnwWVZBWFUndl6JlBNSyf51fSP+4lPkChbM5UnSOjDOwvE
> E7XpGy31TQI0bqpy8qoIkI9wkek6iOlMCppZ9U2vICbeP+65WtNZKfQcCO0t6Z1H
> 6IqfHsaDvvaiorxEWWIarsIfHZWnWJeav545t6pd4VU3v52YQN2YIOLY8EhWv4Wt
> 90Xc1izPvPvnyQa3eQPg1ISdqNfJRFlYjSJ75zGvSPurIy77oOyvPa1EfEO7IMys
> zXyjgKzU6Yox1iXxeJsDxuAa+FX9P2rXqd8WYP2mBRqH2BE6D+R8V/NitGmXSkYA
> bBXN1H/m+gP5qhHLnBQZU+ABH1dDp6RJ1BCsg7iDJBmfE+hJI8YIwowwH/C0RBST
> 1HgsAUWHmDsjHcYr3/ZB
> =Li+/
> -----END PGP SIGNATURE-----

-- 
Hugo Mills             | "Big data" doesn't just mean increasing the font
hugo@... carfax.org.uk | size.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAVdmAAoJEFheFHXiqx3k5IEP/AsnSiKL864G8yZs80SiOfFL
bf/ESqZJf+5YrsH7khqvi9NSJD07QwqAcE8wjR4BZpJaNzTrLGbF7RJW6qNutKIb
rS8Wfj6GB8mL3qTYoRAJj5B5F3CbrI2Et6cYwREBA0F4IKwaxaspwo7zdEDbihK9
Dou1TAc8OC7EzX/6lX5dWgTg4gPhXdPpyrxC8mnLLRpL14BiLcwUAYs9esTiGbTK
zBSgREusJJfpP5UdR6CdJ6n28YjFjFjVTM2kU3TzbOMuI0oqji5fxLgvhFwmnsaA
7DRsRbeyWpN6YnuVMLHLBV9LwxNIy8h2eMfUfwfrOlVXketadfUL1I5EGBqOh5uk
IEkcN16WVnFXElsYtXayxI9ny23LomHAHK7wK6YS3zK+nrHSW+TfcCt8fAWTTyt6
pGfuDrimYnfH1X8AQ339kPpVpGvyZHjm84MV1N9GweXjhIhLN5CdhaMh2p0lUCJI
3BYtGbiwJJoEooeRsgsFXBtZ77LudaYR2AUZOkSa1XLgmzbbkDyboo6FBOCvYisY
2ORS31xmJMxu8YgX1Y9vlikIZmO9H+Xk9CeUOXRdeKvHUvRNTKIXQJViPW6HmeQT
O5j+LDrvszcJmEEXGlri+ueASj6BDphmZ3k7tn0o8KgH35L52Q9WPSI3cyMfSTN/
p3qqfdDNfHRe+mwIz2Qj
=RSUk
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--

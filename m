From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [PULL] Btrfs error handling v4
Date: Mon, 24 Oct 2011 19:54:41 -0400
Message-ID: <4EA5FAC1.5030508@suse.de>
References: <4EA5DDE5.9030700@jeffreymahoney.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Sterba <dsterba@suse.cz>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA5DDE5.9030700@jeffreymahoney.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/24/2011 05:51 PM, Jeff Mahoney wrote:
> Hi David -
> 
> Please pull from git://git.jeffreymahoney.com/linux/btrfs-unstable 
> for-david.
> 
> It contains the previously integrated v3 error handling patch with
> an updated ("btrfs: clear_extent_bit error push-up") commit that
> resets the return value in btrfs_direct_IO.
> 
> This branch is built on the base of the integration branch you sent
> me previously. If it needs updating, let me know.

Actually, scratch that. The next thing I wanted to do was add
__must_check and that should be integrated into the set, not an
afterthought.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6l+sEACgkQLPWxlyuTD7LP/QCfT5A4lSX4ensbX5DCyeFkoMR5
+qEAn26h1Nl7YVlpXtu4EAjuuM2Vt9lG
=8K4x
-----END PGP SIGNATURE-----

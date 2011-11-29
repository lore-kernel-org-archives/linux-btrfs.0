From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: btrfs/git question.
Date: Mon, 28 Nov 2011 20:58:08 -0500
Message-ID: <4ED43C30.50502@cfl.rr.com>
References: <af6c5f5cb5a1778a8d811e8293dfdd73@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <af6c5f5cb5a1778a8d811e8293dfdd73@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/28/2011 12:53 PM, Ken D'Ambrosio wrote:
> Seems I've picked up a wireless regression, and randomly drop my WiFi
> connection with more recent kernels.  While I'd love to try to track down the
> issue, the sporadic nature makes it difficult.  But I don't want to revert to a
> flat-out old kernel because of all the btrfs modifications.  Is it possible
> using git to add *just* btrfs patches to an older kernel?

Sure: use git rebase to apply the patches to the older kernel.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7UPDAACgkQJ4UciIs+XuLauQCgi9iTXZGD5BVTyTQJoc3Mm1R4
Oi8AmwX0oqwdF4e3dOTtAoUgFeYbKnOt
=i3i2
-----END PGP SIGNATURE-----

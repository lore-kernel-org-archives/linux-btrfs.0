From: Dave <dave@thekilempire.com>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Tue, 1 Nov 2011 11:06:05 -0400
Message-ID: <20111101150605.GA28280@hendrix.borisch.local>
References: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: "Fajar A. Nugraha" <list@fajar.net>, linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Thu, Oct 27, 2011 at 08:32:09PM -0400, Ken D'Ambrosio wrote:
> root@ubuntu:/tmp/btrfs-progs# ./btrfs-zero-log /dev/sda1
> parent transid verify failed on 100695031808 wanted 217713 found 217732
> parent transid verify failed on 100695031808 wanted 217713 found 217732
> parent transid verify failed on 100695031808 wanted 217713 found 217732
> btrfs-zero-log: disk-io.c:413: find_and_setup_root: Assertion '!(!root->node)'
> failed.

This is the same bullshit I dealt with back in August.  In short, your data is
likely fine.  btrfs is preventing you from accessing your data because there is
something wrong with the csum tree.  My solution was to create a custom kernel
which ignored all checksums.  I was then able to mount the filesystem read-only
and copy data to another volume.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/12344

I've had this happen to me on two occasions.  The first time was after a hard
reboot.  The second was on a totally different machine at a different geographic
location, which occurred after nothing more than a reboot.
- -- 
- -=[dave]=-

Entropy isn't what it used to be.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EAREIAAYFAk6wCtwACgkQXM0u5ajNnCj7bQD+LWnK+rF6t3ajkeFfFYfap8eA
eaeRWtH/uVkO3RMTFEMA/1H9aBSDWxfhtFd6a11KRYm5MYYonYtfMtpDqxgl7H0k
=MNIf
-----END PGP SIGNATURE-----

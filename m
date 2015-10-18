Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59887 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbJROkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 10:40:18 -0400
Date: Sun, 18 Oct 2015 14:40:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Xavier Gnata <xavier.gnata@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs autodefrag?
Message-ID: <20151018144015.GV25907@carfax.org.uk>
References: <56227910.7000208@gmail.com>
 <CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VGJtZYeI3LbW67dD"
In-Reply-To: <CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VGJtZYeI3LbW67dD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 18, 2015 at 10:24:39AM -0400, Rich Freeman wrote:
> On Sat, Oct 17, 2015 at 12:36 PM, Xavier Gnata <xavier.gnata@gmail.com> wrote:
> > 2) Disabling copy-on-write for just the VM image directory.
> 
> Unless this has changed, doing this will also disable checksumming.  I
> don't see any reason why it has to, but it does.  So, I avoid using
> this at all costs.

   It has to be disabled because if you enable it, there's a race
condition: since you're overwriting existing data (rather than CoWing
it), you can't update the checksums atomically. So, in the interests
of consistency, checksums are disabled.

   Hugo.

-- 
Hugo Mills             | Nothing wrong with being written in Perl... Some of
hugo@... carfax.org.uk | my best friends are written in Perl.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                  dark

--VGJtZYeI3LbW67dD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWI69PAAoJEFheFHXiqx3kNisP/AglrodgmR1Ssl+2n6j+9dG/
TYra1X2PjdLS1eYqj15zULKHgyuHJNuKDcA/659MPP8dAJ3C14m9yNeoYe0bPMUd
Ws9yfepx5nQkGgKIoyPxjSfq8dzCmWH2WdIsjcC+/I/0Zt9HYJtZFLDOZ32KHRR8
Hd/sl/fslsMqhx3hYQOABN+DoN+FNiOeCGtAKtNwaXuR8mpu9cCLuMR9tGzu4fZ6
3JMNBIb1y5dJV2A2YwCpjrAQx4/atfwfCWNPao0LH9UDLEmYshMy0aIySzlYE4xB
GFWPhkc1DH1xULeN0QOu0ied0BRjQreR+8UemfK6QDZfjtasVM9dQV++6f4yvYQW
PwLn/td3qXNvouGaV1xhCwMSiosrWhC/cVicDEx5A54SImkbDMcP6Qi4PxTCnDrH
KsVlWZ2k7bbTtSQtH9c5qXfW+jvIlU5x+R2qI3iJAhBO9yJPEC3fzuHcimFeOYuL
DwLlQ5zMC1QKN/mHlGscvoF5aksjXTJot5dpMnxELsLijeo6srxKSOQQmfCEdyXq
oF8d5EJ+rluZ9uFshkzw4HFeN46oUkiDswIGKuWJ3Mg8bF/EzjsD6Il7vW5w1kgf
rJ00DpjfWsIhCap5ywA9slkWfn4tJXwvEk4sS4jl7RMcGU7ExYHz8ObnL2hKBfUK
tDdF3ckTuIdwebUj7qdg
=Y7HA
-----END PGP SIGNATURE-----

--VGJtZYeI3LbW67dD--

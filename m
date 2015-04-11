Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60962 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbbDKUst (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Apr 2015 16:48:49 -0400
Date: Sat, 11 Apr 2015 20:48:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Philip Seeger <p0h0i0l0i0p@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance {,meta}data to raid5 not working?
Message-ID: <20150411204847.GA22084@carfax.org.uk>
References: <20150410221049.GE9470@wloczykij>
 <55298865.9080401@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
In-Reply-To: <55298865.9080401@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 11, 2015 at 10:47:33PM +0200, Philip Seeger wrote:
> A two-drive RAID5? Try 3 drives (btrfs dev add <new-drive>
> /mountpoint first).

   2-drive RAID-5 should work on btrfs. It's functionally equivalent
to RAID-1.

   Hugo.

> On 04/11/2015 12:10 AM, Piotr Szymaniak wrote:
> > I tried today to balance two drive btrfs raid1 to two drive btrfs raid5
> 
> 

-- 
Hugo Mills             | The enemy have elected for Death by Powerpoint.
hugo@... carfax.org.uk | That's what they shall get.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                   gdb

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVKYivAAoJEFheFHXiqx3ko+oP/jb4n9Fz3VYqZG+ZHTWsPiZY
f1bINQdPS1hUjXdgp1YtpEH5hFCcU82RwTUFYnQ4lqRKDrb+cj/QsAbodLSbUzEU
AxaZxKO96YKYN1FGKyml0iRXvkLHMJ1eN6OrAH4FcwjHCyAilRtLA7lmD4kIly9T
k8iIwrhEh7P1Dnvco+RLAtUzk8enIPEU0fAQeMSN1mhbm+rTWqRTxmted4TOerZV
ZMNgCLmaqDcZ++fCm59OarG5tibTpfqL7OOkYerKQqcJRdhLAX31BYPwvFJUBCzs
9kND+xCMw/bGAjPon2rsoASKldGKhYs9AQz1aiTCgeRlrgMCBXoxMCcPfyIhiIJ/
V7u9w1N1pSyItKiLUcb5r8b/xR2n3T9+/8hOhRweZJGT18g7WAPBxmcgmZCaCaNa
vprrkPCLETsq77fc9a+V6H0Uh+NYMff+ZipSiPXLTnOTdKe1jOxwkKzoRBmt1b/y
30uqOFgX1Axxj54zZMFn6H08gQsHCxhHQjIGemRaGJTO338V8nyHg/u8gmQVMSG1
YazHfAgZfeHJiwWMkSk17Z6fBeixnZrDwIfGfo8cCLVQjIqz6skUXznRGatMM8RM
cfcIWTLgY0Vl17sJL2iaVWvSEBsG4Oza2/W3yYMNrNhL2+2RYW8iEHGtGXRQzCbO
brfwMuMORlsWr8ISJuRh
=qf3E
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--

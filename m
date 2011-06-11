From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: strange filefrag output on btrfs
Date: Sat, 11 Jun 2011 17:39:15 +0200
Message-ID: <4DF38C23.7010603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,

On one of my btrfs volumes I see a strange output from filefrag when
run against a particular large (~8GB) file. filefrag and filefrag -v
give me a different number of extents, see below.

aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img | grep extents
funtoo.img: 2624 extents found
aph@thor /mnt/nutshell $ sudo filefrag funtoo.img | grep extents
funtoo.img: 2653 extents found

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN84wiAAoJEJIcBJ3+XkgikzsQAKlH4dMcDMAplulM67TNUDRy
hMwQhgpkLTBfvB7SRcNImojPwj2TQq6CXWHqk+yjufN6Mz4Tb1F5vWbgPwQOkC3S
BNtNCJrua6COO2ijOv12UubTY6qQZqXSXNB2be5SVeh9Jt+DUZ55EJRUlhbPb7al
xhXIRNzIW4P0TfTfLgrQ4cZT+89FGilMe0x4YAw6TCl50f28X7Xjj94UHurM/wzX
eX2rR37GALSOw2CwIR2m9fmTOPXw61puXyx2ddO4iv3KWmu8lpp9Cl7QkacSKpOd
kxg0jFVAGj7NAeZU4ekVqZq0GVOqlNEwYfAZyGPI6D6PfO+Fj7l+hWh2aohv0GsL
xU1mcN9d7X+dvwt4NwbAS3H+ZlHIwJeRIdKyFwvMu3gyLmASuDJIZfFkomFzSfjN
DNMWvJdXoB4NZoi4I4cIIrQkcVHwglz3NjjCTErbvKHP7oALXqKGVaB2jIQQCOzz
gi201uGWaOM/tbIUGUxe9nL2cMfID+frMtBng7Q0muPiI57ek4vm7c2wA//2PK9S
/ZGfhzgZPOWQcULhzQ1/o9vIq6asnnd3eGAgEQAeuO90QAEMrnUY8MAsfK8m3i0L
EU7XyziQ3j2vXrN5HKkEJiKHjCrnK7/kFG0y0L5iWGBt0/29YMYqAqxDSvu7RXo/
laQ+Z6t5BcfRrP3I2lX/
=6T05
-----END PGP SIGNATURE-----


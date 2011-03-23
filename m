From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: read-only subvolumes?
Date: Wed, 23 Mar 2011 09:21:59 +0100
Message-ID: <4D89ADA7.2000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi all,

When I am creating subvolumes I get this strange behavior. If I create
a subvolume with a name longer than 4 characters it is read-only, if
the name is shorter than 5 characters the subvolume is writeable as
expected. I think it is since I upgraded to kernel version 2.6.38 (I
do not create subvolumes on a regular basis.). I will compile one of
the latest 2.6.37 kernels to see whether there the problem exists,
too. Another interesting point is that previously created subvolumes
are not affected.

Thanks,
Andreas Philipp

thor btrfs # btrfs subvolume create 123456789
Create subvolume './123456789'
thor btrfs # touch 123456789/lsdkfj
touch: cannot touch `123456789/lsdkfj': Read-only file system

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNia2nAAoJEJIcBJ3+XkgiTQQQAJqvn+zYbDmqmSo8ZRG86ssR
Tj0hsaAYjSWiIUxs7Y9XulmC0sZoSpvX5BLIjW1pYwECzhzrA//pQrwVbXgwbW5H
VjZ+YxcOcw4jxoUbW3lG+KYtSFMJFtbdMejmCY3GgYYIq1mtn0hBrCqZJ0syl4LO
IjyTHR/v0r7FMIgL26F1jOfC478RfhIxAgZOtd65kl7/pHOv5At+99tgM4teUoy0
I76CWu6Ls9+1XevxMWp39XNceYCtQ/WoEThuQCvPERq6Th3NWczPBTP3POSBetVA
Kcomq0TmgXQx1ZalFAFpMi9iRriDXbSm3ITSZW6Jp2BSEPurzpydchfhg0AWVNcC
Icp5b+dy2RVM/K5UNDO6lNf8p+K1wk8GGpD/Pr+K0lO0FlKX+6rApzgx54GYL3cx
0RYL+NAAwSpy1i2uBIw72gyGX/yBliX7CB+YZZ/iULk0eUd36FvpJJAJ1Isk+QNn
6WFBoRwsMrL3WfiqR5/ODO+i+z+CUzYU0mUnD9IuQkdCANyXOeQhs5AyMOPkB1NC
SS9ChpL60khwmLs9c99AyIzcvZU/q12JMvOZ2YUnfEHNIC/XmaThq11RbCIWIsl2
vjPr1QvKK+aykaOfjiTgLTwvB3mq147uEAylzIkduiQSFizMudbsI9vcO/X2pcy3
SVO9m6tlBUsCq3dU1dcA
=NEEb
-----END PGP SIGNATURE-----


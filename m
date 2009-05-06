From: Michael Raskin <7c6f434c@mail.ru>
Subject: Re: [BUG] fallocate behavior when crossing end-of-file
Date: Thu, 07 May 2009 01:07:18 +0400
Message-ID: <4A01FC06.80703@mail.ru>
References: <4A018A90.7050109@mccme.ru> <4A01A5DF.5050406@gmail.com> <4A01A8C4.20205@mail.ru> <4A01AE6E.1050400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A01AE6E.1050400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Edward Shishkin wrote:
>> <<<
>> If the offset+ len is beyond the current file size, then
>> posix_fallocate() shall adjust the file size to offset+ len. Otherwise,
>> the file size shall not be changed.
>>   
> 
> fallocate (2) is something different from posix_fallocate:
> 
> "...This default behavior closely resembles the behavior
> of the posix_fallocate(3) library function, and is intended
> as a method of optimally implementing that function."

If you overincrement file size counter, the only way for glibc to
correctly implement is to ftruncate after fallocate . It doesn't look
like an optimal implementation of posix_fallocate (2 system calls). It
also doesn't look like something glibc would do. It currently doesn't.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKAfwBAAoJEE6tnN0aWvw3NQAH/2XFOZE/9MBAxySxOyNY9Gft
ttotQ4+g7SuKX47tQzskcWde3qbofEYzrsF/ADebjczEwbiKcZaJwlLzqL1X6siC
IWzBS8hIWbbKkyF2erQJP3QZEJq/IwRCK6bOj8EJckGJ6q6tLCIasXGs+GOAjhrB
1NWjDfprXP5M4s1xvG9KRH4Lo38Bz4/5w7ZGqGuXOy+M21ZHim+o9Tbkp7LaV9KP
OHqxgXV6tpHHv+Ai16cR1cJzY8XAIZ6EsL4lfpw7nZGlgRC+snccNdyoN3MltFOG
fbqIxrcPb8jL+3sAY+F1EK9oOKrCjQhY8VKxksy++M8+uP7OmgRiRkPyNewbYlw=
=fY9t
-----END PGP SIGNATURE-----

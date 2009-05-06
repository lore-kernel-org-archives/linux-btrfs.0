From: Michael Raskin <7c6f434c@mail.ru>
Subject: Re: [BUG] fallocate behavior when crossing end-of-file
Date: Wed, 06 May 2009 19:12:04 +0400
Message-ID: <4A01A8C4.20205@mail.ru>
References: <4A018A90.7050109@mccme.ru> <4A01A5DF.5050406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A01A5DF.5050406@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Edward Shishkin wrote:
>> Desired: something (probably, one block) is allocated/reserved for the
>> file. File length is set to 1 byte.
>              
> Where is it documented?
> 
> IMHO we should only guarantee that writes
> to [0, 1] won't fail because of lack of disk space.
> Other things (including file size) are up to implementation.

POSIX, SUS.

http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html

<<<
If the offset+ len is beyond the current file size, then
posix_fallocate() shall adjust the file size to offset+ len. Otherwise,
the file size shall not be changed.
>>>

Michael Raskin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKAajDAAoJEE6tnN0aWvw3umYH/Rhcs2m4UosPLOsSylVAiFiB
rRJbeYWX5xaw9wTCV7RW3BkAEM2gJ5De10j4x7g81L7GZQZNz3Pwu6WN+kQOrBnG
gSeCg7u5OpvJUrX6HxeJEeUOCg9VDzuTNyEWY3pUEo7L00MLuYqTQimg2pua3oAv
Ib7bUWVfRguxgQVO7pnw//CV6L+KBY7OP2za+c2x+Ec+KN0QsgAlYATxNP9+hI4o
VJL7nIGoAs5rZXkLuDJpQYgI2sl6yzZy1Jq0Q3+UnjDDLlU945yMQm4LGTEMMHJX
i/Ci58y+SNhiDFrPrW1nRCZXE0RiEk01hGTtVVI2yfZJz/dabZAtSgEbyp0k0/c=
=6Fmf
-----END PGP SIGNATURE-----

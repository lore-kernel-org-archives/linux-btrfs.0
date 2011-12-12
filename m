From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH] btrfs: change resize ioctl to take device path instead
 of id
Date: Sun, 11 Dec 2011 22:49:03 -0500
Message-ID: <4EE579AF.7050101@cfl.rr.com>
References: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com> <4EE57580.8080907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE57580.8080907@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/11/2011 10:31 PM, Li Zefan wrote:
> Phillip Susi wrote:
>> The resize ioctl took an optional argument that was a string
>> representation of the devid which you wish to resize.  For
>> the sake of consistency with the other ioctls that take a
>> device argument, I converted this to take a device path instead
>> of a devid number, and look up the number from the path.
>>
> 
> but.. isn't this an ABI change?

Technically no, since the ABI is just a string that may (undocumented) have a colon in it followed by digits.

> so instead of changing it, I think it's ok to extend it.

I considered that at first, but the existing code appears to not handle errors ( what happens when the string can't be converted to an integer? ) and the interface has not been documented until now, so I figured may as well just get rid of it.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7leawACgkQJ4UciIs+XuIJ3ACeKuQidLKrb/nVqaS13Z1yzzoh
MDAAoIIPhBEnAbmTWdc6M4NBQUdX1+Pv
=7JV1
-----END PGP SIGNATURE-----

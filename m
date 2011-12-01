From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Resize command syntax wrong?
Date: Wed, 30 Nov 2011 19:01:44 -0500
Message-ID: <4ED6C3E8.60009@cfl.rr.com>
References: <ByrPr1UD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ByrPr1UD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/30/2011 01:59 PM, Helmut Hullen wrote:
> Hallo, Phillip,
> 
> Du meintest am 30.11.11:
> 
>> Currently the resize command is under filesystem, and takes a path to
>> the mounted filesystem.  This seems wrong to me.  Shouldn't it be
>> under device, and take a path to a device to resize?
> 
> No - it's a filesystem operation.

No, it isn't.  You can see the function that implements the resize in the code operates on a specific disk, and the ioctl does take as an argument which disk you are trying to resize.  Logically you are adjusting the space that is available on a particular device, which only indirectly affects the filesystem.  In other words, the only reason that the size of the filesystem changes is because you have changed the size of a device.  In fact, internally device removal is implemented by first resizing the device to 0.

It appears that the utility just passes devid=1 to the kernel when you don't specify it.  It should take a dev node as an argument and translate it to the devid for you.

> p.e.
> You start with a system of 2 disks. They get filled nearly  
> simultaneously.
> Then you add a 3rd disk (which is empty at that time). Now it's a good  
> idea to run "balance" for equalizing the filling.

balance != resize

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7Ww+gACgkQJ4UciIs+XuJjlwCgr2u3zvuhYWC0vv9ObdhBS41Z
M3MAn09xhEopzuIJdN4QP+8bQvYzhvo1
=Qck2
-----END PGP SIGNATURE-----

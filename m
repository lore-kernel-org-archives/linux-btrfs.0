From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Packed small files
Date: Fri, 10 Feb 2012 14:02:26 -0500
Message-ID: <4F3569C2.7090809@ubuntu.com>
References: <CAJJ3ruHxPqL6YRktpK+5V7Hgn2aAe=BCJLyicoLmYkxO4sVh1g@mail.gmail.com> <20120131164610.GE5531@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Hans Stimer <hans.stimer@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120131164610.GE5531@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/31/2012 11:46 AM, Hugo Mills wrote:
> So you're looking at a minimum of 413 bytes of metadata overhead 
> for an inline file, plus the length of the filename.
> 
> Also note that the file is stored in the metadata, so by default 
> it's stored with DUP or RAID-1 replication (even if data is set to
> be "single"). This means that you'll actually use up twice this
> amount of space on the disks, unless you create the FS with
> metadata set to "single".
> 
> I don't know how these figures compare with other filesystems. My 
> entirely uneducated guess is that they're probably comparable,
> with the exception of the DUP effect.

On ext4 you are looking at 256 bytes for the inode, name length + a
few bytes for the directory entry, another few bytes for the hashed
directory entry, and a whole 4k block to hold the data, so ~4300 bytes
( + name length ) of overhead to store a 64 byte file.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPNWnBAAoJEJrBOlT6nu75lVkIAIO2mjYeVK5BbMNfw5HJ7jZO
WfIBv5xR8V06e0VLgv4FQqPlWcm+ZQHorYDM7h15q4cIgoZ3x0P3n3bSCurFRLfF
lSRjn/fsX1Y9isPEB6/monPm+08U6qh7jXGldEMOLKaA7VG/QOVR01k3W2a3FkJ4
kWBjEbK/xE013WaQnfR26PydRT8ILRzGUE4uEKGsdV39JkcEorQ1lDg+XWz5Hvy7
VmelT21272PssIUbRub1QkZXj6p0SUu1zeU1IwOdt6X1uXFcWqFbBFRGJk4f2+ZM
5MquuVC+YrzfDIBnS0ZBZ4UqNmxYuPCSzTLlpPiJJiY/AwR7916H/CoF5k38k/M=
=8YmX
-----END PGP SIGNATURE-----

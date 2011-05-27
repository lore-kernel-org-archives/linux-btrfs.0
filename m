From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 12:06:44 +0200
Message-ID: <4DDF77B4.4040505@gmail.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com> <20110527091224.GA15627@carfax.org.uk> <chaz20110527093029.GA30613@seebyte.com> <20110527094523.GA12089@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Stephane Chazelas <stephane_chazelas@yahoo.fr>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110527094523.GA12089@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 27.05.2011 11:45, Hugo Mills wrote:
> On Fri, May 27, 2011 at 10:30:29AM +0100, Stephane Chazelas wrote:
>> 2011-05-27 10:12:24 +0100, Hugo Mills:
>> [skipped useful clarification]
>>>
>>> That's all rather dense, and probably too much information. Hope
>>> it's helpful, though.
>> [...]
>>
>> It is, thanks.
>>
>> How would one end up in a situation where the output of "btrfs
>> sub list ." has:
>>
>> ID 287 top level 285 path data
>>
>> How could a "subvolume 285" become a "top level"?
>
>> How does one get a subvolume with a top-level other than "5"?
>
> This just means that subvolume 287 was created (somewhere) inside
> subvolume 285.
>
> Due to the way that the FS trees and subvolumes work, there's no
> global namespace structure in btrfs; that is, there's no single data
> structure that represents the entirety of the file/directory hierarchy
> in the filesystem. Instead, it's broken up into these sub-namespaces
> called subvolumes, and we only record parent/child relationships for
> each subvolume separately. The "full path" you get from "btrfs subv
> list" is reconstructed from that information in userspace(*).
>
> Hugo.
>
> (*) Here's how it does it:
>
> The userspace tool gets a list of every subvolume by looking at the FS
> tree. It uses the corresponding back-refs to get the inode that
> represents each of those FS trees inside its parent:
>
> Subvol inode in subvol
> 256 991 5
> 257 896 256
> 258 1073 257
>
> From the inode numbers, it can then recursively walk back up the
> directory path to the top of each subvolume:
>
> Subvol inode in subvol relative path
> 256 991 5 henry
> 257 896 256 edward/mary
> 258 1073 257 elizabeth
>
> From that, it can then reconstruct the full pathnames, by walking back
> up the subvolume tree:
>
> subvol 258 is elizabeth in 257
> is edward/mary/elizabeth in 256
> is henry/edward/mary/elizabeth in 5
Just one (hopefully) short question: A line in the ouput of btrfs
subvolume list like
ID 257 top level 5 path test1/test1.1
says that the subvolume with name test1.1 (the last segment of the
path) and ID 257 has the path test1/test1.1 starting at the top level
subvolume which has ID 5 ?

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN33ezAAoJEJIcBJ3+Xkgi3egP/25y7JjnHJ9ZfQ2TF0cVWlhh
4FSHKhXlokH7E8fMcBbwP6YTB2zJioRkdWKmzoNjAvLlL8QkI7PvljAipe7YMgai
Zq+FNzN2y6qkpNBhdpJC0rnURbtD7neDdcRCDF3uatP2p+m6UghfPyTfqX31h1qc
UOp+3r+HLvlhAtKILxRaIZHidpS9ThZyN2mFHyKbyMMCoFYRXlJwL8xurPWdInbQ
sgjDmXVstsnoTcDaCsdWfUkRiLyPeiieOgCiB0X+/GdEG/gE6ICtzOf93fIeJu/B
CdGoaOSz73UIPdXstqiawhKxB83Ly68GNfoc/mrjFEml91KalGUnq/6f/344u6mB
2Ipwn1dpeC5ImwZO+VEc1HSv/GPCWyotUFzjV8NB/CcYYehX8GiNY0cSaT0NjTzs
ycUOOJUTWHTmavdT8ryDILPqSsqzMnN9NnrjJhs7EjEXSkvRxNQ4vUNOsWvCPjJl
HlooInMQ8/QTBkBLPkkiHWmhNuUaMPH6DJ85v6RNpFLiyf9TFDzBJvvyrZbkWx2y
tIvg8C1oKuZ1iulZidfY36h2wf4u/DuYgNYPSL0vsdOfABStn9MBeqPbqeF6fF42
AJ0gzVd+cqIWiFbnXEi4Zxt72l1DViLqe3Rxij2u00QOPRMtgGoKcwY7WmLKBnU5
1/vjmYvTJNnShewXMvsh
=zCSk
-----END PGP SIGNATURE-----


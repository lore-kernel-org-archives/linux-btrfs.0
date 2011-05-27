From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 13:49:52 +0200
Message-ID: <4DDF8FE0.9040107@gmail.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com> <20110527091224.GA15627@carfax.org.uk> <chaz20110527093029.GA30613@seebyte.com> <20110527094523.GA12089@carfax.org.uk> <chaz20110527113010.GA12775@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110527113010.GA12775@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 27.05.2011 13:30, Stephane Chazelas wrote:
> 2011-05-27 10:45:23 +0100, Hugo Mills: [...]
>>> How could a "subvolume 285" become a "top level"?
>>
>>> How does one get a subvolume with a top-level other than "5"?
>>
>> This just means that subvolume 287 was created (somewhere)
>> inside subvolume 285.
>>
>> Due to the way that the FS trees and subvolumes work, there's no
>> global namespace structure in btrfs; that is, there's no single
>> data structure that represents the entirety of the file/directory
>> hierarchy in the filesystem. Instead, it's broken up into these
>> sub-namespaces called subvolumes, and we only record parent/child
>> relationships for each subvolume separately. The "full path" you
>> get from "btrfs subv list" is reconstructed from that information
>> in userspace(*).
> [...]
>
> Thanks, I can understand that. What I don't get is how one creates
> a subvol with a top-level other than 5. I might be missing the
> obvious, though.
>
> If I do:
>
> btrfs sub create A btrfs sub create A/B btrfs sub snap A A/B/C
>
> A, A/B, A/B/C have their top-level being 5. How would I get a new
> snapshot to be a child of A/B for instance?
>
> In my case, 285, was not appearing in the btrfs sub list output,
> 287 was a child of 285 with path "data" while all I did was create
> a snapshot of 284 (path u6:10022/vm+xfs@u8/xvda1/g8/v3/data in vol
> 5) in u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30
>
> So I did manage to get a volume with a parent other than 5, but I
> did not ask for it.
Reconsidering the explanations on btrfs subvolume list in this thread
I get the impression that a line in the output of btrfs subvolume list
with top level other than 5 indicates that the backrefs from one
subvolume to its parent are broken.

What's your opinion on this?

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN34/fAAoJEJIcBJ3+XkgiTVcP/iQ62XnEAS0rVGOl+0DNqySb
5A5N3/pzhgzOdMhldJYtgg0K60lV0qs0H31ITgOdGUtpEXibybU/6Yuy2yIfqx0T
3OQCb2KE8la2hlh472aTuIN3beljFYzPu89KVrGaT6kD7lABRXkCG5y1Y5+fvVXI
gtq5/mCqvyaxxUMTppgzLHwtt0YVICZeCDmALMtsVe1DMr0uT5QI0XY+4Glpl7AJ
1G6Plyr7qciOwdRgvM/7NkHl/gsJ4GEvIOSVFiBM4Hb8fX7APy/C//sIPfD2Kg5K
7B6sJMpS2i87uEsrr+w8j7nLWn9Y/255W89r/cG3uISDFRn/RDs9xEnRCfEXb6qf
ZeBPVfv9+pN6mmwrfUOJr4pb44f9/UgTC+udCfzKm1yWVci895NIGsfJgYfA0OOf
GRnCWVRwFStiUGf0uSRH0yJAW5ozI8DzDnDKzByFpMcmw3eVNq5usCftA4XxVi7r
Wu/v9z6DNdHj7ibsSdeYXAmVGpwennILPeEvGWDbMB/OZIDKC3s75yCzXIhxWpya
zR5jGDbGj9IkvUhSAwW0afFqBK+bZny/SJsqA0vFH7Emao0CG1FIJVlN7/S6OSg1
Dtye//ocjhO0kf3OX3hj689n4/mvaBZeVArCz5vJzG2wEcRZTF4DZ4ApsUjne0LC
q4L2n9nLM4yeAs+YjFx/
=R53y
-----END PGP SIGNATURE-----


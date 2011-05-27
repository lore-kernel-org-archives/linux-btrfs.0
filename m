From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 11:24:48 +0200
Message-ID: <4DDF6DE0.3050109@gmail.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com> <20110527091224.GA15627@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Stephane Chazelas <stephane_chazelas@yahoo.fr>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110527091224.GA15627@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 27.05.2011 11:12, Hugo Mills wrote:
> On Fri, May 27, 2011 at 09:47:33AM +0100, Stephane Chazelas wrote:
>> 2011-05-27 10:21:03 +0200, Andreas Philipp:
>> [...]
>>>> What do those top-level IDs mean by the way?
>>> The top-level ID associated with a subvolume is NOT the ID of this
>>> particular subvolume but of the subvolume containing it. Since the
>>> "root/initial" (sub-)volume has always ID 0, the subvolumes of "depth"
>>> 1 will all have top-level ID set to 0. You need those top-level IDs to
>>> correctly mount a specific subvolume by name.
>>>
>>> # mount /dev/dummy -o subvol=<subvolume>,subvolrootid=<top-level ID>
>>> /mountpoint
>>>
>>> Of course, you do need them, if you specify the subvolume to mount by
>>> its ID.
>> [...]
>>
>> Thanks Andreas for pointing that subvolrootid (might be worth
>> adding it to
>> https://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options
>> BTW).
>>
>> In my case, on a freshly made btrfs file system, subvolumes have
>> top-level 5. (and neither volume with id 0 or 5 appear in the
>> btrfs sub list).
>>
>> All the top-levels are 5, and I don't even know how to create a
>> subvolume with a different top-level there, so I wonder how that
>> subvol that I had created with
>
> Actually, top-level subvolume ID=0 is a fiction. Internally, each
> subvolume is a separate FS tree (an FS tree in btrfs is a btree
> containing all of the inode and directory information for some
> subvolume). These trees are all referred to by a tree called the "root
> tree", which indexes all of the btrees in the filesystem.
>
> The root tree has a unique reference ID for each tree that it
> points to: most of the trees (extent tree, device tree, etc) have
> fixed and well-known IDs smaller than 256. The FS tree for the
> top-level subvolume -- the one that doesn't show up on a subvolume
> list -- always has ID 5. Hence the containing subvolume for most of
> your subvolumes is 5. The FS trees for the non-top-level subvolumes
> have IDs starting at 256 and increasing monotonically.
>
> Internally, there's a bit of a fiddle in the API, where a request
> for a subvolume ID of 0 is (sometimes) translated to an ID of 5. It's
> not always done, I think, and those cases where a subvol ID of 0
> doesn't get you the top-level subvolume should be treated as bugs.
Thank you for all this information. Once I had a such a situation,
where mount with subvolid=0 did not mount the top-level subvolume. I
will try to recreate it with a recent kernel.

Thanks,
Andreas

>
> That's all rather dense, and probably too much information. Hope
> it's helpful, though.
>
> Hugo.
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN323eAAoJEJIcBJ3+XkgiFe8QALC9pa9DwygWNhULHF1jGoqY
+sHCvgD5WazkcquFD3xWg2pc52rnvDWpdeJAPw+6DzViCqnrk6lICyhhvjnAbm8a
h/87/7cV2CZbcVn/v283iuPLsok+HXsiyoMUHSEOhSCAE8CvveZbK7LtMSxagQpv
+e9TM9HUImw6UweYZ2LwMXY/Wu1z9yBaG/JuOq2MkslLniFekKaIPe8eZD4aej3o
RFkVKplvx3egu5lVJMDaK4rpL8xrQVxE4G8CtHLvVKRzJVHs8V3XTccaXmwpDks6
sZ+lzeU2+lNg+776K9+saXOuT9Ytuo0rpcDiEUAYxBO2DxSmbV2NArYkTLo0C3Sf
32+ecoqtZeNJH/v9a68+Pq0UH5cualLROGwyoc+MgqqIB+4zFq+nuTqk9eGtKchh
2YxQePXejnVsga8wgFMFSDYYaGKtfYUDKM+loq5XA/1A9bqjprIC40ovc3AHcJID
eqb861TEGXDBMajhFlLICk4YxyLd87ze6BOa4NxWwpVjkLW4HHPplsbW6EkTJBv6
bVwKDIpE4bmIpovIhRwxo5Eba4DNRtHrRD7U+2Ep+Juxx8n3y6DQD+qm40mOEtG0
oAhpVE/rKcR6FTxHPWon6lGH6D51bDDVOxVTwAyzETGbRA+eSA3nP05dtisXjEB2
07UBm2s0wHX7oQKOiATE
=R/Ih
-----END PGP SIGNATURE-----


From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Thu, 30 Jun 2011 12:52:59 +0200
Message-ID: <4E0C558B.9010304@gmail.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Andreas Philipp <philipp.andreas@gmail.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110630104340.GD28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 30.06.2011 12:43, Stephane Chazelas wrote:
> 2011-06-30 11:18:42 +0200, Andreas Philipp: [...]
>>>> After that, I posted a patch to fix btrfs-progs, which Chris
>>>> aggreed on:
>>>>
>>>> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2
>>> [...]
>>>
>>> Great. Thanks a lot
>>>
>>> It fixes my problem indeed.
>>>
>>> Which brings me to my next question: where to find the latest
>>> btrfs-progs if not at
>>>
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
>
>>>
[...]
>> Hugo Mills keeps an integration branch with nearly all patches
>> to btrfs-progs applied. See
>>
>> http://www.spinics.net/lists/linux-btrfs/msg10594.html
>>
>> and for the last update
>>
>> http://www.spinics.net/lists/linux-btrfs/msg10890.html
> [...]
>
> Thanks.
>
> It might be worth adding a link to that to
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>
> Note that it (integration-20110626) doesn't seem to include the fix
> in http://marc.info/?l=linux-btrfs&m=129238454714319&w=2 though.
Hi Hugo,

Can you please include that fix in the next release of your
integration branch for btrfs-progs-unstable?

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODFWKAAoJEJIcBJ3+Xkgi9VUQAI178VUW93+lHZV03YooS36z
YzCSd9UE4AK8n1H58gpQ2OWuLarTEkVB2iV2zn80DhKZioAlaJYA+mU9LG+c+dU6
IfwiyWrCFlaoyQn62gdmlFwgHcPglViSZX35LXuUbxdVzNM/KuCamp++ViL8TOZm
9vPd4UW98DxnvY+d4ui59Vt+5RWLxu5KHv+kRzXb5V4cMPRFmA4wrfyXkN8UdYLe
vJcJMFEy9JV2/fG+9thL+oglrb9pBkasHCXpoedUmJetf3eXpfnSZSiHRnYBlJY9
+dw1e4eh9uerJlwmCsqP1/TtGtyitwE8M/gXI8i+SkQKDNNqqa6RNf0axPNxfI9J
6jsqTzJCKcsV5VbdWMGJSEFanYmQ8rAI0BxJ+FrDlJIwZImnokFbxhrxUcYM4SpM
nNzbLV9bYHgx2LhotV+Iwoyfgb/S2vnnOnMoGs/LuaeDVO3fBnp1Ft1Ac6fi4T9q
wv/ot2TJ9tjLWGQOp1ACI+LzKd/DhtFs8p4NWaK/Tgc4Uy4VmcE+uLSIWh10s9Sg
UT0bEZMr7AXuDG9+QsjdnuOdLt/RjR2QAu4k3S3vU4ZHjGkYBXvYZd2pmaxCqJb1
aKtyGMf/apOYOWWyc8ia7dmm/dwA0plIjN30lWXfbx9YGlAzc3U4KYfgVyxfHjKx
lJkYHPcVpTSy4Y0AP6UJ
=uc4W
-----END PGP SIGNATURE-----


From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Thu, 30 Jun 2011 11:18:42 +0200
Message-ID: <4E0C3F72.5040508@gmail.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110630084046.GC28702@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 30.06.2011 10:40, Stephane Chazelas wrote:
> 2011-06-30 08:47:38 +0800, Li Zefan:
>> Stephane Chazelas wrote:
>>> 2011-06-29 15:37:47 +0100, Stephane Chazelas: [...]
>>>> I found
>>>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/8123/focus=8208
>>>>
>>>>
>>>>
>>>>
which looks like the same issue, with Li Zefan saying he had a
>>>> fix, but I couldn't find any mention that it was actually
>>>> fixed.
>>>>
>>>> Has anybody got any update on that?
>>> [...]
>>>
>>> I've found
>>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/8232
>>>
>>
>> After that, I posted a patch to fix btrfs-progs, which Chris
>> aggreed on:
>>
>> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2
> [...]
>
> Great. Thanks a lot
>
> It fixes my problem indeed.
>
> Which brings me to my next question: where to find the latest
> btrfs-progs if not at
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
>
>
>
(that one hasn't been modified in 8 months)?
>
> Have changes for read-only subvolumes, per-directory settings...
> been applied to some publicly available repository?
Hugo Mills keeps an integration branch with nearly all patches to
btrfs-progs applied.
See

http://www.spinics.net/lists/linux-btrfs/msg10594.html

and for the last update

http://www.spinics.net/lists/linux-btrfs/msg10890.html

Cheers,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODD9xAAoJEJIcBJ3+XkgiN1QP/RiO5KD4+wlEyVxe6WXq0xIE
GGsa4YrFWg/E9vKCw6LFVJAzdx3UdX3aM1EzDXoypX9jrtgEIbJbfjP635TAotDR
lYzvou0tovlxuyTBCbike7OVHz9faZwr91vpH9cNKFhDQMYXG0AIYO3gjv+lbTUc
m1CZNRaG1NUiyPTNoJi0Oj/e2cIAS7rhl1D26lLNfnwXMLA49a8EfaP526Qcg8eP
HqYWtBmm4cAPC7dNJbU9PELcJJ7hjnGE5ahZs/DwW6Usm8YEFZO6vA859oBp2REy
LwUCUcpnOSYjxD5iX4R7K7oPsHXdw8UkMACBzF1JgrqPS3rIi4bwRIp/ZA3M07AA
2B8eFD0oITxVK07vp9M64Sqms97V4cZxOtCkkCF+lEXppEaKj1lwpRoE4cmaAMW4
jA0sd8tgQw79Dy6/rBZyrxVJnXSmoWF3pisWIhHmFeAX+YnqT7ft7qXiWbQh7WMC
NFUw+1bagjshgZI+CxdY6stInJ+L+lSH4KTgtZb0mSxVnK440n/y/v5f9iDJ5js6
BkCZSYVjnite6wjZN5AYghZJfDCT4lXLN78dpeU6RWDD5/YlkJf4FkwFpHFVkHrO
M9x6cFRh74C5SiAPPWZUTT5g97mR4vuOzfTGwcSTv0ccaJzcxapUDZo50h30AbUA
TYTpSI2K2q3f+HvNJOPx
=ifgA
-----END PGP SIGNATURE-----


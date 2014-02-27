Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49929 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaB0VHQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 16:07:16 -0500
Message-ID: <530FA8FA.9020700@fb.com>
Date: Thu, 27 Feb 2014 16:07:06 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: >16TB Btrfs volumes are mountable on 32 bit kernels
References: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com>
In-Reply-To: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 04:05 PM, Chris Murphy wrote:
> User reports successfully formatting and using an ~18TB Btrfs
> volume on hardware raid5 using i686 kernel for over a year, and
> then suddenly the file system starts behaving weirdly:
> 
> https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg31856.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=5ac126734d7fa1d3238ab09a2ddc021a8dcc8fff7b022560a4d068be2de37c00
>
> 
> 
> I think this is due to the kernel page cache address space being
> 16TB limited on 32-bit kernels, as mentioned by Dave Chinner in
> this thread:
> 
> https://urldefense.proofpoint.com/v1/url?u=http://oss.sgi.com/pipermail/xfs/2014-February/034588.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=3e45f9288e6a77bc1a24dded368802c2ab46b812bf59953f74d4ee1d4141f7d2
>
>  So it sounds like it shouldn't be possible to mount a Btrfs volume
> larger than 16TB on 32-bit kernels. This is consistent with ext4
> and XFS which refuse to mount large file systems.
> 
> 

Well that's not good, I'll fix this up.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTD6j6AAoJEANb+wAKly3BhIEQAJheOf/NMEurHSlxnLWYuRog
thRJMk+je1Ae9Sz93B5/0OztrmzYhK+OoQhWuF79OxVPoMeZ2Ta5qqmeNw3U+dRn
T44SjlYRnerq0ksVt9xR9j2zMXWatgO5+20doZpeESco/IRWYkakQTyrWj9WUATN
7YQsxZB57nijrOvig0GPmMtH9PriscsPQhMVDuTDIHkvfWgk0M2oqu/0TZl9f5xA
Es1uK0rv6KsExVQix+4GjWc/RBpl2QzxGEq/Ct+vcL+HaiKIERXuEw5liP9dSamj
Wqbkkli+FDftBx/GXGTA38VYSxLExrlF891R4fOXWUcqDvlLwhdBpZExeYCV9MUz
lEtaZaKUa3eeRBwzuxeLT8mEvY3BqvePQg8Io7auuIHG4fuRlOWWRiDG7bpTTPlD
NFZACEDlGGdXNli7TqQ82La9kxFDvXCISnfxNbbu2vlXqL/HqQom1HiPwgMNIDQ7
0UIOLW5X+gg++kH7ArhOv19B7FR2i50wxuJSwj2/XSLELAPFAd9/BMI+3DXWfkE4
qZwnHEt8bVKR/yJ+srnRC2mZP41eHWHA6c9IXEGU/STy2uOdnwnXoS+KAdNWEt1d
QRlr79S8Mhf7U8Acx/LhgwkbB1npmm0xssZmK2WycSyU7A66rdk0Cc+gfVyZOW5C
k68LvCitzpU1W7MSMmPt
=9S2b
-----END PGP SIGNATURE-----

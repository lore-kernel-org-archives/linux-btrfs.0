Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab2JaVFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 17:05:07 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1250628pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 14:05:07 -0700 (PDT)
Message-ID: <50919280.1030606@gmail.com>
Date: Thu, 01 Nov 2012 05:05:04 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Hugo Mills <hugo@carfax.org.uk>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net> <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com> <50904949.8010603@gmail.com> <20121030221412.GB11422@carfax.org.uk> <20121030221947.GC11422@carfax.org.uk> <50906702.1010608@gmail.com> <CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
In-Reply-To: <CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:18 AM, cwillu wrote:
> import os
> import sys
>
> data = "1" * 1024 * 3
>
> for x in xrange(100 * 1000):
>   with open('%s/%s' % (sys.argv[1], x), 'a') as f:
>     f.write(data)
>
> root@repository:~$ mount -o loop ~/inline /mnt
> root@repository:~$ mount -o loop,max_inline=0 ~/noninline /mnt2
>
> root@repository:~$ time python test.py /mnt
> real	0m11.105s
> user	0m1.328s
> sys	0m5.416s
> root@repository:~$ time python test.py /mnt2
> real	0m21.905s
> user	0m1.292s
> sys	0m5.460s
>
> root@repository:/$ btrfs fi df /mnt
> Data: total=1.01GB, used=256.00KB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=652.70MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/$ btrfs fi df /mnt2
> Data: total=1.01GB, used=391.12MB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=60.98MB
> Metadata: total=8.00MB, used=0.00
>
> 3k data, 4k leaf: inline is twice the speed, but 1.4x bigger.
>
> ----
>
> root@repository:~$ mkfs.btrfs inline -l 64k
> root@repository:~$ mkfs.btrfs noninline -l 64k
> ...
> root@repository:~$ time python test.py /mnt
> real	0m12.244s
> user	0m1.396s
> sys	0m8.101s
> root@repository:~$ time python test.py /mnt2
> real	0m13.047s
> user	0m1.436s
> sys	0m7.772s
>
> root@repository:/$ btr\fs fi df /mnt
> Data: total=8.00MB, used=256.00KB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=342.06MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/$ btr\fs fi df /mnt2
> Data: total=1.01GB, used=391.10MB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=50.06MB
> Metadata: total=8.00MB, used=0.00
>
> 3k data, 64k leaf: inline is still 10% faster, and is now 25% smaller
>
> ----
>
> data = "1" * 1024 * 32
>
> ... (mkfs, mount, etc)
>
> root@repository:~$ time python test.py /mnt
> real	0m17.834s
> user	0m1.224s
> sys	0m4.772s
> root@repository:~$ time python test.py /mnt2
> real	0m20.521s
> user	0m1.304s
> sys	0m6.344s
>
> root@repository:/$ btrfs fi df /mnt
> Data: total=4.01GB, used=3.05GB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=54.00MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/$ btrfs fi df /mnt2
> Data: total=4.01GB, used=3.05GB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=53.56MB
> Metadata: total=8.00MB, used=0.00
>
> 32k data, 64k leaf: inline is still 10% faster, and is now the same
> size (not dead sure why, probably some interaction with the size of
> the actual write that happens)
>
> ----
>
> data = "1" * 1024 * 7
>
> ... etc
>
>
> root@repository:~$ time python test.py /mnt
> real	0m9.628s
> user	0m1.368s
> sys	0m4.188s
> root@repository:~$ time python test.py /mnt2
> real	0m13.455s
> user	0m1.608s
> sys	0m7.884s
>
> root@repository:/$ btrfs fi df /mnt
> Data: total=3.01GB, used=1.91GB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=74.69MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/$ btrfs fi df /mnt2
> Data: total=3.01GB, used=1.91GB
> System, DUP: total=8.00MB, used=64.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=74.69MB
> Metadata: total=8.00MB, used=0.00
>
> 7k data, 64k leaf:  30% faster, same data usage.
>
> ----
>
> Are we done yet?  Can I go home now? ;p
>


thanks for the test.

but the result just indicate the inline small file is not a "safe" optimization to be turned on by default.


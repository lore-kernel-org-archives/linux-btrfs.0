Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:54664 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPEiV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 00:38:21 -0400
Received: by mail-ig0-f170.google.com with SMTP id h3so3462350igd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 21:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BC5F6709-9089-4A3D-AE77-377C63E85E3C@colorremedies.com>
References: <5398CA16.3030609@libero.it>
	<20140612012104.GO9508@dastard>
	<20140612013728.GP4453@dastard>
	<5E3380D5-FF9F-4152-B115-7D16CD8CC215@colorremedies.com>
	<20140615223421.GF24386@tango.0pointer.de>
	<BC5F6709-9089-4A3D-AE77-377C63E85E3C@colorremedies.com>
Date: Sun, 15 Jun 2014 22:38:21 -0600
Message-ID: <CAE5mzvhjnLUnQoBMkg5TcCyRyA7t1LYXS9RzZ2H=42bxhVU=qQ@mail.gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Lennart Poettering <lennart@poettering.net>,
        Dave Chinner <david@fromorbit.com>, kreijack@inwind.it,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fallocate is a red herring except insofar as it's a hint that btrfs
isn't making much use of: you see the same behaviour with small writes
to an mmap'ed file that's msync'ed after each write, and likewise with
plain old appending small writes with an fsync after each write, with
or without fallocating the file first.  Looking at the fiemap output
while doing either of those, you'll see a new 4k extent being made,
and then the physical location of that extent will increment until the
writes move on to the next 4k extent.

cwillu@cwillu-home:~/work/btrfs/e2fs$ touch /tmp/test

>>> f=open('/tmp/test', 'r+')
>>> m=mmap.mmap(f.fileno(), size)
>>> for x in xrange(size):
...   m[x] = " "
...   m.flush(x / 4096 * 4096, 4096)   # msync(self->data + offset,
size, MS_SYNC)) {

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 800000
fs_ioc_fiemap 3223348747d
File /tmp/test has 3 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000b3d9c0000 0000000000001000 0000
1:	0000000000001000 000000069f012000 00000000003ff000 0000
2:	0000000000400000 0000000b419d1000 0000000000400000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b3daf3000 0000000000001000 0000
1:	0000000000001000 000000069f012000 00000000003ff000 0000
2:	0000000000400000 0000000b419d1000 0000000000400000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b3dc38000 0000000000001000 0000
1:	0000000000001000 000000069f012000 00000000003ff000 0000
2:	0000000000400000 0000000b419d1000 0000000000400000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b3dc9f000 0000000000001000 0000
1:	0000000000001000 0000000b3d2b7000 0000000000001000 0000
2:	0000000000002000 000000069f013000 00000000003fe000 0000
3:	0000000000400000 0000000b419d1000 0000000000400000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat
/tmp/test -c %s)# msync(self->data + offset, size, MS_SYNC)) {
0:	0000000000000000 0000000b3dc9f000 0000000000001000 0000
1:	0000000000001000 0000000b3d424000 0000000000001000 0000
2:	0000000000002000 000000069f013000 00000000003fe000 0000
3:	0000000000400000 0000000b419d1000 0000000000400000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b3dc9f000 0000000000001000 0000
1:	0000000000001000 0000000b3d563000 0000000000001000 0000
2:	0000000000002000 000000069f013000 00000000003fe000 0000
3:	0000000000400000 0000000b419d1000 0000000000400000 0001

========

cwillu@cwillu-home:~/work/btrfs/e2fs$ rm /tmp/test
cwillu@cwillu-home:~/work/btrfs/e2fs$ touch /tmp/test

>>> f=open('/tmp/test', 'r+')
>>> f.truncate(size)
>>> m=mmap.mmap(f.fileno(), size)
>>> for x in xrange(size):
...   m[x] = " "
...   m.flush(x / 4096 * 4096, 4096)   # msync(self->data + offset,
size, MS_SYNC)) {

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 800000
fs_ioc_fiemap 3223348747d
File /tmp/test has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000b47f11000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b48006000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b48183000 0000000000001000 0000
1:	0000000000001000 0000000b48255000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b48183000 0000000000001000 0000
1:	0000000000001000 0000000b48353000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b48183000 0000000000001000 0000
1:	0000000000001000 0000000b493ed000 0000000000001000 0000
2:	0000000000002000 0000000b4a68f000 0000000000001000 0000
3:	0000000000003000 0000000b4b36f000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
0:	0000000000000000 0000000b48183000 0000000000001000 0000
1:	0000000000001000 0000000b493ed000 0000000000001000 0000
2:	0000000000002000 0000000b4a68f000 0000000000001000 0000
3:	0000000000003000 0000000b4b4cf000 0000000000001000 0001

========

cwillu@cwillu-home:~/work/btrfs/e2fs$ rm /tmp/test
cwillu@cwillu-home:~/work/btrfs/e2fs$ touch /tmp/test

>>> f=open('/tmp/test', 'r+')
>>> for x in xrange(size):
...   f.write(' ')
...   f.flush()
...   os.fdatasync(f.fileno())

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 395
fs_ioc_fiemap 3223348747d
File /tmp/test has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000000000000 0000000000001000 0301

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 5b5
0:	0000000000000000 0000000000000000 0000000000001000 0301

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 1d61
0:	0000000000000000 0000000b4d2bc000 0000000000001000 0000
1:	0000000000001000 0000000b4e1c5000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 1e8c
0:	0000000000000000 0000000b4d2bc000 0000000000001000 0000
1:	0000000000001000 0000000b4e334000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 207c
0:	0000000000000000 0000000b4d2bc000 0000000000001000 0000
1:	0000000000001000 0000000b4e4a9000 0000000000001000 0000
2:	0000000000002000 0000000b4e528000 0000000000001000 0001

cwillu@cwillu-home:~/work/btrfs/e2fs$ fiemap /tmp/test 0 $(stat /tmp/test -c %s)
start: 0, length: 21be
0:	0000000000000000 0000000b4d2bc000 0000000000001000 0000
1:	0000000000001000 0000000b4e4a9000 0000000000001000 0000
2:	0000000000002000 0000000b4e66c000 0000000000001000 0001

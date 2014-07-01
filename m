Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from santino.mail.tiscali.it ([213.205.33.245]:50834 "EHLO
	santino.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaGAKWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 06:22:22 -0400
Message-ID: <53B28A82.2000907@assyoma.it>
Date: Tue, 01 Jul 2014 12:16:34 +0200
From: Gionatan Danti <g.danti@assyoma.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: g.danti@assyoma.it
Subject: Question about fallocate
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I'm doing some test using a small BTRFS volume on CentOS 6.5 x86_64 (I 
know that CentOS 6 use an old kernel and btrfs version and I plan to 
replicate the same test on Fedora 20).

 From my understanding, disabling CoW and fallocate a file should give a 
non-fragmented file. The followind commands show that:

[root@blackhole test]# fallocate test.img -l 1G
[root@blackhole test]# sync
[root@blackhole test]# filefrag -v test.img
Filesystem type is: 9123683e
File size of test.img is 1073741824 (262144 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0   269312          262144 eof
test.img: 1 extent found

As you can see, I have a single, continuous block stream.

However, write some 4k blocks into the file leads to fragmentation:

[root@blackhole test]# for id in `seq 1 32`; do dd if=/dev/zero 
of=test.img bs=4k count=1 seek=$id conv=notrunc,nocreat 
oflag=direct,sync; done
...
[root@blackhole test]# filefrag -v test.img
Filesystem type is: 9123683e
File size of test.img is 1073741824 (262144 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0   269312               1
    1       1   269313               1
    2       2   531456   269314     31
    3      33   269345   531487 262111 eof
test.img: 3 extents found

If I don't use fallocate to reserve space, using a simple dd to write 0s 
to the target file, the fragmentation do not occour:
[root@blackhole test]# dd if=/dev/zero of=test.img bs=2M count=512
[root@blackhole test]# sync
[root@blackhole test]# for id in `seq 1 32`; do dd if=/dev/zero 
of=test.img bs=4k count=1 seek=$id conv=notrunc,nocreat 
oflag=direct,sync; done
...
[root@blackhole test]# filefrag -v test.img
Filesystem type is: 9123683e
File size of test.img is 1073741824 (262144 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0   269312          262144 eof
test.img: 1 extent found

So, my question is: why writing to a fallocated file produce 
fragmentation, even with CoW disabled?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

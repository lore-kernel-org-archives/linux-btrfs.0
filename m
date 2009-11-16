From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: btrfs failed to delete reference
Date: Mon, 16 Nov 2009 19:05:22 +0100
Message-ID: <20091116180522.GA1753@arch.trippelsdorf.de>
References: <20091116081527.GA1711@arch.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091116081527.GA1711@arch.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 16, 2009 at 09:15:27AM +0100, Markus Trippelsdorf wrote:
> Last night the following line was logged:
> Nov 16 04:01:07 arch kernel: btrfs failed to delete reference to ammintrin.h, inode 118665 parent 2687784
> 
> This file is part of an rsnapshot backup directory:
> /var/.snapshots/hourly.5/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include
> 
> arch include # find . -inum 118665
> find: `./ammintrin.h': No such file or directory
> 
> arch include # ls -al
> ls: cannot access ammintrin.h: No such file or directory
> total 0
> drwxr-xr-x 1 root root 22 2009-11-16 08:39 .
> drwxr-xr-x 1 root root 14 2009-11-16 04:01 ..
> -????????? ? ?    ?     ?                ? ammintrin.h
> 
> arch include # ..
> arch install-tools # rm -fr include
> rm: cannot remove directory `include': Directory not empty

Some more date:

 # btrfsck /dev/sda1
bad key ordering 1 2
bad block 84865024000
owner ref check failed [84865024000 4096]
found 43408293888 bytes used err is 1
total csum bytes: 40020016
total tree bytes: 2427797504
total fs tree bytes: 2278412288
btree space waste bytes: 613750582
file data blocks allocated: 40987045888
 referenced 40979152896
 Btrfs v0.19-1-g4f89b6e

.snapshots # find . -inum 118665
./hourly.0/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./weekly.1/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./weekly.0/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.6/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.5/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.4/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.3/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.2/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.1/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./daily.0/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
find: `./debug/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./hourly.5/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
./hourly.4/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./hourly.3/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./hourly.2/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h
./hourly.1/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h

and after deleting most of these hardlinks by hand:

.snapshots # find . -inum 118665
find: `./daily.3/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./daily.2/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./daily.1/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./daily.0/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./debug/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./hourly.5/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./hourly.4/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory
find: `./hourly.3/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include/ammintrin.h': No such file or directory


-- 
Markus

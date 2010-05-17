From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Rename+crash behaviour of btrfs - nearly ext3!
Date: Mon, 17 May 2010 20:04:21 +0200
Message-ID: <4BF18525.8080904@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508000508090207000206"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010508000508090207000206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

Following Ubuntu's dpkg+ext4 problems I wanted to see if btrfs would
solve them all. And it nearly does! Now I wonder if the remaining 0.2
seconds window of exposing 0-size files could be closed too.

I tested using two simple scripts (attached for reference) on kernel
2.6.34-rc7:
- rentest creates files $i.tmp and renames to $i.cur,
- owtest does the same but overwrites existing $i.cur files,
letting them run for 30-50 seconds then resetting the virtual machine.

The results for ext3 are as expected: 0-size files are never exposed as
$i.cur, overwrites are atomic.

ext4 overwrites are /almost/ atomic (I get one 0-size file in owtest),
lots of 0-size files are exposed in rentest (30 seconds window).

btrfs *nearly* does as well as ext3. Overwrites are atomic.

The rentest exposes only a 0.2 seconds windows of 0-size $i.cur files,
so that a "ls --full-time" after the crash looks like this (notice the
time between 01281.cur and 01292.tmp, only 0.2 seconds):
[...]
-rw-r--r-- 1 root root 20 2010-05-17 17:06:25.812016407 +0200 01280.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:06:25.835999490 +0200 01281.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:25.868035485 +0200 01282.cur
[...]
-rw-r--r-- 1 root root  0 2010-05-17 17:06:26.080003626 +0200 01291.cur
-rw-rw-rw- 1 root root  0 2010-05-17 17:06:26.108010083 +0200 01292.tmp


Finally, xfs kills lots of existing files in owtest and exposes lots of
0-size files in rentest (both 40 seconds window).

If anybody is interested, the bunch of trimmed "ls --full-time" output
for all filesystems is attached.


Thanks,
Jakob

--------------010508000508090207000206
Content-Type: text/plain;
 name="rentest"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rentest"

#!/bin/bash

set -eu

cd rentest-tmp
rm -Rf *
sync

echo "$0: Running rename loop"
( sleep 30s ; echo "$0: 30s. " )&
for i in `seq -w 1 10000`
do
	echo "File content $i." > $i.tmp
	mv $i.tmp $i.cur
done


--------------010508000508090207000206
Content-Type: text/plain;
 name="owtest"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="owtest"

#!/bin/bash

set -eu

cd owtest-tmp
rm -Rf *
sync

echo "$0: Running create loop"

for i in `seq -w 1 10000`
do
	echo "old file content" > $i.cur
done
sync

echo "$0: Running overwrite loop"

( sleep 30s ; echo "$0: 30s" )&
for i in `seq -w 1 10000`
do
	echo "new file content of different size" > $i.tmp
	mv $i.tmp $i.cur
done


--------------010508000508090207000206
Content-Type: text/plain;
 name="results.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="results.txt"

Linux lucid-crash-burn 2.6.34-020634rc7-generic #020634rc7 SMP Mon May 10 10:08:20 UTC 2010 i686 GNU/Linux

########
ext3 data=ordered
########

********
rentest
********
-rw-r--r-- 1 root root 20 2010-05-17 19:05:05.000000000 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 20 2010-05-17 19:05:50.000000000 +0200 02013.cur

********
owtest
********
-rw-r--r-- 1 root root 35 2010-05-17 19:05:04.000000000 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 35 2010-05-17 19:05:50.000000000 +0200 02027.cur
-rw-r--r-- 1 root root 35 2010-05-17 19:05:50.000000000 +0200 02028.cur
-rw-r--r-- 1 root root 35 2010-05-17 19:05:50.000000000 +0200 02029.cur
-rw-r--r-- 1 root root 17 2010-05-17 19:05:03.000000000 +0200 02030.cur
-rw-r--r-- 1 root root 35 2010-05-17 19:05:50.000000000 +0200 02030.tmp
-rw-r--r-- 1 root root 17 2010-05-17 19:05:03.000000000 +0200 02031.cur
-rw-r--r-- 1 root root 17 2010-05-17 19:05:03.000000000 +0200 02032.cur
-rw-r--r-- 1 root root 17 2010-05-17 19:05:03.000000000 +0200 02033.cur
[...]
-rw-r--r-- 1 root root 17 2010-05-17 19:05:04.000000000 +0200 10000.cur



########
ext4 data=ordered
########

********
rentest
********
-rw-r--r-- 1 root root 20 2010-05-17 17:05:56.000000000 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 20 2010-05-17 17:06:06.000000000 +0200 00429.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:06:06.000000000 +0200 00430.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:06:06.000000000 +0200 00431.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:06.000000000 +0200 00432.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:06.000000000 +0200 00433.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:06.000000000 +0200 00434.cur
[...]
-rw-r--r-- 1 root root  0 2010-05-17 17:06:36.000000000 +0200 01748.cur

********
owtest
********
-rw-r--r-- 1 root root 35 2010-05-17 16:47:25.000000000 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 35 2010-05-17 16:48:01.000000000 +0200 01451.cur
-rw-r--r-- 1 root root 35 2010-05-17 16:48:01.000000000 +0200 01452.cur
-rw-r--r-- 1 root root 35 2010-05-17 16:48:01.000000000 +0200 01453.cur
-rw-r--r-- 1 root root  0 2010-05-17 16:48:01.000000000 +0200 01454.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.000000000 +0200 01455.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.000000000 +0200 01456.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.000000000 +0200 01457.cur
[...]
-rw-r--r-- 1 root root 17 2010-05-17 16:47:24.000000000 +0200 10000.cur



########
btrfs
########

********
rentest
********
-rw-r--r-- 1 root root 20 2010-05-17 17:05:56.260291651 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 20 2010-05-17 17:06:25.788083319 +0200 01279.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:06:25.812016407 +0200 01280.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:06:25.835999490 +0200 01281.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:25.868035485 +0200 01282.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:25.887995591 +0200 01283.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:06:25.912002104 +0200 01284.cur
[...]
-rw-r--r-- 1 root root  0 2010-05-17 17:06:26.080003626 +0200 01291.cur
-rw-rw-rw- 1 root root  0 2010-05-17 17:06:26.108010083 +0200 01292.tmp

********
owtest
********
-rw-r--r-- 1 root root 35 2010-05-17 16:47:26.310637092 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 35 2010-05-17 16:47:56.770578127 +0200 01226.cur
-rw-r--r-- 1 root root 35 2010-05-17 16:47:56.794580123 +0200 01227.cur
-rw-r--r-- 1 root root 35 2010-05-17 16:47:56.818574731 +0200 01228.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.122599650 +0200 01229.cur
-rw-rw-rw- 1 root root  0 2010-05-17 16:47:56.842574557 +0200 01229.new
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.122599650 +0200 01230.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.122599650 +0200 01231.cur
-rw-r--r-- 1 root root 17 2010-05-17 16:47:22.122599650 +0200 01232.cur
[...]
-rw-r--r-- 1 root root 17 2010-05-17 16:47:25.906584357 +0200 10000.cur



########
xfs
########

********
rentest
********
-rw-r--r-- 1 root root 20 2010-05-17 17:45:29.856656127 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 20 2010-05-17 17:45:39.836115618 +0200 00346.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:45:39.860120683 +0200 00347.cur
-rw-r--r-- 1 root root 20 2010-05-17 17:45:39.892119985 +0200 00348.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:45:39.928119346 +0200 00349.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:45:39.964136036 +0200 00350.cur
-rw-r--r-- 1 root root  0 2010-05-17 17:45:39.992118460 +0200 00351.cur
[...]
-rw-r--r-- 1 root root  0 2010-05-17 17:46:19.036119284 +0200 01657.cur

********
owtest
********
-rw-r--r-- 1 root root 35 2010-05-17 18:02:00.046591863 +0200 00001.cur
[...]
-rw-r--r-- 1 root root 35 2010-05-17 18:02:04.886617159 +0200 00193.cur
-rw-r--r-- 1 root root 35 2010-05-17 18:02:04.906607613 +0200 00194.cur
-rw-r--r-- 1 root root 35 2010-05-17 18:02:04.930592724 +0200 00195.cur
-rw-r--r-- 1 root root  0 2010-05-17 18:02:04.958586922 +0200 00196.cur
-rw-r--r-- 1 root root  0 2010-05-17 18:02:04.982590376 +0200 00197.cur
-rw-r--r-- 1 root root  0 2010-05-17 18:02:05.006606400 +0200 00198.cur
[...]
-rw-r--r-- 1 root root  0 2010-05-17 18:02:44.878590296 +0200 01775.cur
-rw-r--r-- 1 root root 17 2010-05-17 18:01:46.674588629 +0200 01776.cur
[...]
-rw-r--r-- 1 root root 17 2010-05-17 18:01:53.202593995 +0200 10000.cur

--------------010508000508090207000206--

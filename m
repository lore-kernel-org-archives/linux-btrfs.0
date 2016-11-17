Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:47666 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936458AbcKQSJV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 13:09:21 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <d4209447-5fb5-e947-1546-45608814c87a@libero.it>
Date: Thu, 17 Nov 2016 19:09:16 +0100
MIME-Version: 1.0
In-Reply-To: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------AAF872D4C2DF75DF054FA276"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------AAF872D4C2DF75DF054FA276
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Qu,

On 2016-11-15 03:50, Qu Wenruo wrote:
> Fix the so-called famous RAID5/6 scrub error.
> 
> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
> sight.
> (Yes, without the Phoronix report on this,
> https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
> I won't ever be aware of it)
> 
> Unlike many of us(including myself) assumed, it's not a timed bomb buried
> deeply into the RAID5/6 code, but a race condition in scrub recovery
> code.
> 
> The problem is not found because normal mirror based profiles aren't
> affected by the race, since they are independent with each other.

Unfortunately, even with these patches btrfs still fails to rebuild a raid5 array in my tests.
To perform the tests I create a filesystem raid5-three disks; then I created a file

# python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" >out.txt

The filesystem layout is composed by stripes large 128k of data, and 64k of parity.

The idea is that the first third of the stripe (64k on disk0) is composed by "adaaa...";
the second third (again 64k on disk1 is composed by "bdbbbb"; and finally the parity (disk0^disk1) is stored on the last portion of the stripe.

Doing some calculation it is possible to know where the data is physically stored.

I perform 3 tests:
1) I corrupt some bytes of the data stored on disk0; mount the filesystem; run scrub; unmount the filesystem; check all the disks if the bytes of the stripe are corrected
2) I corrupt some bytes of the data stored on disk1; mount the filesystem; run scrub; unmount the filesystem; check all the disks the bytes of the stripe are corrected
3) I corrupt some bytes of the parity stored on disk2; mount the filesystem; run scrub; unmount the filesystem; check all the disks the bytes of the stripe are corrected

Before your patches, my all tests fail (not all the times, but very often).
After your patches, test1 and test2 still fail. In my test test3 succeded.

Enclosed my script which performs the tests (it uses loop device; please run in a VM; firts you have to uncomment the function make_imgs to create the disk image.).

Let me know if I can help you providing more information.

BR
G.Baroncelli


> 
> Although this time the fix doesn't affect the scrub code much, it should
> warn us that current scrub code is really hard to maintain.
> 
> Abuse of workquque to delay works and the full fs scrub is race prone.
> 
> Xfstest will follow a little later, as we don't have good enough tools
> to corrupt data stripes pinpointly.
> 
> Qu Wenruo (2):
>   btrfs: scrub: Introduce full stripe lock for RAID56
>   btrfs: scrub: Fix RAID56 recovery race condition
> 
>  fs/btrfs/ctree.h       |   4 ++
>  fs/btrfs/extent-tree.c |   3 +
>  fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 199 insertions(+)
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--------------AAF872D4C2DF75DF054FA276
Content-Type: application/x-sh;
 name="test-btrfs.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test-btrfs.sh"

#!/bin/bash

sudo modprobe loop

disks="disk1.img disk2.img disk3.img"
UUID=11111111-1111-1111-1111-111111111111
offsets="$((81788928+16*4096)) $((61865984+16*4096)) $((61865984+16*4096))"

# sanity check: the test filesystem must be not mounted
[ -d /sys/fs/btrfs/$UUID ] && exit

mydd() {
	dd 2>/dev/null "$@"
}

getn() {
	echo "$1" | cut -d ' ' -f $2
}

myhd() {
	hexdump -v -e '"x" 1/1 "%02X" " "'
}

loops_setup() {
	for i in $disks; do
		sudo losetup -f $i
		sudo btrfs dev scan $(sudo losetup -j $i -O NAME -n)
	done
}

get_loops() {
	for i in $disks; do
		sudo losetup -j $i -O NAME -n
	done
}

loops_destroy() {
	sudo losetup -d $(get_loops)
}

make_disks() {
	sudo losetup | grep loop && exit

	mkdir mnt

	for i in $disks; do
		rm -f $i
		truncate -s 500M $i ; 
	done
	loops_setup

	sudo mkfs.btrfs -U $UUID -d raid5 -m raid5 $(get_loops)
	sudo mount UUID=$UUID mnt/

	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | 
		sudo tee mnt/out.txt >/dev/null

	sleep 1
	sudo umount mnt/

	loops_destroy

	sync
	
	# sanitary test
	check_disks || exit
	tar cSzf clean-disks-$UUID.tgz $disks
}

check_disks() {
	data="$(mydd if=disk1.img skip=$(getn "$offsets" 1) bs=1 count=5)"
	[ "$data" != "bdbbb" ] && return 1 
	data="$(mydd if=disk2.img skip=$(getn "$offsets" 2) bs=1 count=5)"
	[ "$data" != "adaaa" ] && return 1
	data="$(mydd if=disk3.img skip=$(getn "$offsets" 3) bs=1 count=5 | myhd)"
	[ "$data" != "x03 x00 x03 x03 x03 " ] && return 1

	return 0


}

corrupt_parity() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 3) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 3) count=5
	check_disks && exit
	tar cSzf corrupt_parity-disks-$UUID.tgz $disks
}

corrupt_disk1() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 1) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 1) count=5
	check_disks && exit
	tar cSzf corrupt_disk1-disks-$UUID.tgz $disks
}

corrupt_disk2() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 2) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 2) count=5
	check_disks && exit
	tar cSzf corrupt_disk2-disks-$UUID.tgz $disks
}

make_imgs() {
	make_disks
	corrupt_disk2
	corrupt_disk1
	corrupt_parity
}

__do_test() {
	j="$1"
	tar xzf $j
	if check_disks; then
		corrupted=0
	else
		corrupted=1
	fi

	loops_setup
	sudo mount UUID=$UUID mnt
	echo 
	echo Test $j
	sudo btrfs scrub start mnt/.
	#cat mnt/out.txt | md5sum

	# sometime umount fail ???
	sudo umount mnt
	while [ -f mnt/out.txt ]; do
		echo "Repeat umount"
		sleep 1s
		sudo umount mnt
	done
	loops_destroy
	sync; sync

	if check_disks; then
			corrected=1
	else
			corrected='0 <-- FAIL!!!!!!!!!!!!!!!!'
	fi
	echo corrupted=$corrupted, corrected=$corrected
	echo premi enter per continuare
	read line
}

do_test() {
	filter="$1"
	for j in *.tgz; do
		if [ -n "$filter" ]; then
			echo "$j" | grep "$filter" || continue
		fi
		__do_test $j
	done
}

#make_imgs
do_test "$1"

--------------AAF872D4C2DF75DF054FA276--

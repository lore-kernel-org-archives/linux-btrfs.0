Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:50973 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751132AbcFYMVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 08:21:42 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Reply-To: kreijack@inwind.it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
Date: Sat, 25 Jun 2016 14:21:38 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F9DCB25854A31F5DC9B7A339"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------F9DCB25854A31F5DC9B7A339
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi all,

following the thread "Adventures in btrfs raid5 disk recovery", I investigated a bit the BTRFS capability to scrub a corrupted raid5 filesystem. To test it, I first find where a file was stored, and then I tried to corrupt the data disks (when unmounted) or the parity disk.
The result showed that sometime the kernel recomputed the parity wrongly.

I tested the following kernel
- 4.6.1
- 4.5.4
and both showed the same behavior.

The test was performed as described below:

1) create a filesystem in raid5 mode (for data and metadata) of 1500MB 

	truncate -s 500M disk1.img; losetup -f disk1.img
	truncate -s 500M disk2.img; losetup -f disk2.img
	truncate -s 500M disk3.img; losetup -f disk3.img
	sudo mkfs.btrfs -d raid5 -m raid5 /dev/loop[0-2]
	sudo mount /dev/loop0 mnt/

2) I created a file with a length of 128kb:

	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt
	sudo umount mnt/

3) I looked at the output of 'btrfs-debug-tree /dev/loop0' and I was able to find where the file stripe is located:

/dev/loop0: offset=81788928+16*4096        (64k, second half of the file: 'bdbbbb.....)
/dev/loop1: offset=61865984+16*4096        (64k, first half of the file: 'adaaaa.....)
/dev/loop2: offset=61865984+16*4096        (64k, parity: '\x03\x00\x03\x03\x03.....)

4) I tried to corrupt each disk (one disk per test), and then run a scrub:

for example for the disk /dev/loop2:
	sudo dd if=/dev/zero of=/dev/loop2 bs=1 \
        	        seek=$((61865984+16*4096)) count=5
	sudo mount /dev/loop0 mnt
	sudo btrfs scrub start mnt/.

5) I check the disks at the offsets above, to verify that the data/parity is correct

However I found that:
1) if I corrupt the parity disk (/dev/loop2), scrub don't find any corruption, but recomputed the parity (always correctly);

2) when I corrupted the other disks (/dev/loop[01]) btrfs was able to find the corruption. But I found two main behaviors:

2.a) the kernel repaired the damage, but compute the wrong parity. Where it was the parity, the kernel copied the data of the second disk on the parity disk

2.b) the kernel repaired the damage, and rebuild a correct parity 

I have to point out another strange thing: in dmesg I found two kinds of messages:

msg1)
	[....]
	[ 1021.366944] BTRFS info (device loop2): disk space caching is enabled
	[ 1021.366949] BTRFS: has skinny extents
	[ 1021.399208] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
	[ 1021.399214] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
	[ 1021.399291] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0

msg2)
	[ 1017.435068] BTRFS info (device loop2): disk space caching is enabled
	[ 1017.435074] BTRFS: has skinny extents
	[ 1017.436778] BTRFS info (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
	[ 1017.463403] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, 	root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
	[ 1017.463409] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
	[ 1017.463467] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
	[ 1017.463472] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
	[ 1017.463512] BTRFS error (device loop2): unable to fixup (regular) error at logical 142802944 on dev /dev/loop0
	[ 1017.463535] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0


but these seem to be UNrelated to the kernel behavior 2.a) or 2.b)

Another strangeness is that SCRUB sometime reports
 ERROR: there are uncorrectable errors
and sometime reports
 WARNING: errors detected during scrubbing, corrected

but also these seems UNrelated to the behavior 2.a) or 2.b) or msg1 or msg2


Enclosed you can find the script which I used to trigger the bug. I have to rerun it several times to show the problem because it doesn't happen every time. Pay attention that the offset and the loop device name are hard coded. You must run the script in the same directory where it is: eg "bash test.sh". 

Br
G.Baroncelli


 
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--------------F9DCB25854A31F5DC9B7A339
Content-Type: application/x-sh;
 name="test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.sh"

root="$(pwd)"
disks="disk1.img disk2.img disk3.img"
imgsize=500M


#
# returns all the loopback devices
#
loop_disks() {
	sudo losetup | grep $root | awk '{ print $1 }'
}


#init the fs

init_fs() {
	#destroy fs
	echo umount mnt
	sudo umount mnt
	for i in $( loop_disks ); do
		echo "losetup -d $i"
		sudo losetup -d $i
	done

	for i in $disks; do
		rm $i
		truncate -s $imgsize $i
		sudo losetup -f $i
	done

	loops="$(loop_disks)"
	loop1="$(echo $loops | awk '{ print $1 }')"
	echo "loops=$loops; loop1=$loop1"

	sudo mkfs.btrfs -d raid5 -m raid5 $loops
	sudo mount $loop1 mnt/

	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null

	ls -l mnt/out.txt

	sudo umount mnt
	sync; sync
}

check_fs() {
	# check
	d="$(dd 2>/dev/null if=/dev/loop0 bs=1 skip=$((81788928+16*4096)) count=5)"
	if [ "$d" != "bdbbb" ]; then
		echo "******** Wrong data on disk /dev/loop0 [$d]"
		return 1
	fi

	d="$(dd 2>/dev/null if=/dev/loop1 bs=1 skip=$((61865984+16*4096)) count=5)"
	if [ "$d" != "adaaa" ]; then
		echo "******** Wrong data on disk /dev/loop1 [$d]"
		return 1
	fi
	d="$(dd 2>/dev/null if=/dev/loop2 bs=1 skip=$((61865984+16*4096)) count=5 | xxd | dd bs=1 count=4 skip=10)"
	if [ "x$d" != "x0300" ]; then
		echo "******* Wrong data on disk /dev/loop2 [$(echo -n $d)]"
		return 1
	fi

	return 0
}

test_corrupt_loop2() {
	echo "--- test 1: corrupt loop2"
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo dd if=/dev/zero of=/dev/loop2 bs=1 \
		seek=$((61865984+16*4096)) count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo mount /dev/loop0 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	check_fs || exit
	echo "--- test1: OK"
}



test_corrupt_loop1() {
	echo "--- test 2: corrupt loop1"
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo dd if=/dev/zero of=/dev/loop1 bs=1 \
		seek=$((61865984+16*4096)) count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo mount /dev/loop0 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	check_fs || exit
	echo "--- test2: OK"
}

test_corrupt_loop0() {
	echo "--- test 3: corrupt loop0"
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo dd if=/dev/zero of=/dev/loop0 bs=1 \
		seek=$((81788928+16*4096)) count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	sudo mount /dev/loop0 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	check_fs || exit
	echo "--- testr3: OK"
}


init_fs
check_fs || exit 100
echo "Integrity test OK"

test_corrupt_loop0




--------------F9DCB25854A31F5DC9B7A339--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:49431 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbcGLVul (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 17:50:41 -0400
Reply-To: kreijack@inwind.it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5: take
 two
Message-ID: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
Date: Tue, 12 Jul 2016 23:50:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I developed a new btrfs command "btrfs insp phy"[1] to further investigate this bug [2]. Using "btrfs insp phy" I developed a script to trigger the bug. The bug is not always triggered, but most of time yes. 

Basically the script create a raid5 filesystem (using three loop-device on three file called disk[123].img); on this filesystem  it is create a file. Then using "btrfs insp phy", the physical placement of the data on the device are computed.

First the script checks that the data are the right one (for data1, data2 and parity), then it corrupt the data:

test1: the parity is corrupted, then scrub is ran. Then the (data1, data2, parity) data on the disk are checked. This test goes fine all the times

test2: data2 is corrupted, then scrub is ran. Then the (data1, data2, parity) data on the disk are checked. This test fail most of the time: the data on the disk is not correct; the parity is wrong. Scrub sometime reports "WARNING: errors detected during scrubbing, corrected" and sometime reports "ERROR: there are uncorrectable errors". But this seems unrelated to the fact that the data is corrupetd or not
test3: like test2, but data1 is corrupted. The result are the same as above.


test4: data2 is corrupted, the the file is read. The system doesn't return error (the data seems to be fine); but the data2 on the disk is still corrupted.


Note: data1, data2, parity are the disk-element of the raid5 stripe-

Conclusion:

most of the time, it seems that btrfs-raid5 is not capable to rebuild parity and data. Worse the message returned by scrub is incoherent by the status on the disk. The tests didn't fail every time; this complicate the diagnosis. However my script fails most of the time.

BR
G.Baroncelli

----

root="$(pwd)"
disks="disk1.img disk2.img disk3.img"
imgsize=500M
BTRFS=../btrfs-progs/btrfs


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

        sudo mount $loop1 mnt
        data="$(sudo $BTRFS insp phy mnt/out.txt)"
        
        data1_off="$(echo "$data" | grep "DATA$" | awk '{ print $5 }')"
        data2_off="$(echo "$data" | grep "OTHER$" | awk '{ print $5 }')"
        parity_off="$(echo "$data" | grep "PARITY$" | awk '{ print $5 }')"
        data1_dev="$(echo "$data" | grep "DATA$" | awk '{ print $3 }')"
        data2_dev="$(echo "$data" | grep "OTHER$" | awk '{ print $3 }')"
        parity_dev="$(echo "$data" | grep "PARITY$" | awk '{ print $3 }')"
        
        sudo umount mnt
        
	# check
	d="$(dd 2>/dev/null if=$data1_dev bs=1 skip=$data1_off count=5)"
	if [ "$d" != "adaaa" ]; then
		echo "******* Wrong data on disk:off $data1_dev:$data1_off (data1)"
		return 1
	fi

	d="$(dd 2>/dev/null if=$data2_dev bs=1 skip=$data2_off count=5)"
	if [ "$d" != "bdbbb" ]; then
		echo "******* Wrong data on disk:off $data2_dev:$data2_off (data2)"
		return 1
	fi

	d="$(dd 2>/dev/null if=$parity_dev bs=1 skip=$parity_off count=5 | 
                xxd | dd 2>/dev/null bs=1 count=9 skip=10)"
	if [ "x$d" != "x0300 0303" ]; then
		echo "******* Wrong data on disk:off $parity_dev:$parity_off (parity)"
		return 1
	fi

	return 0
}

test_corrupt_parity() {
	echo "--- test 1: corrupt parity"
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo dd 2>/dev/null if=/dev/zero of=$parity_dev bs=1 \
		seek=$parity_off count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo mount $loop1 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	check_fs || return 1
	echo "--- test1: OK"
	return 0
}



test_corrupt_data2() {
	echo "--- test 2: corrupt data2"
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo dd 2>/dev/null if=/dev/zero of=$data2_dev bs=1 \
		seek=$data2_off count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee >/dev/null >/dev/null /proc/sys/vm/drop_caches
	sudo mount $loop1 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	check_fs || return 1
	echo "--- test2: OK"
	return 0
}

test_corrupt_data1() {
	echo "--- test 3: corrupt data1"
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo dd 2>/dev/null if=/dev/zero of=$data1_dev bs=1 \
		seek=$data1_off count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo mount $loop1 mnt
	sudo btrfs scrub start mnt/.
	sync; sync
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	check_fs || return 1
	echo "--- test3: OK"
	return 0
}

test_corrupt_data2_wo_scrub() {
	echo "--- test 4: corrupt data2; read without scrub"
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo dd 2>/dev/null if=/dev/zero of=$data2_dev bs=1 \
		seek=$data2_off count=5
	check_fs &>/dev/null && {
			echo Corruption failed
			exit 100
		}
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	sudo mount $loop1 mnt
	cat mnt/out.txt &>/dev/null || echo "Read FAIL"
	sudo umount mnt
	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches
	check_fs || return 1
	echo "--- test 4: OK"
	return 0
}


for t in test_corrupt_parity test_corrupt_data2 test_corrupt_data1 \
    test_corrupt_data2_wo_scrub; do
    
        init_fs &>/dev/null
        if ! check_fs &>/dev/null; then 
             echo Integrity test failed
             exit 100
        fi

        $t
        echo
    
done


-----------------




[1] See email "New btrfs sub command: btrfs inspect physical-find"
[2] See email "[BUG] Btrfs scrub sometime recalculate wrong parity in raid5"



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

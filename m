Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.piipiip.net ([176.31.107.179]:38897 "EHLO
	james.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbcGQTgM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 15:36:12 -0400
Received: from jlavi by james.piipiip.net with local (Exim 4.80)
	(envelope-from <jlavi@ks392938.kimsufi.com>)
	id 1bOs1L-0002o8-2F
	for linux-btrfs@vger.kernel.org; Sun, 17 Jul 2016 22:46:35 +0300
Date: Sun, 17 Jul 2016 22:46:35 +0300
From: Jarkko Lavinen <jlavi@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Message-ID: <20160717194634.GA1217@ks392938.kimsufi.com>
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <20160716155111.GA9751@ks392938.kimsufi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <20160716155111.GA9751@ks392938.kimsufi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 16, 2016 at 06:51:11PM +0300, Jarkko Lavinen wrote:
>  The modified script behaves very much like the original dd version.

Not quite. The bad sector simulation works like old hard drives without error correction and bad block remapping. This changes the error behaviour.

My script prints now kernel messages once the check_fs fails. The time range of messages messages is from the adding of the bad sector device to the point when check_fs fails.

The parity test which often passes with the Goffredo's script, always fails with my bad sector version and scrub says the error is uncorrectable. In the kernel messages there are two buffer IO read errors but no write error as if scrub quits before writing?

In the data2 test scrub again says the error is uncorrectable but according to the kernel messages the bad sector is read 4 times and written twice during the scrub. In my bad sector script the data2 is still corrupted and parity ok since the bad sector cannot be written and scrub likely quits earlier than in Goffredo's script. In his script the data2 gets fixed but the parity gets corrupted.

Jarkko Lavinen

$ bash h2.sh
--- test 1: corrupt parity
scrub started on mnt/., fsid 2625e2d0-420c-40b6-befa-97fc18eaed48 (pid=32490)
ERROR: there are uncorrectable errors
******* Wrong data on disk:off /dev/mapper/loop0:61931520 (parity)
Data read ||, expected |0300 0303|

Kernel messages in the test
First Check_fs started
Buffer I/O error on dev dm-0, logical block 15120, async page read
Scrub started
Second Check_fs started
Buffer I/O error on dev dm-0, logical block 15120, async page read

--- test 2: corrupt data2
scrub started on mnt/., fsid 8e506268-16c7-48fa-b176-0a8877f2a7aa (pid=434)
ERROR: there are uncorrectable errors
******* Wrong data on disk:off /dev/mapper/loop2:81854464 (data2)
Data read ||, expected |bdbbb|

Kernel messages in the test
First Check_fs started
Buffer I/O error on dev dm-2, logical block 19984, async page read
Scrub started
BTRFS warning (device dm-0): i/o error at logical 142802944 on dev /dev/mapper/loop2, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 1, rd 1, flush 0, corrupt 0, gen 0
BTRFS warning (device dm-0): i/o error at logical 142802944 on dev /dev/mapper/loop2, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 1, rd 2, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 142802944 on dev /dev/mapper/loop2
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 2, rd 2, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 142802944 on dev /dev/mapper/loop2
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 2, rd 3, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 2, rd 4, flush 0, corrupt 0, gen 0
Second Check_fs started
BTRFS info (device dm-0): bdev /dev/mapper/loop2 errs: wr 2, rd 4, flush 0, corrupt 0, gen 0
Buffer I/O error on dev dm-2, logical block 19984, async page read

--- test 3: corrupt data1
scrub started on mnt/., fsid f8a4ecca-2475-4e5e-9651-65d9478b56fe (pid=856)
ERROR: there are uncorrectable errors
******* Wrong data on disk:off /dev/mapper/loop1:61931520 (data1)
Data read ||, expected |adaaa|

Kernel messages in the test
First Check_fs started
Buffer I/O error on dev dm-1, logical block 15120, async page read
Scrub started
BTRFS warning (device dm-0): i/o error at logical 142737408 on dev /dev/mapper/loop1, sector 120960, root 5, inode 257, offset 0, length 4096, links 1 (path: out.txt)
BTRFS error (device dm-0): bdev /dev/mapper/loop1 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
BTRFS warning (device dm-0): i/o error at logical 142737408 on dev /dev/mapper/loop1, sector 120960, root 5, inode 257, offset 0, length 4096, links 1 (path: out.txt)
BTRFS error (device dm-0): bdev /dev/mapper/loop1 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): bdev /dev/mapper/loop1 errs: wr 1, rd 2, flush 0, corrupt 0, gen 0
BTRFS error (device dm-0): unable to fixup (regular) error at logical 142737408 on dev /dev/mapper/loop1
BTRFS error (device dm-0): unable to fixup (regular) error at logical 142737408 on dev /dev/mapper/loop1
BTRFS error (device dm-0): bdev /dev/mapper/loop1 errs: wr 1, rd 3, flush 0, corrupt 0, gen 0
Second Check_fs started
BTRFS error (device dm-0): bdev /dev/mapper/loop1 errs: wr 1, rd 4, flush 0, corrupt 0, gen 0
BTRFS info (device dm-0): bdev /dev/mapper/loop1 errs: wr 1, rd 4, flush 0, corrupt 0, gen 0
Buffer I/O error on dev dm-1, logical block 15120, async page read

--- test 4: corrupt data2; read without scrub
******* Wrong data on disk:off /dev/mapper/loop2:81854464 (data2)
Data read ||, expected |bdbbb|

Kernel messages in the test
First Check_fs started
Buffer I/O error on dev dm-2, logical block 19984, async page read
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
Second Check_fs started
BTRFS error (device dm-0): bdev /dev/mapper/loop2 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
BTRFS info (device dm-0): bdev /dev/mapper/loop2 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
Buffer I/O error on dev dm-2, logical block 19984, async page read

--x+6KMIRAuhnl3hBn
Content-Type: application/x-sh
Content-Disposition: attachment; filename="h2.sh"
Content-Transfer-Encoding: quoted-printable

#! /bin/bash=0A=0Aroot=3D"$(pwd)"=0Adisks=3D"disk1.img disk2.img disk3.img"=
=0Aimgsize=3D500M=0ABTRFS=3D../btrfs-progs/btrfs=0A=0A=0A#=0A# returns all =
the loopback devices=0A#=0Aloop_disks() {=0A	sudo losetup | grep $root | aw=
k '{ print $1 }'=0A}=0A=0Aloop_devmaps() {=0A    	sudo dmsetup ls | perl -l=
ne 'if (/^loop/) { push @a, "/dev/mapper/" . (split)[0]; } END{ print join(=
" ", @a) }'=0A}=0A=0A# diskX.img -> /dev/loopY=0Aget_loop_dev() {=0A    loc=
al disk=3D$1=0A    sudo losetup | perl -lne 'BEGIN{ $d=3D"'"$disk"'" } @a =
=3D split; print $a[0] if (m|^/dev/loop| && $a[5] =3D~ m|$d$|)'=0A}=0A=0A# =
/dev/loopX -> diskY.img=0Aget_loop_file() {=0A    local dev=3D$1=0A    sudo=
 losetup | perl -lne 'BEGIN{$d=3D"'"$dev"'"} if (m|^$d|) { print ((split)[5=
]); }'=0A}=0A=0Aget_dmesg_tag() {=0A    dmesg | tail -1 | perl -lne 'print =
$1 if (/([\d\.]+)/)'=0A}=0A=0A# prints dmesg from the next line after the t=
ag=0Aprint_dmesg_range() {=0A    [ -z "$1" ] && return=0A    dmesg | perl -=
lne 'BEGIN {=0A			   @tags =3D qw{'"$*"'};=0A			   $start =3D shift @tags;=
=0A			   print;=0A			   print "Kernel messages in the test";=0A			   print =
"First Check_fs started";=0A		       }=0A		       if ($p) {=0A			   if (def=
ined($tags[0]) && /$tags[0]/) {=0A				if ($#tags > 0) {=0A				    print "Sc=
rub started";=0A				} else {=0A      				    print "Second Check_fs started=
";=0A				}=0A				shift @tags;=0A			   }=0A		           next if (/disk space=
 caching is enabled/ ||=0A				    /has skinny extents|drop_caches/);=0A			 =
  s/\S+\s//;=0A			   print;=0A		       } elsif (/$start/) {=0A			   $p =3D =
1;=0A		       }'=0A}=0A=0A# diskX.img -> good device mapping=0Amake_good_ta=
ble() {=0A    local loopdev=3D$(get_loop_dev $1)=0A    local n_sect=3D$(ls =
-l $1 | awk '{ print int($5 / 512) }')=0A    echo 0 $n_sect linear $loopdev=
 0=0A}=0A=0A#  offset, dev/[mapper/loopX -> device mapping with error=0Amak=
e_bad_table() {=0A    local offset=3D$1=0A    local loop=3D$(basename $2)=
=0A    local sector=3D$((offset / 512))=0A    local file=3D$(get_loop_file =
/dev/$loop)=0A    local n_sect=3D$(ls -l "$file" | awk '{print int($5 / 512=
)}')=0A=0A    echo 0 $sector linear /dev/$loop 0=0A    echo $sector 1 error=
=0A    echo $((sector + 1)) $((n_sect - (sector + 1))) linear /dev/$loop $(=
(sector + 1))=0A}=0A=0A#Init the fs=0A=0Ainit_fs() {=0A	#destroy fs=0A	echo=
 umount mnt=0A	sudo umount mnt=0A=0A	sudo dmsetup remove $(loop_devmaps)=0A=
	for i in $( loop_disks ); do=0A		echo "losetup -d $i"=0A		sudo losetup -d =
$i=0A	done=0A=0A	for i in $disks; do=0A		rm $i=0A		truncate -s $imgsize $i=
=0A		sudo losetup -f $i=0A		dev=3D$(basename $(get_loop_dev $i))=0A		make_g=
ood_table $i | sudo dmsetup --addnodeoncreate create $dev=0A	done=0A=0A	loo=
ps=3D"$(loop_devmaps)"=0A	loop1=3D"$(echo $loops | awk '{print $1}')"=0A	ec=
ho "loops=3D$loops; loop1=3D$loop1"=0A=0A	sudo mkfs.btrfs -d raid5 -m raid5=
 $loops=0A	sudo mount $loop1 mnt/=0A=0A	python -c "print 'ad'+'a'*65534+'bd=
'+'b'*65533" | sudo tee mnt/out.txt >/dev/null=0A=0A	ls -l mnt/out.txt=0A=
=0A	sudo umount mnt=0A	sync; sync=0A}=0A=0Acheck_fs() {=0A	local error=3D0=
=0A        sudo mount $loop1 mnt=0A        data=3D"$(sudo $BTRFS insp phy m=
nt/out.txt)"=0A        =0A        data1_off=3D"$(echo "$data" | grep "DATA$=
" | awk '{ print $5 }')"=0A        data2_off=3D"$(echo "$data" | grep "OTHE=
R$" | awk '{ print $5 }')"=0A        parity_off=3D"$(echo "$data" | grep "P=
ARITY$" | awk '{ print $5 }')"=0A        data1_dev=3D"$(echo "$data" | grep=
 "DATA$" | awk '{ print $3 }')"=0A        data2_dev=3D"$(echo "$data" | gre=
p "OTHER$" | awk '{ print $3 }')"=0A        parity_dev=3D"$(echo "$data" | =
grep "PARITY$" | awk '{ print $3 }')"=0A        =0A        sudo umount mnt=
=0A        =0A	# check=0A	d=3D"$(sudo dd 2>/dev/null if=3D$data1_dev bs=3D1=
 skip=3D$data1_off count=3D5)"=0A	if [ "$d" !=3D "adaaa" ]; then=0A		echo "=
******* Wrong data on disk:off $data1_dev:$data1_off (data1)"=0A		echo "Dat=
a read |$d|, expected |adaaa|"=0A		error=3D1=0A	fi=0A=0A	d=3D"$(sudo dd 2>/=
dev/null if=3D$data2_dev bs=3D1 skip=3D$data2_off count=3D5)"=0A	if [ "$d" =
!=3D "bdbbb" ]; then=0A		echo "******* Wrong data on disk:off $data2_dev:$d=
ata2_off (data2)"=0A		echo "Data read |$d|, expected |bdbbb|"=0A		error=3D1=
=0A	fi=0A=0A	d=3D"$(sudo dd 2>/dev/null if=3D$parity_dev bs=3D1 skip=3D$par=
ity_off count=3D5 | xxd | dd 2>/dev/null bs=3D1 count=3D9 skip=3D9)"=0A	if =
[ "x$d" !=3D "x0300 0303" ]; then=0A		echo "******* Wrong data on disk:off =
$parity_dev:$parity_off (parity)"=0A	    	echo "Data read |$d|, expected |0=
300 0303|"=0A		error=3D1=0A	fi=0A=0A	if [ "$error" -gt 0 ]; then=0A	    pri=
nt_dmesg_range "$@"=0A	    return 1=0A	fi=0A=0A	return 0=0A}=0A=0Atest_corr=
upt_parity() {=0A	echo "--- test 1: corrupt parity"=0A	echo 3 | sudo tee >/=
dev/null /proc/sys/vm/drop_caches=0A	local base_dev=3D$(basename $parity_de=
v)=0A	sudo dmsetup remove $base_dev 2> /dev/null=0A	make_bad_table $parity_=
off $parity_dev | sudo dmsetup create $base_dev --addnodeoncreate=0A	local =
tag1=3D$(get_dmesg_tag)=0A	check_fs &>/dev/null && {=0A			echo Corruption f=
ailed=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop=
_caches=0A	local tag2=3D$(get_dmesg_tag)=0A	sudo mount $loop1 mnt=0A	sudo b=
trfs scrub start mnt/.=0A	sync; sync=0A	cat mnt/out.txt &>/dev/null || echo=
 "Read FAIL"=0A	sudo umount mnt=0A	echo 3 | sudo tee >/dev/null /proc/sys/v=
m/drop_caches=0A	local tag3=3D$(get_dmesg_tag)=0A	check_fs $tag1 $tag2 $tag=
3 || return 1=0A	echo "--- test1: OK"=0A	return 0=0A}=0A=0A=0A=0Atest_corru=
pt_data2() {=0A	echo "--- test 2: corrupt data2"=0A	echo 3 | sudo tee >/dev=
/null /proc/sys/vm/drop_caches=0A	local base_dev=3D$(basename $data2_dev)=
=0A	sudo dmsetup remove $base_dev 2> /dev/null=0A	make_bad_table $data2_off=
 $base_dev | sudo dmsetup create $base_dev --addnodeoncreate=0A	local tag1=
=3D$(get_dmesg_tag)=0A	check_fs &>/dev/null && {=0A			echo Corruption faile=
d=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev/null >/dev/null /proc/sys/=
vm/drop_caches=0A	local tag2=3D$(get_dmesg_tag)	=0A	sudo mount $loop1 mnt=
=0A	sudo btrfs scrub start mnt/.=0A	sync; sync=0A	cat mnt/out.txt &>/dev/nu=
ll || echo "Read FAIL"=0A	sudo umount mnt=0A	echo 3 | sudo tee >/dev/null /=
proc/sys/vm/drop_caches=0A	local tag3=3D$(get_dmesg_tag)		=0A	check_fs $tag=
1 $tag2 $tag3 || return 1=0A	echo "--- test2: OK"=0A	return 0=0A}=0A=0Atest=
_corrupt_data1() {=0A	echo "--- test 3: corrupt data1"=0A	echo 3 | sudo tee=
 >/dev/null /proc/sys/vm/drop_caches=0A	local base_dev=3D$(basename $data1_=
dev)=0A	sudo dmsetup remove $base_dev 2> /dev/null=0A	make_bad_table $data1=
_off $base_dev | sudo dmsetup create $base_dev --addnodeoncreate=0A	local t=
ag1=3D$(get_dmesg_tag)=0A	check_fs &>/dev/null && {=0A			echo Corruption fa=
iled=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_=
caches=0A	local tag2=3D$(get_dmesg_tag)=0A	sudo mount $loop1 mnt=0A	sudo bt=
rfs scrub start mnt/.=0A	sync; sync=0A	cat mnt/out.txt &>/dev/null || echo =
"Read FAIL"=0A	sudo umount mnt=0A	local tag3=3D$(get_dmesg_tag)=0A	echo 3 |=
 sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	check_fs $tag1 $tag2 $tag3=
 || return 1=0A	echo "--- test3: OK"=0A	return 0=0A}=0A=0Atest_corrupt_data=
2_wo_scrub() {=0A	echo "--- test 4: corrupt data2; read without scrub"=0A	e=
cho 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	local base_dev=3D$(=
basename $data2_dev)=0A	sudo dmsetup remove $base_dev 2> /dev/null=0A	make_=
bad_table $data2_off $base_dev | sudo dmsetup create $base_dev --addnodeonc=
reate=0A	local tag1=3D$(get_dmesg_tag)=0A	check_fs &>/dev/null && {=0A			ec=
ho Corruption failed=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev/null /p=
roc/sys/vm/drop_caches=0A	sudo mount $loop1 mnt=0A	cat mnt/out.txt &>/dev/n=
ull || echo "Read FAIL"=0A	sudo umount mnt=0A	local tag2=3D$(get_dmesg_tag)=
=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	check_fs $tag1=
 $tag2 || return 1=0A	echo "--- test 4: OK"=0A	return 0=0A}=0A=0A=0Afor t i=
n test_corrupt_parity test_corrupt_data2 test_corrupt_data1 \=0A    test_co=
rrupt_data2_wo_scrub; do=0A    =0A        init_fs &>/dev/null=0A        if =
! check_fs &>/dev/null; then =0A             echo Integrity test failed=0A =
            exit 100=0A        fi=0A=0A        $t=0A        echo=0Adone=0A=
=0Asudo dmsetup remove $(loop_devmaps)=0Asudo losetup -d $(loop_disks)=0A
--x+6KMIRAuhnl3hBn--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.piipiip.net ([176.31.107.179]:33214 "EHLO
	james.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcGPQEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 12:04:39 -0400
Received: from jlavi by james.piipiip.net with local (Exim 4.80)
	(envelope-from <jlavi@ks392938.kimsufi.com>)
	id 1bORrz-0004jE-Fc
	for linux-btrfs@vger.kernel.org; Sat, 16 Jul 2016 18:51:11 +0300
Date: Sat, 16 Jul 2016 18:51:11 +0300
From: Jarkko Lavinen <jlavi@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Message-ID: <20160716155111.GA9751@ks392938.kimsufi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
In-Reply-To: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 07/12/2016 05:50 PM, Goffredo Baroncelli wrote:
> Using "btrfs insp phy" I developed a script to trigger the bug.

Thank you for the script and all for sharing the raid5 and scrubbing issues. I have been using two raid5 arrays and ran scrub occasionally without any problems lately and been in false confidence. I converted successfully raid5 arrays into raid10 without any glitch.

I tried to modify the shell script so that instead of corrupting data with dd, a simulated bad block is created with device mapper. Modern disks are likely to either return the correct data or an error if they cannot.

The modified script behaves very much like the original dd version. With dd version I see wrong data instead of expected data. With simulated bad block I see no data at all instead of expected data since dd quits on read error.

Jarkko Lavinen

--Q68bSM7Ycu6FN28Q
Content-Type: application/x-sh
Content-Disposition: attachment; filename="h.sh"
Content-Transfer-Encoding: quoted-printable

#! /bin/bash=0A=0Aroot=3D"$(pwd)"=0Adisks=3D"disk1.img disk2.img disk3.img"=
=0Aimgsize=3D500M=0ABTRFS=3D../btrfs-progs/btrfs=0A=0A=0A#=0A# returns all =
the loopback devices=0A#=0Aloop_disks() {=0A	sudo losetup | grep $root | aw=
k '{ print $1 }'=0A}=0A=0Aloop_devmaps() {=0A    	sudo dmsetup ls | perl -l=
ne 'if (/^loop/) { push @a, "/dev/mapper/" . (split)[0]; } END{ print join(=
" ", @a) }'=0A}=0A=0A# diskX.imf -> /dev/loopY=0Aget_loop_dev() {=0A    loc=
al disk=3D$1=0A    sudo losetup | perl -lne 'BEGIN{ $d=3D"'"$disk"'" } @a =
=3D split; print $a[0] if (m|^/dev/loop| && $a[5] =3D~ m|$d$|)'=0A}=0A=0A# =
/dev/loopX -> diskY.img=0Aget_loop_file() {=0A    local dev=3D$1=0A    sudo=
 losetup | perl -lne 'BEGIN{$d=3D"'"$dev"'"} if (m|^$d|) { print ((split)[5=
]); }'=0A}=0A=0A# diskX.img -> good device mapping=0Amake_good_table() {=0A=
    local loopdev=3D$(get_loop_dev $1)=0A    local n_sect=3D$(ls -l $1 | aw=
k '{ print int($5 / 512) }')=0A    echo 0 $n_sect linear $loopdev 0=0A}=0A=
=0A#  offset, dev/[mapper/loopX -> device mapping with error=0Amake_bad_tab=
le() {=0A    local offset=3D$1=0A    local loop=3D$(basename $2)=0A    loca=
l sector=3D$((offset / 512))=0A    local file=3D$(get_loop_file /dev/$loop)=
=0A    local n_sect=3D$(ls -l "$file" | awk '{print int($5 / 512)}')=0A=0A =
   echo 0 $sector linear /dev/$loop 0=0A    echo $sector 1 error=0A    echo=
 $((sector + 1)) $((n_sect - (sector + 1))) linear /dev/$loop $((sector + 1=
))=0A}=0A=0A#Init the fs=0A=0Ainit_fs() {=0A	#destroy fs=0A	echo umount mnt=
=0A	sudo umount mnt=0A=0A	for i in $( loop_devmaps ); do=0A	    echo "dmset=
up remove $i"=0A	    sudo dmsetup remove $i=0A	done=0A=0A	for i in $( loop_=
disks ); do=0A		echo "losetup -d $i"=0A		sudo losetup -d $i=0A	done=0A=0A	f=
or i in $disks; do=0A		rm $i=0A		truncate -s $imgsize $i=0A		sudo losetup -=
f $i=0A		dev=3D$(basename $(get_loop_dev $i))=0A		make_good_table $i | sudo=
 dmsetup --addnodeoncreate create $dev=0A	done=0A=0A	loops=3D"$(loop_devmap=
s)"=0A	loop1=3D"$(echo $loops | awk '{print $1}')"=0A	echo "loops=3D$loops;=
 loop1=3D$loop1"=0A=0A	sudo mkfs.btrfs -d raid5 -m raid5 $loops=0A	sudo mou=
nt $loop1 mnt/=0A=0A	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo=
 tee mnt/out.txt >/dev/null=0A=0A	ls -l mnt/out.txt=0A=0A	sudo umount mnt=
=0A	sync; sync=0A}=0A=0Acheck_fs() {=0A=0A        sudo mount $loop1 mnt=0A =
       data=3D"$(sudo $BTRFS insp phy mnt/out.txt)"=0A        =0A        da=
ta1_off=3D"$(echo "$data" | grep "DATA$" | awk '{ print $5 }')"=0A        d=
ata2_off=3D"$(echo "$data" | grep "OTHER$" | awk '{ print $5 }')"=0A       =
 parity_off=3D"$(echo "$data" | grep "PARITY$" | awk '{ print $5 }')"=0A   =
     data1_dev=3D"$(echo "$data" | grep "DATA$" | awk '{ print $3 }')"=0A  =
      data2_dev=3D"$(echo "$data" | grep "OTHER$" | awk '{ print $3 }')"=0A=
        parity_dev=3D"$(echo "$data" | grep "PARITY$" | awk '{ print $3 }')=
"=0A        =0A        sudo umount mnt=0A        =0A	# check=0A	d=3D"$(sudo=
 dd 2>/dev/null if=3D$data1_dev bs=3D1 skip=3D$data1_off count=3D5)"=0A	if =
[ "$d" !=3D "adaaa" ]; then=0A		echo "******* Wrong data on disk:off $data1=
_dev:$data1_off (data1)"=0A		echo "Data read |$d|, expected |adaaa|"=0A		re=
turn 1=0A	fi=0A=0A	d=3D"$(sudo dd 2>/dev/null if=3D$data2_dev bs=3D1 skip=
=3D$data2_off count=3D5)"=0A	if [ "$d" !=3D "bdbbb" ]; then=0A		echo "*****=
** Wrong data on disk:off $data2_dev:$data2_off (data2)"=0A		echo "Data rea=
d |$d|, expected |bdbbb|"=0A		return 1=0A	fi=0A=0A	d=3D"$(sudo dd 2>/dev/nu=
ll if=3D$parity_dev bs=3D1 skip=3D$parity_off count=3D5 | xxd | dd 2>/dev/n=
ull bs=3D1 count=3D9 skip=3D9)"=0A	if [ "x$d" !=3D "x0300 0303" ]; then=0A	=
	echo "******* Wrong data on disk:off $parity_dev:$parity_off (parity)"=0A	=
    	echo "Data read |$d|, expected |0300 0303|"=0A		return 1=0A	fi=0A=0A	r=
eturn 0=0A}=0A=0Atest_corrupt_parity() {=0A	echo "--- test 1: corrupt parit=
y"=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	local base_d=
ev=3D$(basename $parity_dev)=0A	sudo dmsetup remove $base_dev 2> /dev/null=
=0A	make_bad_table $parity_off $parity_dev | sudo dmsetup create $base_dev =
--addnodeoncreate=0A=0A	check_fs &>/dev/null && {=0A			echo Corruption fail=
ed=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_ca=
ches=0A	sudo mount $loop1 mnt=0A	sudo btrfs scrub start mnt/.=0A	sync; sync=
=0A	cat mnt/out.txt &>/dev/null || echo "Read FAIL"=0A	sudo umount mnt=0A	e=
cho 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	check_fs || return =
1=0A	echo "--- test1: OK"=0A	return 0=0A}=0A=0A=0A=0Atest_corrupt_data2() {=
=0A	echo "--- test 2: corrupt data2"=0A	echo 3 | sudo tee >/dev/null /proc/=
sys/vm/drop_caches=0A	local base_dev=3D$(basename $data2_dev)=0A	sudo dmset=
up remove $base_dev 2> /dev/null=0A	make_bad_table $data2_off $base_dev | s=
udo dmsetup create $base_dev --addnodeoncreate=0A	check_fs &>/dev/null && {=
=0A			echo Corruption failed=0A			exit 100=0A		}=0A	echo 3 | sudo tee >/dev=
/null >/dev/null /proc/sys/vm/drop_caches=0A	sudo mount $loop1 mnt=0A	sudo =
btrfs scrub start mnt/.=0A	sync; sync=0A	cat mnt/out.txt &>/dev/null || ech=
o "Read FAIL"=0A	sudo umount mnt=0A	echo 3 | sudo tee >/dev/null /proc/sys/=
vm/drop_caches=0A	check_fs || return 1=0A	echo "--- test2: OK"=0A	return 0=
=0A}=0A=0Atest_corrupt_data1() {=0A	echo "--- test 3: corrupt data1"=0A	ech=
o 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	local base_dev=3D$(ba=
sename $data1_dev)=0A	sudo dmsetup remove $base_dev 2> /dev/null=0A	make_ba=
d_table $data1_off $base_dev | sudo dmsetup create $base_dev --addnodeoncre=
ate=0A	check_fs &>/dev/null && {=0A			echo Corruption failed=0A			exit 100=
=0A		}=0A	echo 3 | sudo tee >/dev/null /proc/sys/vm/drop_caches=0A	sudo mou=
nt $loop1 mnt=0A	sudo btrfs scrub start mnt/.=0A	sync; sync=0A	cat mnt/out.=
txt &>/dev/null || echo "Read FAIL"=0A	sudo umount mnt=0A	echo 3 | sudo tee=
 >/dev/null /proc/sys/vm/drop_caches=0A	check_fs || return 1=0A	echo "--- t=
est3: OK"=0A	return 0=0A}=0A=0Atest_corrupt_data2_wo_scrub() {=0A	echo "---=
 test 4: corrupt data2; read without scrub"=0A	echo 3 | sudo tee >/dev/null=
 /proc/sys/vm/drop_caches=0A	local base_dev=3D$(basename $data2_dev)=0A	sud=
o dmsetup remove $base_dev 2> /dev/null=0A	make_bad_table $data2_off $base_=
dev | sudo dmsetup create $base_dev --addnodeoncreate=0A	check_fs &>/dev/nu=
ll && {=0A			echo Corruption failed=0A			exit 100=0A		}=0A	echo 3 | sudo te=
e >/dev/null /proc/sys/vm/drop_caches=0A	sudo mount $loop1 mnt=0A	cat mnt/o=
ut.txt &>/dev/null || echo "Read FAIL"=0A	sudo umount mnt=0A	echo 3 | sudo =
tee >/dev/null /proc/sys/vm/drop_caches=0A	check_fs || return 1=0A	echo "--=
- test 4: OK"=0A	return 0=0A}=0A=0A=0Afor t in test_corrupt_parity test_cor=
rupt_data2 test_corrupt_data1 \=0A    test_corrupt_data2_wo_scrub; do=0A   =
 =0A        init_fs &>/dev/null=0A        if ! check_fs &>/dev/null; then =
=0A             echo Integrity test failed=0A             exit 100=0A      =
  fi=0A=0A        $t=0A        echo=0A    =0Adone=0A
--Q68bSM7Ycu6FN28Q--

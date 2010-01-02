From: Steve Freitas <sflist@ihonk.com>
Subject: Segfault in btrfsck
Date: Sat, 02 Jan 2010 15:56:05 -0800
Message-ID: <1262476565.17096.20.camel@phat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've got a Debian unstable system (kernel is 2.6.32-trunk-amd64) with
the root partition running btrfs. Used it for a few weeks with no large
problems, but had to reboot it this morning after it became unresponsive
simultaneous with unexplained constant disk access. It wouldn't reboot
-- it loaded the kernel fine off the ext3 /boot partition but couldn't
mount root.

Booted into the Karmic live disk (2.6.31-14, also amd64). Ran their
stock btrfsck and it crashed. Pulled the latest from unstable git and it
did the same.

I didn't build btrfsck with debug enabled, so if you want that let me
know how to change the Makefile (or whatever). I can also supply the
core file if you like. Also, smartctl is telling me this hard drive has
lots of bad sectors :-D, but don't know if that's relevant here.

Thanks!

- Steve

root@ubuntu:~# btrfsck /dev/sda3
leaf 72134656 items 26 free space 2019 generation 29647 owner 2
fs uuid c43fe29d-d95c-4a33-8097-f5c61dfc77ed
chunk uuid 6a52db0a-04d3-4a1e-8e27-f73306b28a51
	item 0 key (69120000 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204066004992 a8 8192) level 0
		tree block backref root 2
	item 1 key (69124096 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204069421056 a8 524288) level 0
		tree block backref root 2
	item 2 key (69128192 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204071538688 a8 81920) level 0
		tree block backref root 2
	item 3 key (69132288 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204075094016 a8 16384) level 0
		tree block backref root 2
	item 4 key (69136384 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204078809088 a8 49152) level 0
		tree block backref root 2
	item 5 key (69144576 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
		extent refs 1 gen 28342 flags 2
		tree block key (214869 54 2384640830) level 2
		tree block backref root 5
	item 6 key (69148672 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204124024832 a8 8192) level 0
		tree block backref root 2
	item 7 key (69152768 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204131520512 a8 20480) level 0
		tree block backref root 2
	item 8 key (69156864 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204142813184 a8 421888) level 1
		tree block backref root 2
	item 9 key (69160960 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204142813184 a8 421888) level 0
		tree block backref root 2
	item 10 key (69165056 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204149268480 a8 507904) level 0
		tree block backref root 2
	item 11 key (69169152 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (204154077184 a8 65536) level 0
		tree block backref root 2
	item 12 key (69173248 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
		extent refs 1 gen 28052 flags 2
		tree block key (18446744073709551606 80 223654449152) level 1
		tree block backref root 7
	item 13 key (69177344 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
		extent refs 1 gen 28052 flags 2
		tree block key (18446744073709551606 80 223726600192) level 0
		tree block backref root 7
	item 14 key (69181440 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204194607104) level 1
		tree block backref root 7
	item 15 key (69185536 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204258570240) level 0
		tree block backref root 7
	item 16 key (69189632 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204256403456) level 0
		tree block backref root 7
	item 17 key (69193728 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204252368896) level 0
		tree block backref root 7
	item 18 key (69197824 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204248334336) level 0
		tree block backref root 7
	item 19 key (69201920 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204244299776) level 0
		tree block backref root 7
	item 20 key (69206016 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204243025920) level 0
		tree block backref root 7
	item 21 key (69210112 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204238987264) level 0
		tree block backref root 7
	item 22 key (69214208 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204234952704) level 0
		tree block backref root 7
	item 23 key (69218304 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204229103616) level 0
		tree block backref root 7
	item 24 key (69222400 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
		extent refs 1 gen 25448 flags 2
		tree block key (18446744073709551606 80 204225191936) level 0
		tree block backref root 7
	item 25 key (69226496 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
		extent refs 1 gen 28342 flags 2
		tree block key (216906 54 775391778) level 1
		tree block backref root 5
failed to find block number 69140480
Aborted (core dumped)


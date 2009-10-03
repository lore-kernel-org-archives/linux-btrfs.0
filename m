From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Sat, 3 Oct 2009 13:21:09 +0100
Message-ID: <20091003122109.GB3116@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I've just had the following on my home server. I believe that it's
btrfs that's responsible, as the machine wasn't doing much other than
reading/writing on a btrfs filesystem. The process that was doing so
is now stuck in D+ state, and can't be killed. The timing of the oops
at the end is also suggestive of being involved in the same incident.
This is the only btrfs filesystem on the machine.

hrm@vlad:~ $ uname -a
Linux vlad 2.6.31 #1 Tue Sep 15 15:36:35 BST 2009 x86_64 GNU/Linux
hrm@vlad:~ $ df -h
Filesystem            Size  Used Avail Use% Mounted on
[...]
/dev/mapper/media-scratch
                      1.4T  1.3T   85G  94% /media/vlad/video


Oct  3 12:29:36 vlad kernel: 27840 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1023267569664 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1024341311488 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1025415053312 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1026488795136 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1027562536960 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1028636278784 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1028904714240, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1029710020608 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1030783762432 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1031723286528, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1031857504256 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1032931246080 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1034004987904 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1035078729728 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1036152471552 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1036420907008, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: entry offset 1037091995648, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 2 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1037226213376 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1038165737472, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1038299955200 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1039373697024 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1040447438848 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1041521180672 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1042594922496 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1043668664320 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1044742406144 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1045816147968 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1046889889792 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1047963631616 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1049037373440 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1050111115264 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1051184857088 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1051855945728, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: entry offset 1052124381184, bytes 16384, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 2 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1052258598912 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1053332340736 has 1073741824 bytes, 1073713152 used 0 pinned 28672 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1054406082560 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1055479824384 has 1073741824 bytes, 1073684480 used 0 pinned 57344 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1055479824384, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1056553566208 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1057627308032 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1058701049856 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1059774791680 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1059774791680, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1060848533504 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1061116968960, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1061922275328 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1062996017152 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1064069758976 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1065143500800 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1066217242624 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1067290984448 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1068364726272 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1069438468096 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1070512209920 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1071585951744 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1072659693568 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1073733435392 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1074807177216 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1075880919040 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1076954660864 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1078028402688 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1079102144512 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1080175886336 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1081249628160 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1082323369984 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1083397111808 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1084470853632 has 1073741824 bytes, 1073709056 used 0 pinned 32768 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1084873506816, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1085544595456 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1086618337280 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1087692079104 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1088765820928 has 1073741824 bytes, 1073700864 used 0 pinned 40960 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1089839562752 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1090913304576 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1091987046400 has 1073741824 bytes, 1073709056 used 0 pinned 32768 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1093060788224 has 1073741824 bytes, 1073704960 used 0 pinned 36864 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1094000312320, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1094134530048 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1095208271872 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1096282013696 has 1073741824 bytes, 1073713152 used 0 pinned 28672 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1097355755520 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1098429497344 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1099369021440, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1099503239168 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1100576980992 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1101650722816 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1101919158272, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1102724464640 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1103798206464 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1104871948288 has 1073741824 bytes, 1073713152 used 0 pinned 28672 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1105945690112 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1107019431936 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1108093173760 has 1073741824 bytes, 1073713152 used 0 pinned 28672 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1109032697856, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1109166915584 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1110240657408 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1111314399232 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1112388141056 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1113461882880 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1114535624704 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1115609366528 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1116012019712, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1116683108352 has 1073741824 bytes, 1073696768 used 0 pinned 45056 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1117756850176 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1118830592000 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1119904333824 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1120978075648 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1122051817472 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1123125559296 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1124199301120 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1125273042944 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1126346784768 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1127420526592 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1128494268416 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1129568010240 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1130641752064 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1131581276160, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1131715493888 has 1073741824 bytes, 1073709056 used 0 pinned 32768 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1132789235712 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1133326106624, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1133862977536 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1134936719360 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1135339372544, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1136010461184 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1137084203008 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1138157944832 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1139231686656 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1139365904384, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1140305428480 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1141379170304 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1142318694400, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1142452912128 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1142721347584, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1143526653952 has 1073741824 bytes, 1073659904 used 0 pinned 81920 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1144600395776 has 1073741824 bytes, 1073664000 used 0 pinned 77824 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1145674137600 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1146747879424 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1147821621248 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1148761145344, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1148895363072 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1149566451712, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1149969104896 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1151042846720 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1152116588544 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1153190330368 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1154264072192 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1155337814016 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1156411555840 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1157485297664 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1158559039488 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1159632781312 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1160706523136 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1161780264960 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1162854006784 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1163927748608 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1164867272704, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1165001490432 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1165672579072, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1166075232256 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1167148974080 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1168222715904 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1169296457728 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1170370199552 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1171309723648, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1171443941376 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1172517683200 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1173591425024 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1174530949120, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1174665166848 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1175738908672 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1176812650496 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1177886392320 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1178960134144 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1180033875968 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1181107617792 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1181510270976, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1182181359616 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1183120883712, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1183255101440 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1184328843264 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1185402585088 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1186342109184, bytes 16384, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1186476326912 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1186878980096, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1187550068736 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1188623810560 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1189697552384 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1190234423296, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1190771294208 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1191845036032 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1192918777856 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1193992519680 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1195066261504 has 1073741824 bytes, 1073713152 used 0 pinned 28672 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1195334696960, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1196140003328 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1197213745152 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1198287486976 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1198421704704, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1199361228800 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1200434970624 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1201508712448 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1202582454272 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1203656196096 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1204729937920 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1205803679744 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1206877421568 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1207816945664, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1207951163392 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1208488034304, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1209024905216 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1210098647040 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1211172388864 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1212246130688 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1213185654784, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1213319872512 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1214393614336 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1215467356160 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1216541097984 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1217614839808 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1218688581632 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1219762323456 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1220836065280 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1221909807104 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1222983548928 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1224057290752 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1225131032576 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1226204774400 has 1073741824 bytes, 1073700864 used 0 pinned 40960 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1227278516224 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1228352258048 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1229157564416, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: entry offset 1229291782144, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 2 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1229425999872 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1230499741696 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1231573483520 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1232647225344 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1233720967168 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1234794708992 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1235734233088, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1235868450816 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1236942192640 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1237881716736, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1238015934464 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1239089676288 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1240163418112 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1241237159936 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1242176684032, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1242310901760 has 1073741824 bytes, 1073709056 used 0 pinned 32768 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1243384643584 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1244458385408 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1245532127232 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1246605869056 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1247679610880 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1248753352704 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1249827094528 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1250900836352 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1251840360448, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1251974578176 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1253048320000 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1254122061824 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1254927368192, bytes 16384, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1255195803648 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1256269545472 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1258417029120 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1259490770944 has 1073741824 bytes, 1073709056 used 0 pinned 32768 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1259624988672, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1260564512768 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1261638254592 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1262711996416 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1263785738240 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1264859480064 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1265933221888 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1268080705536 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1269154447360 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1270228189184 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1271301931008 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1272375672832 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1273449414656 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1274523156480 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1275596898304 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1277744381952 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1278818123776 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1279891865600 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1280965607424 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1282039349248 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1283113091072 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1284186832896 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1285260574720 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1287408058368 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1288481800192 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1289555542016 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1290495066112, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1290629283840 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1291703025664 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1292776767488 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1293850509312 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1294924251136 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1297071734784 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1298145476608 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1298413912064, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1299219218432 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1300292960256 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1301366702080 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1302440443904 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1303379968000, bytes 8192, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1303514185728 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1304587927552 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1306735411200 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1307809153024 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1308882894848 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1309956636672 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1311030378496 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1312104120320 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1313177862144 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1315325345792 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1316399087616 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1317472829440 has 1073741824 bytes, 1073717248 used 0 pinned 24576 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1318546571264 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1319620313088 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1320694054912 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1321767796736 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1322841538560 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1324989022208 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1326062764032 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1327136505856 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1328076029952, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1328210247680 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1329283989504 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1330357731328 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1331431473152 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1332505214976 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1334652698624 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1335726440448 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1336800182272 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1337873924096 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1338947665920 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1340021407744 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1341095149568 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1342168891392 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1344316375040 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1345390116864 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1346463858688 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1347403382784, bytes 12288, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1347537600512 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1348611342336 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1349685084160 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1350758825984 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1351832567808 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1353980051456 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1355053793280 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1356127535104 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1357201276928 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1358275018752 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1359348760576 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1360422502400 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1361496244224 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: entry offset 1362435768320, bytes 4096, bitmap yes
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 1 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1363643727872 has 1073741824 bytes, 1073725440 used 0 pinned 16384 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1364717469696 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1365791211520 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1366864953344 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1367938695168 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1369012436992 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1370086178816 has 1073741824 bytes, 1073729536 used 0 pinned 12288 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1371159920640 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1373307404288 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1374381146112 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1375454887936 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1376528629760 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1377602371584 has 1073741824 bytes, 1073733632 used 0 pinned 8192 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1378676113408 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1379749855232 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1380823597056 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1382971080704 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1384044822528 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1385118564352 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1386192306176 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1387266048000 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1388339789824 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1389413531648 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1390487273472 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1392634757120 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1393708498944 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1394782240768 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1395855982592 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1396929724416 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1398003466240 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1399077208064 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1400150949888 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: block group 1401224691712 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
Oct  3 12:29:36 vlad kernel: block group has cluster?: no
Oct  3 12:29:36 vlad kernel: 0 blocks of free space at or bigger than bytes is
Oct  3 12:29:36 vlad kernel: ------------[ cut here ]------------
Oct  3 12:29:36 vlad kernel: kernel BUG at fs/btrfs/inode.c:735!
Oct  3 12:29:36 vlad kernel: invalid opcode: 0000 [#1]
Oct  3 12:29:36 vlad kernel: last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
Oct  3 12:29:36 vlad kernel: CPU 0
Oct  3 12:29:36 vlad kernel: Modules linked in: tcp_diag inet_diag cpufreq_userspace nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 bridge stp llc btrfs zlib_deflate xfs exportfs hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide_cd_mod evdev usb_storage pcspkr usb_libusual usbhid k8temp hwmon pl2303 usbserial i2c_viapro i2c_core 8250_pnp 8250 serial_core button processor dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sg sr_mod cdrom ehci_hcd uhci_hcd via82cxxx via_rhine mii pata_via usbcore sd_mod ide_pci_generic floppy ide_core thermal fan unix [last unloaded: scsi_wait_scan]
Oct  3 12:29:36 vlad kernel: Pid: 24318, comm: pdflush Not tainted 2.6.31 #1 System Product Name
Oct  3 12:29:36 vlad kernel: RIP: 0010:[<ffffffffa02c92a4>]  [<ffffffffa02c92a4>] cow_file_range+0x1b2/0x307 [btrfs]
Oct  3 12:29:36 vlad kernel: RSP: 0018:ffff880000413940  EFLAGS: 00010286
Oct  3 12:29:36 vlad kernel: RAX: 00000000ffffffe4 RBX: 0000000000001000 RCX: ffff880038cfcba8
Oct  3 12:29:36 vlad kernel: RDX: 00000000ffffffff RSI: 00000000000460d6 RDI: ffff880038cfcba8
Oct  3 12:29:36 vlad kernel: RBP: 000000006cd6c000 R08: 0000000000000000 R09: 000000000000000a
Oct  3 12:29:36 vlad kernel: R10: 000000000000000a R11: 00000000ffffffff R12: 0000000000001000
Oct  3 12:29:36 vlad kernel: R13: ffff880038dbf800 R14: ffff88003a4dad30 R15: 000000006cd6bfff
Oct  3 12:29:36 vlad kernel: FS:  00007ffd7a8c5750(0000) GS:ffffffff812f5000(0000) knlGS:0000000000000000
Oct  3 12:29:36 vlad kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Oct  3 12:29:36 vlad kernel: CR2: 00007f6a783bf000 CR3: 000000003b864000 CR4: 00000000000006f0
Oct  3 12:29:36 vlad kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  3 12:29:36 vlad kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  3 12:29:36 vlad kernel: Process pdflush (pid: 24318, threadinfo ffff880000412000, task ffff880037b72db0)
Oct  3 12:29:36 vlad kernel: Stack:
Oct  3 12:29:36 vlad kernel: ffffffffffffffff ffff8800004139b0 0000000000000001 0000000000000000
Oct  3 12:29:36 vlad kernel: <0> ffff880000000000 ffff880011536dc8 ffff880000413b98 ffff880000413bb4
Oct  3 12:29:36 vlad kernel: <0> ffffea00008087b8 0000100011536dc8 ffff88003a4dabd8 ffff8800116e4b20
Oct  3 12:29:36 vlad kernel: Call Trace:
Oct  3 12:29:36 vlad kernel: [<ffffffffa02c9aaf>] ? run_delalloc_range+0x9e/0x2ed [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02de274>] ? find_lock_delalloc_range+0x124/0x17d [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02de9a1>] ? __extent_writepage+0x21e/0x803 [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffff8104d92f>] ? find_get_pages_tag+0x46/0xb6
Oct  3 12:29:36 vlad kernel: [<ffffffffa02dc3da>] ? extent_write_cache_pages+0x13c/0x242 [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02db070>] ? flush_write_bio+0x0/0x2 [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02de783>] ? __extent_writepage+0x0/0x803 [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02dc52b>] ? extent_writepages+0x4b/0x5f [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffffa02c807e>] ? btrfs_get_extent+0x0/0x71f [btrfs]
Oct  3 12:29:36 vlad kernel: [<ffffffff81053161>] ? do_writepages+0x20/0x2d
Oct  3 12:29:36 vlad kernel: [<ffffffff81085097>] ? writeback_single_inode+0x148/0x323
Oct  3 12:29:36 vlad kernel: [<ffffffffa010e6f6>] ? dm_any_congested+0x4a/0x56 [dm_mod]
Oct  3 12:29:36 vlad kernel: [<ffffffff81085650>] ? generic_sync_sb_inodes+0x295/0x3f0
Oct  3 12:29:36 vlad kernel: [<ffffffff81053bc3>] ? pdflush+0x0/0x1b9
Oct  3 12:29:36 vlad kernel: [<ffffffff8108588c>] ? writeback_inodes+0x68/0xa1
Oct  3 12:29:36 vlad kernel: [<ffffffff81053286>] ? wb_kupdate+0x95/0x104
Oct  3 12:29:36 vlad kernel: [<ffffffff81053ccf>] ? pdflush+0x10c/0x1b9
Oct  3 12:29:36 vlad kernel: [<ffffffff810531f1>] ? wb_kupdate+0x0/0x104
Oct  3 12:29:36 vlad kernel: [<ffffffff81037241>] ? kthread+0x85/0x8d
Oct  3 12:29:36 vlad kernel: [<ffffffff8100ba4a>] ? child_rip+0xa/0x20
Oct  3 12:29:36 vlad kernel: [<ffffffff810371bc>] ? kthread+0x0/0x8d
Oct  3 12:29:36 vlad kernel: [<ffffffff8100ba40>] ? child_rip+0x0/0x20
Oct  3 12:29:36 vlad kernel: Code: 44 24 70 48 0f 46 54 24 60 45 31 c0 48 c7 44 24 10 01 00 00 00 48 89 44 24 08 48 c7 04 24 ff ff ff ff e8 79 ed fe ff 85 c0 74 04 <0f> 0b eb fe bf 50 00 00 00 e8 99 6c 00 00 48 89 68 18 48 89 68
Oct  3 12:29:36 vlad kernel: RIP  [<ffffffffa02c92a4>] cow_file_range+0x1b2/0x307 [btrfs]
Oct  3 12:29:36 vlad kernel: RSP <ffff880000413940>
Oct  3 12:29:36 vlad kernel: ---[ end trace 7e459ebb1a09afb0 ]---

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- make bzImage, not war ---                      

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFKx0G1IKyzvlFcI40RArwxAJ9h+AxT8FzEPWyxgQrWRN3obhVaeACgucS5
QrDjq7WTOPc+Uhyh2mka6Jg=
=/t4I
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--

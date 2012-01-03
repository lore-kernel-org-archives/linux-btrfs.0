From: Dan Garton <dan.garton@gmail.com>
Subject: Btrfs partition lost after RAID1 mirror disk failure?
Date: Tue, 3 Jan 2012 14:44:33 +0000
Message-ID: <CA+h3BtujUZbu17t0FSEht2wytE7Kj8T9DbAS7T74+c0bOWNnGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm running Ubuntu with kernel 2.6.38 on a fileserver system.
One of the disks in a RAID1 configuration failed (/dev/sdc), and since then
I haven't been able to access the btrfs filesystem on the remaining disk
(/dev/sdb).

root@midnite:~/src/btrfs-progs-unstable# ./btrfsck  /dev/sdb
No valid Btrfs found on /dev/sdb

root@midnite:~/src/btrfs-progs-unstable# ./btrfsck  -s 1 /dev/sdb
using SB copy 1, bytenr 67108864
No valid Btrfs found on /dev/sdb

root@midnite:~/src/btrfs-progs-unstable# ./btrfsck  -s 2 /dev/sdb
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/sdb

(This was using a btrfsck compiled from the only git repo I could find
which was responding:
http://git.darksatanic.net/repo/btrfs-progs-unstable.git ........ version
v0.19-102-g2482539)

I include below a list of commands which were executed around the time of
the disk failure, attempting to mount the single remaining device (which is
on /dev/sdb, and the failed disk was on /dev/sdc). I'm pretty sure I didn't
destroy anything in the process, but who knows - hence why I include the
list.

Any help appreciated in recovering the partition on /dev/sdb and accessing
the data.

Thanks,
Dan G




  527  btrfs device scan
  610  btrfs device scan
  611  btrfs device show
  612  btrfs fi df
  613  btrfs fi df -h
  614  btrfs fi df nuvat
  615  btrfs fi show
  648  btrfs device scan
  649  btrfs
  650  btrfs  fi df
  651  btrfs  fi df nuvat
  652  btrfs fi show
  653  btrfs  fi df /nuvat/
  654  btrfs fi show
  665  vi /usr/share/initramfs-tools/modules.d/btrfs
 1136  btrfs
 1137  btrfs device scan
 1139  btrfs device scan
 1140  man btrfs
 1141  btrfs device scan /dev/sdc
 1143  btrfs filesystem df /nuvat/
 1144  btrfsck
 1145  btrfsck /dev/sdc
 1146  btrfsck /nuvat
 1147  btrfsctl --help
 1148  btrfsctl -a
 1149  btrfsctl -A /dev/sdc
 1150  btrfs-show
 1197  btrfs-show
 1198  btrfsck
 1199  btrfsck /dev/sdb
 1200  btrfsck /dev/sdc
 1201  btrfsck /dev/sdv
 1202  btrfsck /dev/sdb
 1203  btrfstune
 1204  btrfsctl
 1205  btrfsctl  -a
 1286  btrfs-vol
 1287  btrfs filesystem show
 1290  btrfs device scan
 1292  btrfsck
 1293  btrfsck /dev/sdb
 1299  btrfsctl
 1300  btrfsctl -a
 1304  btrfsck  -h
 1305  btrfsck  --help
 1306  btrfsck
 1307  btrfsck /dev/sdc
 1308  btrfsck /dev/sdb
 1309  btrfs-show
 1310  btrfs-show nuvat
 1311  btrfs-vol
 1312  dpkg -l | grep btrfs
 1313  apt-get install btrfs-tools
 1314  btrfsctl
 1315  btrfsctl -c
 1316  btrfsctl -A
 1317  btrfsctl -A /dev/sdb
 1318  btrfsctl -d
 1319  btrfsctl -d /nuvat/
 1320  btrfsctl -d /dev/sdb
 1321  btrfs-show
 1322  btrfs-show  --help
 1323  btrfs-show  /dev/sdb
 1326  btrfs-vol
 1327  btrfs-vol -a
 1328  btrfs-vol -a /nuvat
 1329  btrfs-vol -a asdasd /nuvat
 1330  btrfs-vol -a missing /nuvat
 1331  btrfs-vol -a /dev/sdc /nuvat
 1332  btrfs-vol -a /dev/sdb /nuvat
 1334  btrfs-vol -a missing /nuvat
 1335  btrfs
 1336  btrfs device /dev/sdc /nuvat
 1337  btrfs device add /dev/sdc /nuvat
 1338  btrfs device delete /dev/sdc /nuvat
 1339  btrfs fi show
 1340  btrfs fi show /nuvat
 1341  btrfs fi show nuvat
 1342  btrfs filesystem  show nuvat
 1343  btrfs filesystem  show
 1344  btrfsctl -a
 1345  btrfs device scan
 1346  btrfs filesystem  show all
 1348  btrfs-show  /dev/sdb
 1352  btrfsck /dev/sdb
 1355  btrfsck
 1356  btrfsck  -s
 1357  btrfsck  -s 1
 1358  btrfsck  -s 1 /dev/sdb
 1360  apt-cache search btrfs
 1361  btrfs filesystem show
 1374  btrfs
 1375  btrfs device scan
 1376  btrfs fi show
 1377  history | grep btrfs
 1387  btrfs-vol
 1388  btrfsck  /dev/sdb
 1389  btrfs subvolume
 1390  btrfs fi show
 1391  dpkg -l | grep btrfs
 1392  apt-cache search btrfs
 1393  git clone
http://git.darksatanic.net/repo/btrfs-progs-unstable.git/btrfs-progs__git
 1394  cd btrfs-progs__git/
 1398  ./btrfs device scan
 1399  ./btrfsck
 1400  ./btrfsck  /dev/sdb
 1401  ./btrfsctl -a

From: Victor Stinner <victor.stinner@haypocalc.com>
Subject: Issues with KVM
Date: Fri, 22 Jul 2011 21:44:24 +0200
Message-ID: <4E29D318.7050602@haypocalc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  Hi,

I have a new fast computer to run many virtual machines. Everything 
looks very fast, except the installation of new operating systems in 
KVM. The installation is very fast until it begins to write on disk. It 
looks like it writes slower and slower. I tried Debian, FreeBSD, 
OpenIndiana and OpenBSD: same problem. The FreeBSD installer displays 
the speed: it starts at 780 KB/sec (which it already very slow) to 
finish between 1 and 8 KB/sec.

darksatanic suggested me to use nodatacow mount flag: it is not faster, 
and it looks even slower (fewer wsec/s in iostat output, see below).

The computer is an Intel i7 2600 (4 cores with hyper threading: 8 
threads), 12 GB or RAM, 2 hard drives of 1 TB (Western Digital Caviar 
Blue 1 To 7200 RPM 32 Mo Serial ATA 6Gb/s - WD10EALX). Both disks are 
connected to SATA 6 GB/sec connectors using a P67 chipset. I'm using 
RAID 0 with Linux software (MD) RAID, and I have one unique btrfs 
partition of 2 TB. The host OS is Fedora 15 (Linux kernel 2.6.38).

I'm using hardware virtualisation with KVM. Debian is installed using 
virtio, so it should not be an issue with the hard drive driver of KVM.

I'm watching iostat during the Debian installation. With the default 
mount option, wsec/s starts at 49000 to finish near 42000 (on the MD 
device), %usage is greater than 50% of both disks (near 80% for sda, 
near 60% for sdb). Using nodatacow option, wsec/s starts at 12000 
(%usage > 75%) to finish near 10000 (%usage always > 75%). It is slower, 
right? A sector is 512 bytes. The Debian image size is 40 GB, its type 
is "raw". The system load is greater than 2 (or maybe 3) during the 
installation of the VM, while CPU usage is under 8% and wa% is also low 
(maybe 10% or lower, I don't remember).

bonnie++ output (on the Fedora host, not in a VM):

Version  1.96       ------Sequential Output------ --Sequential Input- 
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
ned          24048M   346  98 220839  24 98489  19   245  84 251547  18 
199.2 259
Latency             37256us     326ms     943ms     251ms     197ms 
151ms
Version  1.96       ------Sequential Create------ --------Random 
Create--------
ned                 -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16 11128  34 +++++ +++ 16558  45 14006  40 +++++ +++ 
17226  48
Latency             14997us     663us   11401us    8115us     282us 
10105us
1.96,1.96,ned,1,1311365747,24048M,,346,98,220839,24,98489,19,245,84,251547,18,199.2,259,16,,,,,11128,34,+++++,+++,16558,45,14006,40,+++++,+++,17226,48,37256us,326ms,943ms,251ms,197ms,151ms,14997us,663us,11401us,8115us,282us,10105us

Do you have any idea why the %usage is so high (in iostat), while the 
speed looks so low? The disk speed during the installation is between 5 
MB/sec and 23 MB/sec, whereas the raw speed is greater than 200 MB/sec 
on the host (234 MB/sec according to hdparm -t /dev/md127, 220 MB/sec 
according to bonnie++ on sequential output).

It's difficult to read bonnie++ output: random create is near 14 MB/sec 
if I read correctly. btrfs behaves maybe very badly with a raw image of 
40 GB, especially on RAID 0 with 2 disks?

Should I try other KVM option (e.g. use another type of image)? Try 
btrfs RAID instead of Linux MD RAID? Try to disable some CPU cores? Or 
maybe not using btrfs for KVM images? :-)

Victor



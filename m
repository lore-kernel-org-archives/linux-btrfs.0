From: Philip Lawatsch <philip@lawatsch.at>
Subject: Read performance problems with compression
Date: Mon, 16 Aug 2010 17:26:28 +0200
Message-ID: <AANLkTik_w_WpF=1OZKZOLhTMLG0UbFCvjBrSY4kpi7AG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I've got a strange performance problem on my netbook.
This netbook has a 160g hd:
Model Family:     Seagate Momentus 5400.5 series
Device Model:     ST9160310AS

It's an Atom N270 with 1G ram.

Used kernel is 2.6.34, coming from arch linux.

Disk setup is:

One huge lvm volume which just provides a device for dm_crypt. This,
when decrypted, is then another pv for a lvm volumegroup which
provides swap and /

/ is a btrfs volume mounted with
/dev/mapper/decrypted-root on / type btrfs (rw,noatime,compress)

[philip@icebook ~]$ df /
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/decrypted-root
                     147849216  88997364  55891024  62% /

[philip@icebook ~]$ sudo btrfs filesystem df /
Metadata: total=4.50GB, used=1.71GB
Data: total=109.00GB, used=83.17GB
System: total=32.00MB, used=24.00KB

[philip@icebook ~]$ sudo btrfs filesystem show
Label: none  uuid: a94abf5a-8263-4d89-be68-7fd14348cc9d
        Total devices 1 FS bytes used 84.87GB
        devid    1 size 141.00GB used 113.53GB path /dev/dm-3

Btrfs Btrfs v0.19


I've got around 1 million files on that volume (mostly objects and
libraries / source code).

What I'm encountering now is that I've got a really poor performance
when _reading_ some larger files.

I first thought I was cpu limited (due to dm_crypt and compress), but
it turns out something else is going on.

Some stats:

Raw hard disk read performance:
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && dd if=/dev/sda
of=/dev/null bs=1M count=4k
4294967296 bytes (4.3 GB) copied, 63.5457 s, 67.6 MB/s

Encrypted lv read performance:
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && dd
if=/dev/mapper/raw-crypt_base of=/dev/null bs=1M count=1k
1073741824 bytes (1.1 GB) copied, 15.798 s, 68.0 MB/s

Decrypted pv read performance:
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && dd
if=/dev/mapper/crypt-pv of=/dev/null bs=1M count=1k
1073741824 bytes (1.1 GB) copied, 47.6222 s, 22.5 MB/s

btrfs lv read performance:
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && dd
if=/dev/mapper/decrypted-root of=/dev/null bs=1M count=1k
1073741824 bytes (1.1 GB) copied, 47.8481 s, 22.4 MB/s

Now, I've picked a "large" random file, one gig in my case
(I'm not sure, but I guess this file is not actually compressed since
it contains compressed stuff beyond the first 4k):
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && dd if=/bigfile
of=/dev/null bs=1M
1073741824 bytes (1.1 GB) copied, 100.779 s, 10.7 MB/s

Now I'm only getting half the throughput, however, top still shows
only about 60-70% sys cpu usage (and virtually no user, rest is always
iowait).

Looking at /proc/diskstats shows some interesting things:

before last dd
 254       3 dm-3 4539094 0 36312752 1175407210 59776 0 478208
32909243 0 2357823 1208398680
after the dd
 254       3 dm-3 4931674 0 39453392 1355170673 59776 0 478208
32909243 0 2459623 1388162136

-> btrfs read around 1.5g from the pv for the 1g of data dd read from the file.

And there is nothing going on on the machine, sectors read barely
increases after the dd finished running.

This would still be acceptable for me, however, I started
investigating because I've ran into even more severe performance
issues with rsync.
I'm rsyncing (via rsh, so no extra compression / encryption), and
using rsyncs --progress to display some stats while it's running.
I end up rsyncing some bigger (>100M) files with only about 6-700kbytes/sec.

-> I tried one of these 'smaller' files
It has 21 megabytes.

[root@icebook vm]# cat /proc/diskstats | grep dm-3
 254       3 dm-3 5256408 0 42051264 1382604720 59864 0 478912
32910713 0 2750173 1415597640
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && time dd
if=/small_file of=/dev/null bs=1M
21388990 bytes (21 MB) copied, 17.3889 s, 1.2 MB/s

real    0m18.692s
user    0m0.007s
sys     0m2.373s
[root@icebook vm]# cat /proc/diskstats | grep dm-3
 254       3 dm-3 5296861 0 42374888 1390392186 59864 0 478912
32910713 18 2764543 1423385113

Now, this time 158 (!) megabytes where read while reading my 21meg file.

So, I thought perhaps this was due to flushing the caches, but:
[root@icebook vm]# echo 3 > /proc/sys/vm/drop_caches && cat
/proc/diskstats | grep dm-3 && sleep 120 && cat /proc/diskstats | grep
dm-3
 254       3 dm-3 5302498 0 42419984 1391362440 59864 0 478912
32910713 1 2768886 1424355366
 254       3 dm-3 5302669 0 42421352 1391364236 59864 0 478912
32910713 0 2769590 1424357163
less than 1meg read in these 2 minutes.

So I copied the small file, just to see if that makes a difference.
[root@icebook /]# echo 3 > /proc/sys/vm/drop_caches && dd
if=/small_file2 of=/dev/null bs=1M
20+1 records in
20+1 records out
21388990 bytes (21 MB) copied, 17.4381 s, 1.2 MB/s

-> I rebooted, this time mounted / without the compress flag. Copied
small_file2 to small_file3.

[root@icebook /]# echo 3 > /proc/sys/vm/drop_caches && dd
if=/small_file3 of=/dev/null bs=1M
20+1 records in
20+1 records out
21388990 bytes (21 MB) copied, 1.21649 s, 17.6 MB/s

At this point I'm not really sure what the problem could be.
The second test file here is neatly compressable,
-rwxr-xr-x   1 root root 21388990 Aug 16 17:09 small_file2
-rwxr-xr-x   1 root root  4052737 Aug 16 17:15 small_file3.gz

This makes me wonder even more, btrfs (under ideal conditions) would
have to read just 4megs from the lv, instead of the 150 it actually
read.

-> I'd actually expect a speedup and not such a huge slowdown when
reading such a compressed file.
Decompression itself should also not be limiting factor:
(didn't flush cashes, file was in memory)
[root@icebook /]# time zcat small_file3.gz > /dev/null

real    0m0.367s
user    0m0.353s


So, to finish up a really really long mail, any ideas on what might be
going on? I'd have expected compression to give me a performance boost
for my setup instead of a >x10 slowdown :(
Anything else I could benchmark / debug?

kind regards

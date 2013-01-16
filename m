Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49066 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3APUjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 15:39:15 -0500
Received: from merkaba.localnet (ppp-93-104-147-164.dynamic.mnet-online.de [93.104.147.164])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A6AE92D4
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2013 21:39:03 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to refresh degraded BTRFS? free space fragmentation, file fragmentation...
Date: Wed, 16 Jan 2013 21:39:10 +0100
References: <201212091212.26248.Martin@lichtvoll.de> (sfid-20121209_121802_607942_89B77E9F)
In-Reply-To: <201212091212.26248.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201301162139.11140.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 9. Dezember 2012 schrieb Martin Steigerwald:
> Hi!
> 
> I have BTRFS on some systems since more than two years. My experience so
> far is: Performance at the beginning is pretty good, but some of my more 
> often used BTRFS filesystem degrade badly in different areas. On some
> workloads pretty quickly.
> 
> There are also some fs however that did not degrade that badly. These were
> some that have way more free space left than the ones that degraded
> badly. About 900 GB freespace left on my eSATA backup disk with BTRFS
> that is also quite new. About 80 GB left on my BTRFS RAID 1 local home disk
> where I can build debian packages or kernels and such without the restrictions
> NFS brings (root squash). These still appear to be fine, but I redid the local
> home one with mkfs.btrfs -n 32768 and -l 32768 not to long ago, but I
> think it was quite fine before anyway, so I might have overdone it here.
> This already points at a way to prevent some degradation BTRFS filesystems:
> Leave more free space.
> 
> 
> 1) fsync speed on my ThinkPad T23 has gone down that much that I use
[…]

Interesting to try after latest fsync improvements.

> 2) File fragmentation: Example with a SUSE Manager VirtualBox on an
[…]

> 3) Freespace fragmentation on the / filesystem on this ThinkPad T520 with
> Intel SSD 320:
> 
> === fstrim ===
> 
> merkaba:~> /usr/bin/time fstrim -v /
> /: 6849871872 bytes were trimmed
> 0.00user 5.99system 0:44.69elapsed 13%CPU (0avgtext+0avgdata 752maxresident)k
> 0inputs+0outputs (0major+237minor)pagefaults 0swaps
> 
> It took a second or two in the beginning.
> 
> 
> atop:
> 
> LVM |  rkaba-debian  |  busy     91%  |  read       0  |   write  10313  |  MBw/s  67.48  |  avio 0.20 ms  |
> […]
> DSK |           sda  |  busy     90%  |  read       0  |   write  10319  |  MBw/s  67.54  |  avio 0.19 ms  |
> […]
> 
>   PID   TID RUID      THR   SYSCPU  USRCPU  VGROW  RGROW   RDDSK  WRDSK ST EXC  S CPUNR  CPU CMD         1/2
>  6085     - root        1    0.29s   0.00s     0K     0K      0K     0K --   -  D     0  13% fstrim
> 
> 
> 10000 write requests in 10 seconds.

I was able to refresh my BTRFS regarding this issue on 11th of January:

merkaba:~> btrfs filesystem df /
Data: total=15.10GB, used=11.06GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=654.12MB
Metadata: total=8.00MB, used=0.00


merkaba:~> btrfs balance start -dusage=5 /
Done, had to relocate 0 out of 25 chunks
merkaba:~> btrfs filesystem df /          
Data: total=15.01GB, used=11.06GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=654.05MB
Metadata: total=8.00MB, used=0.00


merkaba:~> btrfs balance start -d /       
Done, had to relocate 16 out of 25 chunks
merkaba:~> btrfs filesystem df /   
Data: total=11.09GB, used=11.06GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.75GB, used=647.72MB
Metadata: total=8.00MB, used=0.00


merkaba:~> /usr/bin/time -v fstrim -v /
/: 2246623232 bytes were trimmed
        Command being timed: "fstrim -v /"
        User time (seconds): 0.00
        System time (seconds): 2.34
        Percent of CPU this job got: 10%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:21.84
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 748
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 239
        Voluntary context switches: 110690
        Involuntary context switches: 1426
        Swaps: 0
        File system inputs: 16
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0



merkaba:~> btrfs balance start -fmconvert=single /   
Done, had to relocate 8 out of 20 chunks
merkaba:~> btrfs filesystem df /
Data: total=11.09GB, used=11.06GB
System: total=36.00MB, used=4.00KB
Metadata: total=1.75GB, used=642.92MB



[406005.831307] btrfs: balance will reduce metadata integrity, use force if you want this
[406129.187057] btrfs: force reducing metadata integrity
[406129.199133] btrfs: relocating block group 9290383360 flags 36
[406132.645299] btrfs: found 6989 extents
[406132.673390] btrfs: relocating block group 8082423808 flags 36
[406135.807065] btrfs: found 6906 extents
[406135.841572] btrfs: relocating block group 7948206080 flags 36
[406138.413270] btrfs: found 4514 extents
[406138.435382] btrfs: relocating block group 6740246528 flags 36
[406142.572004] btrfs: found 10667 extents
[406142.638079] btrfs: relocating block group 6606028800 flags 36
[406146.272095] btrfs: found 19844 extents
[406146.289729] btrfs: relocating block group 6471811072 flags 36
[406149.136422] btrfs: found 14850 extents
[406149.159510] btrfs: relocating block group 29360128 flags 36
[406183.637010] btrfs: found 116645 extents
[406183.653225] btrfs: relocating block group 20971520 flags 34
[406183.671958] btrfs: found 1 extents



Metadata tree still on old size, thus a regular rebalance:

merkaba:~> btrfs balance start -m /               
Done, had to relocate 8 out of 20 chunks
merkaba:~> btrfs filesystem df /
Data: total=11.09GB, used=11.06GB
System: total=36.00MB, used=4.00KB
Metadata: total=768.00MB, used=643.38MB


[406270.880962] btrfs: relocating block group 31801212928 flags 2
[406270.961955] btrfs: found 1 extents
[406270.976857] btrfs: relocating block group 31532777472 flags 4
[406270.990729] btrfs: relocating block group 31264342016 flags 4
[406271.006172] btrfs: relocating block group 30995906560 flags 4
[406271.020158] btrfs: relocating block group 30727471104 flags 4
[406271.480442] btrfs: found 5187 extents
[406271.515768] btrfs: relocating block group 30459035648 flags 4
[406277.158280] btrfs: found 54593 extents
[406277.173024] btrfs: relocating block group 30190600192 flags 4
[406284.680294] btrfs: found 63749 extents
[406284.756582] btrfs: relocating block group 29922164736 flags 4
[406290.907101] btrfs: found 59530 extents


merkaba:~> df -hT /
Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/dm-0      btrfs   19G     12G  6,8G   64% /

merkaba:~> /usr/bin/time -v fstrim -v /            
/: 5472256 bytes were trimmed
        Command being timed: "fstrim -v /"
        User time (seconds): 0.00
        System time (seconds): 0.00
        Percent of CPU this job got: 50%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.00
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 748
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 238
        Voluntary context switches: 12
        Involuntary context switches: 3
        Swaps: 0
        File system inputs: 0
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0



Today Still fast:

merkaba:~#1> /usr/bin/time -v fstrim /
        Command being timed: "fstrim /"
        User time (seconds): 0.00
        System time (seconds): 0.03
        Percent of CPU this job got: 17%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.19
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 708
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 227
        Voluntary context switches: 736
        Involuntary context switches: 35
        Swaps: 0
        File system inputs: 0
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0




Boot time seems a tad bid slower tough:

merkaba:~> systemd-analyze
Startup finished in 5495ms (kernel) + 6331ms (userspace) = 11827ms
merkaba:~> systemd-analyze blame  
  3051ms cups.service
  2330ms dirmngr.service
  2267ms postfix.service
  1411ms schroot.service
  1385ms lvm2.service
  1230ms network-manager.service
  1128ms ssh.service
  1117ms acpi-fakekey.service
  1112ms avahi-daemon.service
  1061ms privoxy.service
  1010ms systemd-logind.service
   721ms loadcpufreq.service
   646ms colord.service
   552ms kdm.service
   533ms networking.service
   532ms keyboard-setup.service
   463ms remount-rootfs.service
   368ms bootlogs.service
   349ms udev.service
   327ms console-kit-log-system-start.service
   326ms postgresql.service
   322ms binfmt-support.service
   316ms acpi-support.service
   315ms qemu-kvm.service
   310ms sys-kernel-debug.mount
   309ms dev-mqueue.mount
   309ms anacron.service
   303ms atd.service
   297ms sys-kernel-security.mount
   282ms cron.service
   282ms dev-hugepages.mount
   272ms lightdm.service
   271ms console-kit-daemon.service
   271ms lirc.service
   268ms lxc.service
   259ms cpufrequtils.service
   259ms mdadm.service
   252ms openntpd.service
   240ms smartmontools.service
   240ms alsa-utils.service
   237ms run-user.mount
   237ms speech-dispatcher.service
   230ms udftools.service
   229ms run-lock.mount
   229ms systemd-remount-api-vfs.service
   224ms ebtables.service
   214ms openbsd-inetd.service
   208ms motd.service
   199ms hdparm.service
   198ms irqbalance.service
   190ms mountdebugfs.service
   181ms saned.service
   160ms systemd-user-sessions.service
   157ms polkitd.service
   147ms screen-cleanup.service
   146ms console-setup.service
   141ms networking-routes.service
   140ms pppd-dns.service
   130ms rc.local.service
   130ms jove.service
   128ms sysstat.service
   112ms rsyslog.service
   111ms udev-trigger.service
   103ms home.mount
    93ms systemd-sysctl.service
    89ms boot.mount
    85ms dns-clean.service
    84ms kbd.service
    66ms upower.service
    60ms systemd-tmpfiles-setup.service
    53ms openvpn.service
    37ms boot-efi.mount
    27ms udisks.service
    22ms sysfsutils.service
    22ms mdadm-raid.service
    20ms proc-sys-fs-binfmt_misc.mount
    18ms tmp.mount
     2ms sys-fs-fuse-connections.mount



> vmstat 1:
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  3  0 1963688 3943380 156972 1827836    0    0     0     0 5421 15781  6  6 88  0
>  0  0 1963688 3943132 156972 1827852    0    0     0     0 5733 16478  9  7 83  0
>  1  0 1963688 3943008 156972 1827992    0    0     0     0 5050 14434  0  4 96  0
>  1  0 1963688 3949768 156972 1826708    0    0     0     0 5246 14960  2  5 93  0
>  0  0 1963688 3949644 156980 1826712    0    0     0    36 5104 14996  1  4 94  0
>  0  0 1963688 3949768 156980 1826720    0    0     0     0 5102 15210  2  4 94  0
>  3  0 1963688 3949644 156980 1826720    0    0     0     0 5321 15995  4  7 89  0
>  0  0 1963688 3949396 156980 1827188    0    0     0     0 5316 15616  6  5 88  0
>  1  0 1963688 3949148 156980 1827188    0    0     0     0 5102 14944  1  4 95  0
>  1  0 1963688 3949272 156980 1827188    0    0     0     0 5510 15928  5  6 89  0
>  1  0 1963688 3949272 156980 1827188    0    0     0    52 5107 15054  2  4 94  0
>  0  0 1963688 3949396 156980 1826868    0    0     0     4 4930 14567  1  4 95  0
>  1  0 1963688 3949396 156988 1826828    0    0     0    52 5132 15014  2  5 93  0
>  3  0 1963688 3949396 156988 1826836    0    0     0     0 5015 14447  1  4 95  0
>  0  0 1963688 3949520 156988 1826836    0    0     0     0 5233 15652  3  6 91  0
>  1  0 1963684 3949612 156988 1827172    0    0     0  3032 2546 7555  6  4 84  6
> 
> After fstrim:
> 
>  0  0 1963684 3944244 157016 1827752    0    0     0     0  357 1018  2  1 97  0
>  1  0 1963684 3943776 157024 1827776    0    0     0    64  634 1660  4  2 93  0
>  0  0 1963684 3943872 157024 1827784    0    0     0     0  180  473  0  0 99  0
> 
> 
> The I/O activity does not seem to be reflected in vmstat, I bet due to page
> cache not involved.



> === fallocate ===
> 
> merkaba:/var/tmp> /usr/bin/time fallocate -l 2G fallocate-test
> 0.00user 118.85system 2:00.50elapsed 98%CPU (0avgtext+0avgdata 720maxresident)k
> 14912inputs+49112outputs (0major+227minor)pagefaults 0swaps

Now, lets try this:

merkaba:/var/tmp> /usr/bin/time -v fallocate -l 2G fallocate-test
        Command being timed: "fallocate -l 2G fallocate-test"
        User time (seconds): 0.00
        System time (seconds): 0.00
        Percent of CPU this job got: 80%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.00
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 724
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 231
        Voluntary context switches: 5
        Involuntary context switches: 6
        Swaps: 0
        File system inputs: 80
        File system outputs: 72
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0


There we go :)

> Filesystem type is: 9123683e
> File size of fallocate-test is 2147483648 (524288 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0  2626450            2048 
>    1    2048  3215128  2628498   2040 
>    2    4088  3408631  3217168   2032 
>    3    6120  3430045  3410663   2024 
>    4    8144  3439999  3432069   2016 
>    5   10160  3474610  3442015   1004 
>    6   11164  3743715  3475614   1002 
[…]
> fallocate-test: 4556 extents found

merkaba:/var/tmp> filefrag -v fallocate-test                     
Filesystem type is: 9123683e
File size of fallocate-test is 2147483648 (524288 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  8501248          524288 eof
fallocate-test: 1 extent found


Yes, thats the same filesystem :)

> But:
> 
> merkaba:/var/tmp> /usr/bin/time rm fallocate-test
> 0.00user 0.24system 0:00.38elapsed 63%CPU (0avgtext+0avgdata 784maxresident)k
> 4464inputs+36184outputs (0major+243minor)pagefaults 0swaps

merkaba:/var/tmp> /usr/bin/time rm fallocate-test 
0.00user 0.00system 0:00.00elapsed 100%CPU (0avgtext+0avgdata 784maxresident)k
0inputs+24outputs (0major+243minor)pagefaults 0swaps

> Some more information on the filesystem in question:
> 
> merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi sh
> failed to read /dev/sr0
> Label: 'debian'  uuid: […]
>         Total devices 1 FS bytes used 13.56GB
>         devid    1 size 18.62GB used 18.62GB path /dev/dm-0
> 
> Btrfs v0.19-239-g0155e84
> 
> 
> merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi df /
> Disk size:                18.62GB
> Disk allocated:           18.62GB
> Disk unallocated:            0.00
> Used:                     13.56GB
> Free (Estimated):          3.31GB       (Max: 3.31GB, min: 3.31GB)
> Data to disk ratio:          91 %
> 
> 
> merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs fi disk-usage /
> Data,Single: Size:15.10GB, Used:12.94GB
>    /dev/dm-0       15.10GB
> 
> Metadata,Single: Size:8.00MB, Used:0.00
>    /dev/dm-0        8.00MB
> 
> Metadata,DUP: Size:1.75GB, Used:630.11MB
>    /dev/dm-0        3.50GB
> 
> System,Single: Size:4.00MB, Used:0.00
>    /dev/dm-0        4.00MB
> 
> System,DUP: Size:8.00MB, Used:4.00KB
>    /dev/dm-0       16.00MB
> 
> Unallocated:
>    /dev/dm-0          0.00
> merkaba:/home/martin/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> ./btrfs dev disk-usage /
> /dev/dm-0          18.62GB
>    Data,Single:             15.10GB
>    Metadata,Single:          8.00MB
>    Metadata,DUP:             3.50GB
>    System,Single:            4.00MB
>    System,DUP:              16.00MB
>    Unallocated:                0.00

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

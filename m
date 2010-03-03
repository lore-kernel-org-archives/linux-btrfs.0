From: Jim Hughes <jhughes@ctio.noao.edu>
Subject: Wretched Excess - a 62T btrfs filesystem
Date: Wed, 03 Mar 2010 11:55:56 -0300
Message-ID: <4B8E787C.4080001@ctio.noao.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Folks:

Thought you all might be interested to know we've just built a 
"Backblaze Pod" (see 
http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/) 
running Fedora 12 and your latest (as of yesterday) GIT kernel snapshot.

We mounted *all 45 disks* into one huge 62Tb btrfs RAID10 filesystem, 
and so far it works just great!

I'd be interested in your comments as to pitfall, problems you all see 
in creating such a huge btrfs file system...


Jim Hughes
Cerro Tololo Interamerican Observatory

La Serena, Chile

----------------
ferrari.27# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1             30237648  20710404   7991244  73% /
tmpfs                  1978536         0   1978536   0% /dev/shm
/dev/sda3             42555184    185304  40208188   1% /home
/dev/sdb             65931236280   6917008 65924319272   1% /raid45

ferrari.28# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              29G   20G  7.7G  73% /
tmpfs                 1.9G     0  1.9G   0% /dev/shm
/dev/sda3              41G  181M   39G   1% /home
/dev/sdb               62T  6.6G   62T   1% /raid45

ferrari.29# mount
/dev/sda1 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sda3 on /home type ext4 (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/sdb on /raid45 type btrfs (rw)

ferrari.30# cat /proc/version
Linux version 2.6.32 (root@localhost.localdomain) (gcc version 4.4.3 
20100127 (Red Hat 4.4.3-4) (GCC) ) #1 SMP Tue Mar 2 12:28:10 CLST 2010

ferrari.31# lspci
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller 
(rev 03)
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset 
Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation 4 Series Chipset 
Integrated Graphics Controller (rev 03)
00:03.0 Communication controller: Intel Corporation 4 Series Chipset 
HECI Controller (rev 03)
00:19.0 Ethernet controller: Intel Corporation 82567V-2 Gigabit Network 
Connection
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 2
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 4
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface 
Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port 
SATA IDE Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port 
SATA IDE Controller
02:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA 
Raid II Controller (rev 01)
03:00.0 PCI bridge: Pericom Semiconductor Device e111 (rev 02)
04:04.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 01)
05:00.0 IDE interface: JMicron Technologies, Inc. JMB368 IDE controller
06:00.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 01)
06:06.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


From: Thomas Rohwer <trohwer@ennit.de>
Subject: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 04:34:47 +0200
Message-ID: <4F98B447.30102@ennit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am using btrfs as my root file system on partition sda1. Now I am getting errors
because of a full device, although df shows a use of only 64%. I read the FAQ and
understand that this number may not be accurate. But according to the FAQ
"btrfs fi show" should show a full device.
I am getting:

humbur:~# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: 484f8251-678f-4625-a05e-9dc8483f20a9
         Total devices 1 FS bytes used 64.31GB
         devid    1 size 111.79GB used 89.07GB path /dev/sda1

Label: none  uuid: be144c3c-3c34-45d1-aff2-415e72b0ec6e
         Total devices 1 FS bytes used 34.15GB
         devid    1 size 111.79GB used 37.29GB path /dev/sda

Btrfs Btrfs v0.19

And this does not make sense to me at all. First, the device listed for /dev/sda1
does not seem to be fully used. Second, I have no idea what the entry for /dev/sda
is supposed to mean. There should be only one btrfs filesystem, and certainly not
a second one on the device /dev/sda.

Some additional information:

humbur:~# btrfs fi df /
Data: total=76.00GB, used=60.27GB
System, DUP: total=32.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=6.50GB, used=4.04GB

humbur:~# df
Filesystem     1K-blocks     Used Available Use% Mounted on
rootfs         117219800 71666680  40316032  64% /
/dev/root      117219800 71666680  40316032  64% /
tmpfs             397608      200    397408   1% /run
tmpfs               5120        0      5120   0% /run/lock
tmpfs             795212        8    795204   1% /tmp
tmpfs              10240        0     10240   0% /dev
tmpfs             795212        0    795212   0% /run/shm

humbur:~# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / btrfs rw,noatime,ssd,noacl,nospace_cache 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=397608k,mode=755 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
tmpfs /tmp tmpfs rw,nosuid,nodev,relatime,size=795212k 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev tmpfs rw,relatime,size=10240k,mode=755 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,relatime,size=795212k 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0

humbur:~# ls -l /dev/sd*
brw-rw---T 1 root disk 8, 0 Apr 26 01:27 /dev/sda
brw-rw---T 1 root disk 8, 1 Apr 26 01:18 /dev/sda1

humbur:~# cat /proc/version
Linux version 3.3.0 (tr@humbur) (gcc version 4.6.3 (GCC) ) #3 SMP Thu Apr 5 00:14:18 CEST 2012




Some help would be appreciated.

Sincerely,

Thomas Rohwer


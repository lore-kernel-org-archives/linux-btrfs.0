From: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Subject: Re: Poor read performance on high-end server
Date: Mon, 09 Aug 2010 16:45:45 +0200
Message-ID: <4C601499.5040402@sara.nl>
References: <4C5AC52D.9030906@sara.nl> <20100805145138.GJ29846@think>	<4C5BF829.3020200@kernel.dk> <87r5i98tdf.fsf@basil.nowhere.org> <4C5E8F46.5010706@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5E8F46.5010706@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Thanks a lot for the great feedback from before the weekend. Since one
of my colleagues needed the machine, I could only do the tests today.

In short: just installing 2.6.35 did make some difference, but I was
mostly impressed with the speedup gained by the hardware acceleration of
the crc32c_intel module.

Here is some quick data.

Reference figures:
16* single disk (theoretical limit):     4092 MiByte/s
fio data layer tests (achievable limit): 3250 MiByte/s
ZFS performance:                         2505 MiByte/s

BtrFS figures:
IOzone on 2.6.32:                         919 MiByte/s
fio btrfs tests on 2.6.35:               1460 MiByte/s
IOzone on 2.6.35 with crc32c:            1250 MiByte/s
IOzone on 2.6.35 with crc32c_intel:      1629 MiByte/s
IOzone on 2.6.35, using -o nodatasum:    1955 MiByte/s

For those finding this message and want a howto: the easiest way to use
crc32c_intel is to add the module name to /etc/modules:
 # echo "crc32c_intel" >> /etc/modules
 # reboot

Now the next step for us is to tune the block sizes. We only did that
preliminary, but now that we have a good knowledge of what software to
use, we can start tuning that in more detail.

If there is interest on this list, I'll gladly post our results here.


Jens Axboe wrote:

>>> Also, I didn't see Chris mention this, but if you have a newer intel box
>>> you can use hw accellerated crc32c instead. For some reason my test box
>>> always loads crc32c and not crc32c-intel, so I need to do that manually.
> 
> it is pretty annoying to have to do it manually. Sometimes
> you forget. And it's not possible to de-select CRC32C and have
> the intel variant loaded.

You can, but only if you first unmount the partition:

 # unmount /mnt/mybtrfsdisk
 # rmmod btrfs
 # rmmod libcrc32c
 # rmmod crc32c
 # modprobe crc32c_intel
 # mount -t btrfs /dev/sda1 /mnt/mybtrfsdisk




We encountered a small bug: the btrfs partition with RAID0 that was made
on 2.6.32 did not mount after a reboot or after unmounting. Running
btrfsck fixes this, but after a next umount, we had to run btrfsck
again. After recreating the btrfs partition on 2.6.35, all was well.
btrfs partitions that don't use (software) RAID work fine.

~# mount -t btrfs -o ssd /dev/sdd /mnt/ssd3
mount: wrong fs type, bad option, bad superblock on /dev/sdd,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

~# dmesg | tail
device fsid ec4d518ec61d4496-81e5aeda2d8ef7b5 devid 1 transid 69 /dev/sdd
btrfs: use ssd allocation scheme
btrfs: failed to read the system array on sdd
btrfs: open_ctree failed

~# btrfsck /dev/sdd
found 550511136768 bytes used err is 0
total csum bytes: 536870912
total tree bytes: 755322880
total fs tree bytes: 77824
btree space waste bytes: 169152328
file data blocks allocated: 549755813888
 referenced 549755813888
Btrfs Btrfs v0.19

~# mount -t btrfs -o ssd /dev/sdd /mnt/ssd3
[and it mounts fine now]


Regards,
Freek Dijkstra
SARA High Performance Computing and Networking

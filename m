Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:36596 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbIFRxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Sep 2015 13:53:05 -0400
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "util-linux@vger.kernel.org" <util-linux@vger.kernel.org>,
        "Kani, Toshimitsu" <toshi.kani@hpe.com>,
        "Knippers, Linda" <linda.knippers@hpe.com>
Subject: mkfs.btrfs cannot find rotational file for SSD detection for a pmem
 device
Date: Sun, 6 Sep 2015 17:51:32 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs does not detect pmem devices as being SSDs in kernel 4.2.

Label:              (null)
UUID:               46603efe-728c-43fe-8241-ffc125e1a7ed
Node size:          16384
Sector size:        4096
Filesystem size:    8.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP             417.56MiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1     8.00GiB  /dev/pmem0

mkfs.btrfs opens "/sys/block/%s/queue/rotational" and looks for
0 (non-rotational - an SSD) or non-zero (rotational - a HDD).

However, strace shows it is having trouble creating that path.
The blkid_devno_to_wholedisk function from libblkid leads it to
this path:
	/sys/block/LNXSY/queue/rotational
which doesn't exist.

That is based on:
$ realpath /sys/block/pmem0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus1/region0/namespace0.0/block/pmem0

$ realpath /sys/dev/block/259:0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus1/region0/namespace0.0/block/pmem0

The impact looks limited to the print and causing it to not
automatically disable "metadata duplication on a single device."

References:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git 
git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
http://comments.gmane.org/gmane.comp.file-systems.btrfs/18749

mkfs.c excerpt
==============
static int is_ssd(const char *file)
{
...
        /* Get whole disk name (not full path) for this devno */
        ret = blkid_devno_to_wholedisk(devno,
                        wholedisk, sizeof(wholedisk), NULL);
        if (ret) {
                blkid_free_probe(probe);
                return 0;
        }

        snprintf(sysfs_path, PATH_MAX, "/sys/block/%s/queue/rotational",
                 wholedisk);

        blkid_free_probe(probe);

        fd = open(sysfs_path, O_RDONLY);
        if (fd < 0) {
                return 0;
        }

        if (read(fd, &rotational, sizeof(char)) < sizeof(char)) {
                close(fd);
                return 0;
...
int main(int ac, char **av)
...
        if (!mixed) {
                if (!metadata_profile_opt) {
                        if (dev_cnt == 1 && ssd && verbose)
                                printf("Detected a SSD, turning off metadata "
                                "duplication.  Mkfs with -m dup if you want to "
                                "force metadata duplication.\n");

                        metadata_profile = (dev_cnt > 1) ?
                                        BTRFS_BLOCK_GROUP_RAID1 : (ssd) ?
                                        0: BTRFS_BLOCK_GROUP_DUP;
                }


strace
======
open("/dev/pmem0", O_RDWR|O_EXCL)       = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(259, 0), ...}) = 0
close(3)                                = 0
open("/dev/pmem0", O_RDONLY|O_CLOEXEC)  = 3
fadvise64(3, 0, 0, POSIX_FADV_RANDOM)   = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(259, 0), ...}) = 0
uname({sysname="Linux", nodename="s18", ...}) = 0
ioctl(3, BLKGETSIZE64, 8589934592)      = 0
open("/sys/dev/block/259:0", O_RDONLY|O_CLOEXEC) = 4
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/sys/dev/block/259:0", O_RDONLY|O_CLOEXEC) = 4
newfstatat(4, "partition", 0x7fffb67faa50, 0) = -1 ENOENT (No such file or directory)
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
close(4)                                = 0
ioctl(3, CDROM_GET_CAPABILITY, 0)       = -1 ENOTTY (Inappropriate ioctl for device)
open("/sys/dev/block/259:0", O_RDONLY|O_CLOEXEC) = 4
newfstatat(4, "partition", 0x7fffb67fab90, 0) = -1 ENOENT (No such file or directory)
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
readlink("/sys/dev/block/259:0", "../../devices/LNXSYSTM:00/LNXSY", 31) = 31
close(4)                                = 0
close(3)                                = 0
open("/sys/block/LNXSY/queue/rotational", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/dev/pmem0", O_RDONLY)            = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(259, 0), ...}) = 0
ioctl(3, BLKGETSIZE64, 8589934592)      = 0
close(3)                                = 0
...


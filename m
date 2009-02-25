From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: questions about GRUB and BTRFS
Date: Tue, 24 Feb 2009 18:32:45 -0700
Message-ID: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A quick googling turns up posts that GRUB support for BTRFS is planned. My
curiosity is more towards how this will be managed, because the way this is
currently implemented with software RAID/LVM is quite haphazard. I
therefore have some questions about GRUB + BTRFS:

-With GRUB booting, it's easy to think of awkward use cases and limitations
unless it's capable of discovering BTRFS instances, and can boot by
specifying BTRFS UUID + subvolume. That seems quite ambitious, but is this
planned "eventually"?

-Might it be possible to tweak the userspace component of GRUB to install
the bootloader to every member device? This seems necessary for reliable
booting and rebuilding after a dead disk.

-64 kb at the beginning of the device is plenty for MBR + GRUB stage 1 +
1.5. Might this allow bootable BTRFS without paritions being used at all?
The space used for partitioning is negligible, however we're on the cusp of
disks that are too big to partition with MBR, and GPT booting doesn't seem
well supported yet.

There's obviously no point in getting worked up about this before
production ready support is available in the first place. :) However, I am
curious about what sort of implementation is planned.

-Anthony

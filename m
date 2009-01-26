From: ashford@whisperpc.com
Subject: [Discussion] Apparent inconsistancies in use of io_align,
      io_width & sector_size
Date: Mon, 26 Jan 2009 12:06:21 -0800 (PST)
Message-ID: <38874.75.80.183.92.1233000381.squirrel@www.whisperpc.com>
References: <1231857643.29164.28.camel@think.oraclecorp.com>
    <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz>
    <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed>
    <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed>
    <20090120132829.GA27429@infradead.org>
    <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed>
    <20090126162711.GA2083@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090126162711.GA2083@elf.ucw.cz>
List-ID: <linux-btrfs.vger.kernel.org>

While digging through btrfs-progs, I noticed that there were several apparent
discrepancies in the use of io_align, io_width & sector_size (in structure
btrfs_dev_item).  I believe we need the core developers to define the contents
of these values, so that the various programs and kernel modules can be
checked to be sure that the correct values are being used.


I have made some guesses as to the definitions of these values, and the kernel
code appears to support these guesses at first glance (not too sure about
io_align).  My guesses are:

sector_size - This is the size, in bytes, of the atomic unit of allocation and
    I/O within the file-system.  It must be a power of two, must be at least as
    large as a disk sector, and must be no larger than a kernel page.

io_width - This value is only meaningful in a RAID-0 or RAID-10 (also RAID-5
    and RAID-6 in the future) volume, or when the underlying device is a RAID
    array (other than RAID-1).  This is the maximum number of bytes that can be
    written to a device without switching to another device, and is equivalent
    to "chunk size" in the MD driver.  This must be a power of two, and an
    integer multiple of sector_size.

io_align - This value is the offset, in bytes, of the start of the partition to
    the start of the file-system.  As an example, a value of 1536 would
    indicate that the file-system starts 1536 bytes (3 disk blocks) into the
    file-system.  This must be an integer multiple of the disk sector size.

    For optimum RAID performance, it should also be the offset of first RAID
    segment from the beginning of the partition.  I believe that the intended
    usage of this value is to allow file-system allocations to align with RAID
    segments provided by lower levels (Linux MD, HW RAID controllers or SAN
    controllers).

Thank you.

Peter Ashford


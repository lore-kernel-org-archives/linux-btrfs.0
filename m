Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52635 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3B0Iut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 03:50:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UAcjE-0003CK-T7
	for linux-btrfs@vger.kernel.org; Wed, 27 Feb 2013 09:51:08 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 09:51:08 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 09:51:08 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: lvm volume like support
Date: Wed, 27 Feb 2013 00:50:34 -0800
Message-ID: <kgkhcp$dfg$1@ger.gmane.org>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <201302261130.31494.Martin@lichtvoll.de> <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com> <20130227100558.37d86d82@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov wrote:

> On Wed, 27 Feb 2013 13:23:23 +1100
> "Fajar A. Nugraha" <list@fajar.net> wrote:
> 
>> Not to mention the hassle in accessing the data if it resides on a
>> partition inside the file (e.g. you need losetup + kpartx to access it,
>> and you must remember to do the reverse when you're finished with it).
> 
>> 
>> In zfsonlinux it's very easy to do so since a zvol is treated pretty
>> much like a disk, and whenever there's a partition inside a zvol, a
>> coressponding device noed is also created automatically.
> 
> So I'd say what you (we) need is a generic Linux kernel framework that
> would allow treating any regular file pretty much like a disk. Not some
> filesystem-specific block device emulation kludge.
> 
> Btw some years ago there was a patchset adding proper automatic partition
> support to 'loop'; but it seems like that went nowhere, and I have no idea
> why something this useful did not end up being added into the mainline
> kernel.
> 

I mentioned it in another branch of the thread, but the SCSI Target stack 
*does* this. If you use the FILEIO backend and the 'loopback' transport, you 
get a file that is visible to the local system as Just Another SCSI Disk. 
There are patches on the scsi target list to add UNMAP and WRITE SAME 
w/UNMAP=1 support to the FILEIO backend, at which point it will do 
FL_PUNCH_HOLE operations appropriately.

The commands are:

---cut---

# $IDX = a preferably-unique index
# $NAME = a useful name for humans
# $IMGFILE = a disk image
# $SIZE = the size of $IMGFILE in bytes
# $UUID = a random v4 UUID
# ${NAA[x]} = a valid naa WWN, targetcli generates this as
#     "naa.6001405" + the first 10 digits of a random v4 UUID
#     (not the same uuid as $UUID). When x varies, it's a different
#     WWN, since more than one gets used.

# Load the scsi target core and backends
modprobe target_core_mod

# Tell it where the file is and how big it is
tcm_node --establishdev "fileio_$IDX/$NAME" \
    "fd_dev_name=$IMGFILE,fd_dev_size=$SIZE"

# Give it a unique serial
tcm_node --setunitserialwithmd fileio_$IDX/$NAME $UUID

# Load the local scsi frontend transport
modprobe tcm_loop
mkdir -p /sys/kernel/config/target/loopback

# Some setup so you have a place to put LUNs
mkdir -p /sys/kernel/config/target/loopback/${NAA[1]}/tpgt_1
echo ${NAA[2]} > /sys/kernel/config/target/loopback/${NAA[1]}/tpgt_1/nexus

# Create a fresh LUN...
mkdir -p /sys/kernel/config/target/loopback/${NAA[1]}/tpgt_1/lun/lun_$IDX

# ...and map the file to it.
ln -s /sys/kernel/config/target/core/fileio_$IDX/$NAME \
    /sys/kernel/config/target/loopback/${NAA[1]}/tpgt_1/lun/lun_$IDX

---cut---

This could be pretty easily put into a shell script that uses du -b and 
manually pokes configfs instead of calling tcm_node, and it'd be able to run 
without any nonstandard userspace dependencies.


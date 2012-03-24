From: Christoph Groth <cwg@falma.de>
Subject: Re: "Invalid argument" when mounting a btrfs raid1 filesystem
Date: Sat, 24 Mar 2012 23:26:50 +0100
Message-ID: <87fwcx8wk5.fsf@falma.de>
References: <87vclt99tg.fsf@falma.de> <20120324182104.GB14080@carfax.org.uk>
	<loom.20120324T194951-446@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>>    Basically, the kernel needs to know which devices hold which btrfs
>> filesystems (organised by UUID) before it tries to mount them. So,
>> there's an ioctl that is used for sending that data to the kernel,
>> and a userspace tool (btrfs dev scan) that enumerates all of the
>> block devices it can see, looks for a btrfs superblock on them, and
>> tells the kernel.
>> 
>>    Hugo.

Thanks for the quick help!  I guess that error message ("Invalid
argument") could be made more to the point...

Alex <alex@bpmit.com> writes:

> If you install the package btrfs-tools (currently dated 5 November
> 2011 in unstable), it'll set up the necessary.

The proper btrfs-tools package was already installed by debian-installer
(currently the version in testing is the same as in unstable).
Apparently the initrd.img put in place by the installer was not doing
what it should.  (I'm not sure whether initrd.img is built during
installation or whether just some common one is installed.)

I did the following to get a system that boots:

(1) Use the rescue mode of the installation medium to get a shell with
    /dev/sda2 mounted as root.

(2) Run "update-initramfs -u" to update initrd.img

(3) Run "update-grub" (Not sure whether this was necessary)

(4) Modify /etc/fstab such that the line for the root FS ends with "0 0"
    and not with "0 1".  This is to make the system bootable even when
    there is no btrfs.fsck.

After a reboot, things started working properly.

Christoph


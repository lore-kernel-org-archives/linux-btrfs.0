Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab3BLVFj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 16:05:39 -0500
Date: Tue, 12 Feb 2013 21:05:35 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130212210535.GC16773@rhmail.home.annexia.org>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
 <20130212191637.GD2611@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130212191637.GD2611@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 02:16:37PM -0500, Josef Bacik wrote:
> On Tue, Feb 12, 2013 at 11:54:49AM -0700, Richard W.M. Jones wrote:
> > Btrfs has been broken for me for ages.  I first reported it on this
> > list 5 months ago[1].  Below is a very simple reproducer that anyone
> > can run.
> > 
> > *NB* before you run this, adjust /dev/sda & /dev/sda1 to point to an
> > unused block device!
> > 
> > ----------------------------------------------------------------------
> > #!/bin/sh -
> > set -e
> > while true; do
> >   parted -s -- /dev/sda mklabel msdos
> >   parted -s -- /dev/sda mkpart primary 64s -64s
> >   wipefs -a /dev/sda1
> >   mkfs.btrfs --label TEST /dev/sda1
> >   mount /dev/sda1 /sysroot
> >   touch /sysroot/foo
> >   mkdir /sysroot/bar
> >   umount /sysroot
> > done
> > ----------------------------------------------------------------------
> > 
> > On the latest 3.8.0 kernel, this fails immediately (at the mount), and
> > on 3.7.x it usually fails after a very few iterations.  I see a
> > variety of errors, but the latest kernel error is:
> > 
> > [    8.474934] device label ROOT devid 1 transid 2 /dev/sda2
> > [    8.570619] device label ROOT devid 1 transid 2 /dev/sda2
> > [    8.581891] btrfs: disk space caching is enabled
> > [    8.594146] btrfs bad tree block start 0 4194304
> > [    8.595144] btrfs: failed to read tree root on sda2
> > [    8.605308] btrfs: open_ctree failed
> > 
> > I would really like btrfs to work.  What can I do?
> 
> Been running this in a loop for 20 minutes with no issues, is this in a virt
> guest or something?  Thanks,

Yes, this is inside a very recent KVM (qemu 1.3.0), using virtio-scsi
as the backing disk.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top

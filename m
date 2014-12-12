Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934898AbaLLPbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 10:31:49 -0500
Date: Fri, 12 Dec 2014 16:31:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
Message-ID: <20141212153147.GR27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20141210123750.GA27601@twin.jikos.cz>
 <5488EA3D.9080905@cn.fujitsu.com>
 <CAL3q7H6gmX9wZFxjb_ryHjzbaqq_5W+e9aHj+FNqcfsbuRNstw@mail.gmail.com>
 <548A378F.6020101@cn.fujitsu.com>
 <CAL3q7H6OWFRPdWeKVABbbdAigW6PAx4oFF6=q8vSU-s0Y7EPzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
In-Reply-To: <CAL3q7H6OWFRPdWeKVABbbdAigW6PAx4oFF6=q8vSU-s0Y7EPzQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 08:34:09AM +0000, Filipe David Manana wrote:
> Very simple solution.
> 
> Do:
> 
> 1) Create an empty file;
> 2) Use it as the backing file for a loop device;
> 3) Run mkfs.btrfs against the loop device;
> 4) Mount it;
> 5) Populate the fs;
> 6) Umount it;
> 7) Corrupt some nodes or leafs (by zeroing them out for e.g.);
> 8) Create a tarball from the backing file like this: ZX_OPT=-9 tar
> cJSvf foobar.tar.xz run.sh backing_file
> 9) Add the tarball to the fsck-tests directory;
> 10) Make the test run fsck against the backing file extracted from the
> tarball - fsck can operate against regular files, and not only against
> devices.

I made a few scripts that help to automate most of the steps (no
populating or fuzzing), attached.

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=prep-image-1-mkfs-mount

#!/bin/sh -x

SIZE=64m
MKFS_OPTIONS=
MOUNT_OPTIONS=

mkdir -p mnt
truncate -s0 test.img
truncate -s$SIZE test.img
chmod a+w test.img
LODEV=$(sudo losetup -f --show test.img)
if [ $? -ne 0 ]; then
	echo "Cannot create loop device"
	exit 1
fi

mkfs.btrfs -f $MKFS_OPTIONS $LODEV
sudo mount ${MOUNT_OPTIONS:+-o "$MOUNT_OPTIONS"} $LODEV mnt || { echo "Cannot mount image"; exit 1; }

sudo touch mnt/.btrfs-test-image

echo "Mounted test.img as $LODEV into mnt/"
echo "Populate the image and run the next phase"

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=prep-image-2-umount

#!/bin/sh

LODEV=$(losetup -j test.img -O NAME | tail -n +2)
if [ $? -ne 0 ]; then
	echo "Cannot detect loop devices for test.img"
	exit 1
fi
echo $LODEV

for dev in $LODEV; do
	sudo umount $dev
	sudo losetup -d $dev
done

echo "Unmounted and all loop devices detached"
echo "Corrupt the image now."

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=prep-image-3-tar

#!/bin/sh -x

if ! [ -f test.img ]; then
	echo "No image found"
	exit 1
fi

export ZX_OPT
ZX_OPT=-9 tar cJSvf image.tar.xz --owner=root --group=root test.img

echo "Created image.tar.gz from test.img"
echo "Link it to the test dir, run 'make test'"

--7JfCtLOvnd9MIVvH--

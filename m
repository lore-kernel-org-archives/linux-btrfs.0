Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58615 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaHKSgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 14:36:47 -0400
Received: by mail-oa0-f51.google.com with SMTP id o6so6385795oag.38
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:36:46 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Aug 2014 11:36:46 -0700
Message-ID: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
Subject: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been playing with btrfs as a backing store for my KVM images.

I've used 'chattr +C' on the directory where those images are stored.

You can see my recipe below [1]. I've read the gotchas found here [2]

I'm having continuing performance issues inside the Guest VM that is
created inside the btrfs subvolume, using a qcow2 format. I'm having a
hard time determining whether the issues are related to KVM or btrfs,
or if this is even a reasonable topic of discussion.

I've seen the comments on this list saying that if I want a COW
filesystem with sparse files, that I'd be better off with ZFS. I'd
like to use an in-tree COW filesystem, but if it's just not gonna
happen yet with btrfs, I guess that's just the way it is.

That being said, how would I determine what the root issue is?
Specifically, the qcow2 file in question seems to have increasing
fragmentation, even with the No_COW attr.

[1]
$ mkfs.btrfs -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
$ mount /dev/sda /mnt
$ cd /mnt
$ btrfs create subvolume __data
$ btrfs create subvolume __data/libvirt
$ cd /
$ umount /mnt
$ mount /dev/sda /var/lib/libvirt
$ chattr +C /var/lib/libvirt/images
$ cp /run/media/rbellamy/433acf1d-a1a4-4596-a6a7-005e643b24e0/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/
$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 0 extents found
[START UP THE VM - DO SOME THINGS]
$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 12236 extents found
[START UP THE VM - DO SOME THINGS]
$ filefrag /var/lib/libvirt/images/atlas.qcow2
/var/lib/libvirt/images/atlas.qcow2: 34988 extents found

[2]
https://btrfs.wiki.kernel.org/index.php/Gotchas

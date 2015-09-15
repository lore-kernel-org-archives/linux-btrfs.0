Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33876 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbbIOLdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 07:33:06 -0400
Received: by iofb144 with SMTP id b144so197473751iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 04:33:05 -0700 (PDT)
MIME-Version: 1.0
From: "Marc O'Morain" <marc@circleci.com>
Date: Tue, 15 Sep 2015 12:32:46 +0100
Message-ID: <CAFQJxq57ZOsMy0TFpqSMNwtRaQcVp5x+gV69P-=mxL=mHD7sig@mail.gmail.com>
Subject: Intended destination for symlinks after subvolume snapshot
To: linux-btrfs@vger.kernel.org
Cc: Dev <dev@circleci.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

What is the intended destination of a symlink inside a subvolume after
a snapshot?

When I take a snapshot of a subvolume that contains a symlink, the
symlink points outside the snapshot and into the original subvolume.

Is this the intended behaviour? Or should the symlinks be patched up
to point inside the snapshot?

Here is an example that creates a new subvolume, a file and a symlink
to the file. It then creates a snapshot and shows the destination of
the symlink.

root@vagrant-ubuntu-trusty-64:/mnt/btrfs# mount | grep btrfs
/dev/loop0 on /mnt/btrfs type btrfs (rw)
root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume create subvolume0
Create subvolume './subvolume0'
root@vagrant-ubuntu-trusty-64:/mnt/btrfs# touch subvolume0/readme.txt
root@vagrant-ubuntu-trusty-64:/mnt/btrfs# ln -s
/mnt/btrfs/subvolume0/readme.txt /mnt/btrfs/subvolume0/readme.lnk
root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume snapshot -r
subvolume0 snapshot0
Create a readonly snapshot of 'subvolume0' in './snapshot0'
root@vagrant-ubuntu-trusty-64:/mnt/btrfs# tree
.
├── snapshot0
│   ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
│   └── readme.txt
└── subvolume0
    ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
    └── readme.txt

2 directories, 4 files

(I was expecting snapshot0/reame.lnk to point to
/mnt/btrfs/snapshot0/readme.txt)

Thanks,

Marc

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbbIOMjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 08:39:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZbpVq-0001C2-7z
	for linux-btrfs@vger.kernel.org; Tue, 15 Sep 2015 14:39:06 +0200
Received: from ip18869d04.dynamic.kabel-deutschland.de ([24.134.157.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 14:39:06 +0200
Received: from hurikhan77 by ip18869d04.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 14:39:06 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Intended destination for symlinks after subvolume snapshot
Date: Tue, 15 Sep 2015 14:38:57 +0200
Message-ID: <24glcc-3fb.ln1@hurikhan77.spdns.de>
References: <CAFQJxq57ZOsMy0TFpqSMNwtRaQcVp5x+gV69P-=mxL=mHD7sig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc O'Morain <marc@circleci.com> schrieb:

> Hi all,
> 
> What is the intended destination of a symlink inside a subvolume after
> a snapshot?
> 
> When I take a snapshot of a subvolume that contains a symlink, the
> symlink points outside the snapshot and into the original subvolume.
> 
> Is this the intended behaviour? Or should the symlinks be patched up
> to point inside the snapshot?
> 
> Here is an example that creates a new subvolume, a file and a symlink
> to the file. It then creates a snapshot and shows the destination of
> the symlink.
> 
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# mount | grep btrfs
> /dev/loop0 on /mnt/btrfs type btrfs (rw)
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume create
> subvolume0 Create subvolume './subvolume0'
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# touch subvolume0/readme.txt
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# ln -s
> /mnt/btrfs/subvolume0/readme.txt /mnt/btrfs/subvolume0/readme.lnk
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume snapshot -r
> subvolume0 snapshot0
> Create a readonly snapshot of 'subvolume0' in './snapshot0'
> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# tree
> .
> ├── snapshot0
> │   ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
> │   └── readme.txt
> └── subvolume0
>     ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
>     └── readme.txt
> 
> 2 directories, 4 files
> 
> (I was expecting snapshot0/reame.lnk to point to
> /mnt/btrfs/snapshot0/readme.txt)

If you use absolute symlinks this is intended behaviour and probably has its 
use cases (similar to when you move subdirectories or create a copy, 
symlinks aren't rewritten either).

You should use relative symlinks for your use case (this means, do not start 
with "/", instead walk up with ".." if needed).

-- 
Replies to list only preferred.


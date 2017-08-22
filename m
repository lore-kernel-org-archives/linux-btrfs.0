Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36704 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932913AbdHVOnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:43:19 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:51144)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkAOj-0004Mz-MH
        for linux-btrfs@vger.kernel.org; Tue, 22 Aug 2017 15:43:17 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkAOa-0007fb-49
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 15:43:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22940.17147.756378.347580@tree.ty.sabi.co.uk>
Date: Tue, 22 Aug 2017 15:43:07 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: finding root filesystem of a subvolume?
In-Reply-To: <20170822122350.GA14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How do I find the root filesystem of a subvolume?
> Example:
> root@fex:~# df -T 
> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> -              -    1073740800 104244552 967773976  10% /local/.backup/home
[ ... ]
> I know, the root filesystem is /local,

That question is somewhat misunderstood and uses the wrong
concepts and terms. In UNIX filesystems a filesystem "root" is a
directory inode with a number that is local to itself, and can
be "mounted" anywhere, or left unmounted, and that is a property
of the running system, not of the filesystem "root". Usually
UNIX filesystems have a single "root" directory inode.

In the case of Btrfs the main volume and its subvolumes all have
filesystem "root" directory inodes, which may or may not be
"mounted", anywhere the administrators of the running system
pleases, as a property of the running system. There is no fixed
relationship between the root directory inode of a subvolume and
the root directory inode of any other subvolume or the main
volume.

Note: in Btrfs terminology "volume" seems to mean both the main
volume and the collection of devices where it and subvolumes are
hosted.

> but who can I show it by command?

The system does not keep an explicit record of which Btrfs
"root" directory inode is related to which other Btrfs "root"
directory inode in the same volume, whether mounted or
unmounted.

That relationship has to be discovered by using volume UUIDs,
which are the same for the main subvolume and the other
subvolumes, whether mounted or not, so one has to do:

  * For the indicated mounted subvolume "root" read its UUID.
  * For every mounted filesystem "root", check whether its type
    is 'btrfs' and if it is obtain its UUID.
  * If the UUID is the same, and the subvolume id is '5', that's
    the main subvolume, and terminate.
  * For every block device which is not mounted, check whether it
    has a Btrfs superblock.
  * If the type is 'btrfs' and the volume UUIS is the same as
    that of the subvolume, list the block device.

In the latter case since the main volume is not mounted the only
way to identify it is to list the block devices that host it.

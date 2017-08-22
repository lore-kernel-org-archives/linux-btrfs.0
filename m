Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:37942 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdHVRlo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 13:41:44 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:54932)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkDBO-0001vL-Bt
        for linux-btrfs@vger.kernel.org; Tue, 22 Aug 2017 18:41:42 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkDBG-0002rm-Gq
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 18:41:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22940.27854.159264.779233@tree.ty.sabi.co.uk>
Date: Tue, 22 Aug 2017 18:41:34 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: finding root filesystem of a subvolume?
In-Reply-To: <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
        <22940.17147.756378.347580@tree.ty.sabi.co.uk>
        <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>> There is no fixed relationship between the root directory
>> inode of a subvolume and the root directory inode of any
>> other subvolume or the main volume.

> Actually, there is, because it's inherently rooted in the
> hierarchy of the volume itself. That root inode for the
> subvolume is anchored somewhere under the next higher
> subvolume.

This stupid point relies on ignoring that it is not mandatory to
mount the main volume, and that therefore "There is no fixed
relationship between the root directory inode of a subvolume and
the root directory inode of any other subvolume or the main
volume", because the "root directory inode" of the "main volume"
may not be mounted at all.

This stupid point also relies on ignoring that subvolumes can be
mounted *also* under another directory, even if the main volume
is mounted somewhere else. Suppose that the following applies:

  subvol=5	/local
  subvol=383	/local/.backup/home
  subvol=383	/mnt/home-backup

and you are given the mountpoint '/mnt/home-backup', how can you
find the main volume mountpoint '/local' from that?

Please explain how '/mnt/home-backup' is indeed "inherently
rooted in the hierarchy of the volume itself", because there is
always a "fixed relationship between the root directory inode of
a subvolume and the root directory inode of any other subvolume
or the main volume".

[ ... ]

> Again, it does, it's just not inherently exposed to userspace
> unless you mount the top-level subvolume (subvolid=5 and/or
> subvol=/ in mount options).

This extra stupid point is based on ignoring that to "mount the
top-level subvolume" relies on knowing already which one is the
"top-level subvolume", which is begging the question.

[ ... ]

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62338 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3IXQfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 12:35:22 -0400
Received: by mail-ie0-f176.google.com with SMTP id as1so9145393iec.21
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 09:35:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Sep 2013 11:35:19 -0500
Message-ID: <CAEWPe=r1yaM6DBJpHjGWF47O8jA0uc=rKCg5x5Y6+9__qgYwew@mail.gmail.com>
Subject: Online replacement of missing or completely faulted devices
From: Dead Horse <deadhorseconsulting@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After digging around I cannot seemingly find a clear answer on if or
when BTRFS supports the replacing of completely faulted or failed
drives while the filesystem is still online.

EG: Equivalence or BTRFS notion of the ZFS Attach/Detach/Online/Offline/
Replace features

At the moment it seems the only way to replace or remove a drive which
has completely failed is to take the filesystem offline and mount it
in degraded mode.

EG: "mount -o degraded btrfsdevice mountpoint"
then
"btrfs device delete missing mountpoint"

Thus in order to replace a device which has completely failed we must
take the filesystem completely offline.

Thus is something to the tune of how this can be handled with the FS
still on online like ZFS planned?

EG: "zpool replace poolname failedormissingdevice newdevice"

If not planned is the strategy that when a device fails in such a
manner that one simply removes and replaces the failed device. Then
once the new device is installed it is added via "btrfs device add"?
Then at some point when the FS is taken offline for maintenance for
whatever reason that a "btrfs device delete missing" is done to clean
up the failed devices?

- DHC

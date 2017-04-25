Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47507 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1949429AbdDYUUK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 16:20:10 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d36wM-0003TK-Aa
        for linux-btrfs@vger.kernel.org; Tue, 25 Apr 2017 22:20:02 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: backing up a collection of snapshot subvolumes
Date: Tue, 25 Apr 2017 22:20:02 +0200
Message-ID: <20170425222002.4f119fc6@jupiter.sol.kaishome.de>
References: <58FECA45.1010107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 25 Apr 2017 00:02:13 -0400
schrieb "J. Hart" <jfhart085@gmail.com>:

> I have a remote machine with a filesystem for which I periodically
> take incremental snapshots for historical reasons.  These snapshots
> are stored in an archival filesystem tree on a file server.  Older
> snapshots are removed and newer ones added on a rotational basis.  I
> need to be able to backup this archive by syncing it with a set of
> backup drives. Due to the size, I need to back it up incrementally
> rather than sending the entire content each time.  Due to the
> snapshot rotation, I need to be able to update the state of the
> archive backup filesystem as a whole, in much the same manner that
> rsync handles file trees.
> 
> It seems that I cannot use "btrfs send", as the archive directory 
> contains the snapshots as subvolumes.
> 
> I cannot use rsync as it treats subvolumes as simple directories, and 
> does not preserve subvolume attributes.  Rsync also does not support 
> reflinks, so the snapshot directory content will no longer be
> reflinked to other snapshots on the archive backup.  I cannot use
> hard links in the incrementals as hard links do not cross subvolume
> boundaries.
> 
> Thoughts anyone ?

If this is for archival purpose only and storage efficiency and speed is
your primary concern, try borgbackup.

Borgbackup deploys its own deduplication and doesn't rely on btrfs
snapshot capabilities. You can store your archives wherever you want
(even on non-btrfs), and it won't store any data blocks twice.

Upon restore, you could simply recreate the snapshot/subvolume from a
similar tree and then rsync a tree restored from borgbackup back to
this snapshot to get back a state with the benefits of btrfs snapshots.

Borg also has an adapter for fuse to get a mounted view into the
archives, tho, it is slow and probably takes a lot of RAM. But it is
good enough for single file lookups and navigation.

-- 
Regards,
Kai

Replies to list-only preferred.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:39088 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754722AbcLSM4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 07:56:16 -0500
Message-ID: <1482152074.5857d88ab133a@webmail.adria.it>
Date: Mon, 19 Dec 2016 13:54:34 +0100
From: bepi@adria.it
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <83dbcf2c-df10-5628-fc46-9d33a7bf78af@cn.fujitsu.com>
In-Reply-To: <83dbcf2c-df10-5628-fc46-9d33a7bf78af@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> 
> At 11/21/2016 08:09 PM, bepi@adria.it wrote:
> > Hi.
> >
> > My system: Fedora 23, kernel-4.7.10-100.fc23.x86_64
> btrfs-progs-4.4.1-1.fc23.x86_64
> >
> > Testing the remote differential receive (via ssh and in local network) of
> 24
> > sequential snapshots, and simultaneously deleting the snapshot, (in the
> same
> > file system, but in a different subvolume), there has been an file access
> error,
> > and the file system has corrupt.
> 
> Are you using qgroup?
> 
> IIRC, Filipe fixed a problem which could cause backref corruption which 
> only happens if quota is enabled.
> 
> Thanks,
> Qu


Unfortunately not.

I read that thread (and others), but no one it seemed like my case.


To you (Thanks).


Gdb


> 
> >
> > Both scrub, both recovery and clear_cache mount options, both btrfsck,
> have
> > failed, the file system is left in a state unusable.
> >
> > After reformatting the filesystem, remote receive of 24 snapshots worked
> properly.
> >
> > The file system is used exclusively for receive the snapshot, it is
> composed of
> > a single device.
> > The initial snapshot is a linux installation of 50Gb.
> >
> >
> > I think that there was a race condition between the receive and deletion
> of
> > snapshots (that were performed on two different subvolume).
> >
> >
> > Best regards.
> >
> > gdb
> >
> > ----------------------------------------------------
> > This mail has been sent using Alpikom webmail system
> > http://www.alpikom.it
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> 
> 




----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it


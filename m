Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:44618 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755423AbcLSNEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 08:04:43 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pop.aknet.it (8.12.8/8.12.8) with ESMTP id uBJD4eWC001934
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:04:40 +0100
Message-ID: <1482152671.5857dadfb6166@webmail.adria.it>
Date: Mon, 19 Dec 2016 14:04:31 +0100
From: bepi@adria.it
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com> <2329571.vMCvUE5AeF@exnet.gdb.it>, <9712851.I7FUyRd5GC@exnet.gdb.it> <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
In-Reply-To: <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Resend)

Hi.

It is a bit complex.


Primary system

subvolume on SSD devices on PCIe slot

/root/ (fedora 23, 50GB usati)

/btrfssnapshot/
/btrfssnapshot/root/  (for /root/ snapshot)
/btrfssnapshot/root/root.1
/btrfssnapshot/root/root.2
/btrfssnapshot/root/root.XYZ


subvolume on device HDD "1" sata

/data_storage/  (data, 100GB usati)
/data_backup/   (backup tar files, programs, downloads, etc., used 250GB)

/btrfssnapshot/
/btrfssnapshot/data_storage/  (for /data_storage/ snapshot)
/btrfssnapshot/data_backup/   (for /data_backup/ snapshot)
/btrfssnapshot/data_storage/data_storage.1
/btrfssnapshot/data_storage/data_storage.2
/btrfssnapshot/data_storage/data_storage.XYZ
/btrfssnapshot/data_backup/data_backup.1
/btrfssnapshot/data_backup/data_backup.2
/btrfssnapshot/data_backup/data_backup.XYZ


subvolume on HDD device "2" sata

partition 1

/btrfsreceive/root/  (for receive /btrfssnapshot/root/ snapshot)
/btrfsreceive/root/.part/

partition 2

/btrfsreceive/data_storage/  (for receive /btrfssnapshot/data_storage/ snapshot)
/btrfsreceive/data_storage/.part/
/btrfsreceive/data_backup/  (for receive /btrfssnapshot/data_backup/ snapshot)
/btrfsreceive/data_backup/.part/



Secondary system for receiving snapshot

subvolume on HDD device "3" sata

partition 1

/btrfsreceive/root/
/btrfsreceive/root/.part/

partition 2

/btrfsreceive/data_storage/  (for receive /btrfssnapshot/data_storage/ snapshot)
/btrfsreceive/data_storage/.part/
/btrfsreceive/data_backup/  (for receive /btrfssnapshot/data_backup/ snapshot)
/btrfsreceive/data_backup/.part/


My bash script create snapshot of /root/, /data_storage/ and /data_backup/ on
/btrfssnapshot/ .
Snapshot is created with .part extension, when the creation is finished
properly, is renamed to .1, .2, .XYZ .


My bash script send snapshot from /btrfssnapshot/root/,
/btrfssnapshot/data_storage/ and /btrfssnapshot/data_backup/ (sending
differential, n - 1 -> n) to the subvolume /btrfsreceive/root/,
/btrfsreceive/data_storage/ and /btrfsreceive/data_backup/.


My bash script sends the same snapshot also to the secondary system for
receiving snapshots (using ssh).


P.S. If I recreate the receiving partition from scratch, the receive working
properly.


The previous problems information are in this thread.
Please, you can read the thread?


Thanks to you.


Gdb

Scrive Xin Zhou <xin.zhou@gmx.com>:

> 
> Hi Giuseppe,
> 
> Would you like to tell some details about:
> 1. the XYZ snapshot was taken from which subvolume
> 2. where the base (initial) snapshot is stored
> 3. The 3 partitions receives the same snapshot, are they in the same btrfs
> configuration and subvol structure?
> 
> Also, would you send the link reports "two files unreadable error" post
> mentioned in step 2? 
> Hope can see the message and figure out if the issue first comes from sender
> or receiver side. 
> 
> Thanks,
> Xin
>  
> 


----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it


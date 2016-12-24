Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i4.italiaonline.it ([212.48.25.216]:47282 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754432AbcLXMry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 07:47:54 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sat, 24 Dec 2016 13:47:18 +0100
Message-ID: <3299660.qyGp9ij9r0@exnet.gdb.it>
In-Reply-To: <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <1482515316.585d63747d460@webmail.adria.it> <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

LOCAL "btrfs send/receive"

btrfs send -p /tmp/tmp.hkAa8XaliZ/btrfssnapshot/root/root-2016-12-18_15:10:01.40 /tmp/tmp.hkAa8XaliZ/btrfssnapshot/root/root-2016-12-19_19:44:00.41 | btrfs receive /tmp/tmp.NRYgYVC3p6/btrfsreceive/root/.part/


REMOTE "btrfs send/receive"

btrfs send -p /tmp/tmp.BTACBk7xuK/btrfssnapshot/root/root-2016-12-18_15:10:01.40 /tmp/tmp.BTACBk7xuK/btrfssnapshot/root/root-2016-12-19_19:44:00.41 | ssh root@exnetold.gdb.it btrfsManage REMOTE_RECEIVE /dev/sda3 root root-2016-12-19_19:44:00.41

Remote btrfsManage script (btrfsManage REMOTE_RECEIVE /dev/sda3 root root-2016-12-19_19:44:00.41) executes 

cat - | btrfs receive /tmp/tmp.Wd5togIiaL/btrfsreceive/root/.part/


The waiting for the end of a command, in shell script, is implicit/automatic.


Regards.


Gdb

> Hi,
> 
> Would you like to show the "btrfs send/receive" command the script are
> using, including all the parameters, and how the script waits for a
> completion of a transfer.
> 
> From the beginning of the thread, it seems the transfer tests are going
> through different network environment. 
> Thanks,
> Xin
> 
> Sent: Friday, December 23, 2016 at 9:48 AM
> From: bepi@adria.it
> To: "Xin Zhou" <xin.zhou@gmx.com>
> Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
> Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
> during the snapshot receive Yes.
> 
> Is through to the btrfs-tools error message that the script has printed,
> that I realized the filesystem corruption.
> 
> 
> P.S. Various messages that you see in the working examples of the script,
> are emitted directly by the btrfs-tools.
> 
> 
> Gdb
> 
> Xin Zhou <xin.zhou@gmx.com>:
> > Hi,
> > 
> > Does the script check the transfer status, and is there a transfer returns
> > an error code?
> > Thanks,
> > Xin
> > Â 
> > Â 
> > 


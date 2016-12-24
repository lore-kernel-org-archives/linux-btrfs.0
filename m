Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i4.italiaonline.it ([212.48.25.216]:56122 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751765AbcLXMQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 07:16:34 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Xin Zhou <xin.zhou@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sat, 24 Dec 2016 13:16:10 +0100
Message-ID: <26479704.a8Su2NvQ2R@exnet.gdb.it>
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
> > Sent:Â Thursday, December 22, 2016 at 11:28 PM
> > From:Â "Giuseppe Della Bianca" <bepi@adria.it>
> > To:Â "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
> > Subject:Â Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file
> > system during the snapshot receive
> > (synthetic resend)
> > 
> > Hi.
> > 
> > Is possible that there are transfers, cancellations and other, at the same
> > time, but not in the same subvolume.
> > 
> > My script checks that there are no transfers in progress on the same
> > subvolume.
> > 
> > Is possible that the same subvolume is mounted several times (temporary
> > mount
> > at the beginning, and unmount at the end, in my script).
> > 
> > 
> > Thanks for all.
> > 
> > 
> > P.S. Sorry for my bad English.
> > 
> > 
> > Gdb
> > 
> > In data mercoledÃ¬ 21 dicembre 2016 23:14:44, Xin Zhou ha scritto:
> > > Hi,
> > > Racing condition can happen, if running multiple transfers to the same
> > > destination. Would you like to tell how many transfers are the scripts
> > > running at a time to a specific hdd?
> > > 
> > > Thanks,
> > > Xin
> > > 
> > > 
> > > Sent: Wednesday, December 21, 2016 at 1:11 PM
> > > From: "Chris Murphy" <lists@colorremedies.com>
> > > To: No recipient address
> > > Cc: "Giuseppe Della Bianca" <bepi@adria.it>, "Xin Zhou"
> > 
> > <xin.zhou@gmx.com>,
> > 
> > > "Btrfs BTRFS" <linux-btrfs@vger.kernel.org> Subject: Re: [CORRUPTION
> > > FILESYSTEM] Corrupted and unrecoverable file system during the snapshot
> > > receive
> > > On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <lists@colorremedies.com>
> > 
> > wrote:
> > > > What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
> > > > mount option?
> > > 
> > > This slows things down, and in that case it might avoid the problem if
> > > it's the result of a race condition.
> > > 
> > > --
> > > Chris Murphy
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
> ----------------------------------------------------
> This mail has been sent using Alpikom webmail system
> http://www.alpikom.it[http://www.alpikom.it]
>  


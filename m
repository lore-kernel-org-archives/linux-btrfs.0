Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753193AbcLXUPo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 15:15:44 -0500
MIME-Version: 1.0
Message-ID: <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Giuseppe Della Bianca" <bepi@adria.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Sat, 24 Dec 2016 21:15:40 +0100
In-Reply-To: <26479704.a8Su2NvQ2R@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <1482515316.585d63747d460@webmail.adria.it>
 <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>,
 <26479704.a8Su2NvQ2R@exnet.gdb.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Probably can try to use "-v" to enable more output print.
A quick look at the send / receive code, it seems a little bit risky.
It seems lack of specific error handlings, and in most cases, return the same error code.
I think it might be helpful, when a transfer succeed, the command prints the transfer id, source / dest,
and a specific "success" string. 
Such output could help the script to figure out if a transfer really succeed.

The code is relatively new to me, I did not see retry logic in stream handling, please correct me if I am wrong about this.
So, I am not quite sure about the transfer behavior, if the system subject to network issues in heavy workload,
in which packets missing or connect issues are not rare.

Since the test mentioned at the begining deletes the snapshots after a transfer, while most users keep the middle snapshot even in cascading transfer, probably the current btrfs and cmds still works for regular users.

Thanks,
Xin
 
 

Sent: Saturday, December 24, 2016 at 4:16 AM
From: "Giuseppe Della Bianca" <bepi@adria.it>
To: "Xin Zhou" <xin.zhou@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
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
> http://www.alpikom.it[http://www.alpikom.it][http://www.alpikom.it[http://www.alpikom.it]]
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]

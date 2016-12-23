Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:41049 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932617AbcLWRsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 12:48:47 -0500
Message-ID: <1482515316.585d63747d460@webmail.adria.it>
Date: Fri, 23 Dec 2016 18:48:36 +0100
From: bepi@adria.it
To: Xin Zhou <xin.zhou@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com> <trinity-6a0e983c-9cfd-479a-8f3a-593c8c30b7b0-1482358484582@3capp-mailcom-bs03>, <21181187.lK0OKanLcd@exnet.gdb.it> <trinity-fc2d116f-c173-4c79-8df7-44fac80a4eee-1482512021974@3capp-mailcom-bs01>
In-Reply-To: <trinity-fc2d116f-c173-4c79-8df7-44fac80a4eee-1482512021974@3capp-mailcom-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes.

Is through to the btrfs-tools error message that the script has printed, that I
realized the filesystem corruption.


P.S. Various messages that you see in the working examples of the script, are
emitted directly by the btrfs-tools.


Gdb

Xin Zhou <xin.zhou@gmx.com>:

> Hi,
> 
> Does the script check the transfer status, and is there a transfer returns an
> error code?
> Thanks,
> Xin
>  
>  
> 
> Sent: Thursday, December 22, 2016 at 11:28 PM
> From: "Giuseppe Della Bianca" <bepi@adria.it>
> To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
> Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
> during the snapshot receive
> (synthetic resend)
> 
> Hi.
> 
> Is possible that there are transfers, cancellations and other, at the same
> time, but not in the same subvolume.
> 
> My script checks that there are no transfers in progress on the same
> subvolume.
> 
> Is possible that the same subvolume is mounted several times (temporary
> mount
> at the beginning, and unmount at the end, in my script).
> 
> 
> Thanks for all.
> 
> 
> P.S. Sorry for my bad English.
> 
> 
> Gdb
> 
> 
> In data mercoledì 21 dicembre 2016 23:14:44, Xin Zhou ha scritto:
> > Hi,
> > Racing condition can happen, if running multiple transfers to the same
> > destination. Would you like to tell how many transfers are the scripts
> > running at a time to a specific hdd?
> >
> > Thanks,
> > Xin
> >
> >
> > Sent: Wednesday, December 21, 2016 at 1:11 PM
> > From: "Chris Murphy" <lists@colorremedies.com>
> > To: No recipient address
> > Cc: "Giuseppe Della Bianca" <bepi@adria.it>, "Xin Zhou"
> <xin.zhou@gmx.com>,
> > "Btrfs BTRFS" <linux-btrfs@vger.kernel.org> Subject: Re: [CORRUPTION
> > FILESYSTEM] Corrupted and unrecoverable file system during the snapshot
> > receive
> > On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> > > What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
> > > mount option?
> >
> > This slows things down, and in that case it might avoid the problem if
> > it's the result of a race condition.
> >
> > --
> > Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 




----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it


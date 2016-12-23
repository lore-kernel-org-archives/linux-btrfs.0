Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i4.italiaonline.it ([212.48.25.215]:42941 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752410AbcLWH2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 02:28:32 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Fri, 23 Dec 2016 08:28:19 +0100
Message-ID: <21181187.lK0OKanLcd@exnet.gdb.it>
In-Reply-To: <trinity-6a0e983c-9cfd-479a-8f3a-593c8c30b7b0-1482358484582@3capp-mailcom-bs03>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <CAJCQCtSZf+Z12HzhNHX8XMXZH4peNVQ=a_kbFJS3gUUKq=_T0g@mail.gmail.com> <trinity-6a0e983c-9cfd-479a-8f3a-593c8c30b7b0-1482358484582@3capp-mailcom-bs03>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(synthetic resend)

Hi.

Is possible that there are transfers, cancellations and other, at the same 
time, but not in the same subvolume.

My script checks that there are no transfers in progress on the same 
subvolume.

Is possible that the same subvolume is mounted several times (temporary mount 
at the beginning, and unmount at the end, in my script).


Thanks for all.


P.S. Sorry for my bad English.


Gdb


In data mercoledì 21 dicembre 2016 23:14:44, Xin Zhou ha scritto:
> Hi,
> Racing condition can happen, if running multiple transfers to the same
> destination. Would you like to tell how many transfers are the scripts
> running at a time to a specific hdd?
> 
> Thanks,
> Xin
>  
> 
> Sent: Wednesday, December 21, 2016 at 1:11 PM
> From: "Chris Murphy" <lists@colorremedies.com>
> To: No recipient address
> Cc: "Giuseppe Della Bianca" <bepi@adria.it>, "Xin Zhou" <xin.zhou@gmx.com>,
> "Btrfs BTRFS" <linux-btrfs@vger.kernel.org> Subject: Re: [CORRUPTION
> FILESYSTEM] Corrupted and unrecoverable file system during the snapshot
> receive
> On Wed, Dec 21, 2016 at 2:09 PM, Chris Murphy <lists@colorremedies.com> 
wrote:
> > What about CONFIG_BTRFS_FS_CHECK_INTEGRITY? And then using check_int
> > mount option?
> 
> This slows things down, and in that case it might avoid the problem if
> it's the result of a race condition.
> 
> --
> Chris Murphy


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:40153 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3LREM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 23:12:27 -0500
Received: by mail-yh0-f50.google.com with SMTP id b6so5164469yha.9
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 20:12:26 -0800 (PST)
Received: from vfr.localnet (adsl-74-190-214-178.asm.bellsouth.net. [74.190.214.178])
        by mx.google.com with ESMTPSA id h23sm28540372yhc.0.2013.12.17.20.12.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2013 20:12:26 -0800 (PST)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs RAID1 File System Grew Something Extra
Date: Tue, 17 Dec 2013 23:12:25 -0500
Message-ID: <17576852.FmZ5tQlVm8@vfr>
In-Reply-To: <52B10C85.90405@oracle.com>
References: <1617587.38j2eTuIdt@vfr> <52B10C85.90405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12-18-13 10:46:29 Anand Jain wrote:
> On 12/18/2013 10:03 AM, Garry T. Williams wrote:
> > I have been using btrfs for my /home partition on my home machine for
> > a few years now.  I created the file system RAID1 using two disk
> > partitions.  Recently I noticed btrfs fi df shows extra Data, System,
> > and Metadata allocations.  And btrfs fi show indicates extra
> > allocations on one of my disk drives accounting for the 20 MiB
> > allocation in the df display.
>
>   this is a known bug in mkfs.btrfs, the workaround for now is
>   to run balance on FS having some data. so that unused group-
>   profile will go away.

Thanks.

    garry@vfr$ sudo btrfs balance start /home
    Done, had to relocate 50 out of 50 chunks
    garry@vfr$ sudo btrfs filesystem df /home
    Data, RAID1: total=22.00GiB, used=21.02GiB
    System, RAID1: total=32.00MiB, used=12.00KiB
    System, single: total=4.00MiB, used=0.00
    Metadata, RAID1: total=1.00GiB, used=419.60MiB

Hmmm.

Well, it's better, but the extra allocation for System is baffling.  I
believe that this happened sometime after creating the file system.

Also balance on a RAID1 file system with exactly two drives doesn't
make much sense to me.  Why would any "chunks" have to be relocated?
I'm clearly missing something here.

-- 
Garry T. Williams


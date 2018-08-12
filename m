Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:34849 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbeHLUSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 16:18:31 -0400
Received: by mail-ed1-f42.google.com with SMTP id e6-v6so7140176edr.2
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Aug 2018 10:39:46 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <CAJCQCtQS+yiSQ4Cu-F_Spi5_6fEw_FuGdXCafJLxBe1swacabQ@mail.gmail.com>
 <pan$37ed4$1f39572a$7dd0a77a$b6954c8@cox.net>
 <CAJCQCtR9mYzFSHheyjK6sSf-KKeXtibArw9UcpH9Bh-ptXTVcg@mail.gmail.com>
 <5bcd7922-9820-ac9d-5dc2-77a8a4618f91@gmail.com>
Message-ID: <746f748b-3d81-a76f-e15b-5c0112ee4f50@gmail.com>
Date: Sun, 12 Aug 2018 20:39:43 +0300
MIME-Version: 1.0
In-Reply-To: <5bcd7922-9820-ac9d-5dc2-77a8a4618f91@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

12.08.2018 10:04, Andrei Borzenkov пишет:
> 
> On ZFS snapshots are contained in dataset and you limit total dataset
> space consumption including all snapshots. Thus end effect is the same -
> deleting data that is itself captured in snapshot does not make a single
> byte available. ZFS allows you to additionally restrict active file
> system size ("referenced" quota in ZFS) - this more closely matches your
> expectation - deleting file in active file system decreases its
> "referenced" size thus allowing user to write more data (as long as user
> does not exceed total dataset quota). This is different from btrfs
> "exculsive" and "shared". This should not be hard to implement in btrfs,
> as "referenced" simply means all data in current subvolume, be it
> exclusive or shared.
> 

Oops, actually this is exactly what "referenced" quota is. Limiting
total subvolume + snapshots is more difficult, as there is no inherent
connection between qgroups of source and snapshot nor any built-in way
to include snapshot qgroup in some common total qgroup when creating
snapshot.

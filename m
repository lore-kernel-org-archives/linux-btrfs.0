Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36556 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeCETiT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 14:38:19 -0500
Received: by mail-lf0-f42.google.com with SMTP id g72so24925215lfg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Mar 2018 11:38:18 -0800 (PST)
Subject: Re: How to change/fix 'Received UUID'
To: Marc MERLIN <marc@merlins.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        fdmanana@gmail.com
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
Date: Mon, 5 Mar 2018 22:38:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

05.03.2018 19:16, Marc MERLIN пишет:
> Howdy,
> 
> I did a bunch of copies and moving around subvolumes between disks and
> at some point, I did a snapshot dir1/Win_ro.20180205_21:18:31 dir2/Win_ro.20180205_21:18:31
> 
> As a result, I lost the ro flag, and apparently 'Received UUID' which is
> now preventing me from restarting the btrfs send/receive.
> 
> I changed the snapshot back to 'ro' but that's not enough:
> 
> Source:
>         Name:                   Win_ro.20180205_21:18:31
>         UUID:                   23ccf2bd-f494-e348-b34e-1f28486b2540
>         Parent UUID:            -
>         Received UUID:          3cc327e1-358f-284e-92e2-4e4fde92b16f
>         Creation time:          2018-02-15 20:14:42 -0800
>         Subvolume ID:           964
>         Generation:             4062
>         Gen at creation:        459
>         Parent ID:              5
>         Top level ID:           5
>         Flags:                  readonly
> 
> Dest:
>         Name:                   Win_ro.20180205_21:18:31
>         UUID:                   a1e8777c-c52b-af4e-9ce2-45ca4d4d2df8
>         Parent UUID:            -
>         Received UUID:          -
>         Creation time:          2018-02-17 22:20:25 -0800
>         Subvolume ID:           94826
>         Generation:             250714
>         Gen at creation:        250540
>         Parent ID:              89160
>         Top level ID:           89160
>         Flags:                  readonly
> 
> If I absolutely know that the data is the same on both sides, how do I
> either
> 1) force back in a 'Received UUID' value on the destination

I suppose the most simple is to write small program that does it using
BTRFS_IOC_SET_RECEIVED_SUBVOL.

> 2) force a btrfs receive to work despite the lack of matching 'Received
> UUID' 
> 
> Yes, I could discard and start over, but my 2nd such subvolume is 8TB,
> so I'd really rather not :)
> 
> Any ideas?
> 
> Thanks,
> Marc
> 


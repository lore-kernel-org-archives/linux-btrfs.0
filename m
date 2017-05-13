Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45342 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbdEMKsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 06:48:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9Uai-0001Lt-8q
        for linux-btrfs@vger.kernel.org; Sat, 13 May 2017 12:48:04 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Sat, 13 May 2017 12:47:52 +0200
Message-ID: <20170513124752.140db9d0@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <20170513145247.247791b7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 13 May 2017 14:52:47 +0500
schrieb Roman Mamedov <rm@romanrm.net>:

> On Fri, 12 May 2017 20:36:44 +0200
> Kai Krakow <hurikhan77@gmail.com> wrote:
> 
> > My concern is with fail scenarios of some SSDs which die unexpected
> > and horribly. I found some reports of older Samsung SSDs which
> > failed suddenly and unexpected, and in a way that the drive
> > completely died: No more data access, everything gone. HDDs start
> > with bad sectors and there's a good chance I can recover most of
> > the data except a few sectors.  
> 
> Just have your backups up-to-date, doesn't matter if it's SSD, HDD or
> any sort of RAID.
> 
> In a way it's even better, that SSDs [are said to] fail abruptly and
> entirely. You can then just restore from backups and go on. Whereas a
> failing HDD can leave you puzzled on e.g. whether it's a cable or
> controller problem instead, and possibly can even cause some data
> corruption which you won't notice until too late.

My current backup strategy can handle this. I never backup files from
the source again if it didn't change by timestamp. That way, silent data
corruption won't creep into the backup. Additionally, I keep a backlog
of 5 years of file history. Even if a corrupted file creeps into the
backup, there is enough time to get a good copy back. If it's older, it
probably doesn't hurt so much anyway.


-- 
Regards,
Kai

Replies to list-only preferred.


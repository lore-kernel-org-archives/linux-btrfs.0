Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40935 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbeF3IU1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 04:20:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fZB5A-0001BU-D7
        for linux-btrfs@vger.kernel.org; Sat, 30 Jun 2018 10:18:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send/receive vs rsync
Date: Sat, 30 Jun 2018 08:18:06 +0000 (UTC)
Message-ID: <pan$459f7$e799c140$81f1419d$ea68563a@cox.net>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
        <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
        <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
        <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
        <20180629060657.qrtcxfcy22zkstfw@merlins.org>
        <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
        <20180629065903.xgwpvaa2vuiys75r@merlins.org>
        <20180629120954.4bbcd174@natsu>
        <20180629072210.nxvtwbokblol7xcb@merlins.org>
        <f693b8c8-1b3c-4847-b5f5-3990e3b8389a@bouton.name>
        <20180629162420.xszjxquo7gtrwtxz@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 29 Jun 2018 09:24:20 -0700 as excerpted:

>> If instead of using a single BTRFS filesystem you used LVM volumes
>> (maybe with Thin provisioning and monitoring of the volume group free
>> space) for each of your servers to backup with one BTRFS filesystem per
>> volume you would have less snapshots per filesystem and isolate
>> problems in case of corruption. If you eventually decide to start from
>> scratch again this might help a lot in your case.
> 
> So, I already have problems due to too many block layers:
> - raid 5 + ssd - bcache - dmcrypt - btrfs
> 
> I get occasional deadlocks due to upper layers sending more data to the
> lower layer (bcache) than it can process. I'm a bit warry of adding yet
> another layer (LVM), but you're otherwise correct than keeping smaller
> btrfs filesystems would help with performance and containing possible
> damage.
> 
> Has anyone actually done this? :)

So I definitely use (and advocate!) the split-em-up strategy, and I use 
btrfs, but that's pretty much all the similarity we have.

I'm all ssd, having left spinning rust behind.  My strategy avoids 
unnecessary layers like lvm (tho crypt can arguably be necessary), 
preferring direct on-device (gpt) partitioning for simplicity of 
management and disaster recovery.  And my backup and recovery strategy is 
an equally simple mkfs and full-filesystem-fileset copy to an identically 
sized filesystem, with backups easily bootable/mountable in place of the 
working copy if necessary, and multiple backups so if disaster takes out 
the backup I was writing at the same time as the working copy, I still 
have a backup to fall back to.

So it's different enough I'm not sure how much my experience will help 
you.  But I /can/ say the subdivision is nice, as it means I can keep my 
root filesystem read-only by default for reliability, my most-at-risk log 
filesystem tiny for near-instant scrub/balance/check, and my also at risk 
home small as well, with the big media files being on a different 
filesystem that's mostly read-only, so less at risk and needing less 
frequent backups.  The tiny boot and large updates (distro repo, sources, 
ccache) are also separate, and mounted only for boot maintenance or 
updates.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


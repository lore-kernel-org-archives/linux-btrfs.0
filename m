Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaGPHmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 03:42:02 -0400
Date: Wed, 16 Jul 2014 15:41:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Hugo Mills <hugo-lkml@carfax.org.uk>, Norbert Preining <preining@logic.at>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: btrfs hanging since 3.16-rc3 or so
Message-ID: <20140716074120.GA29931@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20140715134046.GX23620@auth.logic.tuwien.ac.at>
 <20140715214701.GD4834@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140715214701.GD4834@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Jul 15, 2014 at 10:47:01PM +0100, Hugo Mills wrote:
> cc linux-btrfs list
> 
> On Tue, Jul 15, 2014 at 10:40:46PM +0900, Norbert Preining wrote:
> > Dear all
> > 
> > (please keep Cc)
> > 
> > Since 3.16-rc3 or so I regularly get btrfs hanging in some transations.
> > 
> > Usually during apt-get upgrade or some other large file operations
> > (cowbuilder building of packages).
> > 
> > The log files give me for loads of processes things like:
> > [ 6236.746546] INFO: task aptitude:22775 blocked for more than 120 seconds.
> > [ 6236.746547]       Tainted: G        W  O  3.16.0-rc5 #27
> > [ 6236.746548] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 6236.746549] aptitude        D ffff8800b21a3868     0 22775  22709 0x00000000
> > [ 6236.746550]  ffff88003644fd10 0000000000000082 ffffffff81a15500 ffff88003644ffd8
> > [ 6236.746552]  ffff8800b21a3430 0000000000011c00 ffff880147da9c30 ffff880147da9c30
> > [ 6236.746553]  ffff88003644fd58 ffff880034b3ed48 ffff880034b3ed38 ffff88003644fd20
> > [ 6236.746555] Call Trace:
> > [ 6236.746557]  [<ffffffff81585b4a>] schedule+0x64/0x66
> > [ 6236.746560]  [<ffffffff811bb22e>] btrfs_wait_logged_extents+0xa4/0xdc
> > [ 6236.746561]  [<ffffffff810635c1>] ? finish_wait+0x5d/0x5d
> > [ 6236.746564]  [<ffffffff811d9489>] btrfs_sync_log+0x5ef/0x8a2
> > [ 6236.746567]  [<ffffffff811b43cf>] btrfs_sync_file+0x21b/0x24d
> > [ 6236.746569]  [<ffffffff811b43cf>] ? btrfs_sync_file+0x21b/0x24d
> > [ 6236.746571]  [<ffffffff8110db8a>] vfs_fsync_range+0x1c/0x1e
> > [ 6236.746574]  [<ffffffff810d1681>] SyS_msync+0x15d/0x1ea
> > [ 6236.746575]  [<ffffffff81588712>] system_call_fastpath+0x16/0x1b
> > 
> > THis is aptitude, but I have all the other tasks accessing the disk
> > hanging, too.
> > 
> > This time, issueing a Sysrq-s for emergency syncing did the laptop
> > out of the hang.
> > 
> > Hardware: Sonly VAIO Pro 13
> > Distribution: Debian/sid
> > self compiled kernel, config on request.
> > 
> > Please let me know if there is anything else I can provide.

Would you please try this patch?

[PATCH] Btrfs: fix abnormal long waiting in fsync
https://patchwork.kernel.org/patch/4564961/

thanks,
-liubo


> > 
> > Thanks a lot
> > 
> > Norbert
> > 
> > ------------------------------------------------------------------------
> > PREINING, Norbert                               http://www.preining.info
> > JAIST, Japan                                 TeX Live & Debian Developer
> > GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
> > ------------------------------------------------------------------------
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>       --- Normaliser unix c'est comme pasteuriser le Camembert ---       

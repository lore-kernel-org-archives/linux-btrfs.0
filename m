Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60163 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756997AbaCQRia convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 13:38:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140317161307.GJ6143@merlins.org>
Date: Mon, 17 Mar 2014 11:38:27 -0600
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <788CE3D5-5E1F-48D0-A1A9-4E7DD320BED7@colorremedies.com>
References: <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com> <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com> <20140316231729.GA29149@merlins.org> <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com> <20140317005145.GZ16946@merlins.org> <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com> <20140317011752.GV6143@merlins.org> <3592E609-7145-4F1A-8B16-EEF3C736D191@colorremedies.com> <20140317034451.GW6143@merlins.org> <B593C5F2-5CE0-428C-97FB-A75AB0B11254@colorremedies.com> <20140317161307.GJ6143@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 17, 2014, at 10:13 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> What's confusing is that mounting in degraded mode shows all devices:
> polgara:~# btrfs fi show
> Label: backupcopy  uuid: 7d8e1197-69e4-40d8-8d86-278d275af896
>        Total devices 10 FS bytes used 376.27GiB
>        devid    1 size 465.76GiB used 42.42GiB path /dev/dm-0
>        devid    2 size 465.76GiB used 42.40GiB path /dev/dm-1
>        devid    3 size 465.75GiB used 42.40GiB path /dev/mapper/crypt_sde1 << this is missing
>        devid    4 size 465.76GiB used 42.40GiB path /dev/dm-3
>        devid    5 size 465.76GiB used 42.40GiB path /dev/dm-4
>        devid    6 size 465.76GiB used 42.40GiB path /dev/dm-5
>        devid    7 size 465.76GiB used 42.40GiB path /dev/dm-6
>        devid    8 size 465.76GiB used 42.40GiB path /dev/mapper/crypt_sdj1
>        devid    9 size 465.76GiB used 42.40GiB path /dev/mapper/crypt_sdk1
>        devid    10 size 465.76GiB used 42.40GiB path /dev/dm-8

/dev/mapper/crypt_sde1 is completely unavailable, as in not listed by lsblk? If it's not connected and not listed by lsblk yet it's listed by btrfs fi show that's a bug.

> 
> eventually it turned into:
> BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 3891, rd 321927996, flush 0, corrupt 0, gen 0
> BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 3891, rd 321927997, flush 0, corrupt 0, gen 0
[snip]
> BTRFS: error (device dm-9) in __btrfs_free_extent:5755: errno=-5 IO failure
> BTRFS info (device dm-9): forced readonly
> BTRFS: error (device dm-9) in btrfs_run_delayed_refs:2713: errno=-5 IO failure

I think it's a lost cause at this point. Your setup is substantially more complicated than my simple setup, and I can't even get the simple setup to recover from an idealized single device raid5 failure. The only apparent way out is to mount degraded, backup, and then start over.

In your case it looks like at least two devices are reporting, or Btrfs thinks they're reporting, I/O errors. Whether this is the physical drive itself, or if it's some other layer (it looks like these are dmcrypt logical block devices).


Chris Murphy
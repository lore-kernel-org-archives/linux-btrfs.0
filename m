Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54049 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdIRTf7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 15:35:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1du1pe-0006Tl-Bp
        for linux-btrfs@vger.kernel.org; Mon, 18 Sep 2017 21:35:50 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1989
Date: Mon, 18 Sep 2017 21:35:47 +0200
Message-ID: <20170918213547.2c0aefd0@jupiter.sol.kaishome.de>
References: <MEXPR01MB2168C2FE0ABD1B78F120044E9E630@MEXPR01MB2168.ausprd01.prod.outlook.com>
        <20170918170930.GC6357@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
        <00c7d3be-fbff-a911-e7e0-308ebb619e64@applied-asynchrony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 18 Sep 2017 20:30:41 +0200
schrieb Holger Hoffstätte <holger@applied-asynchrony.com>:

> On 09/18/17 19:09, Liu Bo wrote:
> > This 'mirror 0' looks fishy, (as mirror comes from
> > btrfs_io_bio->mirror_num, which should be at least 1 if raid1 setup
> > is in use.)
> > 
> > Not sure if 4.13.2-gentoo made any changes on btrfs, but can you  
> 
> No, it did not; Gentoo always strives to be as close to mainline as
> possible except for urgent security & low-risk convenience fixes.

According to
https://dev.gentoo.org/~mpagano/genpatches/patches-4.13-2.htm
it's not only security patches.

But as the list shows, there are indeed no btrfs patches. But there's
one that may change btrfs behavior (tho unlikely), that is enabling
native gcc optimizations if you choose so. I don't think that's a
default option in Gentoo.

I'm using native optimizations myself and see no strange mirror issues
in btrfs. OTOH, I've lately switched to gentoo ck patchset to get
better optimizations for gaming and realtime apps. But it's still at
the 4.12 series.

Are you sure the system crashed and wasn't just stuck at reading from
the disks? If the disks have error correction and recovery enabled, the
Linux block layer times out on the requests that the drives eventually
won't fix anyways and resets the link after 30s. The drive timeout is
120s by default.

You can change that on enterprise grade and NAS-ready drives, also a
handful of desktop drives support it. Smartctl is used to set the
values, just google "smartctl scterc". You could also adjust the
timeout of the scsi layer to above the drive timeout, that means more
than 120s if you cannot change scterc. I think it makes most sense to
not reset the link before the drive had its chance to answer the
request.

I think there are pros and cons of changing these values. I always
recommend to increase the scsi timeout above the scterc timeout.
Personally, I lower the scterc timeout to 70 centisecs, and let the
scsi timeout just at its default. RAID setups should use this to get
control of their own error correction methods: The drive returns from
request early and the RAID can do its job of reading from another copy,
i.e. btrfs or mdraid, then repair it by writing back a correct copy
which the drive converts into a sector relocation aka self-repair.

Other people may jump in and recommend their own perspective of why or
why not change which knob to which value.

But well, as long as you saw no scsi errors reported when the "crash"
occurred, these values are not involved in your problem anyways.

What about "btrfs device stats"?


-- 
Regards,
Kai

Replies to list-only preferred.



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967158AbeF1TDe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:34 -0400
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
 <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
 <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b100c06f-597d-048d-50bc-ff07c829ebc9@suse.com>
Date: Thu, 28 Jun 2018 17:25:35 +0300
MIME-Version: 1.0
In-Reply-To: <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.06.2018 17:17, Christoph Anton Mitterer wrote:
> On Thu, 2018-06-28 at 22:09 +0800, Qu Wenruo wrote:
>>> [   72.168662] WARNING: CPU: 0 PID: 242 at /build/linux-
>>> uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565
>>> btrfs_update_device+0x1b2/0x1c0It
>> looks like it's the old WARN_ON() for unaligned device size.
>> Would you please verify if it is the case?
> 
> # blockdev --getsize64 /dev/sdb2 /dev/sda2
> 999131127296
> 999131127296
> 
> 
> Since getsize64 returns bytes and not sectors, I suppose it would need
> to be aligned to 1024 by the least?
> 
> 999131127296 / 1024 = 975713991,5
> 
> So it's not.
> 
> 
>> If so, "btrfs rescue fix-device-size" should handle it pretty well.
> 
> I guess this needs to be done with the fs unmounted?
> Anything to consider since I have RAID1 (except from running it on both
> devices)?
> 
> 
> Also, it's a bit strange that this error occurred never before (though
> the btrfs-restore manpage says the kernel would check for this since
> 4.11).

Was this an old FS or a fresh one? Looking at the callstack this seems
to have occured due to "btrfs_set_device_total_bytes(leaf, dev_item,
btrfs_device_get_disk_total_bytes(device));" call. Meaning the total
bytes of the disk were unalgined. Perhaps this has been like that for
quite some time, then you did a couple of kernel upgrades (this WARN_ON
was added later than 4.11) and just now you happened to delete a chunk
which would trigger a device update on-disk ?

> 
> It would further be nice if btrfs-check would warn about this.
> 
> 
> Thanks,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([188.40.36.198]:34292 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdDDECx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 00:02:53 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
From: Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
Date: Tue, 4 Apr 2017 06:02:47 +0200
MIME-Version: 1.0
In-Reply-To: <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03.04.2017 16:25, Robert Krig wrote:
>
> I'm gonna run a extensive memory check once I get home, since you
> mentioned corrupt memory might be an issue here.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I ran a memtest over a couple of hours with no errors. Ram seems to be
fine so far.

I've looked at the link you provided. Frankly it looks very scary. (At
least to me it does)
But I've just thought of something else.

My storage array is BTRFS Raid1 with 4x8TB Drives.
Wouldn't it be possible to simply disconnect two of those drives, mount
with -o degraded and still have access (even if read-only) to all my data?
E.g. I could use the two removed drives as a backup and rebuild my array
from there. Since I'm kind of playing with the idea of turning it into a
MD RAID5 and only use btrfs on specific lvm volumes which need it.

The one thing that slightly worries me with this idea is, I don't know
if there is a way to tell which datablocks are on which drives. If I've
understood btrfs raid1 correctly it simply ensures that there is at
least a copy of each block on a different device.

Would my idea work? Or could it be that I can only safely remove one
drive, since the other drives might contain blocks from any of the other
drives?

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:44363 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLUpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 15:45:54 -0500
Received: by mail-yk0-f171.google.com with SMTP id q200so3190260ykb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 12:45:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <11865500.KaKfdqacBs@zafu>
References: <11865500.KaKfdqacBs@zafu>
Date: Thu, 12 Feb 2015 13:45:53 -0700
Message-ID: <CAJCQCtRAz66sT_sKpy_JOhHnWf4ZvVMtYQyJXrMGLPx-oPDp8Q@mail.gmail.com>
Subject: Re: BTRFS RAID-1 leaf size change scenario
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 6:26 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> It also contains *lots* of subvols and snapshots.

About how many is "lots"?


> 1/ Could I first pull a disk out of the current RAID-1 config, losing redundancy
> without breaking anything else ?
>
>
> 2/ Then reset the removed HD, and create onto it a new BTRFS FS with 16K leaf
> size ?
>
> 3/ Then is there a ways I could "btrfs send | btrfs receive" a complete volume
> including its subvolumes and snapshots,or is this impossible (and would I
> rather have to create the receiving volumes structure manually, and use rsync)
> ?
>
> 4/ Once the data are copied onto the new FS, could I reset the remaining "old"
> HD, import it into the new FS and get back to a RAID-1 config, rebuilding the
> RAID with a "balance" operation ?

You could do that, however at any point in the migration a read
error/checksum mismatch could occur, and with the raid1 degraded, the
entire point of having the btrfs raid1 in the first place is defeated.

Best practices suggests acquiring a 3rd drive to migrate the data to.
Only once that's successful and confirmed, then you can obliterate one
of the old raid1 mirrors, and put the other old mirror on a shelf JUST
IN CASE. You can always mount it ro,degraded later.

When wiping one of the old mirrors, I go with some overkill by using
btrfs-show-super -a to show all superblocks, and write 1MB of zeros to
each super. Then add it to the new volume, then btrfs balance
-dconvert=raid1 -mconvert=raid1.

The problems: All of your subvolumes and snapshots. To use btrfs
send/receive on them, they each have to have a read-only version. And
you have to have a naming convention that ensures you get either the
-p or -c correct, so that you aren't unnecessarily duplicating data
during the send/receive. If you don't get it right, you either miss
migrating important data, or you'll run out of space on the
destination. The same problem applies with rsync if you want to keep
most or all of these snapshots.

The other option, is to make the raid1 volume a seed device, add two
new drives, then delete the seed drive(s). I've only ever done this
with a single device as seed, not a raid1. I don't even know if it
will work because of this, but also there still may be seed device
bugs in even recent kernels. The huge plus of this method though, is
that you don't have to make a bunch of ro snapshots first, everything
is migrated as it is on the seed. It's much easier. If it works. But
since the seed is data and metadata raid1, so will be any added
devices. So I think there isn't a way to make a raid1 a seed, where
the added device is single profile. That'd be pretty nifty if it were
possible.


>
> (Machine's kernel is an Ubuntu 3.16.0-30 with btrfs-tools 3.14.1-1)

Unless this kernel contains, at a minimum, the btrfs fixes in 3.16.2,
I would stop using it. There are also a set of fixes in 3.16.7 that
ought to be used. Since 3.16 isn't even a listed longterm or stable
kernel anymore, I suggest using 3.17.8, 3.18.3 or newer.


> Many thanks for all help / lights about if this is feasible / how to do it
> without losing my data...

I think the strategy at this point necessitates a 3rd drive. And
you're going to need to thin out the herd of subvols and snapshots you
have to something that can be manageably migrated to the new volume.
Once that's done, break one of the old mirrors to make it into a new
mirror (conversion), and put the other old mirror on a shelf in case
this whole thing goes badly. It's the only safe way.

-- 
Chris Murphy

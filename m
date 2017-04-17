Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34416 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdDQRNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 13:13:48 -0400
Received: by mail-io0-f175.google.com with SMTP id a103so160810450ioj.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 10:13:48 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Chris Murphy <lists@colorremedies.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
Date: Mon, 17 Apr 2017 13:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-17 12:58, Chris Murphy wrote:
> On Mon, Apr 17, 2017 at 5:53 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Regarding BTRFS specifically:
>> * Given my recently newfound understanding of what the 'ssd' mount option
>> actually does, I'm inclined to recommend that people who are using high-end
>> SSD's _NOT_ use it as it will heavily increase fragmentation and will likely
>> have near zero impact on actual device lifetime (but may _hurt_
>> performance).  It will still probably help with mid and low-end SSD's.
>
> What is a high end SSD these days? Built-in NVMe?
One with a good FTL in the firmware.  At minimum, the good Samsung EVO 
drives, the high quality Intel ones, and the Crucial MX series, but 
probably some others.  My choice of words here probably wasn't the best 
though.
>
>
>
>> * Files with NOCOW and filesystems with 'nodatacow' set will both hurt
>> performance for BTRFS on SSD's, and appear to reduce the lifetime of the
>> SSD.
>
> Can you elaborate. It's an interesting problem, on a small scale the
> systemd folks have journald set +C on /var/log/journal so that any new
> journals are nocow. There is an initial fallocate, but the write
> behavior is writing in the same place at the head and tail. But at the
> tail, the writes get pushed torward the middle. So the file is growing
> into its fallocated space from the tail. The header changes in the
> same location, it's an overwrite.
For a normal filesystem or BTRFS with nodatacow or NOCOW, the block gets 
rewritten in-place.  This means that cheap FTL's will rewrite that erase 
block in-place (which won't hurt performance but will impact device 
lifetime), and good ones will rewrite into a free block somewhere else 
but may not free that original block for quite some time (which is bad 
for performance but slightly better for device lifetime).

When BTRFS does a COW operation on a block however, it will guarantee 
that that block moves.  Because of this, the old location will either:
1. Be discarded by the FS itself if the 'discard' mount option is set.
2. Be caught by a scheduled call to 'fstrim'.
3. Lay dormant for at least a while.

The first case is ideal for most FTL's, because it lets them know 
immediately that that data isn't needed and the space can be reused. 
The second is close to ideal, but defers telling the FTL that the block 
is unused, which can be better on some SSD's (some have firmware that 
handles wear-leveling better in batches).  The third is not ideal, but 
is still better than what happens with NOCOW or nodatacow set.

Overall, this boils down to the fact that most FTL's get slower if they 
can't wear-level the device properly, and in-place rewrites make it 
harder for them to do proper wear-leveling.
>
> So long as this file is not reflinked or snapshot, filefrag shows a
> pile of mostly 4096 byte blocks, thousands. But as they're pretty much
> all continuous, the file fragmentation (extent count) is usually never
> higher than 12. It meanders between 1 and 12 extents for its life.
>
> Except on the system using ssd_spread mount option. That one has a
> journal file that is +C, is not being snapshot, but has over 3000
> extents per filefrag and btrfs-progs/debugfs. Really weird.
Given how the 'ssd' mount option behaves and the frequency that most 
systemd instances write to their journals, that's actually reasonably 
expected.  We look for big chunks of free space to write into and then 
align to 2M regardless of the actual size of the write, which in turn 
means that files like the systemd journal which see lots of small 
(relatively speaking) writes will have way more extents than they should 
until you defragment them.
>
> Now, systemd aside, there are databases that behave this same way
> where there's a small section contantly being overwritten, and one or
> more sections that grow the data base file from within and at the end.
> If this is made cow, the file will absolutely fragment a ton. And
> especially if the changes are mostly 4KiB block sizes that then are
> fsync'd.
>
> It's almost like we need these things to not fsync at all, and just
> rely on the filesystem commit time...
Essentially yes, but that causes all kinds of other problems.

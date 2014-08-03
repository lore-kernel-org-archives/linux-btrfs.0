Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:37923 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHCA3A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Aug 2014 20:29:00 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so4059250oag.21
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Aug 2014 17:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
Date: Sat, 2 Aug 2014 19:28:59 -0500
Message-ID: <CAKcLGm9OFmk-Fg=4tvPNr4x51zOtLM+CiYHVrKcdghXryfPKxA@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Peter Waller <peter@scraperwiki.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 2, 2014 at 6:35 PM, Peter Waller <peter@scraperwiki.com> wrote:
> Hi All,
>
> My TL;DR questions are at the bottom, before the stack trace.
>
> I'm running Ubuntu 14.04. I wonder if this problem is related to the
> thread titled "Machine lockup due to btrfs-transaction on AWS EC2
> Ubuntu 14.04" which I started on the 29th of July:
>
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/37224
>
> Kernel: 3.15.7-031507-generic
>
> I'm on a single block device system, i.e, no RAID.
>
> I was observing ENOSPC from `mkdir` and `rename` on this system, with
> a good amount of free disk space (df -h reports 62 GB remain). I added
> enospc_debug (full umount/mount, not just mount -o remount), but this
> had no apparent effect when receiving ENOSPC from userland.
>
> $ sudo btrfs fi df /path/to/volume
> Data, single: total=489.97GiB, used=427.75GiB
> System, DUP: total=8.00MiB, used=60.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=5.00GiB, used=4.50GiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=512.00MiB, used=820.00KiB
>
> After a thorough search of the internet for ENOSPC BTRFS I found
> various resources and came to understand a little bit more. One thing
> which broke my intuition severely is that I expected if there is a
> large number of free GiB, I should expect things to continue to work.
>
> In this case, for example, metadata has 0.5GiB free ("sounds like
> plenty for metadata for one mkdir to me"). Data has 62GiB free. Why
> would I get ENOSPC for a file rename?
>
> I expected that if metadata needed more space, it would just eat it
> from the 'data'. Now I believe this not to be the case and that it
> wanted to allocate > 0.5GiB, and this is why I was getting ENOSPC.
>
> I tried a rebalance with btrfs balance start -dusage=10 and tried
> increasing the value until I saw reallocations in dmesg.
>
> This spat out a large number of messages in dmesg, of this form:
>
>> [376096.546353] BTRFS info (device dm-0): relocating block group 530457821184 flags 1
>> [376010.736879] BTRFS info (device dm-0): 40 enospc errors during balance
>
> (and a full stack trace at the end of this message).
>
> The rebalance printed:
>
>> ERROR: error during balancing '/path/to/volume' - No space left on device
>> There may be more info in syslog - try dmesg | tail
>
> Eventually, not knowing what else to do I had to take my escape hatch
> and enlarge the volume. When I did this, metadata grew by 1GiB:
>
>> Data, single: total=490.97GiB, used=427.75GiB
>> System, DUP: total=8.00MiB, used=60.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=5.50GiB, used=4.50GiB
>> Metadata, single: total=8.00MiB, used=0.00
>> unknown, single: total=512.00MiB, used=0.00
>
> A few questions:
>
> * Why didn't the metadata grow before enlarging the disk?
> * Why didn't the rebalance enable the metadata to grow?
> * Why is it necessary to rebalance? Can't it automatically take some
> free space from 'data'?
> * Are my machine lockups related to the fact I was low on space?
> * Can we improve the documentation/FAQ for this? I was scratching my
> head in particular because my notion of free space definitely does not
> match up with BTRFS', and I didn't find the FAQ very helpful for
> getting out of this mess.
> * It isn't documented on the wiki what enospc_debug is supposed to do,
> so I couldn't tell whether I should have expected it to tell me
> anything in my circumstances.
> * What is the best course of action to take (other than enlarging the
> disk or deleting files) if I encounter this situation again?
>

Looking at this line:

> Data, single: total=489.97GiB, used=427.75GiB

I see that btrfs has allocated almost the entire disk to Data, and it
appears you are starved for Metadata room.

Once btrfs allocates space for either Data or Metadata, there are
currently no build-in kernel mechanisms re-allocate that space.  We
have to use the userland balance tools.

I agree that this behavior can become a "gotcha".  Btrfs has the
capability to run in a mode where Data and Metadata are combined, but
there is a speed penalty running in Mixed Data/Metadata mode.

The btrfs balance tools have to ability to use filters to run a
quicker pass on just the mostly-empty blocks, skipping a full balance.

https://btrfs.wiki.kernel.org/index.php/Balance_Filters

I would suggest this as the next step.

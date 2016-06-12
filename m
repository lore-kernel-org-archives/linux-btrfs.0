Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34721 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcFLTDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 15:03:24 -0400
Received: by mail-vk0-f48.google.com with SMTP id t129so27136729vka.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 12:03:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0426BC4B-1E70-4988-94FC-8D56EEBD0796@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
 <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net> <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
 <CAPmG0jYrstbaBkL98YrwQk4CXxmBOo4nXd=waAJ9tXGc_WpTag@mail.gmail.com> <0426BC4B-1E70-4988-94FC-8D56EEBD0796@bueechi.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 12 Jun 2016 21:03:22 +0200
Message-ID: <CAPmG0jYTd0a3NfzAXSGCBkMxZNQQ0pE+U_bmd3ks4x0OAWL6Rw@mail.gmail.com>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
To: boli <btrfs@bueechi.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 7:03 PM, boli <btrfs@bueechi.net> wrote:
>>> It's done now, and took close to 99 hours to rebalance 8.1 TB of data from a 4x6TB raid1 (12 TB capacity) with 1 drive missing onto the remaining 3x6TB raid1 (9 TB capacity).
>>
>> Indeed, it not clear why it takes 4 days for such an action. You
>> indicated that you cannot add an online 5th drive, so then you and
>> intermediate compaction of the fs to less drives is a way to handle
>> this issue. There are 2 ways however:
>>
>> 1) Keeping the to-be-replaced drive online until a btrfs dev remove of
>> it from the fs of it is finished and only then replace a 6TB with an
>> 8TB in the drivebay. So in this case, one needs enough free capacity
>> on the fs (which you had) and full btrfs raid1 redundancy is there all
>> the time.
>>
>> 2) Take a 6TB out of the drivebay first and then do the btrfs dev
>> remove, in this case on a really missing disk. This way, the fs is in
>> degraded mode (or mounted as such) and the action of remove missing is
>> also a sort of 'reconstruction'. I don't know the details of the code,
>> but I can imagine that it has performance implications.
>
> Thanks for reminding me about option 1). So in summary, without temporarily adding an additional drive, there are 3 ways to replace a drive:
>
> 1) Logically removing old drive (triggers 1st rebalance), physically removing it, then adding new drive physically and logically (triggers 2nd rebalance)
>
> 2) Physically removing old drive, mounting degraded, logically removing it (triggers 1st rebalance, while degraded), then adding new drive physically and logically (2nd rebalance)
>
> 3) Physically replacing old with new drive, mounting degraded, then logically replacing old with new drive (triggers rebalance while degraded)
>
>
> I did option 2, which seems to be the worst of the three, as there was no redundancy for a couple days, and 2 rebalances are needed, which potentially take a long time.
>
> Option 1 also has 2 rebalances, but redundancy is always maintained.
>
> Option 3 needs just 1 rebalance, but (like option 1) does not maintain redundancy at all times.
>
> That's where an extra drive bay would come in handy, allowing to maintain redundancy while still just needing one "rebalance"? Question mark because you mentioned "highspeed data transfer" rather than "rebalance" when doing a btrfs-replace, which sounds very efficient (in case of -r option these transfers would be from multiple drives).

I haven't used -r with replace other then for testing purposes inside
virtual machines. I think the '..transfers would be from multiple
drives...' might not be a speed advantage with the current state of
the code. If the drives are still healthy and the replace purpose is
capacity increase, my experience is that without the -r option (and
using an extra SATA port), the transfer is mostly at the drives max
magnetic media transferspeed. Also for cases like if you want to add
LUKS or bcache headers in front of the blockdevice that hosts the
fs/devid1 data.

But now that you anyhow have all data on 3x 6TB drives, you could save
balancing time by just doing btrfs-replace 6TB to 8TB 3x and then for
the 4th 8TB just add it and let btrfs do the spreading/balancing over
time by itself.

> The man page mentioned that the replacement drive needs to be at least as large as the original, which makes me wonder if it's still a "highspeed data transfer" if the new drive is larger, or if it does a rebalance in that case. If not then that'd be pretty much what I'm looking for. More on that below.
>
>>> If the goal is to replace 4x 6TB drive (raid1) with 4x 8TB drive (still raid1), is there a way to remove one 6 TB drive at a time, recreate its exact contents from the other 3 drives onto a new 8 TB drive, without doing a full rebalance? That is: without writing any substantial amount of data onto the remaining 3 drives.
>>
>> There isn't such a way. This goal has a violation in itself with
>> respect to redundancy (btrfs raid1).
>
> True, it would be "hack" to minimize the amount of data to rebalance (thus saving time), with the (significant) downside of not maintaining redundancy at all times.
> Personally I'd probably be willing to take the risk, since I have a few other copies of this data.
>
>> man btrfs-replace and option -r I would say. But still, having a 5th
>> drive online available makes things much easier and faster and solid
>> and is the way to do a drive replace. You can then do a normal replace
>> and there is just highspeed data transfer for the old and the new disk
>> and only for parts/blocks of the disk that contain filedata. So it is
>> not a sector-by-sector copying also deleted blocks, but from end-user
>> perspective is an exact copy. There are patches ('hot spare') that
>> assume it to be this way, but they aren't in the mainline kernel yet.
>
> Hmm, so maybe I should think about using an USB enclosure to temporarily add a 5th drive.
> Being a bit wary about an external USB enclosure, I'd probably try to minimize transfers from/to the USB enclosure.
>
> Say by putting the old (to-be-replaced) drive into the USB enclosure, the new drive into the internal drive bay where the old drive used to be, and then do a btrfs-replace with -r option to minimize reads from USB.
>
> Or put one of the *other* disks into the USB enclosure (neither the old nor its new replacement drive), and doing a btrfs-replace without -r option.

Yes USB would also not be my preferred choice. I have had chipset and
sectors lost issues. If I have some SATA free (external or on the
motherboard), I'd rather use that. but if it is all remote, other
factors might be more important.


>> The btrfs-replace should work ok for btrfs raid1 fs (at least it
>> worked ok for btrfs raid10 half a year ago I can confirm), if the fs
>> is mostly idle during the replace (almost no new files added).
>
> That's good to read. The fs will be idle during the replace.
>
>> Still, you might want to have the replace related fixes added in kernel
>> 4.7-rc2.
>
> Hmm, since I'm on Fedora with kernel 4.5.5 (or 4.5.6 after most recent upgrades, which this box didn't get yet), I guess waiting for kernel 4.7 is not very practical, and replacing the kernel is outside my comfort zone/knowledge for know.
>
> Anyway, thanks for your helpful reply!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

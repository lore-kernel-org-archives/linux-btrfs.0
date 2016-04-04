Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33029 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcDDXJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 19:09:15 -0400
Received: by mail-io0-f171.google.com with SMTP id a129so159106119ioe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 16:09:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160404225018.150988d2@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
	<20160404213637.58ad33b1@jupiter.sol.kaishome.de>
	<CAJCQCtQdGG3o9mu2u=Vjc0rN+0eLWYVXikH5KtfOap2SijjSKA@mail.gmail.com>
	<20160404225018.150988d2@jupiter.sol.kaishome.de>
Date: Mon, 4 Apr 2016 17:09:14 -0600
Message-ID: <CAJCQCtSVHwx=xwzv29sYVEdQ5Y=vOjT-26iagiqbWU5mXyGkZw@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 2:50 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

>> Anyway the 2nd 4 is not possible. The seed is ro by definition so you
>> can't remove snapshots from the seed. If you remove them from the
>> mounted rw sprout volume, they're removed from the sprout, not the
>> seed. If you want them on the sprout, but not on the seed, you need to
>> delete snapshots only after the seed is a.) removed from the sprout
>> and b.) made no longer a seed with btrfstune -S 0 and c.) mounted rw.
>
> If I understand right, the seed device won't change? So whatever action
> I apply to the sprout pool, I can later remove the seed from the pool
> and it will still be kind of untouched. Except, I'll have to return it
> no non-seed mode (step b).

Correct. In a sense, making a volume a seed is like making it a
volume-wide read-only snapshot. Any changes are applied via COW only
to added device(s).

>
> Why couldn't/shouldn't I remove snapshots before detaching the seed
> device? I want to keep them on the seed but they are useless to me on
> the sprout.

You can remove snapshots before or after detaching the seed device, it
doesn't matter, but such snapshot removal only affects the sprout. You
wrote:

"remove all left-over snapshots from the seed"

The seed is read only, you can't modify the contents of the seed device.

What you should do is just delete the snapshots you don't want
migrated over to the sprout right away before you even do the balance
-dconvert -mconvert. That way you aren't wasting time moving things
over that you don't want. To be clear:

btrfstune -S 0
mount /dev/seed /mnt/
btrfs dev add /dev/new1
btrfs dev add /dev/new2
mount -o remount,rw /mnt/
btrfs sub del blah/ blah2/ blah3/ blah4/
btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/
btrfs dev del /dev/seed /mnt/

If you're doing any backsup once remounting rw, note those backups
will only be on the sprout. Backups will not be on the seed because
it's read-only.


>
> What happens to the UUIDs when I separate seed and sprout?

Nothing. They remain intact and unique, per volume.




>
> I'd now reboot into the system to see if it's working.

Note you'll need to change grub.cfg, possibly fstab, and possibly the
initramfs, all three of which may be referencing the old volume.


> By then, it's
> time for some cleanup (remove the previously deferred "trashes" and
> retention snapshots), then separate the seed from the sprout. During
> that time, I could already use my system again while it's migrating for
> me in the background.
>
> I'd then return the seed back to non-seed, so it can take the role of
> my backup storage again. I'd do a rebalance now.

OK? I don't know why you need to balance the seed at all, let alone
afterward, but it seems like it might be a more efficient replication
if you balanced before making it a seed?


>
> During the whole process, the backup storage will still stay safe for
> me. If something goes wrong, I could easily start over.
>
> Did I miss something? Is it too much of an experimental kind of stuff?

I'm not sure where all the bugs are. It's good to find bugs though and
get them squashed. I have an idea of making live media use Btrfs
instead of using a loop mounted file to back a rw lvm snapshot device
(persistent overlay), which I think is really fragile and a lot more
complicated in the initramfs. It's also good to take advantage of
checksumming after having written an ISO to flash media, where users
often don't verify or something can mount the USB stick rw and
immediately modify the stick in such a way that media verification
will fail anyway. So, a number of plusses, I'd like to see the seed
device be robust.


>
> BTW: The way it is arranged now, the backup storage is bootable by
> setting the scratch area subvolume as the rootfs on kernel cmdline,
> USB drivers are included in the kernel, it's tested and works. I guess,
> this isn't possible while the backup storage acts as a seed device? But
> I have an initrd with latest btrfs-progs on my boot device (which is an
> UEFI ESP, so not related to btrfs at all), I should be able to use that
> to revert changes preventing me from booting.



-- 
Chris Murphy

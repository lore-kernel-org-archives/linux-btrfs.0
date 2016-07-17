Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33583 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbcGQUKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 16:10:11 -0400
Received: by mail-vk0-f44.google.com with SMTP id x130so215984056vkc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 13:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <91da7783-ffa1-7d35-a364-344c61e7ddbe@matthiasprager.de>
References: <91da7783-ffa1-7d35-a364-344c61e7ddbe@matthiasprager.de>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 17 Jul 2016 22:10:08 +0200
Message-ID: <CAPmG0jb+FMOMNWhsOhE1gzsry_x862pjSO_wV8_PFbyaBoEmUg@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 17, 2016 at 10:26 AM, Matthias Prager
<linux@matthiasprager.de> wrote:

> from my experience btrfs does work as badly with SMR drives (I only had
> the opportunity to test on a 8TB Seagate device-managed drive) as ext4.
> The initial performance is fine (for a few gigabytes / minutes), but
> drops of a cliff as soon as the internal buffer-region for
> non-sequential writes fills up (even though I tested large file SMB
> transfers).

What kernel (version) did you use ?
I hope it included:
http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=bugzilla-93581&id=7c4fbd50bfece00abf529bc96ac989dd2bb83ca4

so >= 4.4, as without this patch, it is quite problematic, if not
impossible, to use this 8TB Seagate SMR drive with linux without doing
other patches or setting/module changes.

Since this patch, I have been using the drive for cold storage
archiving, connected to a Baytrail SoC SATA port. I use bcache
(writethrough or writearound) on an 8TB GPT partition that has a LUKS
container that is Btrfs m-dup, d-single formatted and mounted
compress=lzo,noatine,nossd. It is only powered on once a month for a
day or so and then it receives incremental snapshots mostly or some
SSD or flash images of 10-50G.
I have more or less kept all the snapshots sofar, so chunks keep being
added to previously unwritten space, so as sequential as possible.

If free space would be heavily fragmented and also files would be
heavily fragmented and the disk would be very full, adding new files
or modifying would be very slow. You see than many seconds that the
drive is active but no traffic on the SATA link. Also then there is
the risk that the default '/sys/block/$(kerneldevname)/device/timeout'
of 30 secs is too low, and that the kernel might reset the SATA link.
A SATA link still happened 2x the last 1/2 year, I haven't really
looked at the details sofar, just rebooted at some point in time
later, but I will set the timeout at least higher, e.g. 180, and then
see if ata errors/resets still occur. It might be FW crashes as well.

> The only file system that worked really well with the 8TB Seagate SMR
> drive was f2fs. I used 'mkfs.f2fs -o 0 -a 0 -s 9 /dev/sdx' to create one
> and mounted it with noatime. -o means no additional over provisioning
> (the 5% default is a lot of wasted space on a 8TB drive), -a 0 tells
> f2fs not to use separate areas on the disks at the same time (which does
> not perform well on hdds only on ssds) and finally -s 9 tells f2fs to
> layout the file system in 1GB chunks.
> I hammered this file system for some days (via SMB and via shred-script)
> and it worked really well (performance and stability wise).

Interesting that f2fs works well, although now thinking a bit, I am
not so surprised that it works better than ext4

> I am considering using SMR drives for the next upgrades in my storage
> server in the basement - the only things missing in f2fs are checksums
> and raid1 support. But in my current setup (md-raid1+ext4) I don't get
> checksums either so f2fs+smr is still on my road-map. Long term, I would
> really like to switch to btrfs with it's built-in check summing (which
> unfortunately does not work with NOCOW) and raid1. But some of the file
> systems are almost 100% filled and I'm not trusting btrfs's stability
> yet (and the manageability / handling of btrfs lacks behind compared to
> say zfs).

At least this SMR drive is not advised to use in raid setups. As
not-so-active array it might work if you use the right timeouts and
scterc etc, but if have seen how long the wait on the SATA link can be
and that makes me realize that the stamp 'Archive Drive' done by
Seagate has a clear reason.

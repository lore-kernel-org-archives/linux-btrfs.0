Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34523 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcF2EZe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 00:25:34 -0400
Received: by mail-ob0-f176.google.com with SMTP id ru5so9468300obc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 21:25:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160629005208.5e9addcf@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system> <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Jun 2016 22:25:32 -0600
Message-ID: <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 4:52 PM, Saint Germain <saintger@gmail.com> wrote:

> Well I made a ddrescue image of both drives (only one error on sdb
> during ddrescue copy) and started the computer again (after
> disconnecting the old drives).

What was the error? Any kernel message at the time of this error?



> I don't know if I should continue trying to repair this RAID1 or if I
> should just cp/rsync to a new BTRFS volume and get done with it.

Well for sure already you should prepare to lose this volume, so
whatever backup you need, do that yesterday.

> On the other hand it seems interesting to repair instead of just giving
> up. It gives a good look at BTRFS resiliency/reliability.

On the one hand Btrfs shouldn't become inconsistent in the first
place, that's the design goal. On the other hand, I'm finding from the
problems reported on the list that Btrfs increasingly mounts at least
read only and allows getting data off, even when the file system isn't
fully functional or repairable.

In your case, once there are metadata problems even with raid 1, it's
difficult at best. But once you have the backup you could try some
other things once it's certain the hardware isn't adding to the
problems, which I'm still not yet certain of.



>
> Here is the log from the mount to the scrub aborting and the result
> from smartctl.
>
> Thanks for your precious help so far.
>
>
> BTRFS error (device sdb1): cleaner transaction attach returned -30

Not sure what this is. The Btrfs cleaner is used to remove snapshots,
decrement extent reference count, and if the count is 0, then free up
that space. So, why is it running? I don't know what -30 means.


> BTRFS info (device sdb1): disk space caching is enabled
> BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714507, gen 1335
> BTRFS info (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21622, gen 24

I missed something the first time around in these messages: the
generation error. Both drives have generation errors. A generation
error on a single drive means that drive was not successfully being
written to or was missing. For it to happen on both drives is bad. If
it happens to just one drive, once it's reappears it will be passively
caught up to the other one as reads happen, but best practice for now
requires the user to run scrub or balance. If that doesn't happen and
a 2nd drive vanishes or has write errors that cause generation
mismatches, now both drives are simultaneously behind and ahead of
each other. Some commits went to one drive, some went to the other.
And right now Btrfs totally flips out and will irreparably get
corrupted.

So I have to ask if this volume was ever mounted degraded? If not you
really need to look at logs and find out why the drives weren't being
written to. sdb show lots of write, flush, corruption and generation
errors, so it seems like it was having a hardware issue. But then sda
has only corruptions and generation problems, as if it wasn't even
connected or powered on.

OR another possibility is one of the drives was previously cloned
(block copied), or snapshot via LVM and you ran into the block level
copies gotcha:
https://btrfs.wiki.kernel.org/index.php/Gotchas



> BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sdb1, sector 54528696, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)

Some extent data and its checksum don't match, on sdb. So this file is
considered corrupt. Maybe the data is OK and the checksum is wrong?

> btrfs_dev_stat_print_on_error: 164 callbacks suppressed
> BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714508, gen 1335
> scrub_handle_errored_block: 164 callbacks suppressed
> BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sdb1

And it can't be fixed, because...

> BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)


The same block on sda also doesn't match checksum. So either both
checksums are wrong, or both datas are wrong.

You can make these errors "go away" by using btrfs check --repair
--init-csum-tree but what this does it it will totally paper over any
real corruptions. You will have no idea if they're really corrupt or
not without checking them. Looks like most of the messages have to do
with files, not metadata although I didn't look at every single line.

I think the generations between the two drives is too far off for them
to be put back together again. But if the --init-csum-tree starts to
clean up the data related errors, you could use rsync -c to compare
the files to a backup and see if they are the same and further inspect
to see if they're corrupt or not.

You definitely don't want corrupt files propagating into your future
backups. That's bad news.



-- 
Chris Murphy

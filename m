Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35160 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbdHGCPr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 22:15:47 -0400
Received: by mail-wm0-f42.google.com with SMTP id m85so57386158wma.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 19:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 6 Aug 2017 20:15:45 -0600
Message-ID: <CAJCQCtTbWQvG2g-bXsQ05i5LXL36Pcrd_45YdRwOY95ygXaX8g@mail.gmail.com>
Subject: Re: Power down tests...
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 3, 2017 at 11:51 PM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> Hi all,
>
> We're running a couple of experiments on our servers with btrfs
> (kernel version 4.4).
> And we're running some abrupt power-off tests for a couple of scenarios:
>
> 1. We have a filesystem on top of two different btrfs filesystems
> (distributed across N disks). i.e. Our filesystem lays out data and
> metadata on top of these two filesystems.

This is astronomically more complicated than the already complicated
scenario with one file system on a single normal partition of a well
behaved (non-lying) single drive.

You have multiple devices, so any one or all of them could drop data
during the power failure and in different amounts. In the best case
scenario, at next mount the supers are checked on all the devices, and
the lowest common denominator generation is found, and therefore the
lowest common denominator root tree. No matter what it means some data
is going to be lost.

Next there is a file system on top of a file system, I assume it's a
file that's loopback mounted?

>With the test workload, it
> is going to generate a good amount of 16MB files on top of the system.
> On abrupt power-off and following reboot, what is the recommended
> steps to be run. We're attempting btrfs mount, which seems to fail
> sometimes. If it fails, we run a fsck and then mount the btrfs.

I'd want to know why it fails. And then I'd check all the supers on
all the devices  with 'btrfs inspect-internal dump-super -fa <dev>'.

Are all the copies on a given device the same and valid? Are all the
copies among all devices the same and valid? I'm expecting there will
be discrepancies and then you have to figure out if the mount logic is
really finding the right root to try to mount. I'm not sure if kernel
code by default reports back in detail what logic its using and
exactly where it fails, or if you just get the generic open_ctree
mount failure message.

And then it's an open question whether the supers need fixing, or
whether the 'usebackuproot' mount option is the way to go. It might
depend on the status of the supers how that logic ends up working.
Again, it might be useful if there were debug info that explicitly
shows the mount logic actually being used, dumped to kernel messages.
I'm not sure if that code exists when CONFIG_BTRFS_DEBUG is enabled
(as in, I haven't looked but I've thought it really could come in
handy in some of the cases we see of mount failure can can't tell
where things are getting stuck with the existing reporting).



>The
> issue that we're facing is that a few files have been zero-sized.

I can't tell you if that's a bug or not because I'm not sure how your
software creates these 16M backing files, if they're fallocated or
touched or what. It's plausible they're created as zero length files,
and the file system successful creates them, and then data is written
to them, but before there is either committed metadata or an updated
super pointing to the new root tree you get a power failure. And in
that case, I expect a zero length file or maybe some partial amount of
data is there.


>As a
> result, there is either a data-loss, or inconsistency in the stacked
> filesystem's metadata.

Sounds expected for any file system, but chances are there's more
missing with a CoW file system since by nature it rolls back to the
most recent sane checkpoint for the fs metadata without any regard to
what data is lost to make that happen. The goal is to not lose the
file system in such a case, as some amount of data is always going to
happen, and why power losses need to be avoided (UPS's and such). The
fact that you have a file system on top of a file system makes it more
fragile because the 2nd file system's metadata *IS* data as far as the
1st file system is concerned. And that data is considered expendable.


> We're mounting the btrfs with commit period of 5s. However, I do
> expect btrfs to journal the I/Os that are still dirty. Why then are we
> seeing the above behaviour.

commit 5s might make the problem worse by requiring such constant
flushing of dirty data that you're getting a bunch of disk contention,
hard to say since there's no details about the workload at the time of
the power failure. Changing nothing else but but commit= mount option,
what difference do you see (with a scientific sample) if any between
commit 5 and default commit 30 when it comes to the amount of data
loss?

Another thing we don't know is the application or service writing out
these 16M backing files behavior when it comes to fsync or fdatasync
or fadvise.



-- 
Chris Murphy

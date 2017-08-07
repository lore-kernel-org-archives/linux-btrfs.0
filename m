Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33995 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbdHGGxO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 02:53:14 -0400
Received: by mail-oi0-f41.google.com with SMTP id x3so58105315oia.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 23:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTbWQvG2g-bXsQ05i5LXL36Pcrd_45YdRwOY95ygXaX8g@mail.gmail.com>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <CAJCQCtTbWQvG2g-bXsQ05i5LXL36Pcrd_45YdRwOY95ygXaX8g@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 7 Aug 2017 12:23:13 +0530
Message-ID: <CANT5p=ri+35DjzCPzMfy1Gi6bBx+O=8QLVMNW9kX-fkXbd442Q@mail.gmail.com>
Subject: Re: Power down tests...
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for the detailed reply. :)
Read my answers inline:

On Mon, Aug 7, 2017 at 7:45 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> This is astronomically more complicated than the already complicated
> scenario with one file system on a single normal partition of a well
> behaved (non-lying) single drive.
>
> You have multiple devices, so any one or all of them could drop data
> during the power failure and in different amounts. In the best case
> scenario, at next mount the supers are checked on all the devices, and
> the lowest common denominator generation is found, and therefore the
> lowest common denominator root tree. No matter what it means some data
> is going to be lost.

True. This is something that we're experimenting with, since we can
use many btrfs features. Except for these power off issues, we didn't
face many other issues.

>
> Next there is a file system on top of a file system, I assume it's a
> file that's loopback mounted?
>

Not exactly loopback mounted. We are, however, distributing the data
and metadata across different btrfs files and reading them to present
a filesystem view to the client.

>
> I'd want to know why it fails. And then I'd check all the supers on
> all the devices  with 'btrfs inspect-internal dump-super -fa <dev>'.
>
> Are all the copies on a given device the same and valid? Are all the
> copies among all devices the same and valid? I'm expecting there will
> be discrepancies and then you have to figure out if the mount logic is
> really finding the right root to try to mount. I'm not sure if kernel
> code by default reports back in detail what logic its using and
> exactly where it fails, or if you just get the generic open_ctree
> mount failure message.
>
> And then it's an open question whether the supers need fixing, or
> whether the 'usebackuproot' mount option is the way to go. It might
> depend on the status of the supers how that logic ends up working.
> Again, it might be useful if there were debug info that explicitly
> shows the mount logic actually being used, dumped to kernel messages.
> I'm not sure if that code exists when CONFIG_BTRFS_DEBUG is enabled
> (as in, I haven't looked but I've thought it really could come in
> handy in some of the cases we see of mount failure can can't tell
> where things are getting stuck with the existing reporting).
>

Unfortunately, we don't have these data now, since we've started a
fresh batch of similar tests with a couple of new mount options (-o
flushoncommit,recovery). If we hit the issue again, I'll share the
data here.

>
> I can't tell you if that's a bug or not because I'm not sure how your
> software creates these 16M backing files, if they're fallocated or
> touched or what. It's plausible they're created as zero length files,
> and the file system successful creates them, and then data is written
> to them, but before there is either committed metadata or an updated
> super pointing to the new root tree you get a power failure. And in
> that case, I expect a zero length file or maybe some partial amount of
> data is there.
>

The files are first touched, then truncated to 16M, before being written to.
So, it does makes sense then that on recovery, we ended up with
zero-sized files. Btrfs could be showing us a consistent older
filesystem, rather than inconsistent newer one.

>
> Sounds expected for any file system, but chances are there's more
> missing with a CoW file system since by nature it rolls back to the
> most recent sane checkpoint for the fs metadata without any regard to
> what data is lost to make that happen. The goal is to not lose the
> file system in such a case, as some amount of data is always going to
> happen, and why power losses need to be avoided (UPS's and such). The
> fact that you have a file system on top of a file system makes it more
> fragile because the 2nd file system's metadata *IS* data as far as the
> 1st file system is concerned. And that data is considered expendable.
>

Yes, you're right. that is a downside when we stack one FS on top of
another. As long as we minimize the scope of seeing filesystem
inconsistencies, we should be okay. Even if the data is slightly
older.
We were using ext4 for the same purpose with good results on power off
and recovery. With flushoncommit, hopefully, we should see better
results on btrfs as well. Let's see.

>
> commit 5s might make the problem worse by requiring such constant
> flushing of dirty data that you're getting a bunch of disk contention,
> hard to say since there's no details about the workload at the time of
> the power failure. Changing nothing else but but commit= mount option,
> what difference do you see (with a scientific sample) if any between
> commit 5 and default commit 30 when it comes to the amount of data
> loss?

We're not choking the disk with the workload now, if that is what
you're asking. The disks can take a lot more load.

>
> Another thing we don't know is the application or service writing out
> these 16M backing files behavior when it comes to fsync or fdatasync
> or fadvise.

Yeah. That is something we've considered. Strictly speaking, we should
fsync the files in our test scripts.
However, in this one case of zero-sized file, the stacked filesystem
says that the file should be non-zero sized. So the I/O was not lost
in the client cache.

>
>
>
> --
> Chris Murphy



-- 
-Shyam

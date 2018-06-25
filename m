Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56470 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933424AbeFYQq5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 12:46:57 -0400
Date: Mon, 25 Jun 2018 09:46:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20180625164652.6n5vvn6mthguhx2k@merlins.org>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
 <20180619154730.fblylttw2nyps4cp@merlins.org>
 <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
 <ab17f789-d475-9812-9c76-83702fc2bd65@gmail.com>
 <20180625160706.qnd22zgdv2kwq6dz@merlins.org>
 <58d9fd8d-48b9-669f-05f1-82da9ce0c510@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <58d9fd8d-48b9-669f-05f1-82da9ce0c510@mendix.com>
Subject: Re: btrfs balance did not progress after 12H, hang on reboot, btrfs
 check --repair kills the system still
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 06:24:37PM +0200, Hans van Kranenburg wrote:
> >> output hasn't changed for over 36 hours, unless you've got an insanely slow
> >> storage array, that's extremely unusual (it should only be moving at most
> >> 3GB of data per chunk)).
> > 
> > I didn't hear from any developer, so I had to continue.
> > - btrfs scrub cancel did not work (hang)
> 
> Did you mean balance cancel? It waits until the current block group is
> finished.
 
Yes, I meant that, thanks for correcting me.  And you're correct that
because it was hung, cancel wasn't going to go anywhere.
At least my filesystem was still working at the time (as in IO was going
on just fine)

> > - at reboot mounting the filesystem hung, even with 4.17, which is
> >   disappointing (it should not hang)
> > - mount -o recovery still hung
> > - mount -o ro did not hang though
> > 
> > Sigh, why is my FS corrupted again?
> 
> Again? Do you think balance is corrupting the filesystem? Or have there
> been previous btrfs check --repair operations which made smaller
> problems bigger in the past?

Honestly, I don't fully remember at this point, I keep notes, but not
detailled enough and it's been a little while.
I know I've had to delete/recreate this filesystem twice already over
the last years, but I'm not fully certain I remember when this one was
last wiped.
Yes, I do run balance along with scrub once a month:

    btrfs balance start -musage=0 -v $mountpoint 2>&1 | grep -Ev "$FILTER"
    # After metadata, let's do data:
    btrfs balance start -dusage=0 -v $mountpoint 2>&1 | grep -Ev "$FILTER"
    btrfs balance start -dusage=20 -v $mountpoint 2>&1 | grep -Ev "$FILTER"
    echo btrfs scrub start -Bd $mountpoint
    ionice -c 3 nice -10 btrfs scrub start -Bd $mountpoint

Hard to say if balance has damaged my filesystem over time, but it's
definitely possible.

> Am I right to interpret the messages below, and see that you have
> extents that are referenced hundreds of times?
 
I'm not certain, but it's a backup server with many blocks that are the same, so it 
could be some COW stuff, even if I didn't run any dedupe commands myself.

> Is there heavy snapshotting or deduping going on in this filesystem? If
> so, it's not surprising balance will get a hard time moving extents
> around, since it has to update all of the metadata for each extent again
> in hundreds of places.

There is some snapshotting, but maybe around 20 or so per subvolume, not hundreds.

> Did you investigate what balance was doing if it takes long? Is is using
> cpu all the time, or is it reading from disk slowly (random reads) or is
> it writing to disk all the time at full speed?

I couldn't see what it was doing, but it's running in the kernel, is it not?
(or can you just strace the user space command?)
Either way, it's too late for that now, and given that it didn't make progress of
a single block in 36H, I'm assuming it was well deadlocked.

Thanks for the reply.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

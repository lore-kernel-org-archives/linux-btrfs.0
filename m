Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38074 "EHLO
	mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbcHOMcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 08:32:24 -0400
Received: by mail-it0-f53.google.com with SMTP id n128so5889798ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 05:32:23 -0700 (PDT)
Subject: Re: Huge load on btrfs subvolume delete
To: Daniel Caillibaud <ml@lairdutemps.org>, linux-btrfs@vger.kernel.org
References: <20160815123928.47bd2c03@asus17.lairdutemps.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <95c98a1b-4484-c294-fcd6-001e73cd25d6@gmail.com>
Date: Mon, 15 Aug 2016 08:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <20160815123928.47bd2c03@asus17.lairdutemps.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 06:39, Daniel Caillibaud wrote:
> Hi,
>
> I'm newbie with btrfs, and I have pb with high load after each btrfs subvolume delete
>
> I use snapshots on lxc hosts under debian jessie with
> - kernel 4.6.0-0.bpo.1-amd64
> - btrfs-progs 4.6.1-1~bpo8
>
> For backup, I have each day, for each subvolume
>
> btrfs subvolume snapshot -r $subvol $snap
> # then later
> ionice -c3 btrfs subvolume delete $snap
>
> but ionice doesn't seems to have any effect here and after a few minutes the load grows up
> quite high (30~40), and I don't know how to make this deletion nicer with I/O
Before I start explaining possible solutions, it helps to explain what's 
actually happening here.  When you create a snapshot, BTRFS just scans 
down the tree for the subvolume in question and creates new references 
to everything in that subvolume in a separate tree.  This is usually 
insanely fast because all that needs to be done is updating metadata. 
When you delete a snapshot however, it has to remove any remaining 
references within the snapshot to the parent subvolume, and also has to 
process any changed data that is now different from the parent subvolume 
for deletion just like it would for deleting a file.  As a result of 
this, the work to create a snapshot only depends on the complexity of 
the directory structure within the subvolume, while the work to delete 
it depends on both that and how much the snapshot has changed from the 
parent subvolume.

The spike in load your seeing is the filesystem handling all that 
internal accounting in the background, and I'd be willing to bet that it 
varies based on how fast things are changing in the parent subvolume. 
Setting idle I/O scheduling priority on the command to delete the 
snapshot does nothing because all that command does is tell the kernel 
to delete the snapshot, the actual deletion is handled in the filesystem 
driver.  While it won't help with the spike in load, you probably want 
to add `--commit-after` to that subvolume deletion command.  That will 
cause the spike to happen almost immediately, and the command won't 
return until the filesystem is finished with the accounting and thus the 
load should be back to normal when it returns.
>
> Is there a better way to do so ?
While there isn't any way I know of to do so, there are ways you can 
reduce the impact by reducing how much your backing up:
1. You almost certainly don't need to back up the logs, and if you do, 
they should probably be backed up independently from the rest of the 
system image.  In most cases, logs just add extra size to a backup, and 
have little value when you restore a backup, so it makes little sense in 
most cases to include them in a backup.  The simplest way to exclude 
them in your case is to make /var/log in the LXC containers be a 
separate subvolume.  This will exclude it from the snapshot for the 
backup, which will both speed up the backup, and reduce the amount of 
changes from the parent that occur while creating the backup.
2. Assuming you're using a distribution compliant with the filesystem 
hierarchy standard, there are a couple of directories you can safely 
exclude from all backups simply because portable programs are designed 
to handle losing data from these directories gracefully.  Such 
directories include /tmp, /var/tmp, and /var/cache, and they can be 
excluded the same way as /var/log.
3. Similar arguments apply to $HOME/.cache, which is essentially a 
per-user /var/cache.  This is less likely to have an impact if you don't 
have individual users doing things on these systems.
4. Look for other similar areas you may be able to safely exclude.  For 
example, I use Gentoo, and I build all my packages with external 
debugging symbols which get stored in /usr/lib/debug.  I only have this 
set up for convenience, so there's no point in me backing it up because 
I can just rebuild the package to regenerate the debugging symbols if I 
need them after restoring from a backup.  Similarly, I also exclude any 
VCS repositories that I have copies of elsewhere, simply because I can 
just clone that copy if I need it.
>
> Is it a bad idea to set ionice -c3 on the btrfs-transacti process which seems the one doing a
> lot of I/O ?
Yes, it's always a bad idea to mess with any scheduling properties other 
than CPU affinity for kernel threads (and even messing with CPU affinity 
is usually a bad idea too).  The btrfs-transaction kthread (the name 
gets cut off by the length limits built into the kernel) is a 
particularly bad one to mess with, because it handles committing updates 
to the filesystem.  Setting an idle scheduling priority on it would 
probably put you at severe risk of data loss or cause your system to 
lock up.
>
> Actually my io priority on btrfs process are
>
> ps x|awk '/[b]trfs/ {printf("%20s ", $NF); system("ionice -p" $1)}'
>       [btrfs-worker] none: prio 4
>    [btrfs-worker-hi] none: prio 4
>     [btrfs-delalloc] none: prio 4
>    [btrfs-flush_del] none: prio 4
>        [btrfs-cache] none: prio 4
>       [btrfs-submit] none: prio 4
>        [btrfs-fixup] none: prio 4
>        [btrfs-endio] none: prio 4
>    [btrfs-endio-met] none: prio 4
>    [btrfs-endio-met] none: prio 4
>    [btrfs-endio-rai] none: prio 4
>    [btrfs-endio-rep] none: prio 4
>          [btrfs-rmw] none: prio 4
>    [btrfs-endio-wri] none: prio 4
>    [btrfs-freespace] none: prio 4
>    [btrfs-delayed-m] none: prio 4
>    [btrfs-readahead] none: prio 4
>    [btrfs-qgroup-re] none: prio 4
>    [btrfs-extent-re] none: prio 4
>      [btrfs-cleaner] none: prio 0
>    [btrfs-transacti] none: prio 0
Altogether, this is exactly what they should be in a normal kernel.

Also, neat trick with awk to get that info, I'll have to remember that.

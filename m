Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59566 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S965142AbdIZIGk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:06:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwksq-0005a3-Mw
        for linux-btrfs@vger.kernel.org; Tue, 26 Sep 2017 10:06:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Wrong device?
Date: Tue, 26 Sep 2017 08:06:14 +0000 (UTC)
Message-ID: <pan$ac76f$d1873c6f$99e25eaa$74646ca8@cox.net>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
        <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
        <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
        <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
        <20170925075250.GC25529@carfax.org.uk>
        <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
        <20170925141951.GD25529@carfax.org.uk>
        <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
        <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
        <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

linux-btrfs posted on Mon, 25 Sep 2017 19:11:01 +0300 as excerpted:

Three points first off:

1) Please use a name other than "linux-btrfs".  That can remain the email 
address, but a name to go with it would be nice.  (You can see how my 
name and email address differ, for instance.)

2) Please don't reply to existing threads with a totally different 
topic.  Proper reply-threading clients will see it's a reply to the other 
thread (it's in the headers) and display it as such, even if you change 
the subject line.  If it's a different topic, start a new thread, don't 
reply to an existing thread.

3) I'm not a dev, just another btrfs user and list regular.  So I won't 
attempt to address the real technical or complicated stuff, but I can try 
to reply to the easy stuff at least, freeing the devs for addressing the 
more complicated stuff if they see a bug they can fix or might already be 
working on.

As to the problem...

> I have 15 x 6 TB disks in md-raid (Because btrfs's raid6 was marked as
> not-for-real-use when I first time installed this machine)
> 
> Now I have got both problem twice.
> 
> At this last time I have 233 subvolums, and millions of files (all
> together)

Just a reminder prompted by seeing those numbers tho I'd guess you 
already have this covered...

Sysadmin's backups rule #1:  The true value of your data is defined not 
by any words /claiming/ value nor by what you use it for, as the machine 
doesn't care about that, but rather by the number of backups of it you 
consider it worth having.  No backups means you are defining the data to 
be of less value than the time/trouble/resources to make the backup, so 
loss is never a big deal, because either you either have a backup if you 
considered it important to you, or you already saved what you defined as 
more valuable to you than that data, the time, trouble and resources 
you'd have otherwise put into the backup.

(Similarly with the currency of those backups, only there it's the value 
of the data difference between your last backup and the working copy.  
Once the data in that difference is of more value than the time/trouble/
resources to update the backup, it'll be updated.  Otherwise, the data in 
that delta is obviously not valuable enough to be worth that trouble, and 
thus not valuable enough to be terribly worried about if lost.)

> Then filesystem went to read only with this dmesg:
> 
> [Sat Sep 23 07:25:28 2017] ------------[ cut here ]------------
> [Sat Sep 23 07:25:28 2017] WARNING: CPU: 5 PID: 5431 at
> /build/linux-hwe-edge-CrMNv8/linux-hwe-edge-4.10.0/fs/btrfs/extent-
tree.c:6947
> __btrfs_free_extent.isra.61+0x2cb/0xeb0 [btrfs]
> [Sat Sep 23 07:25:28 2017] BTRFS: Transaction aborted (error -28)

> 4.10.0-26-generic #30~16.04.1-Ubuntu 

Note that this is the mainline btrfs development list, with btrfs still 
stabilizing, not yet fully stable and mature, so this list tends to be 
quite forward focused.  We recommend and best support the latest two 
mainline kernels in two tracks, current and LTS.  The current kernel is 
4.13, so on the current track, 4.13 and 4.12 are recommended and best 
supported.  On the LTS track, the coming 4.14 is scheduled to be an LTS, 
with 4.9 and 4.4 the two previous LTSs before that.

So the 4.9 LTS kernel series is supported, with 4.4 currently supported 
but on its way out and 4.14 on the way in.  And current track 4.13 and 
4.12 are supported, with 4.12 on the way out.

4.10 isn't an LTS kernel, and it's old enough it's already several 
kernels out of current support track.  So upgrading to current 4.13 or 
downgrading to 4.9 LTS series would be recommended.

Meanwhile, your distro is in a better position to support their kernels 
of /whatever/ version since they know what patches they've applied and 
what btrfs fixes they've backported... or not.

Of course we'll still try to help with 4.10, and it's not /too/ dated, 
but you can expect that you might get "does it still happen with a 
current kernel" type questions.

> [Sat Sep 23 07:25:28 2017] BTRFS: error (device sdb) in
> __btrfs_free_extent:6947: errno=-28 No space left [Sat Sep 23 07:25:28
> 2017] BTRFS: error (device sdb) in btrfs_drop_snapshot:9193: errno=-28
> No space left [Sat Sep 23 07:25:28 2017] BTRFS info (device sdb): forced
> readonly
> 
> 
> After a long googling (about more complex situations) I suddenly noticed
> "device sdb" WTF???  Filesystem is mounted from /dev/md3 (sdb is part of
> that mdraid) so btrfs should not even know anything about that /dev/sdb.
> 
> So maybe the error is more simple that I thought.  It tries to allocate
> more metadata from physical drive (not from /dev/md3 as it was supposed
> to do), so that "no space left on device" could be the REAL error...
> 
> But why it is doing so?  Does it help if I add some extra virtualization
> layer, like LVM?

Keep in mind that btrfs, unlike most other filesystems, can be multi-
device.  As such, it needs a way to track which devices are part of each 
filesystem, and it uses the filesystem UUID for that purpose.

Meanwhile, btrfs device scan, which is auto-run by udev after a device 
appears, is what lets the kernel know about all those btrfs containing 
devices and the UUIDs associated with them.

That's why btrfs is listing one of the md components as part of the 
filesystem -- it obviously has the same btrfs UUID as the md device that 
you actually created the filesystem on.

That can cause btrfs to write to the wrong device in some instances, tho 
obviously it doesn't do it all the time or things wouldn't work as well 
as they do.

It's thus recommended that when you're using btrfs on device layering 
such as mdraid or LVM, that you ensure that the lower layer devices 
aren't exposed to btrfs so it doesn't get confused.  I believe LVM can be 
configured to hide the lower layer devices in at least some instances, 
but I'm not sure about mdraid, altho this is the first time I've seen 
that particular issue with it (tho it may simply be because I've not been 
watching for it, Chris Murphy or Hugo are likely to have more information 
about that as they're more active with user support than I am, and are 
more technically skilled too, I believe).

> # btrfs --version btrfs-progs v4.4

As with the kernel version, likewise with the btrfs-progs userspace, tho 
in operation it's less important than the kernel, because for most normal 
operating commands, userspace simply calls the real code in the kernel 
anyway.  But once things begin to go wrong, the userspace version becomes 
more important, because it's the userspace code that handles btrfs check, 
btrfs restore, etc.

So while userspace 4.4 is fine for normal operations, you might want to 
be sure you have a current 4.12 or so available for recovery if needed, 
since it'll have the latest fixes and thus should give you the best 
chance at recovery, if it /is/ needed.

> # btrfs fi usage /data2
> Overall:
>      Device size:                  70.95TiB
>      Device allocated:              4.95TiB
>      Device unallocated:           66.01TiB
>      Device missing:                  0.00B
>      Used:                          4.94TiB
>      Free     (estimated):         66.01TiB      (min: 33.01TiB)
>      Data ratio:                       1.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:4.77TiB, Used:4.76TiB
>     /dev/md3        4.77TiB
> 
> Metadata,DUP: Size:92.00GiB, Used:90.79GiB
>     /dev/md3      184.00GiB
> 
> System,DUP: Size:32.00MiB, Used:592.00KiB
>     /dev/md3       64.00MiB
> 
> Unallocated:
>     /dev/md3       66.01TiB

This usage looks healthy.  No problems here. =:^)

That's the easy to see and address stuff, anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


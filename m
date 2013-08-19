Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.placs.net ([71.244.57.52]:55941 "EHLO mail.placs.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3HSUpk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 16:45:40 -0400
Date: Mon, 19 Aug 2013 15:45:32 -0500 (CDT)
From: BJ Quinn <bj@placs.net>
To: Jan Schmidt <mail@jan-o-sch.net>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        psusi@cfl.rr.com, Freddie Cash <fjwcash@gmail.com>,
        bo li liu <bo.li.liu@oracle.com>
Message-ID: <5278956.15824.1376945132989.JavaMail.root@mail.placs.net>
In-Reply-To: <51F79530.50006@jan-o-sch.net>
Subject: Re: Cloning a Btrfs partition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, so the fix is now in 3.10.6 and I'm using that.  I don't get the hang
anymore, but now I'm having a new problem.

Mount options --

rw,noatime,nodiratime,compress-force=zlib,space_cache,inode_cache,ssd

I need compression because I get a very high compression ratio with my data
and I have lots of snapshots, so it's the only way it can all fit. I have an
ssd and 24 cores anyway, so it should be fast. I need compress-force because
I have lots of files in my data which compress typically by a 10:1 or 20:1
ratio, but btrfs likes to see them as incompressible, so I need the
compress-force flag. I've just heard good things about space_cache
and inode_cache, so I've enabled them. The ssd option is because I do have an
ssd, but I have DRBD on top of it, and it looked like btrfs could not
automatically detect that it was an ssd (rotation speed was showing as "1").

Using newest btrfs-progs from git, because newest shipping btrfs-progs on
CentOS 6 returns an error for invalid argument.

I have a filesystem with maybe 1000 snapshots. They're daily snapshots of
a filesystem that is about 24GB compressed. The total space usage is 323GB
out of 469GB on an Intel SSD.

All the snapshots are writable, so I know I have to create a readonly
snapshot to copy to a backup drive.

btrfs subvolume snapshot -r /home/data/snapshots/storage\@NIGHTLY20101201 /home/data/snapshots\storageROTEMP

Then I send the snapshot to the backup drive, mounted with the same mount options.

btrfs send /home/data/snapshots/storageROTEMP | btrfs receive /mnt/backup/snapshots/

This takes about 5 hours to transfer 24GB compressed. Uncompressed it is about
150GB.  There is a "btrfs" process that takes 100% of one core during this 5
hour period.  There are some btrfs-endio and other processes that are using
small amounts of more than one core, but the "btrfs" process always takes 100%
and always only takes one core. And iostat clearly shows no significant disk
activity, so we're completely waiting on the btrfs command. Keep in mind that
the source filesystem is on an SSD, so it should be super fast. The destination
filesystem is on a hard drive connected via USB 2.0, but again, there's no
significant disk activity.  Processor is a dual socket Xeon E5-2420.

Then I try to copy another snapshot to the backup drive, hoping that it will
keep the space efficiency of the snapshots.

mv /mnt/backup/snapshots/storageROTEMP /mnt/backup/snapshots/storage\@NIGHTLY20101201
btrfs subvolume delete /home/data/snapshots/storageROTEMP
btrfs subvolume snapshot -r /home/data/snapshots/storage\@NIGHTLY20101202 /home/data/snapshots/storageROTEMP
btrfs send /home/data/snapshots/storageROTEMP | btrfs receive /mnt/backup/snapshots/

This results in a couple of problems. First of all, it takes 5 hours just like
the first snapshot did. Secondly, it takes up another ~20GB of data, so it's not
space efficient (I expect each snapshot should add far less than 500MB on
average due to the math on how many snapshots I have and how much total space
usage I have on the main filesystem). Finally, it doesn't even complete without
error. I get the following error after about 5 hours --

At subvol /home/data/snapshots/storageROTEMP
At subvol storageROTEMP
ERROR: send ioctl failed with -12: Cannot allocate memory
ERROR: unexpected EOF in stream.

So in the end, unless I'm doing something wrong, btrfs send is much slower
than just doing a full rsync of the first snapshot, and then incremental
rsyncs with the subsequent ones.  That and btrfs send doesn't seem to be
space efficient here (again, unless I'm using it incorrectly).

Thanks in advance for your help!

-BJ

----- Original Message ----- 

From: "Jan Schmidt" <mail@jan-o-sch.net> 
To: "BJ Quinn" <bj@placs.net> 
Cc: "Jan Schmidt" <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org, psusi@cfl.rr.com, "Freddie Cash" <fjwcash@gmail.com> 
Sent: Tuesday, July 30, 2013 5:28:00 AM 
Subject: Re: Cloning a Btrfs partition 

On Mon, July 29, 2013 at 17:32 (+0200), BJ Quinn wrote: 
> Thanks for the response! Not sure I want to roll a custom kernel on this 
> particular system. Any idea on when it might make it to 3.10 stable or 
> 3.11? Or should I just revert back to 3.9? 

I missed that it's in fact in 3.11 and if I got Liu Bo right he's going to send 
it to 3.10 stable soon. 

Thanks, 
-Jan 

> Thanks! 
> 
> -BJ 
> 
> ----- Original Message ----- 
> 
> From: "Jan Schmidt" <list.btrfs@jan-o-sch.net> 
> Sent: Monday, July 29, 2013 3:21:51 AM 
> 
> Hi BJ, 
> 
> [original message rewrapped] 
> 
> On Thu, July 25, 2013 at 18:32 (+0200), BJ Quinn wrote: 
>> (Apologies for the double post -- forgot to send as plain text the first time 
>> around, so the list rejected it.) 
>> 
>> I see that there's now a btrfs send / receive and I've tried using it, but 
>> I'm getting the oops I've pasted below, after which the FS becomes 
>> unresponsive (no I/O to the drive, no CPU usage, but all attempts to access 
>> the FS results in a hang). I have an internal drive (single drive) that 
>> contains 82GB of compressed data with a couple hundred snapshots. I tried 
>> taking the first snapshot and making a read only copy (btrfs subvolume 
>> snapshot -r) and then I connected an external USB drive and ran btrfs send / 
>> receive to that external drive. It starts working and gets a couple of GB in 
>> (I'd expect the first snapshot to be about 20GB) and then gets the following 
>> error. I had to use the latest copy of btrfs-progs from git, because the 
>> package installed on my system (btrfs-progs-0.20-0.2.git91d9eec) simply 
>> returned "invalid argument" when trying to run btrfs send / receive. Thanks 
>> in advance for any info you may have. 
> 
> The problem has been introduced with rbtree ulists in 3.10, commit 
> 
> Btrfs: add a rb_tree to improve performance of ulist search 
> 
> You should be safe to revert that commit, it's a performance optimization 
> attempt. Alternatively, you can apply the published fix 
> 
> Btrfs: fix crash regarding to ulist_add_merge 
> 
> It has not made it into 3.10 stable or 3.11, yet, but is contained in Josef's 
> btrfs-next 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git 
> 
> Thanks, 
> -Jan 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at http://vger.kernel.org/majordomo-info.html 
> 

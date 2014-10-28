Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51003 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaJ1LdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 07:33:14 -0400
MIME-Version: 1.0
Message-ID: <trinity-1f0ee155-d845-40b5-844d-77270be4d58e-1414495992747@3capp-mailcom-bs04>
From: "Stephan Alz" <stephan008@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS balance segfault, where to go from here
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Oct 2014 12:33:12 +0100
In-Reply-To: <pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
 <5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>,
 <pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Folks,

Thanks for the help what I got so far. I did what you have recommended and upgraded the kernel to 3.16.

After reboot it automatically resumed the balancing operation. For about 2 hours it went well:

Label: 'backup' ...
    Total devices 5 FS bytes used 5.81TiB
    devid    1 size 3.64TiB used 2.77TiB path /dev/sdc
    devid    2 size 3.64TiB used 2.77TiB path /dev/sdb
    devid    3 size 3.64TiB used 2.77TiB path /dev/sda
    devid    4 size 3.64TiB used 2.76TiB path /dev/sdd
    devid    5 size 3.64TiB used 572.00GiB path /dev/sdf < interestingly the used is now lower than it was

After that all the sudden I just lost the machine. As I thought it crashed with kernel panic but this wasn't like with the 3.13, it killed the whole system. Not even the magic keys worked.

http://i59.tinypic.com/5we5ib.jpg

Then when I tried to reboot it with 3.16 the system always segfaulted at boot time when it tried to mount the btrfs filesystem.

With 3.13 it at least didn't crash the entire system so I booted back to that and managed to stop the balancing:

>btrfs filesystem balance status /mnt/backup

Balance on '/mnt/backup' is paused
1 out of about 10 chunks balanced (1 considered),  90% left

Now my filesystem is fortunately back to RW again. Backups can continue tonight.
And about the "data not being important to backed up", hell yes it is so yesterday I did a "backup of the backups" to a good old XFS filesystem (something which is reliable). The problem is that our whole backup system was designed to use BTRFS. It rsync from a lot of servers to the backup server every night then creates snapshots. Changing this and going back to other filesystem would require a lot of time and effort, possibly rewriting all of our backup scripts.

What else can I do?
Should I try an even later 3.18 kernel version?
Can this happen because it doesn't have enough space for real? 


The counter now says that:
 btrfs    19534313824 12468488824 3753187048  77%

The whole point I added the new drive is because it was running out of space.
Somebody could really explain how this balancing works with RAID10 mode. What I want to know that if ANY of the drives are fail do we lose data or not? And the fact that the balancing is paused now changes this or not? If any of the drives out of the 5 would completely fail right now, would I lose all the data? I definitely don't want to leave the system in an inconsistent state like this. At least the backups are only done at nights so if I can get the backup drive mounted to RW by the end of the day that's enough.

Thanks

At the end I attached some recent 3.13 crash logs (maybe it's any help).


[Tue Oct 28 12:01:35 2014] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct 28 12:01:35 2014] btrfs           D ffff88007fc14280     0  3820   3202 0x00000000
[Tue Oct 28 12:01:35 2014]  ffff88003735e800 0000000000000086 0000000000000000 ffffffff81813480
[Tue Oct 28 12:01:35 2014]  0000000000014280 ffff880048feffd8 0000000000014280 ffff88003735e800
[Tue Oct 28 12:01:35 2014]  0000000000000246 ffff880036c8a000 ffff880036c8b260 ffff880036c8b2a0
[Tue Oct 28 12:01:35 2014] Call Trace:
[Tue Oct 28 12:01:35 2014]  [<ffffffffa02c486d>] ? btrfs_pause_balance+0x7d/0xf0 [btrfs]
[Tue Oct 28 12:01:35 2014]  [<ffffffff8109e400>] ? __wake_up_sync+0x10/0x10
[Tue Oct 28 12:01:35 2014]  [<ffffffffa02d1692>] ? btrfs_ioctl+0x1652/0x1f00 [btrfs]
[Tue Oct 28 12:01:35 2014]  [<ffffffff81199ea1>] ? path_openat+0xd1/0x630
[Tue Oct 28 12:01:35 2014]  [<ffffffff811956ac>] ? getname_flags+0xbc/0x1a0
[Tue Oct 28 12:01:35 2014]  [<ffffffff814dad78>] ? __do_page_fault+0x298/0x540
[Tue Oct 28 12:01:35 2014]  [<ffffffff8119c4c1>] ? do_vfs_ioctl+0x81/0x4d0
[Tue Oct 28 12:01:35 2014]  [<ffffffff81154a88>] ? do_brk+0x198/0x2f0
[Tue Oct 28 12:01:35 2014]  [<ffffffff8119c9b0>] ? SyS_ioctl+0xa0/0xc0
[Tue Oct 28 12:01:35 2014]  [<ffffffff814deef9>] ? system_call_fastpath+0x16/0x1b
[Tue Oct 28 12:03:35 2014] INFO: task btrfs:3820 blocked for more than 120 seconds.
[Tue Oct 28 12:03:35 2014]       Not tainted 3.13-0.bpo.1-amd64 #1
[Tue Oct 28 12:03:35 2014] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Oct 28 12:03:35 2014] btrfs           D ffff88007fc14280     0  3820   3202 0x00000000
[Tue Oct 28 12:03:35 2014]  ffff88003735e800 0000000000000086 0000000000000000 ffffffff81813480
[Tue Oct 28 12:03:35 2014]  0000000000014280 ffff880048feffd8 0000000000014280 ffff88003735e800
[Tue Oct 28 12:03:35 2014]  0000000000000246 ffff880036c8a000 ffff880036c8b260 ffff880036c8b2a0
[Tue Oct 28 12:03:35 2014] Call Trace:
[Tue Oct 28 12:03:35 2014]  [<ffffffffa02c486d>] ? btrfs_pause_balance+0x7d/0xf0 [btrfs]
[Tue Oct 28 12:03:35 2014]  [<ffffffff8109e400>] ? __wake_up_sync+0x10/0x10
[Tue Oct 28 12:03:35 2014]  [<ffffffffa02d1692>] ? btrfs_ioctl+0x1652/0x1f00 [btrfs]
[Tue Oct 28 12:03:35 2014]  [<ffffffff81199ea1>] ? path_openat+0xd1/0x630
[Tue Oct 28 12:03:35 2014]  [<ffffffff811956ac>] ? getname_flags+0xbc/0x1a0
[Tue Oct 28 12:03:35 2014]  [<ffffffff814dad78>] ? __do_page_fault+0x298/0x540
[Tue Oct 28 12:03:35 2014]  [<ffffffff8119c4c1>] ? do_vfs_ioctl+0x81/0x4d0
[Tue Oct 28 12:03:35 2014]  [<ffffffff81154a88>] ? do_brk+0x198/0x2f0
[Tue Oct 28 12:03:35 2014]  [<ffffffff8119c9b0>] ? SyS_ioctl+0xa0/0xc0
[Tue Oct 28 12:03:35 2014]  [<ffffffff814deef9>] ? system_call_fastpath+0x16/0x1b
[Tue Oct 28 12:03:48 2014] btrfs: found 16561 extents

Sent: Tuesday, October 28, 2014 at 1:07 AM
From: Duncan <1i5t5.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS balance segfault, where to go from here
Chris Murphy posted on Mon, 27 Oct 2014 10:51:16 -0600 as excerpted:

> On Oct 27, 2014, at 3:26 AM, Stephan Alz <stephan008@gmx.com> wrote:
>>
>> My question is where to go from here? What I going to do right now is
>> to copy the most important data to another separated XFS drive.
>> What I planning to do is:
>>
>> 1, Upgrade the kernel 2, Upgrade BTRFS 3, Continue the balancing.
>
> Definitely upgrade the kernel and see how that goes, there's been many
> many changes since 3.13. I would upgrade the user space tools also but
> that's not as important.

Just emphasizing...

Because btrfs is still under heavy development and not yet fully stable,
keeping particularly the kernel updated is vital, because running an old
kernel often means running a kernel with known btrfs bugs, fixed in newer
kernels.

The userspace isn't quite as important since under normal operation it
mostly simply tells the kernel what operations to perform, and an older
userspace simply means you might be missing newer features. However,
commands such as btrfs check (the old btrfsck) and btrfs restore work
from userspace, so having a current btrfs-progs is important when you run
into trouble and you're trying to fix things.

That said, a couple of recent kernels has known issues. Don't use the
3.15 series at all, and be sure you're on 3.16.3 or newer for the 3.16
series. 3.17 introduced another bug, with the fix hopefully in 3.17.2
(it didn't make 3.17.1) and in 3.18-rcs.

So 3.16.3 or later for stable kernel, or the latest 3.18-rc or live-git
kernel, is what I'd recommend. The other alternative if you're really
conservative is the latest long-term stable series kernel, 3.14.x, as it
gets critical bugfixes as well, tho it won't be quite as current as
3.16.x or 3.18-rc. But anything older than the latest 3.14.x stable
series is old and outdated in btrfs terms, and is thus not recommended.
And 3.15, 3.16 before 3.16.3, and 3.17 before 3.17.2 (hopefully), are
blackout versions due to known btrfs bugs. Avoid them.

Of course with btrfs still not fully stable, the usual sysadmin rule of
thumb that if you don't have a tested backup you don't have a backup, and
if you don't have a backup, by definition you don't care if you lose the
data, applies more than ever. If you're on not-yet-fully-stable btrfs
and you don't have backups, by definition you don't care if you lose that
data. There's people having to learn that the hard way, tho btrfs
restore can often recover at least some of what would otherwise be lost.

> FYI you can mount with skip_balance mount option to inhibit resuming
> balance, sometimes pausing the balance isn't fast enough when there are
> balance problems.

=:^)

>> Could someone please also explain that how is exactly the raid10 setup
>> works with ODD number of drives with btrfs?
>> Raid10 should be a stripe of mirrors. Now then this sdf drive is
>> mirrored or striped or what?
>
> I have no idea honestly. Btrfs is very tolerant of adding odd number and
> sizes of devices, but things get a bit nutty in actual operation
> sometimes.

In btrfs, raid1, including the raid1 side of raid10, is defined as
exactly two copies of the data, one on each of two different devices.
These copies are allocated by chunk size, 1 GiB size for data, quarter
GiB size for metadata, and chunks are normally allocated on the device
with the most unallocated space available, provided the other constraints
(such as don't but both copies on the same device) are met.

Btrfs raid0 stripes will be as wide as possible, but again are allocated
a chunk at a time, in sub-chunk-size strips.

While I've not run btrfs raid10 personally and thus (as a sysadmin not a
dev) can't say for sure, what this implies to me is that, assuming equal
sized devices, an odd number of devices in raid10 will alternate skipping
one device at each chunk allocation.

So with a five same-size device btrfs raid10, if I'm not mistaken, btrfs
will allocate chunks from four at once, two mirrors, two stripes, with
the fifth one unused for that chunk allocation. However, at the next
chunk allocation, the device skipped in the previous allocation will now
have the most free space and will thus get the first allocation, with the
one of the other four devices skipped in that allocation round. After
five allocation rounds (assuming all allocation rounds were 1 GiB data
chunks, not quarter-GiB metadata), usage should thus be balanced across
all five devices.

Of course with six same-size devices, because btrfs raid1 does exactly
two copies, no more, each stripe will be three devices wide.


As for the dataloss question, unlike say raid56 mode which is known to be
effectively little more than expensive raid0 at this point, raid10 should
be as reliable as raid1, etc. But I'd refer again to that sysadmin's
rule of thumb above. If you don't have tested backups, you don't have
backups, and if you don't have backups, the data is by definition not
valuable enough to be worth the hassle of backing it up; the calculated
risk cost of data loss is lower than the given time required to make,
test and keep current the backups. After that, it's your decision
whether you value that data more than the time required to make and
maintain those backups, or not, given the risk factor including the fact
that btrfs is still under heavy development and is not yet fully stable.

--
Duncan - List replies preferred. No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master." Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
 
 

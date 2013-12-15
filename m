Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:33821 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752011Ab3LOXgw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 18:36:52 -0500
Date: Sun, 15 Dec 2013 17:39:59 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Blocket for more than 120 seconds
Message-ID: <20131215233959.GA7260@pyropus.ca>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
 <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
 <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
 <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> wrote:
> On Dec 14, 2013, at 4:19 PM, Hans-Kristian Bakke <hkbakke@gmail.com> wrote:
> 
> > # btrfs fi df /storage/storage-vol0/
> > Data, RAID10: total=13.89TB, used=12.99TB
> > System, RAID10: total=64.00MB, used=1.19MB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID10: total=21.00GB, used=17.59GB
> 

> By my count this is ~ 95.6% full. My past experience with other file
> systems, including btree file systems, is they get unpredictably fussy when
> they're this full. I start migration planning once 80% full is reached, and
> make it a policy to avoid going over 90% full.

For what it's worth, I see exactly the same behaviour on a system where the
filesystem is only ~60% full, with more than 5TB of free space.  All I have to
do is copy a single file of several gigabytes to the filesystem (over the
network, so it's only coming in at ~30MB/s) and I get similar task-blocked
messages:

INFO: task btrfs-transacti:4118 blocked for more than 120 seconds.
Not tainted 3.12.5-custom+ #10
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff88082fd14140     0  4118      2 0x00000000
ffff880805a06040 0000000000000002 ffff8807f7665d40 ffff8808078f2040
0000000000014140 ffff8807f7665fd8 ffff8807f7665fd8 ffff880805a06040
0000000000000001 ffff88082fd14140 ffff880805a06040 ffff8807f7665c70
Call Trace:
[<ffffffff810d1a19>] ? __lock_page+0x66/0x66
[<ffffffff813b26dd>] ? io_schedule+0x56/0x6c
[<ffffffff810d1a20>] ? sleep_on_page+0x7/0xc
[<ffffffff813b0ad6>] ? __wait_on_bit+0x40/0x79
[<ffffffff810d1df1>] ? find_get_pages_tag+0x66/0x121
[<ffffffff810d1ad8>] ? wait_on_page_bit+0x72/0x77
[<ffffffff8105f540>] ? wake_atomic_t_function+0x21/0x21
[<ffffffff810d218f>] ? filemap_fdatawait_range+0x66/0xfe
[<ffffffffa0545bb5>] ? clear_extent_bit+0x25d/0x29d [btrfs]
[<ffffffffa052ff9a>] ? btrfs_wait_marked_extents+0x79/0xca [btrfs]
[<ffffffffa0530059>] ? btrfs_write_and_wait_transaction+0x6e/0x7e [btrfs]
[<ffffffffa05307ad>] ? btrfs_commit_transaction+0x651/0x843 [btrfs]
[<ffffffffa05297e8>] ? transaction_kthread+0xf4/0x191 [btrfs]
[<ffffffffa05296f4>] ? try_to_freeze_unsafe+0x30/0x30 [btrfs]
[<ffffffffa05296f4>] ? try_to_freeze_unsafe+0x30/0x30 [btrfs]
[<ffffffff8105eb45>] ? kthread+0x81/0x89
[<ffffffff81013291>] ? paravirt_sched_clock+0x5/0x8
[<ffffffff8105eac4>] ? __kthread_parkme+0x5d/0x5d
[<ffffffff813b880c>] ? ret_from_fork+0x7c/0xb0
[<ffffffff8105eac4>] ? __kthread_parkme+0x5d/0x5d


So it's not, at least in my case, due to the filesystem approaching full.

I've seen this behaviour over many kernel versions; the above is with 3.12.5.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------

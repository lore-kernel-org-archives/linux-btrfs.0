Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:60400 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbaF0QLu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 12:11:50 -0400
Message-ID: <53AD97E4.80303@elastichosts.com>
Date: Fri, 27 Jun 2014 17:12:20 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: NeilBrown <neilb@suse.de>, Chris Mason <clm@fb.com>
Subject: Re: Deadlock/high load
References: <5399C40F.3070509@elastichosts.com>
In-Reply-To: <5399C40F.3070509@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When using parity md raid backed up by faster SSD disks, with btrfs on
top of it, at intensive I/O, the machine enters a sort of deadlock and
the load average starts to grow until a point where the machine is no
longer responsive.

At the time when the deadlock happens, there are 2 processes that
consume 100% CPU, as reported by atop:
P1. mdX_raidY
P2. btrfs-trasaction
where X is the number of the md device, 130 in our case, Y is the raid
level, which is one of 4, 5, or 6, since it only happens when using
parity raid. Sometimes there's also a kworker process along with the two
above. I'm going to paste the SysRq dump for these processes at the end
of this e-mail.

As stated by the tests table below, it doesn't happen with a file system
other than btrfs, and it doesn't happen with linear raid configurations
(raid 0, 1, 10).

I managed to reproduce the problem only by using ramdisks instead of
SSDs for the base block storage layer. It doesn't reproduce with slower
spinning disks, even some older SSD disks, so the speed is an important
factor for this race condition.

I have used all current kernels, starting from 3.15, to 3.16-rc2, and
linux-next-20140624. The problem is still there.

Here are the steps to reproduce.

R1. Install Bonnie++ disk benchmark tool. I installed it manually from
[1]. Also, make sure you configured ramdisk block devices in the kernel.

R2. Create the md array on top of the /dev/ramX blocks:
mdadm --create --auto=md \
  --level=6 --raid-devices=10 \
  --bitmap=internal --bitmap-chunk=65536 \
  --metadata=0.90 --assume-clean \
  --run --force \
  /dev/md130 \
  /dev/ram{0..9}

R3. Create and mount the filesystem
mkfs.btrfs -K -f -d single -m single /dev/md130
# (a plain "mkfs.ext4 /dev/md130" was used for the ext4 test, see below)
mount /dev/md130 /tmp/test

R4. Create the test environment
mkdir /tmp/test/bonnie
chown nobody /tmp/test/bonnie

R5. Run bonnie
bonnie++ -d /tmp/test/bonnie -s 20480m -m test -r 10240 -x 100 -u nobody


After between 1 and 12 run cycles, the machine enters the state
described at the beginning of this e-mail.

Below are the tests I have performed, with the result. FAIL means that
the machines breaks and the problem happens.
T1. md raid 6 + btrfs + discard => FAIL
T2. md raid 6 + btrfs - discard => FAIL
T3. md raid 5 + btrfs + discard => FAIL
T4. md raid 4 + btrfs + discard => FAIL
T5. md raid 6 + ext4 - discard => PASS
T6. md raid 10 + btrfs + discard => PASS
T7. md raid 0 + btrfs + discard => PASS
T8. md raid 1 + btrfs + discard => PASS
T9. btrfs + discard => PASS

The discard option (as in mount -o ssd,discard) is present in the above
tests to be able to make the environment as close as our production
machines as possible. But in the end it doesn't seem to be a root cause.
Also, this is the case for raid 6, this is the level we use on our
production machines, and it has been preferred over other levels for
many of the tests.

And the SysRq "t" dump follows, for the 2 main processes above. The full
output is available at [3]. You can also find some information in the
SysRq output from the original report at [2].

md130_raid6     R  running task        0  1146      2 0x00080008
ffffea005be81e00 0000000000000000 0000000000000000 ffff880ffb107af8
ffffffff818478a0 0000000000000000 0000000000000000 ffff880ffb107b20
ffffffff818478a0 0000000000000000 ffff881c0810f478 0000000180190018
Call Trace:
[<ffffffff818478a0>] ? __slab_free+0x20b/0x2d9
[<ffffffff818478a0>] ? __slab_free+0x20b/0x2d9
[<ffffffff81178dd4>] ? kmem_cache_free+0x17e/0x1a3
[<ffffffff8113a809>] ? mempool_free_slab+0x12/0x14
[<ffffffff8113ac77>] ? mempool_free+0x71/0x7a
[<ffffffff813b3dd4>] ? bio_put+0x59/0x68
[<ffffffff810f4518>] ? select_task_rq_fair+0x532/0x565
[<ffffffff81616cea>] ? handle_stripe+0x1a97/0x1c06
[<ffffffff810ff20b>] ? autoremove_wake_function+0xd/0x2f
[<ffffffff8160f11b>] ? release_inactive_stripe_list+0x65/0x108
[<ffffffff81617077>] ? handle_active_stripes.isra.30+0x21e/0x2b3
[<ffffffff81617501>] ? raid5d+0x358/0x3c1
[<ffffffff810d7ec5>] ? del_timer_sync+0x25/0x43
[<ffffffff8163410a>] ? md_thread+0x10f/0x125
[<ffffffff810ff1fe>] ? __wake_up_sync+0xd/0xd
[<ffffffff81633ffb>] ? md_register_thread+0xcb/0xcb
[<ffffffff810e72cc>] ? kthread+0xd6/0xde
[<ffffffff810e71f6>] ? kthread_create_on_node+0x167/0x167
[<ffffffff8185043c>] ? ret_from_fork+0x7c/0xb0
[<ffffffff810e71f6>] ? kthread_create_on_node+0x167/0x167

btrfs-transacti S ffff882026d119c0     0   704      2 0x00000000
ffff8817f9c77df8 0000000000000002 ffff8817f9c77fd8 ffff8817fbf45f90
00000000000119c0 ffff881ffb173420 ffff8817fbf45748 ffff8817f9c77d40
ffffffff810f45b2 ffff8817f9c77d88 ffffffff810f8d15 ffff8817f9c77d90
Call Trace:
[<ffffffff810f45b2>] ? __enqueue_entity+0x67/0x69
[<ffffffff810f8d15>] ? enqueue_entity+0x4bd/0x5e1
[<ffffffff8106040c>] ? physflat_send_IPI_mask+0x9/0xb
[<ffffffff8105a0f2>] ? native_smp_send_reschedule+0x56/0x58
[<ffffffff810ed64a>] ? resched_task+0x45/0x48
[<ffffffff8184d4d8>] schedule+0x65/0x67
[<ffffffff8184cb07>] schedule_timeout+0x13f/0x167
[<ffffffff810d7a6d>] ? __internal_add_timer+0xb5/0xb5
[<ffffffff812f1ba1>] transaction_kthread+0x1a2/0x1cb
[<ffffffff812f19ff>] ? btrfs_cleanup_transaction+0x45b/0x45b
[<ffffffff810e72cc>] kthread+0xd6/0xde
[<ffffffff810e71f6>] ? kthread_create_on_node+0x167/0x167
[<ffffffff8185043c>] ret_from_fork+0x7c/0xb0
[<ffffffff810e71f6>] ? kthread_create_on_node+0x167/0x167


I can reproduce this under different testing conditions and gather some
more data, if requested.

Thank for any insight or feedback.

Links referenced above:
[1]
http://archive.ubuntu.com/ubuntu/pool/main/b/bonnie++/bonnie++_1.97.1.tar.gz
[2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/35865
[3] http://84.45.121.180/sysrq.txt


Cheers,
Alin.

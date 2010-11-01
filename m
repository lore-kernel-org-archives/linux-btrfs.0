From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: btrfs and apt package manager in ubuntu (discard stalls)
Date: Mon, 1 Nov 2010 11:06:38 +0000
Message-ID: <AANLkTimT6X6GwyrizZP+-rJ-KYzp9ktGxUDKaqgoP5jz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christian <gmane.20.ceed@spamgourmet.com>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Mike Hommey <mh@glandium.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 1 November 2010 08:10, Mike Hommey <mh@glandium.org> wrote:
> On Sun, Oct 31, 2010 at 11:21:36AM -0500, Christian wrote:
>> On Sun, 2010-10-31 at 16:17 +0300, Abdullah Ansari wrote:
>> > it's very slow in installtion with apt in ubuntu
>>
>> I'm seeing the same thing. When installing using apt the disk grinds
>> "forever" before the installation completes. I have two identical
>> laptops running Linux Mint 10 (rc) with similar disk layout except that
>> one has two btrfs partitions while the other only has ext4. The one with
>> btrfs takes at least 10 times longer to install updates on than the ext4
>> one.
>
> That's because dpkg uses sync when unpacking each package.

I've seen significant stalls in dpkg calling fsync() when BTRFS
discard is enabled on my OCZ Vertex SSD (firmware 1.6, Indilinx
controller). I don't get these stalls with discard on my superb
Crucial C300 (Marvell controller).

What is your block device and your mount options?

I can reproduce an eye-watering 3.1s (!!) stall with:

# sync; echo 2 >/proc/sys/vm/drop_caches; bash -x
/var/lib/dpkg/info/gconf2.postinst

I conclude the Vertex firmware has a performance issue. I see it is
discard, as the call trace is:

 gconftool-2   D ffff880001e54cc0     0  4378   4377 0x00000000
 ffff88010407fb98 0000000000000082 ffff88010407ffd8 0000000000014cc0
 0000000000014cc0 ffff88010407ffd8 0000000000014cc0 ffff88010407ffd8
 0000000000014cc0 ffff88012f115f18 ffff88012f115f20 ffff88012f115b80
Call Trace:
 [<ffffffff81586ade>] schedule_timeout+0x19e/0x2e0
 [<ffffffff812a674e>] ? generic_make_request+0x20e/0x430
 [<ffffffff815866fd>] wait_for_common+0xcd/0x180
 [<ffffffff8105cd90>] ? default_wake_function+0x0/0x20
 [<ffffffff812a69ed>] ? submit_bio+0x7d/0x100
 [<ffffffff8158688d>] wait_for_completion+0x1d/0x20
 [<ffffffff812ae339>] blkdev_issue_discard+0x1b9/0x210
 [<ffffffffa0024991>] btrfs_issue_discard+0x21/0x30 [btrfs]
 [<ffffffffa0024a3c>] btrfs_discard_extent+0x9c/0xc0 [btrfs]
 [<ffffffffa002517e>] btrfs_finish_extent_commit+0x5e/0x1d0 [btrfs]
 [<ffffffffa0038e78>] btrfs_commit_transaction+0x4a8/0x630 [btrfs]
 [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0045635>] btrfs_sync_file+0x125/0x1a0 [btrfs]
 [<ffffffff8117e5a3>] vfs_fsync_range+0x83/0xa0
 [<ffffffff8117e62c>] vfs_fsync+0x1c/0x20
 [<ffffffff8117e66a>] do_fsync+0x3a/0x60
 [<ffffffff8117e6c0>] sys_fsync+0x10/0x20
 [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b

Daniel
-- 
Daniel J Blueman

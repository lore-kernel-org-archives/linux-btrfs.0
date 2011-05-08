From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.29-rc2] insert_dir_item hitting assertion during log replay
Date: Sun, 8 May 2011 21:36:54 +0800
Message-ID: <BANLkTimWLt9M_NLvkJX-8KphdKF2sjLyBg@mail.gmail.com>
References: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>
	<4DA31F11.90200@redhat.com>
	<BANLkTin7nYmOXcHjfS0s77s+-buQW-0cgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTin7nYmOXcHjfS0s77s+-buQW-0cgQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12 April 2011 00:07, Daniel J Blueman <daniel.blueman@gmail.com> wro=
te:
> On 11 April 2011 23:32, Josef Bacik <josef@redhat.com> wrote:
>> On 04/10/2011 04:29 AM, Daniel J Blueman wrote:
>>>
>>> When rebooting from a crash, thus during log replay on 2.6.29-rc2,
>>> btrfs_insert_dir_item caused an assertion failure [1]. The fs was
>>> being mounted clear_cache on an SSD.
>>>
>>> Probably it's not so easy to reproduce, but better to report it...
>>>
>>
>> Do you still have this fs, and does it still panic the same way on m=
ount?
>> =A0Thanks,
>
> I still have this fs, though it didn't panic at next mount. I guess
> this creates a case for cooking a script that eg logically disconnect=
s
> a block device during activity (hdparm or echo 1 >delete) then
> reconnects it for remount...let me know if interested.

I've hit this a few times recently following a crash in 2.6.39-rc (eg
with -rc6 [1]) and have found the only way to access the data is mount
-o ro,notreelog.

I guess btrfs_insert_dir_item is failing due to corruption of the
directory inode. The only solution here would be to gracefully discard
the log item being replayed and print a warning that the filesystem
has corruption, right?

Daniel

--- [1]

kernel BUG at fs/btrfs/inode.c:4676!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/bdi/btrfs-2/uevent
CPU 1
Modules linked in: binfmt_misc kvm_intel kvm arc4 ecb uvcvideo
videodev v4l2_compat_ioctl32 microcode i915 iwlagn sdhci_pci sdhci
drm_kms_helper mac80211 drm i2c_algo_bit mmc_core video

Pid: 1372, comm: mount Tainted: G   M        2.6.39-rc6-330cd+ #3 Dell
Inc. Latitude E5420/0H5TG2
RIP: 0010:[<ffffffff812a3262>]  [<ffffffff812a3262>] btrfs_add_link+0x1=
32/0x190
RSP: 0018:ffff8802102fd7b8  EFLAGS: 00010282
RAX: 00000000ffffffef RBX: ffff880212594860 RCX: 0000000000000040
RDX: 00000000ffffffef RSI: 0000000000000000 RDI: ffffffff8112e413
RBP: ffff8802102fd828 R08: 0000000000000000 R09: ffff88022d732090
R10: 0000000000000025 R11: 0000000000000000 R12: ffff8802124cd010
R13: ffff88020dc48000 R14: 000000000000000f R15: ffff88021dcbc000
=46S:  00007f58dc76b800(0000) GS:ffff88022ec20000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7a5adeb110 CR3: 000000020e2e9000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 1372, threadinfo ffff8802102fc000, task ffff88021e5=
ec020)
Stack:
 ffff880200000001 0000000000001ab8 ffff8802102fd958 0000000000001ab8
 000000000015d5c1 0000000000000001 0000000000001000 0000000000000000
 ffff88020dc25000 0000000000000000 000000000000007e ffff8802102fdac8
Call Trace:
 [<ffffffff812cd595>] add_inode_ref+0x2f5/0x3b0
 [<ffffffff81059261>] ? get_parent_ip+0x11/0x50
 [<ffffffff812cea46>] replay_one_buffer+0x2c6/0x3a0
 [<ffffffff8112d126>] ? init_object+0x46/0x80
 [<ffffffff81059261>] ? get_parent_ip+0x11/0x50
 [<ffffffff812cb3c8>] walk_up_log_tree+0x168/0x320
 [<ffffffff812ce780>] ? replay_one_dir_item+0xe0/0xe0
 [<ffffffff812cbbd8>] walk_log_tree+0xe8/0x290
 [<ffffffff8109a59d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff812d0a50>] btrfs_recover_log_trees+0x220/0x320
 [<ffffffff812ce780>] ? replay_one_dir_item+0xe0/0xe0
 [<ffffffff81295ca1>] open_ctree+0x1301/0x16b0
 [<ffffffff81332504>] ? snprintf+0x34/0x40
 [<ffffffff81270873>] btrfs_fill_super.clone.14+0x73/0x130
 [<ffffffff811a4ebf>] ? disk_name+0x5f/0xc0
 [<ffffffff8132f9c7>] ? strlcpy+0x47/0x60
 [<ffffffff81270cdf>] btrfs_mount+0x3af/0x450
 [<ffffffff811442eb>] mount_fs+0x1b/0xd0
 [<ffffffff8116027e>] vfs_kern_mount+0x5e/0xd0
 [<ffffffff8116080f>] do_kern_mount+0x4f/0x100
 [<ffffffff81162264>] do_mount+0x1e4/0x220
 [<ffffffff8116264b>] sys_mount+0x8b/0xe0
 [<ffffffff8170927b>] system_call_fastpath+0x16/0x1b
Code: 4c 89 d2 44 89 f1 4c 89 ee 4c 89 1c 24 4c 89 55 a8 4c 89 5d a0
e8 df c4 fe ff 4c 8b 5d a0 4c 8b 55 a8 85 c0 75 bc e9 31 ff ff ff <0f>
0b 48 8b b2 d0 fc ff ff 48 8d 7d b0 b9 11 00 00 00 4d 89 d9
RIP  [<ffffffff812a3262>] btrfs_add_link+0x132/0x190
 RSP <ffff8802102fd7b8>
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

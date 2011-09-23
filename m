From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Fri, 23 Sep 2011 17:31:44 +0200
Message-ID: <20110923153144.GA28744@kashmir>
References: <4E7A4695.9080106@redhat.com>
 <20110921231055.GN22205@twin.jikos.cz>
 <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com>
 <4E7B423C.2080007@redhat.com>
 <20110922182222.GA18449@kashmir>
 <4E7B85B3.6080106@redhat.com>
 <20110922193007.GA19088@kashmir>
 <20110922203213.GA19890@kashmir>
 <20110923125530.GA27417@kashmir>
 <4E7C9C72.4020109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7C9C72.4020109@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2011 at 10:49:22AM -0400, Josef Bacik wrote:
> Ok I have no idea how this could happen.  Can you mount -o clear_cache
> and see if it's just the cache that's bad?  Thanks,

Did that and got this (it's a never ending story, this is from a F16
alpha boot cd hence stack trace could be different):

[  512.455253] ------------[ cut here ]------------
[  512.455464] kernel BUG at fs/btrfs/inode.c:4586!
[  512.455662] invalid opcode: 0000 [#1] SMP 
[  512.455874] CPU 1 
[  512.455879] Modules linked in: btrfs zlib_deflate libcrc32c xts lrw gf128mul sha256_generic dm_crypt dm_round_robin dm_multipath linear raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 iscsi_ibft iscsi_boot_sysfs pcspkr edd iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cramfs arc4 firewire_ohci firewire_core sdhci_pci sdhci yenta_socket crc_itu_t mmc_core iwl4965 iwl_legacy mac80211 cfg80211 rfkill nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video e1000e squashfs
[  512.456018] 
[  512.456018] Pid: 1349, comm: mount Not tainted 3.0.0-1.fc16.x86_64 #1 LENOVO 6458V5C/6458V5C
[  512.456018] RIP: 0010:[<ffffffffa036132f>]  [<ffffffffa036132f>] btrfs_add_link+0x123/0x17c [btrfs]
[  512.456018] RSP: 0018:ffff880123e09848  EFLAGS: 00010282
[  512.456018] RAX: 00000000ffffffef RBX: ffff8801194c9d78 RCX: 0040000000000006
[  512.456018] RDX: 0000000000000127 RSI: ffff88012aa7aaf0 RDI: 0000000000000282
[  512.456018] RBP: ffff880123e098b8 R08: ffff8801228ac000 R09: 000000000000005a
[  512.456018] R10: ffff880123e096d8 R11: ffff88013b4023c0 R12: ffff8801194ca610
[  512.456018] R13: ffff8801165d2090 R14: 000000000000000b R15: ffff8801181fd630
[  512.456018] FS:  00007f7bb600a820(0000) GS:ffff88013bc00000(0000) knlGS:0000000000000000
[  512.456018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  512.456018] CR2: 00007f7235313768 CR3: 0000000113f09000 CR4: 00000000000006e0
[  512.456018] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  512.456018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  512.456018] Process mount (pid: 1349, threadinfo ffff880123e08000, task ffff88012aa7a3e0)
[  512.456018] Stack:
[  512.456018]  ffff880100000001 0000000000018028 ffff880123e09888 ffff8801194bb000
[  512.456018]  0000000000000000 5aff8801165b3000 0100000000001537 0000000000000000
[  512.456018]  0000000000001000 ffff8801194ba1b0 ffff8801194ca610 ffff880123e099d7
[  512.456018] Call Trace:
[  512.456018]  [<ffffffffa0382862>] add_inode_ref+0x2e6/0x37c [btrfs]
[  512.456018]  [<ffffffffa037547a>] ? read_extent_buffer+0xc3/0xe3 [btrfs]
[  512.456018]  [<ffffffffa0383208>] replay_one_buffer+0x197/0x212 [btrfs]
[  512.456018]  [<ffffffffa0381068>] walk_up_log_tree+0xe4/0x1aa [btrfs]
[  512.456018]  [<ffffffffa0383071>] ? replay_one_dir_item+0xbd/0xbd [btrfs]
[  512.456018]  [<ffffffffa038148d>] walk_log_tree+0x9e/0x19e [btrfs]
[  512.456018]  [<ffffffffa0384562>] btrfs_recover_log_trees+0x28b/0x298 [btrfs]
[  512.456018]  [<ffffffffa0383071>] ? replay_one_dir_item+0xbd/0xbd [btrfs]
[  512.456018]  [<ffffffffa0355c42>] open_ctree+0x11aa/0x14b8 [btrfs]
[  512.456018]  [<ffffffffa033b908>] btrfs_mount+0x233/0x498 [btrfs]
[  512.456018]  [<ffffffff810f3ef3>] ? free_pages+0x47/0x4c
[  512.456018]  [<ffffffff8113ddac>] mount_fs+0x69/0x155
[  512.456018]  [<ffffffff81107e68>] ? __alloc_percpu+0x10/0x12
[  512.456018]  [<ffffffff81152ee6>] vfs_kern_mount+0x63/0xa0
[  512.456018]  [<ffffffff81153bba>] do_kern_mount+0x4d/0xdf
[  512.456018]  [<ffffffff81155250>] do_mount+0x63c/0x69f
[  512.456018]  [<ffffffff81155534>] sys_mount+0x88/0xc2
[  512.456018]  [<ffffffff814e4fc2>] system_call_fastpath+0x16/0x1b
[  512.456018] Code: 89 f1 4c 89 fa 4c 89 ee 48 89 44 24 08 41 8b 04 24 66 c1 e8 0c 83 e0 0f 0f b6 80 b8 bd 39 a0 89 04 24 e8 db cf fe ff 85 c0 74 02 <0f> 0b 45 01 f6 4d 63 f6 4c 03 b3 a0 01 00 00 4c 89 b3 a0 01 00 
[  512.456018] RIP  [<ffffffffa036132f>] btrfs_add_link+0x123/0x17c [btrfs]
[  512.456018]  RSP <ffff880123e09848>
[  512.485056] ---[ end trace cea880cef8a5d83b ]---

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --

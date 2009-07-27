From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.31-rc4] uninitialised memory during read_sb...
Date: Mon, 27 Jul 2009 23:05:51 +0100
Message-ID: <6278d2220907271505y65c98631o8a117d86140a1785@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When mounting a btrfs filesystem on my server running 2.6.31-rc4,
kmemcheck spotted some believed-uninitialised memory [1] 128 bytes
into the inode structure access from BTRFS_I [2,3].

The filesystem was created with btrfstools-0.18 under 2.6.30 - perhaps
an issue relating to the forward rolling disk format changes? Should
be reproducible.

Thanks,
  Daniel

--- [1]

device fsid bf4baee4f8fc876b-fe3bbc7a5af849a devid 1 transid 29478 /dev/sda1
WARNING: kmemcheck: Caught 64-bit read from uninitialized memory
(ffff88007ac803c0)
b1e01781ffffffffb5ca6681ffffffff5b900081ffffffff25456581ffffffff
 u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
 ^

Modules linked in: ath9k snd_hda_codec_realtek mac80211 led_class ath
snd_hda_intel snd_hda_codec snd_pcm snd_timer snd pl2303 soundcore
snd_page_alloc
Pid: 2172, comm: mount Tainted: G        W  2.6.31-rc4-274sd #1 OEM
RIP: 0010:[<ffffffff811be5d3>]  [<ffffffff811be5d3>] open_ctree+0x673/0x1360
RSP: 0018:ffff88007d769bf8  EFLAGS: 00010246
RAX: ffff88007ac80670 RBX: 0000000000000000 RCX: ffff88007ac80440
RDX: ffffffff821731d0 RSI: 0000000000000001 RDI: ffffffff821731d0
RBP: ffff88007d769d28 R08: 7fffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88007d87d948
R13: ffff88007d87c000 R14: ffff88007d15d000 R15: ffff88007d15a000
FS:  00007fa15cd1e780(0000) GS:ffff8800022fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88007f80cb40 CR3: 000000007e583000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff811a385c>] btrfs_get_sb+0x3fc/0x500
 [<ffffffff810e09b8>] vfs_kern_mount+0x58/0xd0
 [<ffffffff810e0a9e>] do_kern_mount+0x4e/0x110
 [<ffffffff810fa9ca>] do_mount+0x2ca/0x8d0
 [<ffffffff810fb08b>] sys_mount+0xbb/0xf0
 [<ffffffff8100bdeb>] system_call_fastpath+0x16/0x1b
 [<ffffffffffffffff>] 0xffffffffffffffff

--- [2]

ffffffff811bdf60 <open_ctree>:
open_ctree():
...
/store/kernel/linux/fs/btrfs/disk-io.c:1610
ffffffff811be5b7:       49 8b 85 40 19 00 00    mov    0x1940(%r13),%rax
ffffffff811be5be:       48 8b 80 28 02 00 00    mov    0x228(%rax),%rax
ffffffff811be5c5:       4c 89 a0 e8 00 00 00    mov    %r12,0xe8(%rax)
BTRFS_I():
/store/kernel/linux/fs/btrfs/btrfs_inode.h:147
ffffffff811be5cc:       49 8b 8d 40 19 00 00    mov    0x1940(%r13),%rcx   <---
rb_set_parent():
/store/kernel/linux/include/linux/rbtree.h:125
ffffffff811be5d3:       48 8b 41 80             mov    -0x80(%rcx),%rax
ffffffff811be5d7:       48 8d 51 80             lea    -0x80(%rcx),%rdx
ffffffff811be5db:       83 e0 03                and    $0x3,%eax
ffffffff811be5de:       48 09 c2                or     %rax,%rdx
ffffffff811be5e1:       48 89 51 80             mov    %rdx,-0x80(%rcx)

--- [3]

static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
{
        return container_of(inode, struct btrfs_inode, vfs_inode);
}
-- 
Daniel J Blueman

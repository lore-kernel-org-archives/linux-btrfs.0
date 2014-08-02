Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44843 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaHBXgK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Aug 2014 19:36:10 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so4478250wiw.5
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Aug 2014 16:36:08 -0700 (PDT)
MIME-Version: 1.0
From: Peter Waller <peter@scraperwiki.com>
Date: Sun, 3 Aug 2014 00:35:28 +0100
Message-ID: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
Subject: ENOSPC with mkdir and rename
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

My TL;DR questions are at the bottom, before the stack trace.

I'm running Ubuntu 14.04. I wonder if this problem is related to the
thread titled "Machine lockup due to btrfs-transaction on AWS EC2
Ubuntu 14.04" which I started on the 29th of July:

> http://thread.gmane.org/gmane.comp.file-systems.btrfs/37224

Kernel: 3.15.7-031507-generic

I'm on a single block device system, i.e, no RAID.

I was observing ENOSPC from `mkdir` and `rename` on this system, with
a good amount of free disk space (df -h reports 62 GB remain). I added
enospc_debug (full umount/mount, not just mount -o remount), but this
had no apparent effect when receiving ENOSPC from userland.

$ sudo btrfs fi df /path/to/volume
Data, single: total=489.97GiB, used=427.75GiB
System, DUP: total=8.00MiB, used=60.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=5.00GiB, used=4.50GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=820.00KiB

After a thorough search of the internet for ENOSPC BTRFS I found
various resources and came to understand a little bit more. One thing
which broke my intuition severely is that I expected if there is a
large number of free GiB, I should expect things to continue to work.

In this case, for example, metadata has 0.5GiB free ("sounds like
plenty for metadata for one mkdir to me"). Data has 62GiB free. Why
would I get ENOSPC for a file rename?

I expected that if metadata needed more space, it would just eat it
from the 'data'. Now I believe this not to be the case and that it
wanted to allocate > 0.5GiB, and this is why I was getting ENOSPC.

I tried a rebalance with btrfs balance start -dusage=10 and tried
increasing the value until I saw reallocations in dmesg.

This spat out a large number of messages in dmesg, of this form:

> [376096.546353] BTRFS info (device dm-0): relocating block group 530457821184 flags 1
> [376010.736879] BTRFS info (device dm-0): 40 enospc errors during balance

(and a full stack trace at the end of this message).

The rebalance printed:

> ERROR: error during balancing '/path/to/volume' - No space left on device
> There may be more info in syslog - try dmesg | tail

Eventually, not knowing what else to do I had to take my escape hatch
and enlarge the volume. When I did this, metadata grew by 1GiB:

> Data, single: total=490.97GiB, used=427.75GiB
> System, DUP: total=8.00MiB, used=60.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=5.50GiB, used=4.50GiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=512.00MiB, used=0.00

A few questions:

* Why didn't the metadata grow before enlarging the disk?
* Why didn't the rebalance enable the metadata to grow?
* Why is it necessary to rebalance? Can't it automatically take some
free space from 'data'?
* Are my machine lockups related to the fact I was low on space?
* Can we improve the documentation/FAQ for this? I was scratching my
head in particular because my notion of free space definitely does not
match up with BTRFS', and I didn't find the FAQ very helpful for
getting out of this mess.
* It isn't documented on the wiki what enospc_debug is supposed to do,
so I couldn't tell whether I should have expected it to tell me
anything in my circumstances.
* What is the best course of action to take (other than enlarging the
disk or deleting files) if I encounter this situation again?

Thanks in advance,

- Peter

[376007.681938] ------------[ cut here ]------------
[376007.681957] WARNING: CPU: 1 PID: 27021 at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6946
use_block_rsv+0xfd/0x1a0 [btrfs]()
[376007.681958] BTRFS: block rsv returned -28
[376007.681959] Modules linked in: softdog tcp_diag inet_diag dm_crypt
ppdev xen_fbfront fb_sys_fops syscopyarea sysfillrect sysimgblt
i2c_piix4 serio_raw parport_pc parport mac_hid isofs xt_tcpudp
iptable_filter xt_owner ip_tables x_tables btrfs xor raid6_pq
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd floppy psmouse
[376007.681980] CPU: 1 PID: 27021 Comm: pam_script_ses_ Tainted: G
   W     3.15.7-031507-generic #201407281235
[376007.681981] Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/23/2014
[376007.681983]  0000000000001b22 ffff8800acca39d8 ffffffff8176f115
0000000000000007
[376007.681986]  ffff8800acca3a28 ffff8800acca3a18 ffffffff8106ceac
ffff8801efc37870
[376007.681989]  ffff88017db0ff00 ffff8801aedcd800 0000000000001000
ffff88001c987000
[376007.681992] Call Trace:
[376007.682000]  [<ffffffff8176f115>] dump_stack+0x46/0x58
[376007.682005]  [<ffffffff8106ceac>] warn_slowpath_common+0x8c/0xc0
[376007.682008]  [<ffffffff8106cf96>] warn_slowpath_fmt+0x46/0x50
[376007.682016]  [<ffffffffa00d9d1d>] use_block_rsv+0xfd/0x1a0 [btrfs]
[376007.682024]  [<ffffffffa00de687>] btrfs_alloc_free_block+0x57/0x220 [btrfs]
[376007.682027]  [<ffffffff8178033c>] ? __do_page_fault+0x28c/0x550
[376007.682031]  [<ffffffff8119749f>] ? page_add_file_rmap+0x6f/0xb0
[376007.682037]  [<ffffffffa00c8a3c>] btrfs_copy_root+0xfc/0x2b0 [btrfs]
[376007.682041]  [<ffffffff811c60b9>] ? memcg_check_events+0x29/0x50
[376007.682051]  [<ffffffffa013a583>] ? create_reloc_root+0x33/0x2c0 [btrfs]
[376007.682061]  [<ffffffffa013a743>] create_reloc_root+0x1f3/0x2c0 [btrfs]
[376007.682064]  [<ffffffff811dd073>] ? generic_permission+0xf3/0x120
[376007.682073]  [<ffffffffa0140eb8>] btrfs_init_reloc_root+0xb8/0xd0 [btrfs]
[376007.682082]  [<ffffffffa00ee967>]
record_root_in_trans.part.30+0x97/0x100 [btrfs]
[376007.682090]  [<ffffffffa00ee9f4>] record_root_in_trans+0x24/0x30 [btrfs]
[376007.682098]  [<ffffffffa00efeb1>]
btrfs_record_root_in_trans+0x51/0x80 [btrfs]
[376007.682106]  [<ffffffffa00f13d6>]
start_transaction.part.35+0x86/0x560 [btrfs]
[376007.682109]  [<ffffffff8132c197>] ? apparmor_capable+0x27/0x80
[376007.682117]  [<ffffffffa00f18d9>] start_transaction+0x29/0x30 [btrfs]
[376007.682125]  [<ffffffffa00f19a7>] btrfs_join_transaction+0x17/0x20 [btrfs]
[376007.682133]  [<ffffffffa00f7fa8>] btrfs_dirty_inode+0x58/0xe0 [btrfs]
[376007.682141]  [<ffffffffa00fcaf2>] btrfs_setattr+0xa2/0xf0 [btrfs]
[376007.682144]  [<ffffffff811eec74>] notify_change+0x1c4/0x3b0
[376007.682146]  [<ffffffff811dde96>] ? final_putname+0x26/0x50
[376007.682149]  [<ffffffff811d088d>] chown_common+0x16d/0x1a0
[376007.682153]  [<ffffffff811f2b08>] ? __mnt_want_write+0x58/0x70
[376007.682156]  [<ffffffff811d1a8f>] SyS_fchownat+0xbf/0x100
[376007.682159]  [<ffffffff811d1aed>] SyS_chown+0x1d/0x20
[376007.682163]  [<ffffffff817858bf>] tracesys+0xe1/0xe6
[376007.682165] ---[ end trace 1853311c87a5cd94 ]---

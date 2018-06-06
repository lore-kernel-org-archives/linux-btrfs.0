Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752058AbeFFOon (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 10:44:43 -0400
Date: Wed, 6 Jun 2018 16:41:55 +0200
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>
Cc: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in open_fs_devices
Message-ID: <20180606144155.GG3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <000000000000832e70056df8fb38@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <000000000000832e70056df8fb38@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 06:17:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1732a6f7800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
> dashboard link: https://syzkaller.appspot.com/bug?extid=909a5177749d7990ffa4
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=16ba31f7800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d4ac8f800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com
> 
> random: sshd: uninitialized urandom read (32 bytes read)
> BTRFS: device fsid ecf6f2a2-2997-48ae-b81e-1b00920efd9a devid 0 transid 0  
> /dev/loop0
> print_req_error: I/O error, dev loop1, sector 128
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> CPU: 0 PID: 4540 Comm: syz-executor962 Not tainted 4.17.0+ #86
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> RIP: 0010:open_fs_devices+0x7e8/0xc60 fs/btrfs/volumes.c:1124

Strange that this got that far, the image reconstructed from the
reproducer misses a lot of structural information that should prevent
mount:

superblock: bytenr=65536, device=zimg
---------------------------------------------------------
csum_type               0 (crc32c)
csum_size               4
csum                    0x8da4363a [DON'T MATCH]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
fsid                    ecf6f2a2-2997-48ae-b81e-1b00920efd9a
label                   
generation              0
root                    0
sys_array_size          0
chunk_root_generation   0
root_level              0
chunk_root              0
chunk_root_level        0
log_root                0
log_root_transid        0
log_root_level          0
total_bytes             0
bytes_used              0
sectorsize              0
nodesize                0
leafsize (deprecated)           0
stripesize              0
root_dir                0
num_devices             0
compat_flags            0x0
compat_ro_flags         0x0
incompat_flags          0x0
cache_generation        0
uuid_tree_generation    0
dev_item.uuid           00000000-0000-0000-0000-000000000000
dev_item.fsid           00000000-0000-0000-0000-000000000000 [DON'T MATCH]
dev_item.type           0
dev_item.total_bytes    0
dev_item.bytes_used     0
dev_item.io_align       0
dev_item.io_width       0
dev_item.sector_size    0
dev_item.devid          0
dev_item.dev_group      0
dev_item.seek_speed     0
dev_item.bandwidth      0
dev_item.generation     0
sys_chunk_array[2048]:
backup_roots[4]:

Possibly the ioctl (implementing device scan, triggered by udev) was called on
the loop device at some point. The checks there are not that strict as in the
mount path but also don't do anything else than associate the device id
and fsid.

The warning itself catches a state where the counter of devices has an
unexpected value, so that's probably worth further analysis.

We have pending patches to add more sanity checks to the scanning ioctl,
IIRC they were not in the state to be merged but could address the
warning (and also the one from the close_fs_devices).

I was not able to reproduce the warning on current master (that contains
the recent btrfs pull), will try on the exact commit reported.

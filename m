Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:47210 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933464AbdKAXJH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 19:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <CALaQ_hr1x32YyzBduFVhzpW=E_4=k5TiNLvtz9FP3NPJfCe6jg@mail.gmail.com>
References: <CALaQ_hr1x32YyzBduFVhzpW=E_4=k5TiNLvtz9FP3NPJfCe6jg@mail.gmail.com>
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Wed, 1 Nov 2017 18:09:06 -0500
Message-ID: <CALaQ_hrtvej-81hDVZriPg_WGsiqKPje1vQ_RpuEEwmtQ1hrAg@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:3182 - occurred during heavy NFS transfer
To: Nathan Royce <nroycea+kernel@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm guessing this is related.
I noticed my tv wasn't recording to my drive and when I tried to touch
a file on the drive, my console become unresponsive.
Trying to reboot took like 5 minutes to even stop the processes and in
the end couldn't unmount the drive and I had to cut the power to
finally get it to boot.

Nov 01 17:41:42 dd kernel: ------------[ cut here ]------------
Nov 01 17:41:42 dd kernel: WARNING: CPU: 0 PID: 227 at
fs/btrfs/file.c:547 btrfs_drop_extent_cache+0x4b4/0x4e8 [btrfs]
Nov 01 17:41:42 dd kernel: Modules linked in: arc4 tda18271 au8522_dig
au8522_common ath9k_htc ath9k_common au0828 btusb v4l2_common ath9k_hw
btintel videobuf2_vmalloc btbcm videobuf2_memops tveeprom bluetooth
ath dvb_core videobuf2_v4l2 videodev mac80211 ecdh_generic vi
Nov 01 17:41:42 dd kernel: CPU: 0 PID: 227 Comm: mount Not tainted
4.13.0-dirty #2
Nov 01 17:41:42 dd kernel: Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
Nov 01 17:41:42 dd kernel: [<c010f1ec>] (unwind_backtrace) from
[<c010b7ec>] (show_stack+0x10/0x14)
Nov 01 17:41:42 dd kernel: [<c010b7ec>] (show_stack) from [<c070eabc>]
(dump_stack+0x88/0x9c)
Nov 01 17:41:42 dd kernel: [<c070eabc>] (dump_stack) from [<c011c934>]
(__warn+0xe8/0x100)
Nov 01 17:41:42 dd kernel: [<c011c934>] (__warn) from [<c011ca44>]
(warn_slowpath_null+0x20/0x28)
Nov 01 17:41:42 dd kernel: [<c011ca44>] (warn_slowpath_null) from
[<bf198fa8>] (btrfs_drop_extent_cache+0x4b4/0x4e8 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf198fa8>] (btrfs_drop_extent_cache
[btrfs]) from [<bf199a64>] (__btrfs_drop_extents+0x618/0x1000 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf199a64>] (__btrfs_drop_extents [btrfs])
from [<bf19b944>] (btrfs_drop_extents+0x60/0x80 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf19b944>] (btrfs_drop_extents [btrfs])
from [<bf1cc010>] (replay_one_extent+0x718/0x818 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1cc010>] (replay_one_extent [btrfs])
from [<bf1cc95c>] (replay_one_buffer+0x248/0x780 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1cc95c>] (replay_one_buffer [btrfs])
from [<bf1c7420>] (walk_down_log_tree+0x144/0x38c [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1c7420>] (walk_down_log_tree [btrfs])
from [<bf1c7738>] (walk_log_tree+0xd0/0x1e8 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1c7738>] (walk_log_tree [btrfs]) from
[<bf1d0aa8>] (btrfs_recover_log_trees+0x21c/0x49c [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1d0aa8>] (btrfs_recover_log_trees
[btrfs]) from [<bf17e3dc>] (open_ctree+0x232c/0x2400 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf17e3dc>] (open_ctree [btrfs]) from
[<bf1504e0>] (btrfs_mount+0xecc/0xfa8 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf1504e0>] (btrfs_mount [btrfs]) from
[<c0220510>] (mount_fs+0x2c/0x164)
Nov 01 17:41:42 dd kernel: [<c0220510>] (mount_fs) from [<c023e1f8>]
(vfs_kern_mount.part.3+0x48/0xe0)
Nov 01 17:41:42 dd kernel: [<c023e1f8>] (vfs_kern_mount.part.3) from
[<bf14f964>] (btrfs_mount+0x350/0xfa8 [btrfs])
Nov 01 17:41:42 dd kernel: [<bf14f964>] (btrfs_mount [btrfs]) from
[<c0220510>] (mount_fs+0x2c/0x164)
Nov 01 17:41:42 dd kernel: [<c0220510>] (mount_fs) from [<c023e1f8>]
(vfs_kern_mount.part.3+0x48/0xe0)
Nov 01 17:41:42 dd kernel: [<c023e1f8>] (vfs_kern_mount.part.3) from
[<c02404e4>] (do_mount+0x1a8/0xc44)
Nov 01 17:41:42 dd kernel: [<c02404e4>] (do_mount) from [<c02412c8>]
(SyS_mount+0x54/0xc0)
Nov 01 17:41:42 dd kernel: [<c02412c8>] (SyS_mount) from [<c0107cfc>]
(__sys_trace_return+0x0/0x10)
Nov 01 17:41:42 dd kernel: ---[ end trace 35a26e49cc780cf9 ]---

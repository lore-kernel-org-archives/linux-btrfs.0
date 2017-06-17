Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47048 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbdFQO5b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 10:57:31 -0400
Date: Sat, 17 Jun 2017 16:57:25 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170617145725.y3wsex73aaf3vcje@angband.pl>
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
 <20170617083058.7z67mw4622oa7ajo@angband.pl>
 <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 17, 2017 at 09:28:30PM +0800, Qu Wenruo wrote:
> On 2017年06月17日 16:30, Adam Borowski wrote:
> > On Sat, Jun 17, 2017 at 03:43:18PM +0800, Qu Wenruo wrote:
> > > On 2017年06月16日 20:33, David Sterba wrote:
> > > > I see a lot of warnings from btrfs/094
> > > > 
> > > > [13458.628334] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=581632 phys=13078528 len=4096 flags=0x800
> > > 
> > > Strangely, I can't reproduce it either on my original branch (v4.12 with
> > > this patch), or torvalds/master (this patch is already merged with your
> > > renaming)
> > 
> > I for one get this a lot even in regular use.  Somehow, it always has Comm:
> > dpkg, despite the vast majority of activity on the system obviously not
> > being dpkg.
> 
> Is that with 0x800 flag? Or some other flag?

Always 0x2008:

[18330.861160] ------------[ cut here ]------------
[18330.861178] WARNING: CPU: 0 PID: 6735 at fs/btrfs/extent_io.c:4484 extent_fiemap+0x651/0x710
[18330.861180] Modules linked in: cp210x pl2303 usbserial nouveau video ttm
[18330.861197] CPU: 0 PID: 6735 Comm: dpkg Not tainted 4.12.0-rc5-debug-00017-g6afe0ac16d2b #3
[18330.861200] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[18330.861204] task: ffff8801229f2680 task.stack: ffffc9000351c000
[18330.861211] RIP: 0010:extent_fiemap+0x651/0x710
[18330.861214] RSP: 0018:ffffc9000351fd60 EFLAGS: 00010202
[18330.861218] RAX: ffff8802214ee000 RBX: 0000000000020000 RCX: 0000000000000000
[18330.861220] RDX: 0000000000000000 RSI: ffff880187ef64d0 RDI: ffff88021aa10000
[18330.861223] RBP: ffffc9000351fe60 R08: 0000000000020000 R09: 0000000000000000
[18330.861225] R10: ffffffffffffffff R11: ffff880187ef64d0 R12: 0000000000020000
[18330.861228] R13: 0000000000000000 R14: ffff880219a87900 R15: ffff880219a87900
[18330.861232] FS:  00007f2f3d45e400(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[18330.861234] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18330.861237] CR2: 0000556ab3a77d88 CR3: 000000011deec000 CR4: 00000000000006f0
[18330.861239] Call Trace:
[18330.861248]  ? btrfs_get_extent+0xa60/0xa60
[18330.861254]  btrfs_fiemap+0x4d/0x60
[18330.861260]  do_vfs_ioctl+0x3bc/0x5e0
[18330.861266]  SyS_ioctl+0x86/0xa0
[18330.861272]  entry_SYSCALL_64_fastpath+0x17/0x98
[18330.861276] RIP: 0033:0x7f2f3cd77e07
[18330.861279] RSP: 002b:00007fff17a92f08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[18330.861283] RAX: ffffffffffffffda RBX: 0000556ab35ead70 RCX: 00007f2f3cd77e07
[18330.861285] RDX: 00007fff17a92f50 RSI: 00000000c020660b RDI: 000000000000000a
[18330.861288] RBP: 0000000000000548 R08: 000000000000002b R09: 0000000000000052
[18330.861290] R10: 000000000000000a R11: 0000000000000246 R12: 00007fff17a92f20
[18330.861292] R13: 0000556ab15c1147 R14: ffffffffffffffff R15: 00000000000000a9
[18330.861295] Code: 04 fe ff ff 45 85 ed 4d 89 f7 0f 85 a6 fd ff ff 45 31 ed 80 7d 8f 00 48 8b 85 40 ff ff ff 48 8b b8 f0 01 00 00 0f 84 8b fd ff ff <0f> ff 4c 8b 6d a8 44 8b 65 88 48 c7 c6 f0 cc db 81 4c 8b 75 80 
[18330.861362] ---[ end trace fff11f4a8e5b834c ]---
[18330.861370] BTRFS warning (device sda1): unhandled fiemap cache detected: offset=0 phys=2435798867968 len=131072 flags=0x2008

> I'm trying fallocated file with my original branch, but still no chance to
> reproduce it though.

Seems to be perfectly reproducible for me.  Triggers a few times per dpkg run.

> > For me, linus/master with a handful of not possibly relevant patches
> > (in fs/btrfs/ I have dedupe and defrag on files opened ro, raid5/6 warning,
> > raid5/6 incompat flag clearing).
> 
> linus/master without any extra patch is still the same?
> And which commit?

git describe `git merge-base linux/master 6afe0ac16d2b`
v4.12-rc5

I've pushed my exact tree as https://github.com/kilobyte/linux kb-4.12-rc5
but there's not a single commit that could be possibly related.

I can retry with exactly linus/master but only after some stuff I forgot to
put on screen is done (should be an hour or two) -- looking for another setup
that reproduces this warning is probably a waste of time.

> I'm using 1439ccf73d9c07654fdd5b4969fd53c2feb8684d, at least it doesn't
> cause any warning the related test case, and I tried several combination
> with preallocated and written and hole, still no chance.
> 
> I also ran btrfs/* with my patch applied on v4.11-rc2 (sorry, that's the
> correct original patch base), and except some known bug, it doesn't cause
> anything special.

Can try that too if it'd be useful.


喵!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.

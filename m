Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44939 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaJNRAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 13:00:24 -0400
Message-ID: <543D569A.8000103@prnet.org>
Date: Tue, 14 Oct 2014 19:00:10 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs random filesystem corruption in kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>	<543C35C3.9070002@prnet.org>	<CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com> <pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
In-Reply-To: <pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The corruption seems to be worse than expected. In kernel 3.16.5 I can 
not mount this filesystem read/write.

I'm in progress of doing a tar - mkfs.btrfs - untar recovery and staying 
on 3.16.5 for now.

[   55.465584] parent transid verify failed on 51150848 wanted 272368 
found 276401
[   55.468415] parent transid verify failed on 918274048 wanted 273135 
found 274590
[   55.470915] parent transid verify failed on 508444672 wanted 274054 
found 276617
[   55.473758] parent transid verify failed on 18317623296 wanted 275876 
found 278431
[   55.476240] parent transid verify failed on 127254528 wanted 276488 
found 276490
[   55.479494] ------------[ cut here ]------------
[   55.479499] WARNING: CPU: 1 PID: 1723 at fs/btrfs/extent-tree.c:876 
btrfs_lookup_extent_info+0x44c/0x490()
[   55.479500] Modules linked in:
[   55.479502] CPU: 1 PID: 1723 Comm: ls Not tainted 3.16.5 #1
[   55.479502] Hardware name: ASUS All Series/H87M-PRO, BIOS 2101 07/21/2014
[   55.479503]  0000000000000000 0000000000000009 ffffffff816ff873 
0000000000000000
[   55.479504]  ffffffff81078261 ffff8807f7084770 ffff8807ed8ca000 
000000003dcf4000
[   55.479506]  ffff8807f7133de0 0000000000000000 ffffffff812be9bc 
0000000000004000
[   55.479507] Call Trace:
[   55.479511]  [<ffffffff816ff873>] ? dump_stack+0x41/0x51
[   55.479514]  [<ffffffff81078261>] ? warn_slowpath_common+0x81/0xb0
[   55.479515]  [<ffffffff812be9bc>] ? btrfs_lookup_extent_info+0x44c/0x490
[   55.479516]  [<ffffffff812c4998>] ? btrfs_alloc_free_block+0x2c8/0x450
[   55.479519]  [<ffffffff812af7df>] ? update_ref_for_cow+0x1ff/0x3f0
[   55.479520]  [<ffffffff812afc0a>] ? __btrfs_cow_block+0x23a/0x5a0
[   55.479522]  [<ffffffff812d14fd>] ? btrfs_buffer_uptodate+0x6d/0x80
[   55.479524]  [<ffffffff812b0136>] ? btrfs_cow_block+0x126/0x190
[   55.479525]  [<ffffffff812b43bd>] ? btrfs_search_slot+0x1fd/0xaa0
[   55.479527]  [<ffffffff812e07a3>] ? 
btrfs_truncate_inode_items+0x123/0x8e0
[   55.479529]  [<ffffffff812e204a>] ? btrfs_evict_inode+0x32a/0x490
[   55.479532]  [<ffffffff8112e02a>] ? unlock_new_inode+0x3a/0x60
[   55.479533]  [<ffffffff8113abb5>] ? __inode_wait_for_writeback+0x65/0xb0
[   55.479536]  [<ffffffff810a8f70>] ? wake_atomic_t_function+0x30/0x30
[   55.479537]  [<ffffffff8112f276>] ? evict+0xa6/0x160
[   55.479539]  [<ffffffff812e2c2d>] ? btrfs_orphan_cleanup+0x1ed/0x430
[   55.479540]  [<ffffffff812e31c8>] ? btrfs_lookup_dentry+0x358/0x4c0
[   55.479542]  [<ffffffff812e3339>] ? btrfs_lookup+0x9/0x30
[   55.479543]  [<ffffffff8111f6c4>] ? lookup_real+0x14/0x50
[   55.479545]  [<ffffffff81120292>] ? __lookup_hash+0x32/0x50
[   55.479546]  [<ffffffff81120938>] ? lookup_slow+0x48/0xc0
[   55.479547]  [<ffffffff811227bc>] ? path_lookupat+0x73c/0x770
[   55.479550]  [<ffffffff81164860>] ? posix_acl_xattr_get+0x40/0xb0
[   55.479551]  [<ffffffff81137a80>] ? generic_getxattr+0x50/0x80
[   55.479552]  [<ffffffff8112281e>] ? filename_lookup.isra.51+0x2e/0x90
[   55.479554]  [<ffffffff8112553f>] ? user_path_at_empty+0x5f/0xb0
[   55.479555]  [<ffffffff81125549>] ? user_path_at_empty+0x69/0xb0
[   55.479556]  [<ffffffff8111b690>] ? vfs_fstatat+0x40/0x90
[   55.479557]  [<ffffffff8111b862>] ? SyS_newlstat+0x12/0x30
[   55.479559]  [<ffffffff8111f89d>] ? path_put+0xd/0x20
[   55.479560]  [<ffffffff81138ab7>] ? SyS_getxattr+0x57/0x80
[   55.479562]  [<ffffffff817053d2>] ? system_call_fastpath+0x16/0x1b
[   55.479563] ---[ end trace a8ad56fd476f7474 ]---
[   55.479564] BTRFS: error (device sda2) in update_ref_for_cow:1018: 
errno=-30 Readonly filesystem
[   55.479565] BTRFS info (device sda2): forced readonly
[   55.479565] ------------[ cut here ]------------
[   55.479567] WARNING: CPU: 1 PID: 1723 at fs/btrfs/super.c:259 
__btrfs_abort_transaction+0x5a/0x140()
[   55.479567] BTRFS: Transaction aborted (error -30)
[   55.479568] Modules linked in:
[   55.479569] CPU: 1 PID: 1723 Comm: ls Tainted: G        W 3.16.5 #1
[   55.479569] Hardware name: ASUS All Series/H87M-PRO, BIOS 2101 07/21/2014
[   55.479570]  0000000000000000 0000000000000009 ffffffff816ff873 
ffff8807f2dcf788
[   55.479571]  ffffffff81078261 00000000ffffffe2 ffff8807ed8ca000 
ffff8807f7133de0
[   55.479572]  ffffffff8184d800 0000000000000488 ffffffff81078345 
ffffffff8197afd8
[   55.479573] Call Trace:
[   55.479574]  [<ffffffff816ff873>] ? dump_stack+0x41/0x51
[   55.479576]  [<ffffffff81078261>] ? warn_slowpath_common+0x81/0xb0
[   55.479578]  [<ffffffff81078345>] ? warn_slowpath_fmt+0x45/0x50
[   55.479579]  [<ffffffff812aa41a>] ? __btrfs_abort_transaction+0x5a/0x140
[   55.479580]  [<ffffffff812afe02>] ? __btrfs_cow_block+0x432/0x5a0
[   55.479582]  [<ffffffff812d14fd>] ? btrfs_buffer_uptodate+0x6d/0x80
[   55.479583]  [<ffffffff812b0136>] ? btrfs_cow_block+0x126/0x190
[   55.479584]  [<ffffffff812b43bd>] ? btrfs_search_slot+0x1fd/0xaa0
[   55.479586]  [<ffffffff812e07a3>] ? 
btrfs_truncate_inode_items+0x123/0x8e0
[   55.479587]  [<ffffffff812e204a>] ? btrfs_evict_inode+0x32a/0x490
[   55.479588]  [<ffffffff8112e02a>] ? unlock_new_inode+0x3a/0x60
[   55.479590]  [<ffffffff8113abb5>] ? __inode_wait_for_writeback+0x65/0xb0
[   55.479591]  [<ffffffff810a8f70>] ? wake_atomic_t_function+0x30/0x30
[   55.479592]  [<ffffffff8112f276>] ? evict+0xa6/0x160
[   55.479594]  [<ffffffff812e2c2d>] ? btrfs_orphan_cleanup+0x1ed/0x430
[   55.479595]  [<ffffffff812e31c8>] ? btrfs_lookup_dentry+0x358/0x4c0
[   55.479596]  [<ffffffff812e3339>] ? btrfs_lookup+0x9/0x30
[   55.479598]  [<ffffffff8111f6c4>] ? lookup_real+0x14/0x50
[   55.479599]  [<ffffffff81120292>] ? __lookup_hash+0x32/0x50
[   55.479600]  [<ffffffff81120938>] ? lookup_slow+0x48/0xc0
[   55.479601]  [<ffffffff811227bc>] ? path_lookupat+0x73c/0x770
[   55.479603]  [<ffffffff81164860>] ? posix_acl_xattr_get+0x40/0xb0
[   55.479605]  [<ffffffff81137a80>] ? generic_getxattr+0x50/0x80
[   55.479606]  [<ffffffff8112281e>] ? filename_lookup.isra.51+0x2e/0x90
[   55.479607]  [<ffffffff8112553f>] ? user_path_at_empty+0x5f/0xb0
[   55.479608]  [<ffffffff81125549>] ? user_path_at_empty+0x69/0xb0
[   55.479609]  [<ffffffff8111b690>] ? vfs_fstatat+0x40/0x90
[   55.479610]  [<ffffffff8111b862>] ? SyS_newlstat+0x12/0x30
[   55.479611]  [<ffffffff8111f89d>] ? path_put+0xd/0x20
[   55.479613]  [<ffffffff81138ab7>] ? SyS_getxattr+0x57/0x80
[   55.479614]  [<ffffffff817053d2>] ? system_call_fastpath+0x16/0x1b
[   55.479615] ---[ end trace a8ad56fd476f7475 ]---
[   55.479620] BTRFS error (device sda2): Error removing orphan entry, 
stopping orphan cleanup
[   55.479621] BTRFS critical (device sda2): could not do orphan cleanup -22
[   83.454294] parent transid verify failed on 51150848 wanted 272368 
found 276401
[   83.454945] parent transid verify failed on 918274048 wanted 273135 
found 274590
[   83.455601] parent transid verify failed on 508444672 wanted 274054 
found 276617
[   83.456251] parent transid verify failed on 18317623296 wanted 275876 
found 278431
[   83.456897] parent transid verify failed on 127254528 wanted 276488 
found 276490
[   84.647964] parent transid verify failed on 51150848 wanted 272368 
found 276401
[   84.648612] parent transid verify failed on 918274048 wanted 273135 
found 274590
[   84.649267] parent transid verify failed on 508444672 wanted 274054 
found 276617
[   84.649913] parent transid verify failed on 18317623296 wanted 275876 
found 278431
[   84.650557] parent transid verify failed on 127254528 wanted 276488 
found 276490


On 10/14/14 12:36 AM, Duncan wrote:
> Rich Freeman posted on Mon, 13 Oct 2014 16:42:14 -0400 as excerpted:
>
>> On Mon, Oct 13, 2014 at 4:27 PM, David Arendt <admin@prnet.org> wrote:
>>>  From my own experience and based on what other people are saying, I
>>> think there is a random btrfs filesystem corruption problem in kernel
>>> 3.17 at least related to snapshots, therefore I decided to post using
>>> another subject to draw attention from people not concerned about btrfs
>>> send to it. More information can be found in the brtfs send posts.
>>>
>>> Did the filesystem you tried to balance contain snapshots ? Read only
>>> ones ?
>> The filesystem contains numerous subvolumes and snapshots, many of which
>> are read-only.  I'm managing many with snapper.
>>
>> The similarity of the transid verify errors made me think this issue is
>> related, and the root cause may have nothing to do with btrfs send.
>>
>> As far as I can tell these errors aren't having any affect on my data -
>> hopefully the system is catching the problems before there are actual
>> disk writes/etc.
> Summarizing what I've seen on the threads...
>
> 1) The bug seems to be read-only snapshot related.  The connection to
> send is that send creates read-only snapshots, but people creating read-
> only snapshots for other purposes are now reporting the same problem, so
> it's not send, it's the read-only snapshots.
>
> 2) Writable snapshots haven't been implicated yet, and the working set
> from which the snapshots are taken doesn't seem to be affected, either.
> So in that sense it's not affecting ordinary usage, only the read-only
> snapshots themselves.
>
> 3) More problematic, however, is the fact that these apparently corrupted
> read-only snapshots often are not listed properly and can't be deleted,
> tho I'm not sure if that's /all/ the corrupted snapshots or only part of
> them. So while it may not affect ordinary operation in the short term,
> over time until there's a fix, people routinely doing read-only snapshots
> are going to be getting more and more of these undeletable snapshots, and
> depending on whether the eventual patch only prevents more or can
> actually fix the bad ones (possibly via btrfs check or the like),
> affected filesystems may ultimately have to be blown away and recreated
> with a fresh mkfs, in ordered to kill the currently undeletable snapshots.
>
> So the first thing to do would be to shut off whatever's making read-only
> snapshots, so you don't make the problem worse while it's being
> investigated.  For those who can do that without too big an interruption
> to their normal routine (who don't depend on send/receive, for instance),
> just keep it off for the time being.  For those who depend on read-only
> snapshots (send-receive for backup and the data is too valuable to not do
> the backups for a few days), consider switching back to 3.16-stable --
> from 3.16.3 at least, the patch for the compress bug is there, so that
> shouldn't be a problem.
>
> And if you're affected, be aware that until we have a fix, we don't know
> if it'll be possible to remove the affected and currently undeletable
> snapshots.  If it's not, at some point you'll need to do a fresh
> mkfs.btrfs, to get rid of the damage.  Since the bug doesn't appear to
> affect writable snapshots or the "head" from which snapshots are made,
> it's not urgent, and a full fix is likely to include a patch to detect
> and fix the problem as well, but until we know what the problem is we
> can't be sure of that, so be prepared to do that mkfs at some point, as
> at this point it's possible that's the only way you'll be able to kill
> the corrupted snapshots.
>
> 4) Total speculation on my part, but given the wanted transid (aka
> generation, in different contexts) is significantly lower than the found
> transid, and the fact that the problem appears to be limited to
> /read-only/ snapshots, my first suspicion is that something's getting
> updated that would normally apply to all snapshots, but the read-only
> nature of the snapshots is preventing the full update there.  The transid
> of the block is updated, but the snapshot being read-only is preventing
> update of the pointer in that snapshot accordingly.
>
> What I do /not/ know is whether the bug is that something's getting
> updated that should NOT be, and it's simply the read-only snapshots
> letting us know about it since the writable snapshots are fully updated,
> even if that breaks the snapshot (breaking writable snapshots in a
> different and currently undetected way), or if instead, it's a legitimate
> update, like a balance simply moving the snapshot around but not
> affecting it otherwise, and the bug is that the read-only snapshots
> aren't allowing the legitimate update.
>
> Either way, this more or less developed over the weekend, and it's Monday
> now, so the devs should be on it.  If it's anything like the 3.15/3.16
> compression bug, it'll take some time for them to properly trace it, and
> then to figure out an appropriate fix, but they will.  Chances are we'll
> have at least some decent progress on a trace by Friday, and maybe even a
> good-to-go patch. =:^)
>


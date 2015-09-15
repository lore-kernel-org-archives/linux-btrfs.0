Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27067 "EHLO
	m0041696.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751665AbbIONx2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 09:53:28 -0400
Subject: Re: [GIT PULL] Btrfs bug fixes
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Filipe Manana <fdmanana@kernel.org>
References: <1442283778-2342-1-git-send-email-fdmanana@kernel.org>
 <55F805AF.7040506@googlemail.com>
 <CAL3q7H7oHx7_ZzEQrwYpTSqJh+rdYXoyNKF9y1-R9NsvYY3A9w@mail.gmail.com>
 <55F82079.50007@googlemail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F822C8.1070202@fb.com>
Date: Tue, 15 Sep 2015 09:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <55F82079.50007@googlemail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2015 09:43 AM, Holger Hoffstätte wrote:
> On 09/15/15 14:58, Filipe Manana wrote:
>> On Tue, Sep 15, 2015 at 12:49 PM, Holger Hoffstätte
>> <holger.hoffstaette@googlemail.com> wrote:
>>> Hello Filipe,
>>>
>>> your mail comes just in time as I was typing a mail about this patch:
>>>
>>> On 09/15/15 04:22, fdmanana@kernel.org wrote:
>>>>        Btrfs: remove unnecessary locking of cleaner_mutex to avoid deadlock
>>>
>>> While it might seem to fix this particular problem, it seems there is either a new one or a bad interaction with either both or one of these from Josef, which came through around the same time:
>>>
>>> Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
>>> Btrfs: keep dropped roots in cache until transaciton commit
>>>
>>> With all three patches I have now seen something like this when deleting snapshots that contain enough data to also kick off the cleaner:
>>>
>>> [34851.791035] BTRFS info (device sdc1): leaf 865062912000 total ptrs 104 free space 1151
>>> (..lots of stuff that was supposed to be deleted..)
>>> [34851.791210] BTRFS critical (device sdc1): unable to update root key 1328 132 5341
>>> [34851.791795] ------------[ cut here ]------------
>>> [34851.792343] kernel BUG at fs/btrfs/root-tree.c:160!
>>> [34851.792889] invalid opcode: 0000 [#1] SMP
>>> [34851.793442] Modules linked in: nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel btrfs xor snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp crc32_pclmul crc32c_intel aesni_intel i915 raid6_pq aes_x86_64 glue_helper snd_hda_intel lrw gf128mul snd_hda_controller ablk_helper cryptd snd_hda_codec intel_gtt snd_hda_core i2c_algo_bit drm_kms_helper snd_pcm i2c_i801 usbhid drm snd_timer r8169 snd soundcore i2c_core mii video
>>> [34851.795328] CPU: 0 PID: 8807 Comm: sync Not tainted 4.1.7 #1
>>> [34851.795942] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
>>> [34851.796571] task: ffff88040cc91760 ti: ffff880352454000 task.ti: ffff880352454000
>>> [34851.797204] RIP: 0010:[<ffffffffa0435496>]  [<ffffffffa0435496>] btrfs_update_root+0x1e6/0x330 [btrfs]
>>> [34851.797869] RSP: 0018:ffff880352457cf8  EFLAGS: 00010292
>>> [34851.798521] RAX: 0000000000000045 RBX: ffff8802f0e59120 RCX: 0000000000000006
>>> [34851.799188] RDX: 0000000000000007 RSI: 0000000000000246 RDI: ffff88041f20d520
>>> [34851.799858] RBP: ffff880352457d58 R08: 0000000000000000 R09: 0000000000000410
>>> [34851.800534] R10: 00000000ffffffff R11: 0000000000000410 R12: 0000000000000001
>>> [34851.801208] R13: ffff8803fdf191df R14: ffff8803fdf19028 R15: ffff8800c96f4800
>>> [34851.801879] FS:  00007fa61e9bd700(0000) GS:ffff88041f200000(0000) knlGS:0000000000000000
>>> [34851.802566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [34851.803257] CR2: 00007fadc28e4000 CR3: 000000035247f000 CR4: 00000000000406f0
>>> [34851.803962] Stack:
>>> [34851.804661]  00003a6552457d88 00000000000000b0 ffff8803fdf191df ffff88030c3a8f18
>>> [34851.805389]  000000000000053a 0000000000000000 ffff880352457d58 ffff88030c3a8f18
>>> [34851.806107]  ffff88040cba6000 ffff88040cba6070 0000000000000002 ffff8803fdf19000
>>> [34851.806825] Call Trace:
>>> [34851.807536]  [<ffffffffa04bd900>] commit_fs_roots.isra.7+0x11b/0x14d [btrfs]
>>> [34851.808261]  [<ffffffffa0444325>] btrfs_commit_transaction+0x6b5/0xc10 [btrfs]
>>> [34851.808992]  [<ffffffff8107aec0>] ? wake_atomic_t_function+0x60/0x60
>>> [34851.809714]  [<ffffffffa04125b9>] btrfs_sync_fs+0x59/0x110 [btrfs]
>>> [34851.810438]  [<ffffffff811a3d70>] ? do_fsync+0x70/0x70
>>> [34851.811170]  [<ffffffff811a3d90>] sync_fs_one_sb+0x20/0x30
>>> [34851.811904]  [<ffffffff81176a56>] iterate_supers+0xb6/0x120
>>> [34851.812636]  [<ffffffff811a3eb5>] sys_sync+0x55/0x90
>>> [34851.813371]  [<ffffffff81573b97>] system_call_fastpath+0x12/0x6a
>>> [34851.814106] Code: 89 ff e8 de f9 ff ff 48 8b 45 b0 48 c7 c6 88 78 4c a0 49 8b bf f0 01 00 00 0f b6 48 08 4c 8b 40 09 48 8b 10 31 c0 e8 5a e8 fd ff <0f> 0b 49 8b 87 f0 01 00 00 f0 0f ba a8 78 0d 00 00 02 72 1d 48
>>> [34851.815868] RIP  [<ffffffffa0435496>] btrfs_update_root+0x1e6/0x330 [btrfs]
>>> [34851.816713]  RSP <ffff880352457cf8>
>>> [34851.817575] ---[ end trace cc3e428ae50170a3 ]---
>>>
>>> While this happened when issuing sync after a delayed snapshot delete, I've seen it also happen in the background. It's however not easily repeatable. Until now I've not been able to pinpoint whether the problem is only in the lock removal patch or an interaction with Josef's patches (or only there), but so far I have never seen this with only those two.
>>>
>>> Just thought you wanted to know - maybe you have an idea. Maybe there is a bad interaction (larger race window?) with keeping the snapshots pinned longer and the cleaner lock removal.
>>
>> Hi Holger,
>>
>> So at a first glance I don't think the patch that removes the locking
>> of cleaner mutex is the cause here. First it removed the locking in
>> the unmount and remount paths only (before attempts to delete unused
>> block groups), second the cleaner mutex is used only to serialize
>> snapshot removal and block group relocation/balance. Deleting unused
>> block groups is safe without the cleaner mutex and safe against a
>> transaction commit too, since before deleting any block group it will
>> start/join the transaction and block until the current transaction
>> ends its commit (if it's currently committing, such as in your trace).
>
> OK, thanks for the explanation.
>
>> I haven't tried Josef's patches, but I'll leave them running here and
>> see if I can reproduce that.
>
> Thanks.
>
>> When you get such error, are you doing an unmount or remount? If not,
>
> no, just snapshot delete & manual sync.
>
>> I really don't see how the patch introduces any problems, either with
>> or without Josef's changes.
>
> The interesting thing is that I ran with only your patch for a while
> without problems, but saw this error after merging Josef's patches
> and trying a quick snapshot delete *right away* (I remember that I also
> issued a sync then, so..). I chalked it up to stale module info - despite
> clean unmounting/rmmod/depmod/reload, which usually works fine for simple
> patches - and since it worked fine for several days in casual use after
> a clean reboot I let it slide. However it just happened again out of
> the blue while deleting a snapshot. I don't know whether issuing the
> sync was a deciding factor; I was more interested in seeing reclaimed
> space immediately.
>
> I've now reverted Josef's patches and have been running with only yours
> for a good hour, creating/deleting multiple/nested/chained snapshots
> with lots of blocks changed between them, with and without issuing sync
> as hard as I can - nothing. Also verified that the cleaner still does
> its thing (even deleting the very last data chunk) - no problems.
>
> Let me know what you think and how/when I can help or test.
>

This is my bug, sorry about that, I'll send something out to fix it 
right away.  Thanks,

Josef


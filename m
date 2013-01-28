Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:27770 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3A1Qzt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 11:55:49 -0500
Message-ID: <5106AD9D.5020906@giantdisaster.de>
Date: Mon, 28 Jan 2013 17:55:57 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com> <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com> <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com> <20130123075155.GE17162@liubo.jp.oracle.com> <CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com> <20130124005221.GA28406@liubo> <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com> <5102A76C.5050706@giantdisaster.de> <20130127131952.GB16722@liubo>
In-Reply-To: <20130127131952.GB16722@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[CC list reduced (my initial statement was that such dead_list
corruptions happen without the snapshot-aware defrag patch, by now the
contents is not related to the snapshot-aware defrag patch anymore)]

On Sun, 27 Jan 2013 21:19:53 +0800, Liu Bo wrote:
> On Fri, Jan 25, 2013 at 04:40:28PM +0100, Stefan Behrens wrote:
>> Well, the issue that I had reported on IRC some days ago which looks similar (the top part of the call trace is similar: iput -> evict -> destroy_inode -> btrfs_destroy_inode -> btrfs_add_dead_root -> list_add which warns in list_add in your case and crashes in my case) was without Liu Bo's "snapshot-aware defrag" patch. A 3.8.0-rc4 kernel and nothing else.
>>
>> The reproducer was to create and destroy subvolumes and snapshots. I used btrfs-receive to fill them with data. The crash happened on umount. Every time.
>>
>> del_fs_roots() is attempting to empty the dead_roots list, and via btrfs_destroy_inode() deeper in the call stack they are added back to the dead_roots list.
>>
> 
> Hi Stefan,
> 
> I assume that you're with 'inode_cache' option, since the iput() here
> refers to
> static void free_fs_root(struct btrfs_root *root)
> {                                                                                
>         iput(root->cache_inode);
> 	...
> }

Hi Liu Bo,

Yes, inode_cache is enabled.


> If my assumption is right, what about the following patch?
> 
> thanks,
> liubo
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 65f0367..01a601b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3220,6 +3220,13 @@ static void del_fs_roots(struct btrfs_fs_info
> *fs_info)
>  	struct btrfs_root *gang[8];
>  	int i;
>  
> +	list_for_each_entry(gang[0], &fs_info->dead_roots, root_list) {
> +		if (gang[0]->in_radix) {
> +			iput(root->cache_inode);
> +			root->cache_inode = NULL;
> +		}
> +	}
> +
>  	while (!list_empty(&fs_info->dead_roots)) {
>  		gang[0] = list_entry(fs_info->dead_roots.next,
>  				     struct btrfs_root, root_list);

No, this did not fix the problem (and I changed the patch and replaced
"root" with "gang[0]" for the compiler's satisfaction). Same stack trace
as before.

This happens without scrub or defrag running in parallel. The mount
options are compress=lzo,space_cache,inode_cache. I mount the
filesystem, create about 1000 subvols and snapshots, fill some data in
the subvolumes, delete all subvolumes, wait until "btrfs subvol list ...
| wc -l" prints 0, then immediately unmount the filesystem and then it
crashs.

Disabling the inode_cache mount option eliminates the crash.

BTW, when I reproduced this crash with 6600 outstanding subvolume
deletions, the next mount command took 40 minutes to return back to user
mode. The btrfs-cleaner thread was executing btrfs_clean_old_snapshots()
and was writing the superblocks everytime I looked on its stack. The
mount process was executing btrfs_find_orphan_roots() the first half of
the time and afterwards btrfs_orphan_cleanup() for the rest of the 40
minutes.


>> BUG: unable to handle kernel paging request at ffff88042503b830
>> IP: [<ffffffff814532b7>] __list_add+0x17/0xd0
>> PGD 1e0c063 PUD bf58e067 PMD bf6b7067 PTE 800000042503b160
>> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Modules linked in: btrfs bonding raid1 mpt2sas scsi_transport_sas raid_class
>> CPU 2
>> Pid: 10259, comm: umount Not tainted 3.8.0-rc4+ #16 Supermicro X8SIL/X8SIL
>> RIP: 0010:[<ffffffff814532b7>]  [<ffffffff814532b7>] __list_add+0x17/0xd0
>> RSP: 0018:ffff8802f67a1bd8  EFLAGS: 00010286
>> RAX: ffff880425b7c560 RBX: ffff880423ca2828 RCX: 0000000000000001
>> RDX: ffff88042503b828 RSI: ffff8804257794c0 RDI: ffff880423ca2828
>> RBP: ffff8802f67a1bf8 R08: 0000000000077850 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880423ca2000
>> R13: ffff880423ca2898 R14: 0000000000000000 R15: ffff8802f67a1d30
>> FS:  00007f6e89bba740(0000) GS:ffff88042ea00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: ffff88042503b830 CR3: 000000029a56c000 CR4: 00000000000007e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process umount (pid: 10259, threadinfo ffff8802f67a0000, task ffff880425b7c560)
>> Stack:
>>  ffffffffa00a414f ffff880423ca2000 ffff880423ca2000 ffff880423ca2898
>>  ffff8802f67a1c18 ffffffffa00a4170 ffff88042a60c1f8 ffff88042a60c1f8
>>  ffff8802f67a1c48 ffffffffa00b3180 ffff88042a60c1f8 ffff88042a60c280
>> Call Trace:
>>  [<ffffffffa00a414f>] ? btrfs_add_dead_root+0x1f/0x60 [btrfs]
>>  [<ffffffffa00a4170>] btrfs_add_dead_root+0x40/0x60 [btrfs]
>>  [<ffffffffa00b3180>] btrfs_destroy_inode+0x1d0/0x2d0 [btrfs]
>>  [<ffffffff811b5d17>] destroy_inode+0x37/0x60
>>  [<ffffffff811b5e4d>] evict+0x10d/0x1a0
>>  [<ffffffff811b65f5>] iput+0x105/0x190
>>  [<ffffffffa009bd68>] free_fs_root+0x18/0x90 [btrfs]
>>  [<ffffffffa009f1ab>] btrfs_free_fs_root+0x7b/0x90 [btrfs]
>>  [<ffffffffa009f26f>] del_fs_roots+0xaf/0xf0 [btrfs]
>>  [<ffffffffa00a0bc6>] close_ctree+0x1c6/0x300 [btrfs]
>>  [<ffffffff811b6a7c>] ? evict_inodes+0xec/0x100
>>  [<ffffffffa00763a4>] btrfs_put_super+0x14/0x20 [btrfs]
>>  [<ffffffff8119dfcc>] generic_shutdown_super+0x5c/0xe0
>>  [<ffffffff8119e0e1>] kill_anon_super+0x11/0x20
>>  [<ffffffffa007a3a5>] btrfs_kill_super+0x15/0x90 [btrfs]
>>  [<ffffffff8119f111>] ? deactivate_super+0x41/0x70
>>  [<ffffffff8119e4dd>] deactivate_locked_super+0x3d/0x70
>>  [<ffffffff8119f119>] deactivate_super+0x49/0x70
>>  [<ffffffff811ba772>] mntput_no_expire+0xd2/0x130
>>  [<ffffffff811bb621>] sys_umount+0x71/0x390
>>  [<ffffffff81983012>] system_call_fastpath+0x16/0x1b
>> Code: 48 83 c4 08 5b 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <4c> 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 4d 8b 45 00 4d 39
>> RIP  [<ffffffff814532b7>] __list_add+0x17/0xd0
>>  RSP <ffff8802f67a1bd8>
>> CR2: ffff88042503b830
>> ---[ end trace 5e44f1afc74751aa ]---


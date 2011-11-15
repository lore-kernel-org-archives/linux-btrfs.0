From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Tue, 15 Nov 2011 20:13:43 +0100
Message-ID: <4EC2B9E7.7020609@unilogicnetworks.net>
References: <4EBA54F2.3030801@unilogicnetworks.net> <20111109153552.GB1810@localhost.localdomain> <4EBBBFFA.5090000@unilogicnetworks.net> <20111114160342.GB1947@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111114160342.GB1947@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

We have patched the 3.1.1 kernel with your patch and after a short time 
one of the ceph osds crashed (core dumped) and I found this in the 
dmesg, please let me know if that's enough information or if you need more.

Stefan

[11226.207447] ------------[ cut here ]------------
[11226.212107] kernel BUG at fs/btrfs/extent-tree.c:3592!
[11226.217283] invalid opcode: 0000 [#1] SMP
[11226.221442] CPU 2
[11226.223288] Modules linked in: btrfs zlib_deflate lzo_compress md_mod 
target_core_mod configfs ahci libahci e1000e mptsas i7core_edac mptscsih 
mptbase scsi_transport_sas bnx2 i5000_edac edac_core ipmi_devintf 
ipmi_msghandler
[11226.243940]
[11226.245458] Pid: 6845, comm: ceph-osd Not tainted 
3.1.1-un13.1-64-nohz #1 Supermicro X8ST3/X8ST3
[11226.254349] RIP: 0010:[<ffffffffa011719a>]  [<ffffffffa011719a>] 
block_rsv_release_bytes+0x11a/0x120 [btrfs]
[11226.264316] RSP: 0018:ffff8805fb4e1cd8  EFLAGS: 00010206
[11226.269663] RAX: 0000000000000000 RBX: ffff8802c4303d20 RCX: 
000000000113be7a
[11226.276831] RDX: 0000000000018000 RSI: 0000000000000000 RDI: 
ffff8802c4303d58
[11226.284015] RBP: ffff8805fb4e1cf8 R08: ffffffffa0114475 R09: 
ffff8805fb4e1b98
[11226.291173] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[11226.298396] R13: 0000000000018000 R14: ffff8805fb280800 R15: 
0000000000000001
[11226.305579] FS:  00007f34edeae700(0000) GS:ffff88061fc40000(0000) 
knlGS:0000000000000000
[11226.313709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11226.319480] CR2: 00007f34e414e000 CR3: 00000005fc8f9000 CR4: 
00000000000006e0
[11226.326637] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[11226.333797] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[11226.340956] Process ceph-osd (pid: 6845, threadinfo ffff8805fb4e0000, 
task ffff880604292f00)
[11226.349578] Stack:
[11226.351614]  ffff8805e08d5de0 0000000000000001 ffff880602fd8400 
ffff8805e092fdc8
[11226.359164]  ffff8805fb4e1d08 ffffffffa01171cd ffff8805fb4e1d18 
ffffffffa011721f
[11226.366687]  ffff8805fb4e1d58 ffffffffa0139565 ffff8805fb4e1d58 
ffff8805e092fdc8
[11226.374270] Call Trace:
[11226.376776]  [<ffffffffa01171cd>] btrfs_block_rsv_release+0x2d/0x50 
[btrfs]
[11226.383852]  [<ffffffffa011721f>] 
btrfs_orphan_release_metadata+0x2f/0x40 [btrfs]
[11226.391430]  [<ffffffffa0139565>] btrfs_orphan_del+0xe5/0x150 [btrfs]
[11226.398044]  [<ffffffffa013ab27>] btrfs_truncate+0x587/0x600 [btrfs]
[11226.404510]  [<ffffffffa013abe7>] btrfs_setsize+0x47/0xc0 [btrfs]
[11226.410646]  [<ffffffffa013ad05>] btrfs_setattr+0xa5/0xd0 [btrfs]
[11226.416933]  [<ffffffff810e552a>] notify_change+0x10a/0x2b0
[11226.422548]  [<ffffffff810cb75f>] do_truncate+0x5f/0x90
[11226.427840]  [<ffffffff810cb8d4>] sys_truncate+0x144/0x1a0
[11226.433363]  [<ffffffff813fd97b>] system_call_fastpath+0x16/0x1b
[11226.439573] Code: 00 49 8d be b8 00 00 00 e8 64 5d 2e e1 4d 29 6e 20 
49 ff 46 48 41 fe 86 b8 00 00 00 eb a1 0f 1f 00 83 ca 04 41 88 54 24 41 
eb 87 <0f> 0b eb fe 66 90 55 48 89 f8 48 89 e5 48 89 f7 48 8b 80 20 01
[11226.460355] RIP  [<ffffffffa011719a>] 
block_rsv_release_bytes+0x11a/0x120 [btrfs]
[11226.468018]  RSP <ffff8805fb4e1cd8>
[11226.472008] ---[ end trace 7a5f53562ba538a2 ]---


On 11/14/2011 05:03 PM, Josef Bacik wrote:
> On Thu, Nov 10, 2011 at 01:13:46PM +0100, Stefan Kleijkers wrote:
>> Hello Josef,
>>
>> I have a workload running at the moment and I'm seeing a lot of
>> these (paste 1) messages in dmesg, this is the 3.1 kernel with your
>> patch applied.
>>
>> At the end I see a couple of the old warnings (paste 2).
>>
>> Futhermore it looks like after a while the speed of the filesystem
>> decreases. I have a workload with 20 rsyncs and a total of about
>> 1.5T data. I don't make it to have a full run.
>>
> Hmm well thats interesting, and you'd think that would tell me what was wrong
> but I'm still confused :).  Give this debug patch a whirl (unapply the last one
> I gave you and apply this one instead) and send me your dmesg if you get any of
> the new warnings.  Thanks,
>
> Josef
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 634608d..395a746 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -74,6 +74,7 @@ struct btrfs_inode {
>
>   	/* the space_info for where this inode's data allocations are done */
>   	struct btrfs_space_info *space_info;
> +	struct btrfs_block_rsv *rsv;
>
>   	/* full 64 bit generation number, struct vfs_inode doesn't have a big
>   	 * enough field for this.
> @@ -140,7 +141,7 @@ struct btrfs_inode {
>   	 */
>   	unsigned outstanding_extents;
>   	unsigned reserved_extents;
> -
> +	unsigned orphan_count;
>   	/*
>   	 * ordered_data_close is set by truncate when a file that used
>   	 * to have good data has been truncated to zero.  When it is set
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index fa4f602..c73f4b1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3721,6 +3721,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
>   	spin_lock(&block_rsv->lock);
>   	if (num_bytes == (u64)-1)
>   		num_bytes = block_rsv->size;
> +	BUG_ON(block_rsv->size<  num_bytes);
>   	block_rsv->size -= num_bytes;
>   	if (block_rsv->reserved>= block_rsv->size) {
>   		num_bytes = block_rsv->reserved - block_rsv->size;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e16215f..f59231c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2018,8 +2018,11 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
>
>   	if (!BTRFS_I(inode)->orphan_meta_reserved) {
>   		BTRFS_I(inode)->orphan_meta_reserved = 1;
> +		BTRFS_I(inode)->rsv = root->orphan_block_rsv;
>   		reserve = 1;
>   	}
> +	WARN_ON(BTRFS_I(inode)->orphan_count);
> +	BTRFS_I(inode)->orphan_count++;
>   	spin_unlock(&root->orphan_lock);
>
>   	/* grab metadata reservation from transaction handle */
> @@ -2061,9 +2064,12 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
>   	}
>
>   	if (BTRFS_I(inode)->orphan_meta_reserved) {
> +		WARN_ON(BTRFS_I(inode)->rsv != root->orphan_block_rsv);
>   		BTRFS_I(inode)->orphan_meta_reserved = 0;
>   		release_rsv = 1;
>   	}
> +	WARN_ON(!BTRFS_I(inode)->orphan_count);
> +	BTRFS_I(inode)->orphan_count--;
>   	spin_unlock(&root->orphan_lock);
>
>   	if (trans&&  delete_item) {
> @@ -6629,6 +6635,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>   	spin_lock_init(&ei->lock);
>   	ei->outstanding_extents = 0;
>   	ei->reserved_extents = 0;
> +	ei->orphan_count = 0;
>
>   	ei->ordered_data_close = 0;
>   	ei->orphan_meta_reserved = 0;
> @@ -6638,6 +6645,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>   	ei->force_compress = BTRFS_COMPRESS_NONE;
>
>   	ei->delayed_node = NULL;
> +	ei->rsv = NULL;
>
>   	inode =&ei->vfs_inode;
>   	extent_map_tree_init(&ei->extent_tree);


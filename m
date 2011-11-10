From: Stefan Kleijkers <stefan@unilogicnetworks.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Thu, 10 Nov 2011 13:13:46 +0100
Message-ID: <4EBBBFFA.5090000@unilogicnetworks.net>
References: <4EBA54F2.3030801@unilogicnetworks.net> <20111109153552.GB1810@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111109153552.GB1810@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

I have a workload running at the moment and I'm seeing a lot of these 
(paste 1) messages in dmesg, this is the 3.1 kernel with your patch applied.

At the end I see a couple of the old warnings (paste 2).

Futhermore it looks like after a while the speed of the filesystem 
decreases. I have a workload with 20 rsyncs and a total of about 1.5T 
data. I don't make it to have a full run.

Stefan

Paste 1:

[ 2433.606793] ------------[ cut here ]------------
[ 2433.606810] WARNING: at fs/btrfs/extent-tree.c:3592 
block_rsv_release_bytes+0x12b/0x140 [btrfs]()
[ 2433.606814] Hardware name: X8ST3
[ 2433.606816] Modules linked in: btrfs zlib_deflate lzo_compress md_mod 
target_core_mod configfs ahci libahci e1000e mptsas mptscsih mptbase 
i7core_edac scsi_transport_sas bnx2 i5000_edac edac_core ipmi_devintf 
ipmi_msghandler
[ 2433.606838] Pid: 6757, comm: ceph-osd Tainted: G        W   
3.1.1-rc1-un13.1-64-nohz #1
[ 2433.606841] Call Trace:
[ 2433.606848]  [<ffffffff81036e0a>] warn_slowpath_common+0x7a/0xb0
[ 2433.606858]  [<ffffffff81036e55>] warn_slowpath_null+0x15/0x20
[ 2433.606871]  [<ffffffffa011ed5b>] block_rsv_release_bytes+0x12b/0x140 
[btrfs]
[ 2433.606884]  [<ffffffffa011ed9d>] btrfs_block_rsv_release+0x2d/0x50 
[btrfs]
[ 2433.606897]  [<ffffffffa011eeaf>] 
btrfs_orphan_release_metadata+0x2f/0x40 [btrfs]
[ 2433.606915]  [<ffffffffa013f58d>] btrfs_orphan_del+0xbd/0xf0 [btrfs]
[ 2433.606932]  [<ffffffffa0140ab7>] btrfs_truncate+0x587/0x600 [btrfs]
[ 2433.606950]  [<ffffffffa0140b77>] btrfs_setsize+0x47/0xc0 [btrfs]
[ 2433.606968]  [<ffffffffa0140c95>] btrfs_setattr+0xa5/0xd0 [btrfs]
[ 2433.606973]  [<ffffffff810e552a>] notify_change+0x10a/0x2b0
[ 2433.606979]  [<ffffffff810cb75f>] do_truncate+0x5f/0x90
[ 2433.606985]  [<ffffffff810cb8d4>] sys_truncate+0x144/0x1a0
[ 2433.606991]  [<ffffffff813fd97b>] system_call_fastpath+0x16/0x1b
[ 2433.606995] ---[ end trace 5bebc7a2c26b1a32 ]---

Paste 2:

[ 2433.618285] ------------[ cut here ]------------
[ 2433.618306] WARNING: at fs/btrfs/inode.c:2198 
btrfs_orphan_commit_root+0xa8/0xc0 [btrfs]()
[ 2433.618310] Hardware name: X8ST3
[ 2433.618312] Modules linked in: btrfs zlib_deflate lzo_compress md_mod 
target_core_mod configfs ahci libahci e1000e mptsas mptscsih mptbase 
i7core_edac scsi_transport_sas bnx2 i5000_edac edac_core ipmi_devintf 
ipmi_msghandler
[ 2433.618334] Pid: 6756, comm: ceph-osd Tainted: G        W   
3.1.1-rc1-un13.1-64-nohz #1
[ 2433.618337] Call Trace:
[ 2433.618344]  [<ffffffff81036e0a>] warn_slowpath_common+0x7a/0xb0
[ 2433.618350]  [<ffffffff81036e55>] warn_slowpath_null+0x15/0x20
[ 2433.618368]  [<ffffffffa013f4b8>] btrfs_orphan_commit_root+0xa8/0xc0 
[btrfs]
[ 2433.618384]  [<ffffffffa0133c84>] commit_fs_roots+0xc4/0x1b0 [btrfs]
[ 2433.618396]  [<ffffffffa011a475>] ? btrfs_free_path+0x25/0x30 [btrfs]
[ 2433.618413]  [<ffffffffa0134c4e>] 
btrfs_commit_transaction+0x3be/0x7e0 [btrfs]
[ 2433.618429]  [<ffffffffa0133fe3>] ? wait_current_trans+0x23/0x110 [btrfs]
[ 2433.618445]  [<ffffffffa0135150>] ? join_transaction+0x20/0x250 [btrfs]
[ 2433.618451]  [<ffffffff81052870>] ? wake_up_bit+0x40/0x40
[ 2433.618463]  [<ffffffffa01134a7>] btrfs_sync_fs+0x47/0x70 [btrfs]
[ 2433.618468]  [<ffffffff8102d80b>] ? pick_next_task_fair+0x10b/0x190
[ 2433.618484]  [<ffffffffa0160754>] btrfs_ioctl+0x4f4/0xd60 [btrfs]
[ 2433.618491]  [<ffffffff810fffb5>] ? fsnotify+0x1e5/0x310
[ 2433.618498]  [<ffffffff810dca7b>] do_vfs_ioctl+0x9b/0x4f0
[ 2433.618504]  [<ffffffff810dcf1a>] sys_ioctl+0x4a/0x80
[ 2433.618510]  [<ffffffff813fd97b>] system_call_fastpath+0x16/0x1b
[ 2433.618514] ---[ end trace 5bebc7a2c26b1a33 ]---

On 11/09/2011 04:35 PM, Josef Bacik wrote:
> On Wed, Nov 09, 2011 at 11:24:50AM +0100, Stefan Kleijkers wrote:
>> Hello,
>>
>> I'm seeing a lot of warnings in dmesg with a BTRFS filesystem. I'm
>> using the 3.1 kernel, I found a patch for these warnings (
>> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2)
>> <http://marc.info/?l=linux-btrfs&m=131547325515336&w=2>, but that
>> patch has already been included in 3.1. Are there any other patches
>> I can try?
>>
>> I'm using BTRFS in combination with Ceph and it looks like after a
>> while with a high rsync workload that the IO stalls for some time,
>> could the warnings result in IO stall?
>>
> Can you run with this patch and see if you get warnings from extent-tree.c?
> Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0b044e5..144cd8e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3721,6 +3721,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
>   	spin_lock(&block_rsv->lock);
>   	if (num_bytes == (u64)-1)
>   		num_bytes = block_rsv->size;
> +	WARN_ON(block_rsv->size<  num_bytes);
>   	block_rsv->size -= num_bytes;
>   	if (block_rsv->reserved>= block_rsv->size) {
>   		num_bytes = block_rsv->reserved - block_rsv->size;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


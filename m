Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:59575 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3BSRxO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 12:53:14 -0500
Message-ID: <5123BC0D.9020304@giantdisaster.de>
Date: Tue, 19 Feb 2013 18:53:17 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
References: <CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com> <20130123075155.GE17162@liubo.jp.oracle.com> <CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com> <20130124005221.GA28406@liubo> <CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com> <5102A76C.5050706@giantdisaster.de> <20130127131952.GB16722@liubo> <5106AD9D.5020906@giantdisaster.de> <20130216064743.GA3124@liubo.jp.oracle.com> <51225C9E.5000603@giantdisaster.de> <20130219042912.GA25330@liubo.jp.oracle.com>
In-Reply-To: <20130219042912.GA25330@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19.02.2013 05:29, Liu Bo wrote:
> On Mon, Feb 18, 2013 at 05:53:50PM +0100, Stefan Behrens wrote:
>> On Sat, 16 Feb 2013 14:47:45 +0800, Liu Bo wrote:
>>> What about this patch(UNTESTED)?
>>>
>>> thanks,
>>> liubo
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index ca7ace7..dac9d4b 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -4142,9 +4142,14 @@ static void inode_tree_del(struct inode *inode)
>>>   	 * root_refs of 0, so this could end up dropping the tree root as a
>>>   	 * snapshot, so we need the extra !root->fs_info->tree_root check to
>>>   	 * make sure we don't drop it.
>>> +	 *
>>> +	 * Inode cache's inodes may be iput and add root back to dead roots
>>> +	 * list during killing super, which leads to use-after-free, so
>>> +	 * we need to check fs_info->closing to keep us from use-after-free.
>>>   	 */
>>>   	if (empty && btrfs_root_refs(&root->root_item) == 0 &&
>>> -	    root != root->fs_info->tree_root) {
>>> +	    root != root->fs_info->tree_root &&
>>> +	    btrfs_fs_closing(root->fs_info) > 1) {
>>>   		synchronize_srcu(&root->fs_info->subvol_srcu);
>>>   		spin_lock(&root->inode_lock);
>>>   		empty = RB_EMPTY_ROOT(&root->inode_tree);
>>
>> No improvement with this patch. The inode_cache causes a crash in __list_add.
>> I tested it on the latest cmason/for-linus with and without your patch.
>
> Ahh, I think I made a finger error,
>
> +	btrfs_fs_closing(root->fs_info) > 1) {
> SHOULD be
> +	btrfs_fs_closing(root->fs_info) < 2) {

Yes, this eliminates the crash. Thanks!


>> This script is an 100% reproducer on my test box:
>> mkfs.btrfs -d single -m raid1 /dev/sdc /dev/sdj /dev/sds /dev/sdt /dev/sdu /dev/sdv
>> mount /dev/sdc /mnt -o compress=lzo,space_cache,inode_cache
>> btrfs subv create /mnt/src
>> (cd ~/git/btrfs/fs/btrfs && tar cf - .) | (cd /mnt/src && tar xf -)
>> for i in `seq 2000`; do btrfs subv create /mnt/${i}; (cd /mnt/src && tar cf - .) | (cd /mnt/${i} && tar xf -); done
>> for i in /mnt/[0-9]*; do btrfs subv dele ${i}; done
>> sleep 45
>> umount /mnt
>
> With the latest cmason/for-linus(commit 6f60cbd3ae442cb35861bb522f388db123d42ec1
>   btrfs: access superblock via pagecache in scan_one_device),
> I ran this script several times with all good, I used two 40G disks,
> others remains same.

6f60cbd is my HEAD too. Maybe the DEBUG options in the .config make the 
difference although I seem to recall that the issue was also always 
there with a plain RHEL config.


> I'm wondering which line does 'del_fs_roots+0xaf/0xf0 [btrfs]' refer to?

del_fs_roots+0xaf/0xf0 [btrfs]:
0x2c2af is in del_fs_roots (fs/btrfs/disk-io.c:3243).
3238                    ret = 
radix_tree_gang_lookup(&fs_info->fs_roots_radix,
3239                                                 (void **)gang, 0,
3240                                                 ARRAY_SIZE(gang));
3241                    if (!ret)
3242                            break;
3243                    for (i = 0; i < ret; i++)
3244                            btrfs_free_fs_root(fs_info, gang[i]);
3245            }
3246    }
3247

Thanks for the patch :)


>> BUG: unable to handle kernel paging request at ffff88023517d830
>> IP: [<ffffffff814415f7>] __list_add+0x17/0xd0
>> PGD 1e0c063 PUD bf58e067 PMD bf737067 PTE 800000023517d160
>> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Modules linked in: btrfs raid1 mpt2sas scsi_transport_sas raid_class
>> CPU 2
>> Pid: 18503, comm: umount Not tainted 3.7.0+ #44 Supermicro X8SIL/X8SIL
>> RIP: 0010:[<ffffffff814415f7>]  [<ffffffff814415f7>] __list_add+0x17/0xd0
>> RSP: 0018:ffff88019e1abbd8  EFLAGS: 00010286
>> RAX: ffff8802353aa290 RBX: ffff880229e38828 RCX: 0000000000000001
>> RDX: ffff88023517d828 RSI: ffff8802327214c0 RDI: ffff880229e38828
>> RBP: ffff88019e1abbf8 R08: 000000000006e130 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880229e38000
>> R13: ffff880229e38898 R14: 0000000000000000 R15: ffff88019e1abd30
>> FS:  00007f75eabc4740(0000) GS:ffff880236a00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: ffff88023517d830 CR3: 000000019e17e000 CR4: 00000000000007e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process umount (pid: 18503, threadinfo ffff88019e1aa000, task ffff8802353aa290)
>> Stack:
>>   ffffffffa008619f ffff880229e38000 ffff880229e38000 ffff880229e38898
>>   ffff88019e1abc18 ffffffffa00861c0 ffff88012760dc38 ffff88012760dc38
>>   ffff88019e1abc48 ffffffffa0095358 ffff88012760dc38 ffff88012760dcc0
>> Call Trace:
>>   [<ffffffffa008619f>] ? btrfs_add_dead_root+0x1f/0x60 [btrfs]
>>   [<ffffffffa00861c0>] btrfs_add_dead_root+0x40/0x60 [btrfs]
>>   [<ffffffffa0095358>] btrfs_destroy_inode+0x1d8/0x2d0 [btrfs]
>>   [<ffffffff811af9c7>] destroy_inode+0x37/0x60
>>   [<ffffffff811afafd>] evict+0x10d/0x1a0
>>   [<ffffffff811b02a5>] iput+0x105/0x190
>>   [<ffffffffa007dda8>] free_fs_root+0x18/0x90 [btrfs]
>>   [<ffffffffa00811eb>] btrfs_free_fs_root+0x7b/0x90 [btrfs]
>>   [<ffffffffa00812af>] del_fs_roots+0xaf/0xf0 [btrfs]
>>   [<ffffffffa0082c16>] close_ctree+0x1c6/0x300 [btrfs]
>>   [<ffffffff811b072c>] ? evict_inodes+0xec/0x100
>>   [<ffffffffa00583a4>] btrfs_put_super+0x14/0x20 [btrfs]
>>   [<ffffffff8119805c>] generic_shutdown_super+0x5c/0xe0
>>   [<ffffffff81198171>] kill_anon_super+0x11/0x20
>>   [<ffffffffa005c3a5>] btrfs_kill_super+0x15/0x90 [btrfs]
>>   [<ffffffff811991a1>] ? deactivate_super+0x41/0x70
>>   [<ffffffff8119856d>] deactivate_locked_super+0x3d/0x70
>>   [<ffffffff811991a9>] deactivate_super+0x49/0x70
>>   [<ffffffff811b4332>] mntput_no_expire+0xd2/0x130
>>   [<ffffffff811b52e1>] sys_umount+0x71/0x390
>>   [<ffffffff81956992>] system_call_fastpath+0x16/0x1b
>>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab3KGBgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 20:36:52 -0500
Message-ID: <527AEDE0.7040607@cn.fujitsu.com>
Date: Thu, 07 Nov 2013 09:33:20 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, dustymabe@gmail.com
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting
 (bug #61951)
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net> <20131104174230.GK16855@localhost.localdomain> <527A7A6F.7080407@jan-o-sch.net> <20131106173444.GD27784@localhost.localdomain>
In-Reply-To: <20131106173444.GD27784@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/07/2013 01:34 AM, Josef Bacik wrote:
> On Wed, Nov 06, 2013 at 06:20:47PM +0100, Jan Schmidt wrote:
>>   
>> On Mon, November 04, 2013 at 18:42 (+0100), Josef Bacik wrote:
>>> On Thu, Oct 24, 2013 at 03:22:06PM +0200, Jan Schmidt wrote:
>>>> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
>>>> tracking is based on delayed refs. The owner of a tree block is set when a
>>>> tree block is allocated, it is never updated.
>>>>
>>>> When you allocate a tree block and then remove the subvolume that did the
>>>> allocation, the qgroup accounting for that removal is correct. However, the
>>>> removal was accounted again for each subvolume deletion that also referenced
>>>> the tree block, because accounting was erroneously based on the owner.
>>>>
>>>> Instead of queueing delayed refs for the non-existent owner, we now
>>>> queue delayed refs for the root being removed. This fixes the qgroup
>>>> accounting.
>>>>
>>>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>>> Tested-by: <dustymabe@gmail.com>
>>> This breaks btrfs/003, I'm kicking it out.
>> Can you be a bit more specific? Works fine here.
>>
> It's blowing up on the balance, so maybe make a bigger fs and balance that so
> you can see it?  It's exploding in __btrfs_free_extent because we can't find the
> ref we're trying to drop, so I assume you've broken the dropping of the reloc
> root part where it depends on you giving it btrfs_header_owner() instead of
> root->root_key.objectid as when we cow blocks that belong to the reloc root we
> leave the owner set to whoever owned the block originally and not the reloc
> root.  Thanks,
True, i did hit the problem when i test balance regression with btrfs-next.

[ 8468.976315] WARNING: CPU: 3 PID: 14993 at fs/btrfs/extent-tree.c:5783 
__btrfs_free_extent+0x9af/0xa20 [btrfs]()
[ 8468.976316] Modules linked in: btrfs(O) ebtable_nat ip6t_REJECT tun 
xt_CHECKSUM fuse bridge stp llc bluetooth rfkill iptable_mangle 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ebtable_filter ebtables ip6table_filter ip6_tables libcrc32c xor 
zlib_deflate raid6_pq r8169 snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm wmi iTCO_wdt 
iTCO_vendor_support lpc_ich uinput snd_page_alloc snd_timer i2c_i801 snd 
soundcore acpi_cpufreq mperf mfd_core mii pcspkr i915 i2c_algo_bit 
drm_kms_helper drm i2c_core video [last unloaded: btrfs]
[ 8468.976339] CPU: 3 PID: 14993 Comm: btrfs Tainted: G           O 
3.11.0+ #17
[ 8468.976340] Hardware name: LENOVO QiTianM4350/ , BIOS F1KT52AUS 
05/24/2013
[ 8468.976341]  0000000000000009 ffff880087c11828 ffffffff8158f948 
0000000000000000
[ 8468.976343]  ffff880087c11860 ffffffff8104febd ffff8800ba554ab0 
000000001b64c000
[ 8468.976344]  0000000000000000 00000000fffffffe 0000000000000000 
ffff880087c11870
[ 8468.976346] Call Trace:
[ 8468.976351]  [<ffffffff8158f948>] dump_stack+0x45/0x56
[ 8468.976354]  [<ffffffff8104febd>] warn_slowpath_common+0x7d/0xa0
[ 8468.976356]  [<ffffffff8104ff9a>] warn_slowpath_null+0x1a/0x20
[ 8468.976361]  [<ffffffffa0501c3f>] __btrfs_free_extent+0x9af/0xa20 [btrfs]
[ 8468.976366]  [<ffffffffa04f4000>] ? btrfs_free_path+0x20/0x30 [btrfs]
[ 8468.976375]  [<ffffffffa055fcf4>] ? 
btrfs_merge_delayed_refs+0x1f4/0x3d0 [btrfs]
[ 8468.976380]  [<ffffffffa05061ac>] run_clustered_refs+0x46c/0x1080 [btrfs]
[ 8468.976386]  [<ffffffffa050aae0>] btrfs_run_delayed_refs+0xe0/0x540 
[btrfs]
[ 8468.976393]  [<ffffffffa0562ac3>] ? 
alloc_backref_node.isra.14+0x23/0x60 [btrfs]
[ 8468.976399]  [<ffffffffa0560910>] ? tree_insert+0x50/0x60 [btrfs]
[ 8468.976406]  [<ffffffffa0568229>] ? 
btrfs_reloc_post_snapshot+0xf9/0x360 [btrfs]
[ 8468.976412]  [<ffffffffa05198b6>] create_pending_snapshot+0x706/0x920 
[btrfs]
[ 8468.976418]  [<ffffffffa0519b3a>] create_pending_snapshots+0x6a/0x90 
[btrfs]
[ 8468.976424]  [<ffffffffa051afd4>] 
btrfs_commit_transaction+0x384/0x970 [btrfs]
[ 8468.976431]  [<ffffffffa054b22a>] btrfs_mksubvol.isra.30+0x3da/0x460 
[btrfs]
[ 8468.976437]  [<ffffffffa054b38e>] 
btrfs_ioctl_snap_create_transid+0xde/0x170 [btrfs]
[ 8468.976443]  [<ffffffffa054b57b>] 
btrfs_ioctl_snap_create_v2+0xeb/0x130 [btrfs]
[ 8468.976450]  [<ffffffffa054de9a>] btrfs_ioctl+0x11da/0x27a0 [btrfs]
[ 8468.976453]  [<ffffffff8113a420>] ? handle_mm_fault+0x210/0x310
[ 8468.976456]  [<ffffffff815997f4>] ? __do_page_fault+0x1f4/0x500
[ 8468.976457]  [<ffffffff81140995>] ? do_mmap_pgoff+0x305/0x3c0
[ 8468.976460]  [<ffffffff8117dd9d>] do_vfs_ioctl+0x2dd/0x4b0
[ 8468.976461]  [<ffffffff8117dff1>] SyS_ioctl+0x81/0xa0
[ 8468.976463]  [<ffffffff81599b0e>] ? do_page_fault+0xe/0x10
[ 8468.976465]  [<ffffffff8159e202>] system_call_fastpath+0x16/0x1b

Thanks,
Wang
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


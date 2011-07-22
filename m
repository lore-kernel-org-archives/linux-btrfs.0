From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Fri, 22 Jul 2011 17:12:35 +0800
Message-ID: <4E293F03.8030209@cn.fujitsu.com>
References: <1311096438-sup-1263@shiny> <1311182478-sup-9986@shiny> <4E277757.9070504@jp.fujitsu.com> <4E27BD4F.6020900@gmx.net> <1311295973-sup-3312@shiny> <4E28F750.9060405@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E28F750.9060405@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 22 Jul 2011 12:06:40 +0800, Miao Xie wrote:
> On thu, 21 Jul 2011 20:53:24 -0400, Chris Mason wrote:
>>>>> Hi everyone,
>>>>>
>>>>> I just rebased Josef's enospc fixes into integration-test, it sho=
uld fix
>>>>> the warnings in extent-tree.c
>>>>>
>>>>
>>>> Unfortunately, I got the following messages.
>>>>
>>>>
>>>> Jul 21 09:41:22 luna kernel: ------------[ cut here ]------------
>>>> Jul 21 09:41:22 luna kernel: WARNING: at fs/btrfs/extent-tree.c:55=
64 btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]()
>>>> Jul 21 09:41:22 luna kernel: Hardware name: PRIMERGY
>>>> Jul 21 09:41:22 luna kernel: Modules linked in: btrfs zlib_deflate=
 crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand ac=
pi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_l=
og dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_co=
re iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_=
core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sa=
s floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded:=
 microcode]
>>>> Jul 21 09:41:22 luna kernel: Pid: 5517, comm: btrfs-endio-wri Tain=
ted: G        W   2.6.39btrfs-tc1+ #1
>>>> Jul 21 09:41:22 luna kernel: Call Trace:
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff8106004f>] warn_slowpath_co=
mmon+0x7f/0xc0
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff810600aa>] warn_slowpath_nu=
ll+0x1a/0x20
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa044a068>] btrfs_alloc_rese=
rved_file_extent+0xf8/0x100 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa0464121>] insert_reserved_=
file_extent.clone.0+0x201/0x270 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa0468c0b>] btrfs_finish_ord=
ered_io+0x2eb/0x360 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff8106fe23>] ? try_to_del_tim=
er_sync+0x83/0xe0
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa0468cd0>] btrfs_writepage_=
end_io_hook+0x50/0xa0 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa049a3c6>] end_compressed_b=
io_write+0x86/0xf0 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff8117f96d>] bio_endio+0x1d/0=
x40
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa0459d84>] end_workqueue_fn=
+0xf4/0x130 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa048841e>] worker_loop+0x13=
e/0x540 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_wo=
rker+0x2d0/0x2d0 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_wo=
rker+0x2d0/0x2d0 [btrfs]
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff81081756>] kthread+0x96/0xa=
0
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff81486004>] kernel_thread_he=
lper+0x4/0x10
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff810816c0>] ? kthread_worker=
_fn+0x1a0/0x1a0
>>>> Jul 21 09:41:22 luna kernel: [<ffffffff81486000>] ? gs_change+0x13=
/0x13
>>>> Jul 21 09:41:22 luna kernel: ---[ end trace 02c1fa3044677043 ]---
>>>>
>>>
>>> a very similar warning here, but without compression involved:
>>
>> Ok, these are probably the enospc fixes.  Could you please try bisec=
ting
>> out some of Josef's patches?
>=20
> I did binary search and found the following patch led to this problem=
=2E
>=20
> commit 97ffc7d564f55787c7d9ea557d5d30d9ecb2f003
> Author: Josef Bacik <josef@redhat.com>
> Date:   Fri Jul 15 18:29:11 2011 +0000
>=20
>     Btrfs: don't be as agressive with delalloc metadata reservations
>    =20
>     Currently we reserve enough space to COW an entirely full btree f=
or every ex
>     we have reserved for an inode.  This _sucks_, because you only ne=
ed to COW o
>     and then everybody else is ok.  Unfortunately we don't know we'll=
 all be abl
>     get into the same transaction so that's what we have had to do.  =
But the glo
>     reserve holds a reservation large enough to cover a large percent=
age of all=20
>     metadata currently in the fs.  So all we really need to account f=
or is any n
>     blocks that we may allocate.  So fix this by
> =E3=80=80=E3=80=80=E2=80=A6=E2=80=A6

Please ignore my analysis and patch, which can not fix the problem.

> The reason is the calculation of the reservation is wrong, the nodes =
in the search path
> may be split, and new nodes may be created, but the above patch didn'=
t reserve space for
> these new nodes.
>=20
> The following patch can fix it. Though my test passed, I still need A=
rne's verification
> to make sure it can fix all the reported problems.
> Arne, Could you test it for me?
>=20
> Subject: [PATCH] Btrfs: fix wrong calculation of the reservation for =
the transaction
>=20
> At worst, Btrfs may split all the nodes in the search path, so we mus=
t take
> those new nodes into account when we calculate the space that need be=
 reserved.
>=20
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d813a67..4f23819 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2133,10 +2133,16 @@ static inline bool btrfs_mixed_space_info(str=
uct btrfs_space_info *space_info)
>  }
> =20
>  /* extent-tree.c */
> +/*
> + * This inline function is used to calc the size of new nodes/leaves=
 that we
> + * may create. At worst, we may split all the nodes in the path and =
create
> + * two leaves for the insertion of one item.
> + */
>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *=
root,
>  						 unsigned num_items)
>  {
> -	return root->leafsize * 3 * num_items;
> +	return (root->leafsize * 2 + root->nodesize * (BTRFS_MAX_LEVEL - 1)=
) *
> +	       num_items;
>  }
> =20
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

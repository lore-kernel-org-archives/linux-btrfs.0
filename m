From: Christian Brunner <chb@muc.de>
Subject: Re: Delayed inode operations not doing the right thing with enospc
Date: Tue, 12 Jul 2011 17:20:20 +0200
Message-ID: <CAO47_--zux0kiKsY9Edinj98ihoXP4n2ton+j5LgdpNJv9hLbQ@mail.gmail.com>
References: <4DE92BF2.1060905@redhat.com>
	<4DED8143.3090803@cn.fujitsu.com>
	<4DEE9263.1000802@redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEE9263.1000802@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/6/7 Josef Bacik <josef@redhat.com>:
> On 06/06/2011 09:39 PM, Miao Xie wrote:
>> On fri, 03 Jun 2011 14:46:10 -0400, Josef Bacik wrote:
>>> I got a lot of these when running stress.sh on my test box
>>>
>>>
>>>
>>> This is because use_block_rsv() is having to do a
>>> reserve_metadata_bytes(), which shouldn't happen as we should have
>>> reserved enough space for those operations to complete. =A0This is
>>> happening because use_block_rsv() will call get_block_rsv(), which =
if
>>> root->ref_cows is set (which is the case on all fs roots) we will u=
se
>>> trans->block_rsv, which will only have what the current transaction
>>> starter had reserved.
>>>
>>> What needs to be done instead is we need to have a block reserve th=
at
>>> any reservation that is done at create time for these inodes is mig=
rated
>>> to this special reserve, and then when you run the delayed inode it=
ems
>>> stuff you set trans->block_rsv to the special block reserve so the
>>> accounting is all done properly.
>>>
>>> This is just off the top of my head, there may be a better way to d=
o it,
>>> I've not actually looked that the delayed inode code at all.
>>>
>>> I would do this myself but I have a ever increasing list of shit to=
 do
>>> so will somebody pick this up and fix it please? =A0Thanks,
>>
>> Sorry, it's my miss.
>> I forgot to set trans->block_rsv to global_block_rsv, since we have =
migrated
>> the space from trans_block_rsv to global_block_rsv.
>>
>> I'll fix it soon.
>>
>
> There is another problem, we're failing xfstest 204. =A0I tried makin=
g
> reserve_metadata_bytes commit the transaction regardless of whether o=
r
> not there were pinned bytes but the test just hung there. =A0Usually =
it
> takes 7 seconds to run and I ctrl+c'ed it after a couple of minutes.
> 204 just creates a crap ton of files, which is what is killing us.
> There needs to be a way to start flushing delayed inode items so we c=
an
> reclaim the space they are holding onto so we don't get enospc, and i=
t
> needs to be better than just committing the transaction because that =
is
> dog slow. =A0Thanks,
>
> Josef

Is there a solution for this?

I'm running a 2.6.38.8 kernel with all the btrfs patches from 3.0rc7
(except the pluging). When starting a ceph rebuild on the btrfs
volumes I get a lot of warnings from block_rsv_use_bytes in
use_block_rsv:

[ 2157.922054] ------------[ cut here ]------------
[ 2157.927270] WARNING: at fs/btrfs/extent-tree.c:5683
btrfs_alloc_free_block+0x1f8/0x360 [btrfs]()
[ 2157.937123] Hardware name: ProLiant DL180 G6
[ 2157.942132] Modules linked in: btrfs zlib_deflate libcrc32c bonding
ipv6 pcspkr serio_raw iTCO_wdt iTCO_vendor_support ghes hed
i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
usb_storage [last unloaded: scsi_wait_scan]
[ 2157.967386] Pid: 10280, comm: btrfs-freespace Tainted: P        W
2.6.38.8-1.fits.4.el6.x86_64 #1
[ 2157.977554] Call Trace:
[ 2157.980383]  [<ffffffff8106482f>] ? warn_slowpath_common+0x7f/0xc0
[ 2157.987382]  [<ffffffff8106488a>] ? warn_slowpath_null+0x1a/0x20
[ 2157.994192]  [<ffffffffa0240b88>] ?
btrfs_alloc_free_block+0x1f8/0x360 [btrfs]
[ 2158.002354]  [<ffffffffa026eda8>] ? read_extent_buffer+0xd8/0x1d0 [b=
trfs]
[ 2158.010014]  [<ffffffffa0231132>] ? split_leaf+0x142/0x8c0 [btrfs]
[ 2158.016990]  [<ffffffffa022a29b>] ? generic_bin_search+0x19b/0x210 [=
btrfs]
[ 2158.024784]  [<ffffffffa022ca1a>] ? btrfs_leaf_free_space+0x8a/0xe0 =
[btrfs]
[ 2158.032627]  [<ffffffffa0231f83>] ? btrfs_search_slot+0x6d3/0x7a0 [b=
trfs]
[ 2158.040325]  [<ffffffffa0244942>] ?
btrfs_csum_file_blocks+0x632/0x830 [btrfs]
[ 2158.048477]  [<ffffffffa026ffda>] ? clear_extent_bit+0x17a/0x440 [bt=
rfs]
[ 2158.056026]  [<ffffffffa024ffc5>] ? add_pending_csums+0x45/0x70 [btr=
fs]
[ 2158.063530]  [<ffffffffa0252dad>] ?
btrfs_finish_ordered_io+0x22d/0x360 [btrfs]
[ 2158.071755]  [<ffffffffa0252f2c>] ?
btrfs_writepage_end_io_hook+0x4c/0xa0 [btrfs]
[ 2158.080172]  [<ffffffffa027049b>] ?
end_bio_extent_writepage+0x13b/0x180 [btrfs]
[ 2158.088505]  [<ffffffff815406fb>] ? schedule_timeout+0x17b/0x2e0
[ 2158.095258]  [<ffffffff8118964d>] ? bio_endio+0x1d/0x40
[ 2158.101171]  [<ffffffffa0247764>] ? end_workqueue_fn+0xf4/0x130 [btr=
fs]
[ 2158.108621]  [<ffffffffa027b30e>] ? worker_loop+0x13e/0x540 [btrfs]
[ 2158.115703]  [<ffffffffa027b1d0>] ? worker_loop+0x0/0x540 [btrfs]
[ 2158.122563]  [<ffffffffa027b1d0>] ? worker_loop+0x0/0x540 [btrfs]
[ 2158.129413]  [<ffffffff81086356>] ? kthread+0x96/0xa0
[ 2158.135093]  [<ffffffff8100ce44>] ? kernel_thread_helper+0x4/0x10
[ 2158.141913]  [<ffffffff810862c0>] ? kthread+0x0/0xa0
[ 2158.147467]  [<ffffffff8100ce40>] ? kernel_thread_helper+0x0/0x10
[ 2158.154287] ---[ end trace 55e53c726a04ecd7 ]---

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

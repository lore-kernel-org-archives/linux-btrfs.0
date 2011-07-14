From: Christian Brunner <chb@muc.de>
Subject: Re: Delayed inode operations not doing the right thing with enospc
Date: Thu, 14 Jul 2011 09:27:24 +0200
Message-ID: <CAO47_-9qn31AfGQksLnRAreMudBcOQz0UnXxmhFC4cSQW5ZHFQ@mail.gmail.com>
References: <4DE92BF2.1060905@redhat.com>
	<4DED8143.3090803@cn.fujitsu.com>
	<4DEE9263.1000802@redhat.com>
	<CAO47_--zux0kiKsY9Edinj98ihoXP4n2ton+j5LgdpNJv9hLbQ@mail.gmail.com>
	<4E1DB22F.1060405@redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E1DB22F.1060405@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/13 Josef Bacik <josef@redhat.com>:
> On 07/12/2011 11:20 AM, Christian Brunner wrote:
>> 2011/6/7 Josef Bacik <josef@redhat.com>:
>>> On 06/06/2011 09:39 PM, Miao Xie wrote:
>>>> On fri, 03 Jun 2011 14:46:10 -0400, Josef Bacik wrote:
>>>>> I got a lot of these when running stress.sh on my test box
>>>>>
>>>>>
>>>>>
>>>>> This is because use_block_rsv() is having to do a
>>>>> reserve_metadata_bytes(), which shouldn't happen as we should hav=
e
>>>>> reserved enough space for those operations to complete. =A0This i=
s
>>>>> happening because use_block_rsv() will call get_block_rsv(), whic=
h if
>>>>> root->ref_cows is set (which is the case on all fs roots) we will=
 use
>>>>> trans->block_rsv, which will only have what the current transacti=
on
>>>>> starter had reserved.
>>>>>
>>>>> What needs to be done instead is we need to have a block reserve =
that
>>>>> any reservation that is done at create time for these inodes is m=
igrated
>>>>> to this special reserve, and then when you run the delayed inode =
items
>>>>> stuff you set trans->block_rsv to the special block reserve so th=
e
>>>>> accounting is all done properly.
>>>>>
>>>>> This is just off the top of my head, there may be a better way to=
 do it,
>>>>> I've not actually looked that the delayed inode code at all.
>>>>>
>>>>> I would do this myself but I have a ever increasing list of shit =
to do
>>>>> so will somebody pick this up and fix it please? =A0Thanks,
>>>>
>>>> Sorry, it's my miss.
>>>> I forgot to set trans->block_rsv to global_block_rsv, since we hav=
e migrated
>>>> the space from trans_block_rsv to global_block_rsv.
>>>>
>>>> I'll fix it soon.
>>>>
>>>
>>> There is another problem, we're failing xfstest 204. =A0I tried mak=
ing
>>> reserve_metadata_bytes commit the transaction regardless of whether=
 or
>>> not there were pinned bytes but the test just hung there. =A0Usuall=
y it
>>> takes 7 seconds to run and I ctrl+c'ed it after a couple of minutes=
=2E
>>> 204 just creates a crap ton of files, which is what is killing us.
>>> There needs to be a way to start flushing delayed inode items so we=
 can
>>> reclaim the space they are holding onto so we don't get enospc, and=
 it
>>> needs to be better than just committing the transaction because tha=
t is
>>> dog slow. =A0Thanks,
>>>
>>> Josef
>>
>> Is there a solution for this?
>>
>> I'm running a 2.6.38.8 kernel with all the btrfs patches from 3.0rc7
>> (except the pluging). When starting a ceph rebuild on the btrfs
>> volumes I get a lot of warnings from block_rsv_use_bytes in
>> use_block_rsv:
>>
>
> Ok I think I've got this nailed down. =A0Will you run with this patch=
 and make sure the warnings go away? =A0Thanks,

I'm sorry, I'm still getting a lot of warnings like the one below.

I've also noticed, that I'm not getting these messages when the
free_space_cache is disabled.

Christian

[  697.398097] ------------[ cut here ]------------
[  697.398109] WARNING: at fs/btrfs/extent-tree.c:5693
btrfs_alloc_free_block+0x1f8/0x360 [btrfs]()
[  697.398111] Hardware name: ProLiant DL180 G6
[  697.398112] Modules linked in: btrfs zlib_deflate libcrc32c bonding
ipv6 serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
usb_storage [last unloaded: scsi_wait_scan]
[  697.398122] Pid: 6591, comm: btrfs-freespace Tainted: P        W
3.0.0-1.fits.1.el6.x86_64 #1
[  697.398124] Call Trace:
[  697.398128]  [<ffffffff810630af>] warn_slowpath_common+0x7f/0xc0
[  697.398131]  [<ffffffff8106310a>] warn_slowpath_null+0x1a/0x20
[  697.398142]  [<ffffffffa022cb88>] btrfs_alloc_free_block+0x1f8/0x360=
 [btrfs]
[  697.398156]  [<ffffffffa025ae08>] ? read_extent_buffer+0xd8/0x1d0 [b=
trfs]
[  697.398316]  [<ffffffffa021d112>] split_leaf+0x142/0x8c0 [btrfs]
[  697.398325]  [<ffffffffa021629b>] ? generic_bin_search+0x19b/0x210 [=
btrfs]
[  697.398334]  [<ffffffffa0218a1a>] ? btrfs_leaf_free_space+0x8a/0xe0 =
[btrfs]
[  697.398344]  [<ffffffffa021df63>] btrfs_search_slot+0x6d3/0x7a0 [btr=
fs]
[  697.398355]  [<ffffffffa0230942>] btrfs_csum_file_blocks+0x632/0x830=
 [btrfs]
[  697.398369]  [<ffffffffa025c03a>] ? clear_extent_bit+0x17a/0x440 [bt=
rfs]
[  697.398382]  [<ffffffffa023c009>] add_pending_csums+0x49/0x70 [btrfs=
]
[  697.398395]  [<ffffffffa023ef5d>] btrfs_finish_ordered_io+0x22d/0x36=
0 [btrfs]
[  697.398408]  [<ffffffffa023f0dc>]
btrfs_writepage_end_io_hook+0x4c/0xa0 [btrfs]
[  697.398422]  [<ffffffffa025c4fb>]
end_bio_extent_writepage+0x13b/0x180 [btrfs]
[  697.398425]  [<ffffffff81558b5b>] ? schedule_timeout+0x17b/0x2e0
[  697.398436]  [<ffffffffa02336d9>] ? end_workqueue_fn+0xe9/0x130 [btr=
fs]
[  697.398439]  [<ffffffff8118f24d>] bio_endio+0x1d/0x40
[  697.398451]  [<ffffffffa02336e4>] end_workqueue_fn+0xf4/0x130 [btrfs=
]
[  697.398464]  [<ffffffffa02671de>] worker_loop+0x13e/0x540 [btrfs]
[  697.398477]  [<ffffffffa02670a0>] ? btrfs_queue_worker+0x2d0/0x2d0 [=
btrfs]
[  697.398490]  [<ffffffffa02670a0>] ? btrfs_queue_worker+0x2d0/0x2d0 [=
btrfs]
[  697.398493]  [<ffffffff81085896>] kthread+0x96/0xa0
[  697.398496]  [<ffffffff81563844>] kernel_thread_helper+0x4/0x10
[  697.398499]  [<ffffffff81085800>] ? kthread_worker_fn+0x1a0/0x1a0
[  697.398502]  [<ffffffff81563840>] ? gs_change+0x13/0x13
[  697.398503] ---[ end trace 8c77269b0de3f0fb ]---
[  697.432225] ------------[ cut here ]------------
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21500 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2JaAuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:50:37 -0400
Message-ID: <509075CD.6000208@oracle.com>
Date: Wed, 31 Oct 2012 08:50:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Franke <ttfranke@googlemail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
References: <20121031005736.306fd86b@googlemail.com> <50907514.3060400@oracle.com>
In-Reply-To: <50907514.3060400@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:47 AM, Liu Bo wrote:
> On 10/31/2012 07:57 AM, Franke wrote:
>> Hello,
>>
>> I have been having some crashes like this. Since I upgraded to 3.6.4 they have become common. The crashes happen pretty randomly during normal system usage. After the syslog messages the system stays semi usable for a minute, but when I run any new program it hangs. I had to downgrade to 3.6.2 to get my system usable again.
>>
>> Is there any way I can help find the cause of those crashes? 
>>
> 
> Hi Franke,
> 
> Jan and me have worked together to fix the mentioned bugs days before, and you can try
> Jan's git repo and see if it works in your situation:
> 
>           git.jan-o-sch.net for-chris

it should be
           git.jan-o-sch.net/btrfs-unstable for-chris

> 
> (It contains most of patches related to backref walking.)
> 
> thanks,
> liubo
> 
>> thanks,
>> Tobias Franke
>>
>> logs here:
>> https://www.dropbox.com/s/1f6gh4k0zl2t5zq/btrfs_hangs_3-4-6.log
>>
>> It starts like this:
>> Oct 30 22:42:36 localhost kernel: btrfs bad mapping eb start 982689189888 len 4096, wanted 4424 17
>> Oct 30 22:42:36 localhost kernel: ------------[ cut here ]------------
>> Oct 30 22:42:36 localhost kernel: WARNING: at fs/btrfs/extent_io.c:4661 map_private_extent_buffer+0x83/0xc9()
>> Oct 30 22:42:36 localhost kernel: Hardware name: A780L3L
>> Oct 30 22:42:36 localhost kernel: Modules linked in: hwmon_vid snd_hda_codec_hdmi nvidia(PO) snd_hda_codec_realtek snd_hda_intel snd_hda_codec i2c_piix4 k10temp
>> Oct 30 22:42:36 localhost kernel: Pid: 7143, comm: btrfs-endio-wri Tainted: P           O 3.6.4-gentoo #1
>> Oct 30 22:42:36 localhost kernel: Call Trace:
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81030181>] ? warn_slowpath_common+0x78/0x8c
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8127dc2e>] ? map_private_extent_buffer+0x83/0xc9
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81249353>] ? generic_bin_search.clone.50+0xaa/0x130
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8124c11a>] ? btrfs_search_old_slot+0x333/0x6ad
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812a737d>] ? __resolve_indirect_refs+0x147/0x4b1
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812a70bf>] ? __add_keyed_refs.clone.6+0x9e/0x215
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812a6ba6>] ? __add_prelim_ref+0x3a/0xb9
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812a7d54>] ? find_parent_nodes+0x553/0x7ca
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812458b8>] ? leaf_space_used+0xaf/0xd7
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812a8044>] ? btrfs_find_all_roots+0x79/0xd4
>> Oct 30 22:42:36 localhost kernel: [<ffffffff812aa1d0>] ? btrfs_qgroup_account_ref+0xd2/0x4a8
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81278482>] ? alloc_extent_state+0x58/0x9d
>> Oct 30 22:42:36 localhost kernel: [<ffffffff810e8245>] ? kmem_cache_free+0x12/0xbd
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81253c93>] ? btrfs_delayed_refs_qgroup_accounting+0x9e/0xca
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81266723>] ? __btrfs_end_transaction+0x4e/0x293
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8126bb26>] ? btrfs_finish_ordered_io+0x2e1/0x332
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8103cfae>] ? run_timer_softirq+0x2c2/0x2c2
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81286398>] ? worker_loop+0x174/0x4c0
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81286224>] ? btrfs_queue_worker+0x261/0x261
>> Oct 30 22:42:36 localhost kernel: [<ffffffff81286224>] ? btrfs_queue_worker+0x261/0x261
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8104b293>] ? kthread+0x81/0x89
>> Oct 30 22:42:36 localhost kernel: [<ffffffff815de774>] ? kernel_thread_helper+0x4/0x10
>> Oct 30 22:42:36 localhost kernel: [<ffffffff8104b212>] ? kthread_freezable_should_stop+0x52/0x52
>> Oct 30 22:42:36 localhost kernel: [<ffffffff815de770>] ? gs_change+0xb/0xb
>> Oct 30 22:42:36 localhost kernel: ---[ end trace cb2d15ce8c2d83ec ]---
>> Oct 30 22:42:36 localhost kernel: ------------[ cut here ]------------
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


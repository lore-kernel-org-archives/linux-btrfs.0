Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48487 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab2EVKaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 06:30:00 -0400
Received: by yhmm54 with SMTP id m54so5254127yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 03:30:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB9BDBA.2030806@cn.fujitsu.com>
References: <20120514142048.GA3260@localhost.localdomain>
	<20120516192035.GA1910@localhost.localdomain>
	<4FB4D30C.7030301@tuxadero.com>
	<20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
	<4FB51577.5090100@tuxadero.com>
	<20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
	<CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
	<4FB56B21.7070800@tuxadero.com>
	<20120518144759.GA1892@localhost.localdomain>
	<4FB685C9.2050607@tuxadero.com>
	<20120518190105.GB1892@localhost.localdomain>
	<4FB9BDBA.2030806@cn.fujitsu.com>
Date: Tue, 22 May 2012 12:29:59 +0200
Message-ID: <CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
Subject: Re: Ceph on btrfs 3.4rc
From: Christian Brunner <christian@brunner-muc.de>
To: miaox@cn.fujitsu.com
Cc: Josef Bacik <josef@redhat.com>, Martin Mailand <martin@tuxadero.com>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/5/21 Miao Xie <miaox@cn.fujitsu.com>:
> Hi Josef,
>
> On fri, 18 May 2012 15:01:05 -0400, Josef Bacik wrote:
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index 9b9b15f..492c74f 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -57,9 +57,6 @@ struct btrfs_inode {
>>       /* used to order data wrt metadata */
>>       struct btrfs_ordered_inode_tree ordered_tree;
>>
>> -     /* for keeping track of orphaned inodes */
>> -     struct list_head i_orphan;
>> -
>>       /* list of all the delalloc inodes in the FS.  There are times we need
>>        * to write all the delalloc pages to disk, and this list is used
>>        * to walk them all.
>> @@ -156,6 +153,8 @@ struct btrfs_inode {
>>       unsigned dummy_inode:1;
>>       unsigned in_defrag:1;
>>       unsigned delalloc_meta_reserved:1;
>> +     unsigned has_orphan_item:1;
>> +     unsigned doing_truncate:1;
>
> I think the problem is we should not use the different lock to protect the bit fields which
> are stored in the same machine word. Or some bit fields may be covered by the others when
> someone change those fields. Could you try to declare ->delalloc_meta_reserved and ->has_orphan_item
> as a integer?

I have tried changing it to:

struct btrfs_inode {
        unsigned orphan_meta_reserved:1;
        unsigned dummy_inode:1;
        unsigned in_defrag:1;
-       unsigned delalloc_meta_reserved:1;
+       int delalloc_meta_reserved;
+       int has_orphan_item;
+       int doing_truncate;

The strange thing is, that I'm no longer hitting the BUG_ON, but the
old WARNING (no additional messages):

[351021.157124] ------------[ cut here ]------------
[351021.162400] WARNING: at fs/btrfs/inode.c:2103
btrfs_orphan_commit_root+0xf7/0x100 [btrfs]()
[351021.171812] Hardware name: ProLiant DL180 G6
[351021.176867] Modules linked in: btrfs zlib_deflate libcrc32c xfs
exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
iTCO_vendor_support ixgbe dca mdio i7core_edac edac_core
iomemory_vsl(PO) hpsa squashfs [last unloaded: btrfs]
[351021.200236] Pid: 9837, comm: btrfs-transacti Tainted: P        W
O 3.3.5-1.fits.1.el6.x86_64 #1
[351021.210126] Call Trace:
[351021.212957]  [<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
[351021.219758]  [<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
[351021.226385]  [<ffffffffa03eb627>]
btrfs_orphan_commit_root+0xf7/0x100 [btrfs]
[351021.234461]  [<ffffffffa03e6976>] commit_fs_roots+0xc6/0x1c0 [btrfs]
[351021.241669]  [<ffffffffa0438c61>] ?
btrfs_run_delayed_items+0xf1/0x160 [btrfs]
[351021.249841]  [<ffffffffa03e7ae4>]
btrfs_commit_transaction+0x584/0xa50 [btrfs]
[351021.258006]  [<ffffffffa03e8432>] ? start_transaction+0x92/0x310 [btrfs]
[351021.265580]  [<ffffffff81070aa0>] ? wake_up_bit+0x40/0x40
[351021.271719]  [<ffffffffa03e2f3b>] transaction_kthread+0x26b/0x2e0 [btrfs]
[351021.279405]  [<ffffffffa03e2cd0>] ?
btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
[351021.288934]  [<ffffffffa03e2cd0>] ?
btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
[351021.298449]  [<ffffffff8107040e>] kthread+0x9e/0xb0
[351021.303989]  [<ffffffff8158c5a4>] kernel_thread_helper+0x4/0x10
[351021.310691]  [<ffffffff81070370>] ? kthread_freezable_should_stop+0x70/0x70
[351021.318555]  [<ffffffff8158c5a0>] ? gs_change+0x13/0x13
[351021.324479] ---[ end trace 9adc7b36a3e66833 ]---
[351710.339482] ------------[ cut here ]------------
[351710.344754] WARNING: at fs/btrfs/inode.c:2103
btrfs_orphan_commit_root+0xf7/0x100 [btrfs]()
[351710.354165] Hardware name: ProLiant DL180 G6
[351710.359222] Modules linked in: btrfs zlib_deflate libcrc32c xfs
exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
iTCO_vendor_support ixgbe dca mdio i7core_edac edac_core
iomemory_vsl(PO) hpsa squashfs [last unloaded: btrfs]
[351710.382569] Pid: 9797, comm: kworker/5:0 Tainted: P        W  O
3.3.5-1.fits.1.el6.x86_64 #1
[351710.392075] Call Trace:
[351710.394901]  [<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
[351710.401750]  [<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
[351710.408414]  [<ffffffffa03eb627>]
btrfs_orphan_commit_root+0xf7/0x100 [btrfs]
[351710.416528]  [<ffffffffa03e6976>] commit_fs_roots+0xc6/0x1c0 [btrfs]
[351710.423775]  [<ffffffffa03e7ae4>]
btrfs_commit_transaction+0x584/0xa50 [btrfs]
[351710.431983]  [<ffffffff810127a3>] ? __switch_to+0x153/0x440
[351710.438352]  [<ffffffff81070aa0>] ? wake_up_bit+0x40/0x40
[351710.444529]  [<ffffffffa03e7fb0>] ?
btrfs_commit_transaction+0xa50/0xa50 [btrfs]
[351710.452894]  [<ffffffffa03e7fcf>] do_async_commit+0x1f/0x30 [btrfs]
[351710.459979]  [<ffffffff81068959>] process_one_work+0x129/0x450
[351710.466576]  [<ffffffff8106b7fb>] worker_thread+0x17b/0x3c0
[351710.472884]  [<ffffffff8106b680>] ? manage_workers+0x220/0x220
[351710.479472]  [<ffffffff8107040e>] kthread+0x9e/0xb0
[351710.485029]  [<ffffffff8158c5a4>] kernel_thread_helper+0x4/0x10
[351710.491731]  [<ffffffff81070370>] ? kthread_freezable_should_stop+0x70/0x70
[351710.499640]  [<ffffffff8158c5a0>] ? gs_change+0x13/0x13
[351710.505590] ---[ end trace 9adc7b36a3e66834 ]---


Regards,
Christian

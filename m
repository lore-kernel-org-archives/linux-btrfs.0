Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3GaJry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 05:47:54 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6V9lrJB002363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 09:47:54 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6V9lq32023684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 09:47:53 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6V9lqsI026754
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 09:47:52 GMT
Message-ID: <51F8DE99.6060704@oracle.com>
Date: Wed, 31 Jul 2013 17:53:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug] balance BUG at fs/btrfs/relocation.c:886
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


3.11.0-rc3+


------------------
[  225.586356] kernel BUG at fs/btrfs/relocation.c:886!
[  225.586362] invalid opcode: 0000 [#1] SMP
::
[  225.586431] Call Trace:
[  225.586440]  [<ffffffffa0055cd1>] ? 
btree_read_extent_buffer_pages.clone.4+0xd1/0x120 [btrfs]
[  225.586447]  [<ffffffffa00a9123>] relocate_tree_blocks+0x363/0x6d0 
[btrfs]
[  225.586454]  [<ffffffffa00a242c>] ? tree_insert+0x4c/0x60 [btrfs]
[  225.586461]  [<ffffffffa00a97b3>] relocate_block_group+0x323/0x640 
[btrfs]
[  225.586469]  [<ffffffffa00aa14f>] 
btrfs_relocate_block_group+0x19f/0x2c0 [btrfs]
[  225.586477]  [<ffffffffa0081768>] btrfs_relocate_chunk+0x88/0x770 [btrfs]
[  225.586485]  [<ffffffffa0076211>] ? read_extent_buffer+0xb1/0x110 [btrfs]
[  225.586493]  [<ffffffffa00724bf>] ? btrfs_get_token_64+0x5f/0xf0 [btrfs]
[  225.586500]  [<ffffffffa0082c51>] btrfs_balance+0x891/0xe40 [btrfs]
[  225.586508]  [<ffffffffa008c3ff>] ? kzalloc+0xf/0x20 [btrfs]
[  225.586552]  [<ffffffff8113d445>] ? __kmalloc+0xf5/0x170
[  225.586560]  [<ffffffffa008cfca>] btrfs_ioctl_balance+0x21a/0x330 [btrfs]
[  225.586568]  [<ffffffffa008fd95>] btrfs_ioctl+0x585/0x1660 [btrfs]
[  225.586575]  [<ffffffff8111d9eb>] ? handle_mm_fault+0x12b/0x230
[  225.586590]  [<ffffffff811556d4>] do_vfs_ioctl+0x84/0x4c0
[  225.586616]  [<ffffffff812867cd>] ? inode_has_perm.clone.0+0x2d/0x30
[  225.586618]  [<ffffffff8128891a>] ? file_has_perm+0x8a/0xa0
[  225.586625]  [<ffffffff8114ec71>] ? final_putname+0x21/0x50
[  225.586627]  [<ffffffff81155ba1>] SyS_ioctl+0x91/0xa0
[  225.586670]  [<ffffffff8181fed2>] system_call_fastpath+0x16/0x1b
-------------------


                 if (btrfs_root_level(&root->root_item) == cur->level) {
                         /* tree root */
                         BUG_ON(btrfs_root_bytenr(&root->root_item) !=
                                cur->bytenr);
                         if (should_ignore_root(root))
                                 list_add(&cur->list, &useless);
                         else
                                 cur->root = root;
                         break;
                 }



reproducer:

---------------------
# mkfs.btrfs /dev/sdb -f

# btrfsck --init-csum /dev/sdb
Creating a new CRC tree
Checking filesystem on /dev/sdb
UUID: 51576f7d-af1d-458b-b3c5-02eda4b3c39f
checking extents
Reinit crc root
found 0 bytes used err is 0
total csum bytes: 0
total tree bytes: 0
total fs tree bytes: 0
total extent tree bytes: 0
btree space waste bytes: 0
file data blocks allocated: 0
  referenced 0
Btrfs v0.20-rc1-413-g3f4deb0-dirty

# mount /dev/sdb /btrfs

# btrfs fi bal /btrfs
Segmentation fault
#
---------------------

  Any idea how do we fix this ?
  ( other than don't run --init-csum :-) )




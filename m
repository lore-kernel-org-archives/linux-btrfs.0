Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50780 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab2FZGJS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 02:09:18 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5Q69G61011215
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 06:09:16 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q5Q69FRu002039
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 06:09:15 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q5Q69FOi029881
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 01:09:15 -0500
Message-ID: <4FE95146.2030707@oracle.com>
Date: Tue, 26 Jun 2012 14:05:58 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [Report] corrupted root csum tree result in segfault.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




# mkfs.btrfs /dev/sdd && btrfs-debug-tree -R /dev/sdd | egrep checksum

::
checksum tree key (CSUM_TREE ROOT_ITEM 0) 29376512 level 0

# btrfs-corrupt-block -l 29376512 /dev/sdd
mirror 1 logical 29376512 physical 37765120 device /dev/sdd
corrupting 29376512 copy 1
mirror 2 logical 29376512 physical 145113088 device /dev/sdd
corrupting 29376512 copy 2
# btrfsck /dev/sdd
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
read block failed check_tree_block
Couldn't setup csum tree
checking extents
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
Check tree block failed, want=29376512, have=0
read block failed check_tree_block  <---- !!
Segmentation fault (core dumped)  <--- !!
#
----------------


read_tree_block frees buf and returns NULL
----------------
struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
                                      u32 blocksize, u64 parent_transid)
{
::

         while (1) {
::
                 if (ignore) {
                         if (check_tree_block(root, eb))
                                 printk("read block failed check_tree_block\n"); <----
                         else
                                 printk("Csum didn't match\n");
                         break;
                 }
::
         }
         free_extent_buffer(eb);
         return NULL;
}
----------------

we don't check if the buf is NULL and fails with
Segmentation faults in add_root_to_pending
---------------------
static int check_extents(struct btrfs_trans_handle *trans,
                          struct btrfs_root *root, int repair)
{

::
                         buf = read_tree_block(root->fs_info->tree_root,
                                               btrfs_root_bytenr(&ri),
                                               btrfs_level_size(root,
                                                btrfs_root_level(&ri)), 0);   <--- buf is NULL

                         add_root_to_pending(buf, bits, bits_nr, &extent_cache,
                                             &pending, &seen, &reada, &nodes,
                                             &found_key);

                         free_extent_buffer(buf);
                 }
-----------------------


Seems like the simple fix is to redirect btrfsck user to use
--init-csum-tree when csum root is corrupted

thanks
Anand


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2828 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbcDVC5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 22:57:38 -0400
To: Mark Fasheh <mfasheh@suse.de>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About fi du and reflink/dedupe
Message-ID: <0e9b715e-0cb3-c7a3-e40e-36c9be1f53bd@cn.fujitsu.com>
Date: Fri, 22 Apr 2016 10:57:29 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

Thanks for your contribution to btrfs-filesystem-du command.

However there seems to be some strange behavior related to reflinke(and 
further in-band dedupe).
(And the root cause is lying quite deep into kernel backref resolving codes)

["Exclusive" value not really exclsuive]
When a file with 2 file extents, and the 2nd file extent points to the 
1st one, the fi du gives wrong answer

The following command can create such file easily.

# mkfs.btrfs -f /dev/sdb5
# mount /dev/sdb5 /mnt/test
# xfs_io -f -c "pwrite 0 128K" /mnt/test/tmp
# xfs_io -c "reflink /mnt/test/tmp 0 128K 128K" /mnt/test/tmp
# btrfs fi du /mnt/test
      Total   Exclusive  Set shared  Filename
  256.00KiB   256.00KiB           -  /mnt/test//tmp
  256.00KiB   256.00KiB       0.00B  /mnt/test/

Total seems to be OK, while I am confused of the exclusive value.

As the above method will only create one real data extent, which takes 
128K, and if following the qgroup definition, its exclusive should be 
128K other than 256K.


Fi du uses FIEMAP ioctl to get the fiemap, and fi du uses the SHARED 
flag to determine whether it is shared.

However that SHARED flag doesn't handle case like this, in which 
ino/root are all the same, only extent offset is different.


And what's more, if we modify btrfs_check_shared() to return SHARED flag 
for such case, we will get 0 exclusive value for it.
Which is quite strang. (I assume the exclusive should be 128K)

[Slow btrfs_check_shared() performance]
In above case, btrfs fi du returns very fast.
But when the file is in-band deduped and size goes to 1G.
btrfs_check_shared() will take a lot of time to return, as it will do 
backref walk through.

This would be a super huge problem for inband dedupe.


[Possible solution]
Would you please consider to judge shared extent in user space?
And don't rely on the SHARED flag from fiemap.

The work flow would be like:

1) Call fiemap skipping FIEMAP_EXTENT_SHARED flag
    Although we still need to modify kernel to avoid btrfs_check_shared()

2) Get the disk bytenr and record it in user space bytenr pool
3) Compare each file extent disk bytenr with bytenr pool
    And like qgroup, use this to build a rfer/excl data for each inode.

At least, this method would handle above exclusive value and avoid 
year-long fiemap ioctl call in in-band dedupe case.

Thanks,
Qu



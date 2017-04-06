Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49835 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753807AbdDFDRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 23:17:47 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 0/7] Holistic view of device error at commit flush and related cleanup
Date: Thu,  6 Apr 2017 11:22:46 +0800
Message-Id: <20170406032253.14631-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These patches adds cleanup of device barrier, q and flush codes.
This was needed for the following reasons..

  - First of all, Qu approach on the chunk based degradable check
wanted to know what devices failed rather than total count of failed
devices. So the patch 3/7 adds a function check_barrier_error() in
which Qu can add such a logic. Irrespective whether those Qu patches
passes through all the reviews, and if it does not, still this patch
is good to have as it does not change the commit performance since
check_barrier_error() is only called when there is an error in any of
the device. However I believe a volume manager when deciding an action
of the device error, it should rather have a broader view and state of
other devices instead of action based on just individual device, this
just a step towards that. (Earlier the patch [1] was also on the similar
idea, its yet to be separated from the feature patch, as time permits
and priority rises. [1] https://patchwork.kernel.org/patch/9058361/)

 [PATCH v4 3/7] btrfs: cleanup barrier_all_devices() to check dev stat flush error

  - However barrier_all_devices() wasn't capable of supporting 3/7
(above). So clean up of write_dev_flush() is needed, and if it uses
blkdev_issue_flush() then the way we count the error device especially
the err_send++ part can be avoided. Patch 1/7 provides this cleanup.
  
 [PATCH v4 1/7] btrfs: use blkdev_issue_flush to flush the device cache

  - There are some static error checking in barrier_all_devices(), such
as !dev->bdev && errors_send++, these errors would remain same before
or after the flush. As of now we do not have any code which will bring
a null bdev back, also we are in device_mutex. So consolidated all
those errors as dropouts at the place after the flush. This clean up is
in 2/7.

 [PATCH v4 2/7] btrfs: cleanup barrier_all_devices() unify dev error count

Now with 1/7 and 2/7 in place, 3/7 can be applied. These 3 are
dependent patches.

  - Patch 4/7 is not related to above 3 patches, however it adds up a
cleanup around the REQ_PREFLUSH flag. It is found that we do not have
any bio with the flag  REQ_PREFLUSH set. So an end io checking for that
flag is not required. Concerned what if there is a bio in future which
will set REQ_PREFLUSH ? I am not too sure about that. However the
write_dev_flush code with the patch 3/7 (above) is still unaffected
with or without patch 4/7, thats because 3/7  does not depend on
BTRFS_DEV_STAT_FLUSH_ERRS, instead it uses a new per device
last_flush_err member to track the error. But it would have been better
or the right way if it had checked BTRFS_DEV_STAT_FLUSH_ERRS instead.
But as it seeks much bigger change, it can be optimized to use
BTRFS_DEV_STAT_FLUSH_ERRS at a later point
of time.
  
 [PATCH v4 4/7] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback

And rest of the patches are completely a cleanup patches which are
found good to have when around these parts of the code. They are -

[PATCH v4 5/7] btrfs: use q which is already obtained from bdev_get_queue
[PATCH v4 6/7] btrfs: delete unused member nobarriers
[PATCH v4 7/7] btrfs: check if the device is flush capable

Anand Jain (7):
  btrfs: use blkdev_issue_flush to flush the device cache
  btrfs: cleanup barrier_all_devices() unify dev error count
  btrfs: cleanup barrier_all_devices() to check dev stat flush error
  btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
  btrfs: use q which is already obtained from bdev_get_queue
  btrfs: delete unused member nobarriers
  btrfs: check if the device is flush capable

 fs/btrfs/disk-io.c | 112 +++++++++++++++++++++++++----------------------------
 fs/btrfs/volumes.c |  10 ++---
 fs/btrfs/volumes.h |   4 +-
 3 files changed, 58 insertions(+), 68 deletions(-)

-- 
2.10.0


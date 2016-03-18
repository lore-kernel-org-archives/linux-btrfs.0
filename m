Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33142 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbcCRTjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 15:39:39 -0400
Received: by mail-pf0-f178.google.com with SMTP id 4so49370175pfd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 12:39:39 -0700 (PDT)
Date: Fri, 18 Mar 2016 12:39:37 -0700
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <Anand.Jain@oracle.com>
Subject: Global hotspare functionality
Message-ID: <20160318193937.GA21352@jek-Latitude-E7440>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I try to get Anand's patchset for global hotspare functionality working.

Now it's working for me but I have met number of issues while applying
and patches testing.

I took latest versions of patchset and its dependencies (latest at two
weeks ago):

1) Anand's hotspare patchset:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/49985
2) Device delete by id series:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/53208
3) Two Anand's patches about sysfs attributes (hotspare series seems to be
depended on it):
http://thread.gmane.org/gmane.comp.file-systems.btrfs/48943

My kernel is 4.4.5 stable version (I had tried integration-4.6 branch
of btrfs-next first and had same troubles as for 4.4.5).

So, good result: hotspare functionality works!
Bad result: it works for me after some patching only :)

General notice: we are definitely need FS-specific hotspares, because
common case is to have few RAID with different drives size (system root and
data RAIDs, for instance).

I have published my git tree with working set of patches here:
https://bitbucket.org/jekhor/linux-btrfs/branch/4.4.5%2Bhotspare-without_degradable_check
And corresponding btrfs-progs tree:
https://bitbucket.org/jekhor/btrfs-progs/commits/branch/devel-hotspare

This trees contain some RAID state monitoring related changes, just ignore
them (I am going to start another discussion about of RAID status monitoring
soon).


Issue 1.

First, kernel oopsed at FS mounting after unmounting. Unfortunately, I
don't have saved logs for this. I found that fsid_kobj was corrupted (has
NULL ktype field) before invocation of btrfs_sysfs_add_fsid(). I cannot
found the source of corruption – no 'kobject release' events before,
state_initialized field remains true, ktype just is cleaned
(btrfs_ktype.release() wasn't called before this too).

My printk-based trace looks like this but exactly place of value changing
was not permanent, so this is can be some kind of race condition:

Mar 11 01:07:31 grack12 kernel: [   33.694074] btrfs_commit_transaction:2133: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
Mar 11 01:07:31 grack12 kernel: [   33.697967] btrfs_commit_transaction:2142: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
Mar 11 01:07:31 grack12 kernel: [   33.697972] write_all_supers:3672: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
Mar 11 01:07:31 grack12 kernel: [   33.697973] write_all_supers:3677: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
Mar 11 01:07:31 grack12 kernel: [   33.697974] write_all_supers:3679: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
Mar 11 01:07:31 grack12 kernel: [   33.702881] write_all_supers:3690: fsid_kobj=ffff88001f020cd8, ktype=          (null)
Mar 11 01:07:31 grack12 kernel: [   33.702884] write_all_supers:3699: fsid_kobj=ffff88001f020cd8, ktype=          (null)
Mar 11 01:07:31 grack12 kernel: [   33.702885] write_all_supers:3701: fsid_kobj=ffff88001f020cd8, ktype=          (null)

Bisecting pointed me to simple commit 'b0f398c btrfs: optimize
btrfs_check_degradable() for calls outside of barrier' but I have no idea how
it may cause or trigger this issue...

So, after spending some time for debugging, I decided to remove second
patchset entirely except of 'btrfs: create a helper function to read the disk
super' commit and problem had gone out.


Issue 2.
At start of autoreplacig drive by hotspare, kernel craches in transaction
handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
(oops text is attached also). Bdev is closed after replacing by
btrfs_dev_replace_finishing(), so this is safe but doesn't seem
to be right way.

Issue 3.
btrfs_auto_replace_start() doesn't check and doesn't set the
fs_info->mutually_exclusive_operation_running flag as ioctl handler for
DEV_REPLACE_START does, this cause race conditions in some cases, see
https://bitbucket.org/jekhor/linux-btrfs/commits/834bebb96a2f6b5ef5856836839e5ce7830ec745?at=master

Issue 4.
Autoreplacement code doesn't start replacing at mounting in degraded mode,
even if hotspare exists. We need this feature, so I added check for missing
drives also, not only for failed, to checking if replacement needed.
See
https://bitbucket.org/jekhor/linux-btrfs/commits/4c9ddb58d979ae5a232aeaa1fbe3d26373210768?at=master
and
https://bitbucket.org/jekhor/linux-btrfs/commits/be5e2524c10f2b4047da80f9f85b54c6006d4273?at=master

-- 
Yauhen Kharuzhy

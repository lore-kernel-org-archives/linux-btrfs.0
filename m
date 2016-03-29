Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42802 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbcC2Oll (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:41:41 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: Global hotspare functionality
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        linux-btrfs@vger.kernel.org
References: <20160318193937.GA21352@jek-Latitude-E7440>
Message-ID: <56FA9420.8020503@oracle.com>
Date: Tue, 29 Mar 2016 22:41:36 +0800
MIME-Version: 1.0
In-Reply-To: <20160318193937.GA21352@jek-Latitude-E7440>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Yauhen,

  Thanks ! more below..

On 03/19/2016 03:39 AM, Yauhen Kharuzhy wrote:
> Hi all,
>
> I try to get Anand's patchset for global hotspare functionality working.

> Now it's working for me but I have met number of issues while applying
> and patches testing.
>
> I took latest versions of patchset and its dependencies (latest at two
> weeks ago):
>
> 1) Anand's hotspare patchset:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/49985
> 2) Device delete by id series:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/53208

  V2 is sent out based on cleanups-4.6 branch. Plus preparatory
  patch found in the ML.

fc72066b27f3 btrfs: refactor btrfs_dev_replace_start for reuse
0b2322126a95 btrfs: keep sysfs target add in the last
3ecbc05149e0 btrfs: use fs_info directly


> 3) Two Anand's patches about sysfs attributes (hotspare series seems to be
> depended on it):
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/48943

  The sysfs patches we need it only to see the device state or some
  enterprise scripts may need it. But auto replace hot spare as such
  don't depend on that.

> My kernel is 4.4.5 stable version (I had tried integration-4.6 branch
> of btrfs-next first and had same troubles as for 4.4.5).

  Wiki needs an update, pls don't use btrfs-next.

> So, good result: hotspare functionality works!

  Thanks for testing.

> Bad result: it works for me after some patching only :)

  Thanks for working on it. Let me review.

> General notice: we are definitely need FS-specific hotspares, because
> common case is to have few RAID with different drives size (system root and
> data RAIDs, for instance).

  Yep.

> I have published my git tree with working set of patches here:
> https://bitbucket.org/jekhor/linux-btrfs/branch/4.4.5%2Bhotspare-without_degradable_check
> And corresponding btrfs-progs tree:
> https://bitbucket.org/jekhor/btrfs-progs/commits/branch/devel-hotspare

  Hm, generally posting the independent patches to the ML will help.

> This trees contain some RAID state monitoring related changes, just ignore
> them (I am going to start another discussion about of RAID status monitoring
> soon).
>
>
> Issue 1.
>
> First, kernel oopsed at FS mounting after unmounting. Unfortunately, I
> don't have saved logs for this. I found that fsid_kobj was corrupted (has
> NULL ktype field) before invocation of btrfs_sysfs_add_fsid(). I cannot
> found the source of corruption – no 'kobject release' events before,
> state_initialized field remains true, ktype just is cleaned
> (btrfs_ktype.release() wasn't called before this too).
>
> My printk-based trace looks like this but exactly place of value changing
> was not permanent, so this is can be some kind of race condition:
>
> Mar 11 01:07:31 grack12 kernel: [   33.694074] btrfs_commit_transaction:2133: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
> Mar 11 01:07:31 grack12 kernel: [   33.697967] btrfs_commit_transaction:2142: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
> Mar 11 01:07:31 grack12 kernel: [   33.697972] write_all_supers:3672: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
> Mar 11 01:07:31 grack12 kernel: [   33.697973] write_all_supers:3677: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
> Mar 11 01:07:31 grack12 kernel: [   33.697974] write_all_supers:3679: fsid_kobj=ffff88001f020cd8, ktype=ffffffffa0219840
> Mar 11 01:07:31 grack12 kernel: [   33.702881] write_all_supers:3690: fsid_kobj=ffff88001f020cd8, ktype=          (null)
> Mar 11 01:07:31 grack12 kernel: [   33.702884] write_all_supers:3699: fsid_kobj=ffff88001f020cd8, ktype=          (null)
> Mar 11 01:07:31 grack12 kernel: [   33.702885] write_all_supers:3701: fsid_kobj=ffff88001f020cd8, ktype=          (null)
>
> Bisecting pointed me to simple commit 'b0f398c btrfs: optimize
> btrfs_check_degradable() for calls outside of barrier' but I have no idea how
> it may cause or trigger this issue...

  dev is stale here, my bad, that was a crap patch. Also we don't need
  this patch as part of hot spare / auto replace code. I have removed it.

> So, after spending some time for debugging, I decided to remove second
> patchset entirely except of 'btrfs: create a helper function to read the disk
> super' commit and problem had gone out.
>
>
> Issue 2.
> At start of autoreplacig drive by hotspare, kernel craches in transaction
> handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
> routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
> https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
> (oops text is attached also). Bdev is closed after replacing by
> btrfs_dev_replace_finishing(), so this is safe but doesn't seem
> to be right way.

  I have sent out V2. I don't see that issue with this,
  could you pls try ?

> Issue 3.
> btrfs_auto_replace_start() doesn't check and doesn't set the
> fs_info->mutually_exclusive_operation_running flag as ioctl handler for
> DEV_REPLACE_START does, this cause race conditions in some cases, see
> https://bitbucket.org/jekhor/linux-btrfs/commits/834bebb96a2f6b5ef5856836839e5ce7830ec745?at=master

  There were some fixes to the main btrfs_auto_replace_start() before,
  (not the v2). So to avoid such a disconnect, I have sent out a patch
  set which shall not v2 the function, instead it re-factors the original

     btrfs: refactor btrfs_dev_replace_start for reuse

  With this the hot spare V2 will apply nicely, and I have found it
  to be stable.

> Issue 4.
> Autoreplacement code doesn't start replacing at mounting in degraded mode,
> even if hotspare exists. We need this feature, so I added check for missing
> drives also, not only for failed, to checking if replacement needed.

  No. No. No please don't do that, it would lead to trouble in handing
  slow devices. I purposely didn't do it.

  Also kindly note that, in volume manage / storage context things
  should continue to work in degraded mode automatically, and it
  shouldn't wait for user's opinion. If it don't do that, then
  there is no point in having a volume manager. But as of now btrfs has
  already made degraded as non default choice. There is something else
  new which is needed and it can be a separate RFC, not part of this
  patch set.


  Please try. V2 sent out.

Thanks, Anand

> See
> https://bitbucket.org/jekhor/linux-btrfs/commits/4c9ddb58d979ae5a232aeaa1fbe3d26373210768?at=master
> and
> https://bitbucket.org/jekhor/linux-btrfs/commits/be5e2524c10f2b4047da80f9f85b54c6006d4273?at=master





Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8032A1BF;
	Sat, 13 Jun 2026 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781348464; cv=none; b=XLvKsHSmbROvdYz2wf0w2PS70ncv66gXJdNzT22/v/n+kuCo8YQrWpEPlZiyOVGjEzMYfPMvIEYn4ZssfwT/trm4IsVfHknpmzh2rS2UcLx3Pir8y+h1s9eBlLpYR7SzxO/aFWqZofnwkYLhdjB+E1ei8yKoknMeeHFgT/T36Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781348464; c=relaxed/simple;
	bh=mJjmsAx5/+VBtgPRrL8K6lY9CFWNdJHUiOHO0nxWRCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3Hvi5qWCxsqB7PYKBgKePqmGdnbllq1kfgeMBOcWgqQ/KZ9iinsAAXSvrOXMJmbtdBrabPmaIM+gKtWVhKZtjF4IXvRP9GdkthBXB6TRXRGJfORNgAfdkruZsD9OFULmZTOhA3KGAQL5CB+hsOl8/yv9h/2C2D9EPFDK+uuXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 65DB0KG1037676;
	Sat, 13 Jun 2026 20:00:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 65DB0Ko2037673
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 13 Jun 2026 20:00:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp>
Date: Sat, 13 Jun 2026 20:00:17 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <tom.leiming@gmail.com>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Hillf Danton <hdanton@sina.com>
References: <20260529220600.1226-1-hdanton@sina.com>
 <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
 <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
 <20260609175013.GH2636677@ZenIV>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260609175013.GH2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav302.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/06/10 2:50, Al Viro wrote:
> Still breaks xfs/259, same as the version in next-20260605...

I installed xfstests-dev and reproduced a "umount: /home/test: target is busy." problem which Al Viro is
experiencing with https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20260608&id=fb1d5846e99c8aa4ce8da7e6ee7643b01da25b8c .

--------------------------------------------------------------------------------
./check xfs/259
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 kvm1 7.1.0-rc7-next-20260608+ #72 SMP PREEMPT_DYNAMIC Tue Jun  9 18:27:54 EDT 2026
MKFS_OPTIONS  -- -f /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /home/scratch

xfs/259 3s ... umount: /home/test: target is busy.
_check_xfs_filesystem: filesystem on /dev/sdb1 has dirty log
(see /home/al/xfstests/results//xfs/259.full for details)
_check_xfs_filesystem: filesystem on /dev/sdb1 is inconsistent (r)
(see /home/al/xfstests/results//xfs/259.full for details)

Ran: xfs/259
Failures: xfs/259
Failed 1 of 1 tests
--------------------------------------------------------------------------------



Below I describe what I tried, but my opinion is that this "target is busy" problem
should be addressed by xfstests side (i.e. retry umount after a short sleep when
umount failed with "target is busy" error).

--------------------------------------------------------------------------------
# fdisk -l
Disk /dev/nvme0n1: 40 GiB, 42949672960 bytes, 83886080 sectors
Disk model: VMware Virtual NVMe Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 068F8BED-D8BE-4795-8ABD-47A089653C58

Device         Start      End  Sectors Size Type
/dev/nvme0n1p1  2048     4095     2048   1M BIOS boot
/dev/nvme0n1p2  4096 83884031 83879936  40G Linux filesystem


Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x1c8e18a6

Device     Boot    Start      End  Sectors Size Id Type
/dev/sda1           2048 20970495 20968448  10G 83 Linux
/dev/sda2       20971520 41943039 20971520  10G 83 Linux
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
cd
git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/cem/xfstests-dev
cd xfstests-dev/
make -j10
make install
cd /var/lib/xfstests/
TEST_SZ=$(blockdev --getsz /dev/sda1)
SCRATCH_SZ=$(blockdev --getsz /dev/sda2)
dmsetup create delayed_test --table "0 $TEST_SZ delay /dev/sda1 0 10"
dmsetup create delayed_scratch --table "0 $SCRATCH_SZ delay /dev/sda2 0 10"
export FSTYP=xfs
export TEST_DEV=/dev/mapper/delayed_test
export TEST_DIR=/home/test
export SCRATCH_DEV=/dev/mapper/delayed_scratch
export SCRATCH_MNT=/home/scratch
mkdir -p $TEST_DIR $SCRATCH_MNT
cd /var/lib/xfstests/
./check xfs/259
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 localhost 7.1.0-rc7-next-20260608 #22 SMP PREEMPT_DYNAMIC Sat Jun 13 18:50:49 JST 2026
MKFS_OPTIONS  -- -f /dev/mapper/delayed_scratch
MOUNT_OPTIONS -- /dev/mapper/delayed_scratch /home/scratch

xfs/259 61s ... umount: /home/test: target is busy.
_check_xfs_filesystem: filesystem on /dev/mapper/delayed_test has dirty log
(see /var/lib/xfstests/results//xfs/259.full for details)
_check_xfs_filesystem: filesystem on /dev/mapper/delayed_test is inconsistent (r)
(see /var/lib/xfstests/results//xfs/259.full for details)
Trying to repair broken TEST_DEV file system
_repair_test_fs: failed, err=1
(see /var/lib/xfstests/results//xfs/259.full for details)

Ran: xfs/259
Failures: xfs/259
Failed 1 of 1 tests

--------------------------------------------------------------------------------

I initially suspected that the cause of "target is busy" error is that fput() from
__loop_clr_fd() does not wait for completion before "losetup -d" completes. But a
debug printk() patch shown below indicated a tendency:

  (a) __loop_clr_fd() is called by "udev-worker" rather than "losetup" when this problem happens

  (b) propagate_mount_busy()!=0 when do_umount() fails with -EBUSY

--------------------------------------------------------------------------------
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3b607a3ddc4..7408f314a1fa 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1763,6 +1763,8 @@ static void lo_release(struct gendisk *disk)
 	mutex_unlock(&lo->lo_mutex);
 
 	if (need_clear) {
+		printk("Flush: task=%s[%d] dev=loop%d state=%d\n",
+		       current->comm, current->pid, lo->lo_number, lo->lo_state);
 		/*
 		 * Temporarily release disk->open_mutex in order to flush pending I/O
 		 * requests before clearing the backing device.
@@ -1813,6 +1815,8 @@ static void lo_release(struct gendisk *disk)
 		mutex_lock(&lo->lo_disk->open_mutex);
 		if (WARN_ON(data_race(READ_ONCE(lo->lo_state)) != Lo_rundown))
 			return;
+		printk("Teardown: task=%s[%d] dev=loop%d state=%d\n",
+		       current->comm, current->pid, lo->lo_number, lo->lo_state);
 		__loop_clr_fd(lo);
 	}
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index 09ab7fc72f86..9710460fb449 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1893,6 +1893,8 @@ static int do_umount(struct mount *mnt, int flags)
 		 */
 		lock_mount_hash();
 		if (!list_empty(&mnt->mnt_mounts) || mnt_get_count(mnt) != 2) {
+			printk("%s: task=%s[%d] !list_empty(&mnt->mnt_mounts)=%d mnt_get_count(mnt)=%d\n", __func__,
+			       current->comm, current->pid, !list_empty(&mnt->mnt_mounts), mnt_get_count(mnt));
 			unlock_mount_hash();
 			return -EBUSY;
 		}
@@ -1960,6 +1962,9 @@ static int do_umount(struct mount *mnt, int flags)
 		if (!propagate_mount_busy(mnt, 2)) {
 			umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
 			retval = 0;
+		} else {
+			printk("%s: task=%s[%d] propagate_mount_busy()!=0\n", __func__,
+			       current->comm, current->pid);
 		}
 	}
 out:
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
[   77.754264] XFS (dm-0): Mounting V5 Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[   78.161012] XFS (dm-0): Ending clean mount
[   79.882958] XFS (dm-1): Mounting V5 Filesystem f64fdceb-5dd4-489f-ae3f-f14289964a20
[   80.264828] XFS (dm-1): Ending clean mount
[   80.466146] XFS (dm-1): Unmounting Filesystem f64fdceb-5dd4-489f-ae3f-f14289964a20
[   80.547159] XFS (dm-0): Unmounting Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[   81.477419] XFS (dm-0): Mounting V5 Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[   81.871023] XFS (dm-0): Ending clean mount
[   82.008600] run fstests xfs/259 at 2026-06-13 19:39:59
[   83.218605] loop: module loaded
[   83.315929] loop0: detected capacity change from 0 to 8589934584
[   84.897469] loop1: detected capacity change from 0 to 8589934584
[   84.997221] Flush: task=(udev-worker)[1134] dev=loop0 state=2
[   85.014004] Teardown: task=(udev-worker)[1134] dev=loop0 state=2
[   86.354657] Flush: task=losetup[2016] dev=loop1 state=2
[   86.377065] Teardown: task=losetup[2016] dev=loop1 state=2
[   86.416717] loop0: detected capacity change from 0 to 8589934584
[   87.915638] loop1: detected capacity change from 0 to 8589934588
[   88.025704] Flush: task=(udev-worker)[1134] dev=loop0 state=2
[   88.039956] Teardown: task=(udev-worker)[1134] dev=loop0 state=2
[   89.404018] Flush: task=losetup[2048] dev=loop1 state=2
[   89.418144] Teardown: task=losetup[2048] dev=loop1 state=2
[   89.460259] loop0: detected capacity change from 0 to 8589934588
[   91.034214] loop1: detected capacity change from 0 to 8589934588
[   91.149505] Flush: task=(udev-worker)[1134] dev=loop0 state=2
[   91.162932] Teardown: task=(udev-worker)[1134] dev=loop0 state=2
[   92.626690] Flush: task=losetup[2078] dev=loop1 state=2
[   92.652036] Teardown: task=losetup[2078] dev=loop1 state=2
[   92.699585] loop0: detected capacity change from 0 to 8589934590
[   94.307750] loop1: detected capacity change from 0 to 8589934590
[   94.424337] Flush: task=(udev-worker)[1134] dev=loop0 state=2
[   94.441842] Teardown: task=(udev-worker)[1134] dev=loop0 state=2
[   95.869110] Flush: task=losetup[2108] dev=loop1 state=2
[   95.885815] Teardown: task=losetup[2108] dev=loop1 state=2
[   95.931349] loop0: detected capacity change from 0 to 8589934590
[   97.447354] do_umount: task=umount[2143] propagate_mount_busy()!=0
[   97.549813] Flush: task=(udev-worker)[1134] dev=loop0 state=2
[   97.567983] Teardown: task=(udev-worker)[1134] dev=loop0 state=2

[  138.284481] XFS (dm-1): Mounting V5 Filesystem c3b0a09a-f960-464f-a741-84be44d55da0
[  138.679732] XFS (dm-1): Ending clean mount
[  138.865274] XFS (dm-1): Unmounting Filesystem c3b0a09a-f960-464f-a741-84be44d55da0
[  138.944906] XFS (dm-0): Unmounting Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[  139.833646] XFS (dm-0): Mounting V5 Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[  140.213952] XFS (dm-0): Ending clean mount
[  140.342963] run fstests xfs/259 at 2026-06-13 19:40:58
[  141.549551] loop0: detected capacity change from 0 to 8589934584
[  143.112857] loop1: detected capacity change from 0 to 8589934584
[  143.219426] Flush: task=(udev-worker)[2502] dev=loop0 state=2
[  143.240186] Teardown: task=(udev-worker)[2502] dev=loop0 state=2
[  144.575984] Flush: task=losetup[3050] dev=loop1 state=2
[  144.593206] Teardown: task=losetup[3050] dev=loop1 state=2
[  144.631137] loop0: detected capacity change from 0 to 8589934584
[  146.114670] loop1: detected capacity change from 0 to 8589934588
[  146.229225] Flush: task=(udev-worker)[2502] dev=loop0 state=2
[  146.248066] Teardown: task=(udev-worker)[2502] dev=loop0 state=2
[  147.626517] Flush: task=losetup[3080] dev=loop1 state=2
[  147.644085] Teardown: task=losetup[3080] dev=loop1 state=2
[  147.679345] loop0: detected capacity change from 0 to 8589934588
[  149.172884] loop1: detected capacity change from 0 to 8589934588
[  149.296011] Flush: task=(udev-worker)[2502] dev=loop0 state=2
[  149.315040] Teardown: task=(udev-worker)[2502] dev=loop0 state=2
[  150.631328] Flush: task=losetup[3110] dev=loop1 state=2
[  150.650082] Teardown: task=losetup[3110] dev=loop1 state=2
[  150.686210] loop0: detected capacity change from 0 to 8589934590
[  152.186234] loop1: detected capacity change from 0 to 8589934590
[  152.308623] Flush: task=(udev-worker)[2502] dev=loop0 state=2
[  152.325972] Teardown: task=(udev-worker)[2502] dev=loop0 state=2
[  153.652919] Flush: task=losetup[3140] dev=loop1 state=2
[  153.681000] Teardown: task=losetup[3140] dev=loop1 state=2
[  153.716545] loop0: detected capacity change from 0 to 8589934590
[  155.235156] do_umount: task=umount[3175] propagate_mount_busy()!=0
[  155.337055] Flush: task=(udev-worker)[2502] dev=loop0 state=2
[  155.352014] Teardown: task=(udev-worker)[2502] dev=loop0 state=2

[  182.533057] XFS (dm-1): Mounting V5 Filesystem a101f7e1-a8bd-44e2-a49f-21985ce78a3b
[  182.915714] XFS (dm-1): Ending clean mount
[  183.114481] XFS (dm-1): Unmounting Filesystem a101f7e1-a8bd-44e2-a49f-21985ce78a3b
[  183.190809] XFS (dm-0): Unmounting Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[  184.064717] XFS (dm-0): Mounting V5 Filesystem a80d3f5c-f068-4b64-bfe4-543a811c5e93
[  184.456110] XFS (dm-0): Ending clean mount
[  184.592063] run fstests xfs/259 at 2026-06-13 19:41:42
[  185.926189] loop0: detected capacity change from 0 to 8589934584
[  187.473922] loop1: detected capacity change from 0 to 8589934584
[  187.584471] Flush: task=(udev-worker)[3531] dev=loop0 state=2
[  187.603274] Teardown: task=(udev-worker)[3531] dev=loop0 state=2
[  188.961285] Flush: task=losetup[4079] dev=loop1 state=2
[  188.990308] Teardown: task=losetup[4079] dev=loop1 state=2
[  189.029614] loop0: detected capacity change from 0 to 8589934584
[  190.521249] loop1: detected capacity change from 0 to 8589934588
[  190.631200] Flush: task=(udev-worker)[4075] dev=loop0 state=2
[  190.645245] Teardown: task=(udev-worker)[4075] dev=loop0 state=2
[  192.023674] Flush: task=losetup[4109] dev=loop1 state=2
[  192.035269] Teardown: task=losetup[4109] dev=loop1 state=2
[  192.074917] loop0: detected capacity change from 0 to 8589934588
[  193.606595] loop1: detected capacity change from 0 to 8589934588
[  193.727944] Flush: task=(udev-worker)[4075] dev=loop0 state=2
[  193.747188] Teardown: task=(udev-worker)[4075] dev=loop0 state=2
[  195.075694] Flush: task=losetup[4140] dev=loop1 state=2
[  195.092257] Teardown: task=losetup[4140] dev=loop1 state=2
[  195.128969] loop0: detected capacity change from 0 to 8589934590
[  196.636772] loop1: detected capacity change from 0 to 8589934590
[  196.758941] Flush: task=(udev-worker)[4075] dev=loop0 state=2
[  196.779155] Teardown: task=(udev-worker)[4075] dev=loop0 state=2
[  198.105666] Flush: task=losetup[4170] dev=loop1 state=2
[  198.128203] Teardown: task=losetup[4170] dev=loop1 state=2
[  198.163723] loop0: detected capacity change from 0 to 8589934590
[  199.685651] do_umount: task=umount[4205] propagate_mount_busy()!=0
[  199.787468] Flush: task=(udev-worker)[4075] dev=loop0 state=2
[  199.804123] Teardown: task=(udev-worker)[4075] dev=loop0 state=2
--------------------------------------------------------------------------------

That is, if someone else (e.g. udev-worker) by chance has a file descriptor of a loop device
when "losetup -d" called lo_release(), __loop_clr_fd() is not called by "losetup" due to
commit 18048c1af783 ("loop: Fix a race between loop detach and loop open"). Therefore,
I consider that this teardown operation is racy regardless of whether disk->open_mutex is
temporarily released or not. Actually, I can reproduce this problem with below change
(lockdep warning aside).

------------------------------------------------------------
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3b607a3ddc4..076207efb1cc 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1778,7 +1778,7 @@ static void lo_release(struct gendisk *disk)
 		 * the Lo_rundown state guarantees that lo_open() will fail with -ENXIO.
 		 * Thus, there will be effectively no change caused by this violation.
 		 */
-		mutex_unlock(&lo->lo_disk->open_mutex);
+		//mutex_unlock(&lo->lo_disk->open_mutex);
 		/*
 		 * Now that loop_queue_rq() sees lo->lo_state != Lo_bound,
 		 * wait for already started loop_queue_rq() to complete.
@@ -1810,7 +1810,7 @@ static void lo_release(struct gendisk *disk)
 		 * released disk->open_mutex, for I am the only and the last user of
 		 * this loop device because lo_open() cannot succeed.
 		 */
-		mutex_lock(&lo->lo_disk->open_mutex);
+		//mutex_lock(&lo->lo_disk->open_mutex);
 		if (WARN_ON(data_race(READ_ONCE(lo->lo_state)) != Lo_rundown))
 			return;
 		__loop_clr_fd(lo);
------------------------------------------------------------

------------------------------------------------------------
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 localhost 7.1.0-rc7-next-20260608-dirty #23 SMP PREEMPT_DYNAMIC Sat Jun 13 19:19:37 JST 2026
MKFS_OPTIONS  -- -f /dev/mapper/delayed_scratch
MOUNT_OPTIONS -- /dev/mapper/delayed_scratch /home/scratch

xfs/259 61s ... umount: /home/test: target is busy.
_check_xfs_filesystem: filesystem on /dev/mapper/delayed_test has dirty log
(see /var/lib/xfstests/results//xfs/259.full for details)
_check_xfs_filesystem: filesystem on /dev/mapper/delayed_test is inconsistent (r)
(see /var/lib/xfstests/results//xfs/259.full for details)
Trying to repair broken TEST_DEV file system
_repair_test_fs: failed, err=1
(see /var/lib/xfstests/results//xfs/259.full for details)

Ran: xfs/259
Failures: xfs/259
Failed 1 of 1 tests

------------------------------------------------------------

Therefore, although commit fb1d5846e99c ("loop: Fix NULL pointer dereference in
lo_rw_aio()") might have widened the race window, I think that this is a problem
which should be addressed by updating the "umount" user.


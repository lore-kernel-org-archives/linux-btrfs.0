Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AFA47728F
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760132; cv=none; b=bDs0qtgKeUxLTFgcsSvv+gKppxfOofHF6SaZBUnNLTJqLxGrTC6hT7f/DiP00a0UrcNBwUHBAr94d4g7vHXCeAF5wPzmx/1xZO0M3Jg54PxfAToeytDwNiN/c8FoGC6PSPsQanoya85crPUQbois4mDFWVCi4TjMhOnJI48fuLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760132; c=relaxed/simple;
	bh=X5qlsvyKeoI1IrgX9pMbXP6T7BPBJbFZqbc7VshmAmA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=KD4SsCFX7YiV7AF+XgbX2EWm5kARmnSRVhOPeFWwlR7C4/TX8QvOLI1RhQOvYgUt2ELlLIcbGOE17t6ju71TaDnR1ZMAvCrFv2/I96I7GKWYc/YY5Gli8viU/1j+ePKUw3Z55Uo2UIx7ok0jJ+3okR0WIrSi/6NK1mj7xysj2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=U8K1Ya9/; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="U8K1Ya9/"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 7AC48240103
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 11:22:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1790760121;
	bh=UC9zZNsJQMhq6WcIxnUV5RD4ELfYPbLfMPhTVXbeOoI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type:
	 Content-Transfer-Encoding:From;
	b=U8K1Ya9/JHBpd2YYEkCDtIDs/A0xz+1eVsLNl4GgN8IhRtmC/J2IJhTeXITSKwEBf
	 NMd8DtMHs2MIVMjW46lL5W8DP0jXJ8Kv8IknelK7pmFvDJsGSkSqMZuoA1AHvv5xME
	 pEed9jOSTfPhX/TUsw4zziKLG3zzyrT6vyb6nypG5B4CHsBRJbIvp4XIKr4Ei/WYTn
	 vVkp5/knnSIAzNUaNcB8wjjEwj4bwqCli9lG/RxFl6DGxcUk7BAVtZXEi3NRNg4Gr9
	 pwJb1AIrccjmhe8CIgReJodOK4PGrnUe1IXj+tHo+PJDt9Vsh3KwGpNWX77dM/2UNo
	 Loo/k1g8A3v/w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hvqLd13qTz6ty0
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 11:22:01 +0200 (CEST)
Message-ID: <14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de>
Date: Wed, 30 Sep 2026 09:22:01 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-DE
From: c.f.a@posteo.de
Subject: [BUG] qgroup: btrfs_remove_qgroup() can leave an in-memory qgroup,
 without on-disk items, every later rescan gets cancelled
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

on a laptop with full qgroups and snapper I repeatedly end up with a
level-0 qgroup that still exists in memory (it is listed in
/sys/fs/btrfs/<uuid>/qgroups/) while its INFO and LIMIT items are gone from
the quota tree. From then on every transaction commit fails to update that
qgroup's items, marks the qgroups inconsistent and thereby cancels any
running rescan. The rescan never gets past the first commit (~30 s) and
the qgroups stay inconsistent until the qgroup is destroyed by hand or
the filesystem is remounted.

Environment
-----------
   kernel      7.2.7-arch1-1 (line numbers below refer to v7.2.7)
   btrfs-progs 7.1
   snapper     0.13.2, four configs, hourly timeline snapshots,
               QGROUP=1/<subvolid> per config (the group contains the
               subvolume and all its snapshots)
   qgroups     full mode, drop_subtree_threshold raised to 8

Symptom
-------
   BTRFS info (device dm-0): qgroup scan paused

~30 s after every 'btrfs quota rescan', no other message. A kprobe on
qgroup_mark_inconsistent() (reason string from %si) plus a stacktrace
trigger shows who cancels it:

   qmi: (qgroup_mark_inconsistent+0x0/0xe0) reason="qgroup info item 
update error %d"
    => qgroup_mark_inconsistent
    => btrfs_run_qgroups
    => commit_cowonly_roots
    => btrfs_commit_transaction
    => transaction_kthread
   qmi: (qgroup_mark_inconsistent+0x0/0xe0) reason="qgroup limit item 
update error %d"
    (same stack)

Probing update_qgroup_limit_item() on entry (qgroupid) and return:

   610 limit item updates traced, 1 failed
   qgroup 0/8750: error -2

0/8750 belonged to a snapper snapshot that had been deleted and fully
dropped ('btrfs subvolume list' no longer showed it); its sysfs directory
still existed with rfer = excl = 0. 'btrfs qgroup destroy 0/8750 /'
failed with ENOENT, but the qgroup was gone from sysfs afterwards, and
the next rescan completed ("qgroup scan completed (inconsistency flag
cleared)").

Analysis
--------
btrfs_remove_qgroup() (qgroup.c:1806) does, in this order:

   1839  del_qgroup_item()             - deletes the INFO and LIMIT items
   1843  loop over qgroup->groups:
   1846    __del_qgroup_relation()
   1848    if (ret) goto out;
   1889  del_qgroup_rb()               - only reached on success
   1897  btrfs_sysfs_del_one_qgroup()

__del_qgroup_relation() (qgroup.c:1628) returns the result of
quick_update_accounting() (qgroup.c:1674) when the relation was found.
quick_update_accounting() (qgroup.c:1540) starts with ret = 1 and only
clears it when the member's excl == rfer (1549); otherwise it sets
BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT and returns 1. So 1 means "needs a
rescan", not failure, but btrfs_remove_qgroup() treats it as an error and
bails out after the items have already been deleted. The transaction is
not aborted (btrfs_ioctl_qgroup_create() just ends it, ioctl.c:3737ff), so
the item deletion is committed while the struct btrfs_qgroup stays in the
rbtree and in sysfs. Its relation to the parent is already gone from the
rbtree (del_relation_rb() at 1673), which is why a later destroy succeeds
in removing it but reports -ENOENT from __del_qgroup_relation().

The same happens if __del_qgroup_relation() returns -ENOENT because
neither relation item exists and the relation was not found.

Once the stale qgroup gets dirtied (a rescan zeroes and dirties all
qgroups in qgroup_rescan_zero_tracking(), qgroup.c:4028),
btrfs_run_qgroups() fails in update_qgroup_info_item() and
update_qgroup_limit_item() with -ENOENT (qgroup.c:3144-3151) and calls
qgroup_mark_inconsistent(), which sets
BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN (qgroup.c:391-393), so
rescan_should_stop() (qgroup.c:3839) stops the rescan worker. Because the
qgroups are already inconsistent at that point, qgroup_mark_inconsistent()
does not print its reason, which makes this hard to diagnose: the only
visible message is "qgroup scan paused".

How it gets triggered
---------------------
Any removal of a level-0 qgroup that is a member of a higher-level qgroup
while the member's rfer != excl. One path that needs no user action:
btrfs_drop_snapshot() calls btrfs_qgroup_cleanup_dropped_subvolume()
(extent-tree.c:6498), which commits and then calls btrfs_remove_qgroup().
If the qgroups are inconsistent at that time, the dropped subvolume's
numbers are stale and non-zero, quick_update_accounting() returns 1, and
the caller only warns on ret < 0, so the stale qgroup appears silently.

With snapper this is easy to hit: creating a snapshot into a group
qgroup marks the qgroups inconsistent as soon as the group shares any
extent with a subvolume outside it ("qgroup inherit needs a rescan"), and
snapper's cleanup then deletes old snapshots before a rescan has run. On
my machine the first occurrence was exactly that sequence (snapshot at
14:00 marked the qgroups inconsistent, snapper-cleanup at 14:35 deleted
snapshots, every rescan afterwards was cancelled).

Rescans are being cancelled the same way again since this morning, after
snapper-cleanup deleted four snapshots at 06:59 (followed by its usual
'btrfs qgroup clear-stale'). As far as I can tell the qgroups were
consistent at that time, so this would be a different trigger. I have
not traced this occurrence yet; sysfs shows three level-0 qgroups with
rfer = excl = 0 as candidates.

Reproducer
----------
The script below (loop device, needs root) follows the snapper pattern:
create a snapshot with '-i 1/100' from a subvolume outside 1/100, which
goes through qgroup_mark_inconsistent() ("qgroup inherit needs a rescan")
and thereby stops accounting, then delete that snapshot, wait for the
drop and run a rescan.

Note that making the qgroups inconsistent via 'qgroup assign --no-rescan'
instead does not reproduce it: quick_update_accounting() only sets
BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT, accounting continues, the dropped
snapshot's numbers reach zero and the removal succeeds.

Output on 7.2.7 (trimmed):

   == setup: subvolume a, snapshot s created into parent qgroup 1/100
   snapshot s = 0/257, inconsistent = 1
   BTRFS warning (device loop2): qgroup marked inconsistent, qgroup 
inherit needs a rescan
   Qgroupid    Referenced    Exclusive Parent   Child   Path
   0/256         64.02MiB     16.00KiB -        -       a
   0/257         64.02MiB     16.00KiB 1/100    -       s
   1/100            0.00B        0.00B -        0/257   <0 member qgroups>

   == delete s and wait until it is dropped
   Subvolume id 257 is gone (1/1)
   0/257 in sysfs (in memory):  yes
   0/257 in quota tree (on disk): no

   == destroy 0/257 by hand, rescan again
   ERROR: unable to destroy quota group: No such file or directory
   0/257 in sysfs: no

So after the drop, 0/257 is half-removed exactly as on my real
filesystem. On this tiny filesystem the rescan itself still finishes
(presumably because it is done within a single commit); on the real one 
(~700 GiB,
~80 subvolumes) it is cancelled at the first transaction commit every
time, as described above.

Possible fixes
--------------
- In btrfs_remove_qgroup(), do not treat a positive return of
   __del_qgroup_relation() as an error (the qgroups are already flagged
   inconsistent), and tolerate -ENOENT for a relation that no longer
   exists; or
- remove the relations before deleting the INFO/LIMIT items, so that a
   failure leaves the qgroup intact instead of half-deleted.

Workaround
----------
Destroy the qgroup by hand ('btrfs qgroup destroy 0/<id>', ignoring
ENOENT) or remount; the stale qgroups can be found by comparing
/sys/fs/btrfs/<uuid>/qgroups/0_* with 'btrfs subvolume list -a'.

Thanks,
Carl Ahring



---8<--- btrfs-qgroup-repro.sh ---8<---
#!/usr/bin/env bash
# Reproducer for a half-removed qgroup: deleting a snapshot whose level-0
# qgroup is a member of a parent qgroup while qgroup accounting is off
# (inconsistent after a snapshot inherit that needs a rescan).
# Works on a throwaway loop device, touches nothing else. Needs root.
set -eu

img=$(mktemp /tmp/qg-repro.XXXXXX.img)
mnt=$(mktemp -d /tmp/qg-repro.XXXXXX)
truncate -s 2G "$img"
dev=$(losetup -f --show "$img")
cleanup() { umount "$mnt" 2>/dev/null || true; losetup -d "$dev"; rm -f 
"$img"; rmdir "$mnt"; }
trap cleanup EXIT

mkfs.btrfs -q -f "$dev"
mount "$dev" "$mnt"
uuid=$(findmnt -no UUID "$mnt")
q=/sys/fs/btrfs/$uuid/qgroups
step() { printf '\n== %s\n' "$1"; }

step "setup: subvolume a, snapshot s created into parent qgroup 1/100"
btrfs quota enable "$mnt"
btrfs subvolume create "$mnt/a" >/dev/null
dd if=/dev/urandom of="$mnt/a/f" bs=1M count=64 status=none
sync
btrfs quota rescan -w "$mnt" >/dev/null
btrfs qgroup create 1/100 "$mnt"
# What snapper does with QGROUP=1/100. a is not in 1/100, so the kernel
# cannot inherit quickly and calls qgroup_mark_inconsistent() ("qgroup
# inherit needs a rescan"), which also sets NO_ACCOUNTING: from now on the
# numbers of s stay frozen at rfer = 64 MiB, excl = 16 KiB.
btrfs subvolume snapshot -i 1/100 "$mnt/a" "$mnt/s" >/dev/null
sync
sid=$(btrfs inspect-internal rootid "$mnt/s")
echo "snapshot s = 0/$sid, inconsistent = $(cat "$q/inconsistent")"
dmesg | grep -i 'btrfs' | tail -1
btrfs qgroup show -pc "$mnt"

step "delete s and wait until it is dropped"
btrfs subvolume delete "$mnt/s" >/dev/null
btrfs subvolume sync "$mnt"
sleep 2   # btrfs_qgroup_cleanup_dropped_subvolume() runs right after 
the drop
sync
echo "0/$sid in sysfs (in memory):  $([ -e "$q/0_$sid" ] && echo yes || 
echo no)"
echo "0/$sid in quota tree (on disk): $(btrfs qgroup show "$mnt" 
2>/dev/null | awk '{print $1}' | grep -qx "0/$sid" && echo yes || echo no)"

step "rescan"
start=$(date +%s)
btrfs quota rescan -w "$mnt" || true
echo "returned after $(( $(date +%s) - start ))s, inconsistent = $(cat 
"$q/inconsistent")"
dmesg | grep -i 'btrfs' | tail -4

step "destroy 0/$sid by hand, rescan again"
btrfs qgroup destroy "0/$sid" "$mnt" || true
echo "0/$sid in sysfs: $([ -e "$q/0_$sid" ] && echo yes || echo no)"
btrfs quota rescan -w "$mnt" || true
echo "inconsistent = $(cat "$q/inconsistent")"
dmesg | grep -i 'btrfs' | tail -2

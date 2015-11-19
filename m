Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7031 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750819AbbKSJiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 04:38:15 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAJ9bTBB017255
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 17:37:29 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3] btrfs-progs: mkfs: Enable -d dup for single device
Date: Thu, 19 Nov 2015 17:36:24 +0800
Message-ID: <71e6ba091cdb43b7d0d5f73fb3dd2daa2929ec41.1447925407.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code don't support dup profile in single device, except it
is in mixed mode, because following reason:
1: In some ssd with deduplication function, it have no effect.
2: For a physical device, it the entire disk broken, -d dup can
   not help.
3: Half performance comparing with single profile.
4: We have a workaround: Create multi-partition in single device,
   and btefs will treat them as multi device.

Instead of refuse -d dup, we have a better choise:
Give user a chance to select, and output a warning to notice above
problem.

Test:
1: Tested by xfstests
   Run with modified xfstests, I add test items of -d dup in single
   device into btrfs/* and common/rc, run tests of btrfs/*,
   with all mount option, no regression diffed with v4.3.
2: Tested by btrfs-progs
   Checked following commands in "-m dup -d dup" fs with memleck
   checking, all passed:
   mkfs.btrfs -f --data dup --metadata dup /dev/sda6
   btrfs filesystem show /dev/sda6
   btrfs filesystem label /dev/sda6 btrfs_label_test
   btrfs filesystem label /dev/sda6
   btrfs device scan --all-devices
   btrfs device scan /dev/sda6
   btrfs device scan /dev/sda6
   btrfs device ready /dev/sda6
   btrfs check /dev/sda6
   btrfs check -s 1 /dev/sda6
   btrfs check --repair /dev/sda6
   btrfs check --init-csum-tree /dev/sda6
   btrfs check --init-extent-tree /dev/sda6
   btrfs check --check-data-csum /dev/sda6
   btrfs check --qgroup-report /dev/sda6
   btrfs rescue super-recover -y /dev/sda6
   btrfs rescue zero-log /dev/sda6
   btrfs restore -l /dev/sda6
   btrfs restore /dev/sda6 /
   btrfs restore -s /dev/sda6 /
   btrfs restore -x /dev/sda6 /
   btrfs restore -m /dev/sda6 /
   btrfs restore -S /dev/sda6 /
   btrfs restore -v /dev/sda6 /
   btrfs restore -i /dev/sda6 /
   btrfs restore -o /dev/sda6 /
   btrfs restore -u0 /dev/sda6 /
   btrfs restore -u1 /dev/sda6 /
   btrfs restore -D /dev/sda6 /
   btrfs property list /dev/sda6
   btrfs property get /dev/sda6 label
   btrfs property set /dev/sda6 label test
   btrfs property set /dev/sda6 label btrfs_label_test
   btrfs help
   btrfs help --full
   btrfs version
   btrfsck /dev/sda6
   btrfs-find-root /dev/sda6
   btrfs-find-root -a /dev/sda6
   btrfs-map-logical -l1 /dev/sda6
   btrfs-map-logical -l1 -c1 /dev/sda6
   btrfs-map-logical -l1 -o /tmp/btrfs-map-logic-out /dev/sda6
   btrfs-map-logical -l1 -b1 /dev/sda6
   btrfs-select-super -s 0 /dev/sda6
   btrfs-select-super -s 1 /dev/sda6
   btrfstune -S 1 /dev/sda6
   btrfstune -f -S 0 /dev/sda6
   btrfstune -r /dev/sda6
   btrfstune -x /dev/sda6
   btrfstune -n /dev/sda6
   btrfstune -f -U 00000000-0000-0000-0000-000000000000 /dev/sda6
   btrfstune -f -u /dev/sda6
   btrfs-calc-size /dev/sda6
   btrfs-calc-size -v /dev/sda6
   btrfs-calc-size -b /dev/sda6
   btrfs-debug-tree /dev/sda6
   btrfs-debug-tree -e /dev/sda6
   btrfs-debug-tree -d /dev/sda6
   btrfs-debug-tree -r /dev/sda6
   btrfs-debug-tree -R /dev/sda6
   btrfs-debug-tree -u /dev/sda6
   btrfs-debug-tree -b 0 /dev/sda6
   btrfs-debug-tree -t 0 /dev/sda6
   btrfs-debug-tree -t 2 /dev/sda6
   btrfs-show-super /dev/sda6
   btrfs-show-super -i 0 /dev/sda6
   btrfs-show-super -i 1 /dev/sda6
   btrfs-show-super -i 2 /dev/sda6
   btrfs-show-super -a /dev/sda6
   btrfs-show-super -f /dev/sda6
   btrfs-show-super -F /dev/sda6
   btrfs subvolume list /mnt/btrfs-progs-tests
   btrfs subvolume create /mnt/btrfs-progs-tests/mysubvol
   btrfs subvolume list /mnt/btrfs-progs-tests
   btrfs subvolume get-default /mnt/btrfs-progs-tests
   btrfs subvolume set-default 258 /mnt/btrfs-progs-tests
   btrfs subvolume get-default /mnt/btrfs-progs-tests
   btrfs subvolume set-default  /mnt/btrfs-progs-tests
   btrfs subvolume snapshot /mnt/btrfs-progs-tests/mysubvol /mnt/btrfs-progs-tests/mysubvol_snap
   btrfs subvolume list /mnt/btrfs-progs-tests
   btrfs subvolume find-new /mnt/btrfs-progs-tests 0
   btrfs subvolume find-new /mnt/btrfs-progs-tests 0
   btrfs subvolume find-new /mnt/btrfs-progs-tests/mysubvol 0
   btrfs subvolume find-new /mnt/btrfs-progs-tests/mysubvol 0
   btrfs subvolume show /mnt/btrfs-progs-tests
   btrfs subvolume show /mnt/btrfs-progs-tests/mysubvol
   btrfs subvolume show /mnt/btrfs-progs-tests/mysubvol_snap
   btrfs subvolume sync /mnt/btrfs-progs-tests
   btrfs subvolume delete /mnt/btrfs-progs-tests/mysubvol_snap
   btrfs subvolume delete /mnt/btrfs-progs-tests/mysubvol
   btrfs subvolume sync /mnt/btrfs-progs-tests
   btrfs filesystem df /mnt/btrfs-progs-tests
   btrfs filesystem show /mnt/btrfs-progs-tests
   btrfs filesystem sync /mnt/btrfs-progs-tests
   btrfs filesystem label /mnt/btrfs-progs-tests btrfs_label_test
   btrfs filesystem label /mnt/btrfs-progs-tests
   btrfs filesystem usage /mnt/btrfs-progs-tests
   btrfs filesystem defragment -s 1024 -l 2048 /mnt/btrfs-progs-tests/filesystem_test_dir/test_dir_0/test_file_0
   btrfs filesystem defragment /mnt/btrfs-progs-tests/filesystem_test_dir/test_dir_0/test_file_1
   btrfs filesystem defragment -f /mnt/btrfs-progs-tests/filesystem_test_dir/test_dir_0/test_file_2
   btrfs filesystem defragment -czlib /mnt/btrfs-progs-tests/filesystem_test_dir/test_dir_0/test_file_3
   btrfs filesystem defragment -clzo /mnt/btrfs-progs-tests/filesystem_test_dir/test_dir_0/test_file_4
   btrfs filesystem defragment /mnt/btrfs-progs-tests/filesystem_test_dir
   btrfs filesystem defragment -r /mnt/btrfs-progs-tests/filesystem_test_dir
   btrfs filesystem defragment /mnt/btrfs-progs-tests
   btrfs filesystem resize 1:-10M /mnt/btrfs-progs-tests
   btrfs filesystem resize 1:max /mnt/btrfs-progs-tests
   btrfs balance start /mnt/btrfs-progs-tests
   btrfs balance start -v /mnt/btrfs-progs-tests
   btrfs balance start -f /mnt/btrfs-progs-tests
   btrfs balance status -v /mnt/btrfs-progs-tests
   btrfs balance pause /mnt/btrfs-progs-tests
   btrfs balance status /mnt/btrfs-progs-tests
   btrfs balance resume /mnt/btrfs-progs-tests
   btrfs balance status -v /mnt/btrfs-progs-tests
   btrfs balance cancel /mnt/btrfs-progs-tests
   btrfs balance start -dprofiles=single /mnt/btrfs-progs-tests
   btrfs balance start -dconvert=single /mnt/btrfs-progs-tests
   btrfs balance start -ddevid=1 /mnt/btrfs-progs-tests
   btrfs balance start -f -mprofiles=single /mnt/btrfs-progs-tests
   btrfs balance start -f -mconvert=single /mnt/btrfs-progs-tests
   btrfs balance start -f -mdevid=1 /mnt/btrfs-progs-tests
   btrfs balance start -f -sprofiles=single /mnt/btrfs-progs-tests
   btrfs balance start -f -sconvert=single /mnt/btrfs-progs-tests
   btrfs balance start -f -sdevid=1 /mnt/btrfs-progs-tests
   btrfs device add -f /dev/sda10 /mnt/btrfs-progs-tests
   btrfs device del /dev/sda10 /mnt/btrfs-progs-tests
   btrfs device stats /dev/sda6
   btrfs device stats -z /dev/sda6
   btrfs device stats /mnt/btrfs-progs-tests
   btrfs device stats -z /mnt/btrfs-progs-tests
   btrfs device usage /mnt/btrfs-progs-tests
   btrfs scrub status /mnt/btrfs-progs-tests
   btrfs scrub start -B /mnt/btrfs-progs-tests
   btrfs scrub start -B -d /mnt/btrfs-progs-tests
   btrfs scrub start -B -r /mnt/btrfs-progs-tests
   btrfs scrub status /mnt/btrfs-progs-tests
   btrfs scrub start /mnt/btrfs-progs-tests
   btrfs scrub status /mnt/btrfs-progs-tests
   btrfs scrub status /mnt/btrfs-progs-tests
   btrfs scrub status -d /mnt/btrfs-progs-tests
   btrfs scrub status -R /mnt/btrfs-progs-tests
   btrfs scrub status /mnt/btrfs-progs-tests
   btrfs scrub start /dev/sda6
   btrfs scrub status /dev/sda6
   btrfs scrub status /dev/sda6
   btrfs scrub status -d /dev/sda6
   btrfs scrub status -R /dev/sda6
   btrfs scrub status /dev/sda6
   btrfs subvolume snapshot -r /mnt/btrfs-progs-tests /mnt/btrfs-progs-tests/snap1
   btrfs send -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-tests/snap1
   btrfs send -e -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-tests/snap1
   btrfs send --no-data -f /tmp/btrfs_snapshot_test /mnt/btrfs-progs-tests/snap1
   btrfs quota enable /mnt/btrfs-progs-tests
   btrfs quota rescan /mnt/btrfs-progs-tests
   btrfs quota rescan -s /mnt/btrfs-progs-tests
   btrfs quota rescan -w /mnt/btrfs-progs-tests
   btrfs quota disable /mnt/btrfs-progs-tests
   btrfs quota enable /mnt/btrfs-progs-tests
   btrfs qgroup create 1/5 /mnt/btrfs-progs-tests
   btrfs qgroup create 2/5 /mnt/btrfs-progs-tests
   btrfs qgroup assign 1/5 2/5 /mnt/btrfs-progs-tests
   btrfs qgroup limit 1G 1/5 /mnt/btrfs-progs-tests
   btrfs qgroup show /mnt/btrfs-progs-tests
   btrfs qgroup show -p -c -r -e -F -f /mnt/btrfs-progs-tests
   btrfs qgroup remove 1/5 2/5 /mnt/btrfs-progs-tests
   btrfs qgroup destroy 2/5 /mnt/btrfs-progs-tests
   btrfs qgroup destroy 1/5 /mnt/btrfs-progs-tests
   btrfs quota disable /mnt/btrfs-progs-tests
   btrfs replace start -f -B /dev/sda6 /dev/sda10 /mnt/btrfs-progs-tests
   btrfs replace status /mnt/btrfs-progs-tests
   btrfs replace start -f -B /dev/sda10 /dev/sda6 /mnt/btrfs-progs-tests
   btrfs-convert /dev/sda6
   btrfs-convert -r /dev/sda6
   btrfs-convert -d /dev/sda6
   btrfs-convert -i /dev/sda6
   btrfs-convert -n /dev/sda6
   btrfs-convert -N 4096 /dev/sda6
   btrfs-convert -l test /dev/sda6
   btrfs-convert -L /dev/sda6
   btrfs-convert --no-progress /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -c 0 /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -c 9 /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -t 0 /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -t 1 /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -t 32 /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -w /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   mkfs.btrfs -f /dev/sda6
   btrfs-image -w /dev/sda6 /tmp/btrfs_image.img
   btrfs-image -r /tmp/btrfs_image.img /dev/sda6
   btrfs-image -r -t 0 /tmp/btrfs_image.img /dev/sda6
   btrfs-image -r -t 1 /tmp/btrfs_image.img /dev/sda6
   btrfs-image -r -t 32 /tmp/btrfs_image.img /dev/sda6
   btrfs-image -r -o /tmp/btrfs_image.img /dev/sda6
3: Manual check relation source by:
   grep DUP *.c
   Confirmed that all source are modified.
4: Use this raid type manually, do some operations in fs,
   no error found in command and dmesg.
5: Combination of dup conversion with fsck
   Confirmed OK with relative kernel patch titled:
   [PATCH] btrfs: Support convert to -d dup for btrfs-convert

   export TEST_DEV='/dev/vdc'
   export TEST_DIR='/var/ltf/tester/mnt'

   do_dup_test()
   {
       local m_from="$1"
       local d_from="$2"
       local m_to="$3"
       local d_to="$4"
   
       echo "Convert from -m $m_from -d $d_from to -m $m_to -d $d_to"
   
       umount "$TEST_DIR" &>/dev/null
       ./mkfs.btrfs -f -m "$m_from" -d "$d_from" "$TEST_DEV" >/dev/null || return 1
       mount "$TEST_DEV" "$TEST_DIR" || return 1
   
       cp -a /sbin/* "$TEST_DIR"
   
       [[ "$m_from" != "$m_to" ]] && {
           ./btrfs balance start -f -mconvert="$m_to" "$TEST_DIR" || return 1
       }
   
       [[ "$d_from" != "$d_to" ]] && {
       local opt=()
           [[ "$d_to" == single ]] && opt+=("-f")
           ./btrfs balance start "${opt[@]}" -dconvert="$d_to" "$TEST_DIR" || return 1
       }
   
       umount "$TEST_DIR" || return 1
       ./btrfsck "$TEST_DEV" || return 1
       echo
   
       return 0
   }
   
   test_all()
   {
       for m_from in single dup; do
       for d_from in single dup; do
       for m_to in single dup; do
       for d_to in single dup; do
       do_dup_test "$m_from" "$d_from" "$m_to" "$d_to" || return 1
       done
       done
       done
       done
   }
   
   test_all

Changelog v2->v3:
1: Fix a compile warning of "unused variable"
2: Tested "convert to dup case" with kernel patch

Changelog v1->v2:
1: Fix a bug in v1 which cause no dup chunk created, found by above
   check command.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c  |  5 ++---
 utils.c | 10 ++++------
 utils.h |  2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 72ee290..32eacf2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -252,7 +252,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      u64 metadata_profile, int mixed,
 			      struct mkfs_allocation *allocation)
 {
-	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
 	int ret;
 
 	if (metadata_profile) {
@@ -271,7 +270,7 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 
 	}
-	if (!mixed && num_devices > 1 && data_profile) {
+	if (!mixed && data_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
 					    data_profile, allocation);
@@ -1594,7 +1593,7 @@ int main(int ac, char **av)
 		}
 	}
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
-			dev_cnt, mixed);
+			dev_cnt, mixed, ssd);
 	if (ret)
 		exit(1);
 
diff --git a/utils.c b/utils.c
index 258730d..1e0df81 100644
--- a/utils.c
+++ b/utils.c
@@ -2428,7 +2428,7 @@ static int group_profile_devs_min(u64 flag)
 }
 
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
-	u64 dev_cnt, int mixed)
+	u64 dev_cnt, int mixed, int ssd)
 {
 	u64 allowed = 0;
 
@@ -2469,11 +2469,9 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		return 1;
 	}
 
-	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
-		fprintf(stderr,
-			"ERROR: DUP for data is allowed only in mixed mode\n");
-		return 1;
-	}
+	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
+		   "DUP have no effect if your SSD have deduplication function");
+
 	return 0;
 }
 
diff --git a/utils.h b/utils.h
index 33b410c..8117ad4 100644
--- a/utils.h
+++ b/utils.h
@@ -167,7 +167,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite);
 int get_label_mounted(const char *mount_path, char *labelp);
 int get_label_unmounted(const char *dev, char *label);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
-	u64 dev_cnt, int mixed);
+	u64 dev_cnt, int mixed, int ssd);
 int group_profile_max_safe_loss(u64 flags);
 int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-- 
1.8.5.1


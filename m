Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727587AbeH2Mbr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 08:31:47 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70E3CAFC4
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 08:35:57 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs-progs: tests: Add tests for changing fsid feature
Date: Wed, 29 Aug 2018 11:35:53 +0300
Message-Id: <1535531754-29774-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1535531754-29774-1-git-send-email-nborisov@suse.com>
References: <1535531754-29774-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a bunch of tests exercising the new btrfstune functionality. In
particular check that various restrictions are implemented correctly,
test that btrfs-image works as expected and also test the output of
btrfs inspect-internal dump-super is correct.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/misc-tests/033-metadata-uuid/test.sh | 137 +++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100755 tests/misc-tests/033-metadata-uuid/test.sh

diff --git a/tests/misc-tests/033-metadata-uuid/test.sh b/tests/misc-tests/033-metadata-uuid/test.sh
new file mode 100755
index 000000000000..b08220c257c8
--- /dev/null
+++ b/tests/misc-tests/033-metadata-uuid/test.sh
@@ -0,0 +1,137 @@
+#!/bin/bash
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+check_prereq btrfstune
+check_prereq btrfs-image
+
+setup_root_helper
+
+prepare_test_dev
+
+function read_fsid {
+	local dev="$1"
+	echo $(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal \
+		dump-super "$dev" | awk '/fsid/ {print $2}' | head -n 1)
+}
+
+function read_metadata_uuid {
+	local dev="$1"
+	echo $(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal \
+		dump-super "$dev" | awk '/metadata_uuid/ {print $2}')
+}
+
+function check_btrfstune {
+	local fsid
+	echo "Checking btrfstune logic" >> "$RESULTS"
+	#Test with random uuid
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+
+	#check that specific uuid can set
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M d88c8333-a652-4476-b225-2e9284eb59f1 "$TEST_DEV"
+
+	#test that having seed on already changed device doesn't work 
+	run_mustfail "Managed to set seed on metadata uuid fs" \
+		$SUDO_HELPER "$TOP/btrfstune" -S 1 "$TEST_DEV"
+
+	#test that setting both seed and -m|M is forbidden 
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_mustfail "Succeeded setting seed and changing fs uuid" \
+		$SUDO_HELPER "$TOP/btrfstune" -S 1 -m "$TEST_DEV"
+
+	#test that having -m|-M on seed device is forbidden
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -S 1 "$TEST_DEV" 
+	run_mustfail "Succeded changing fsid on a seed device" $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+
+	#test that using -U|-u on an fs with METADATA_UUID flag is forbidden
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+	run_mustfail "Succeeded triggering FSID rewrite while METADATA_UUID is active" \
+		$SUDO_HELPER "$TOP/btrfstune" -u  "$TEST_DEV"
+
+}
+
+function check_dump_super_output {
+	local fsid
+	local metadata_uuid
+	local dev_item_match
+	local old_metadata_uuid
+
+	echo "Checking dump-super output" >> "$RESULTS"
+	#Assert that metadata/fsid match on non-changed fs
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	[ "$fsid" = "$metadata_uuid" ] || _fail "fsid ("$fsid") doesn't match metadata_uuid ("$metadata_uuid")"
+
+	dev_item_match=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | awk '/dev_item.fsid/ {print $3}')
+
+	[ $dev_item_match = "[match]" ] || _fail "dev_item.fsid doesn't match on non-metadata uuid fs"
+
+
+	echo "Checking output after fsid change" >> "$RESULTS"
+	#change metadatauuid and ensure everything in the output is still correct 
+	old_metadata_uuid=$metadata_uuid
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M d88c8333-a652-4476-b225-2e9284eb59f1 "$TEST_DEV"
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	dev_item_match=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" \
+		inspect-internal dump-super "$TEST_DEV" | awk '/dev_item.fsid/ {print $3}')                         
+		                                                                                
+    [ "$dev_item_match" = "[match]" ] || _fail "dev_item.fsid doesn't match on metadata uuid fs"
+	[ "$fsid" = "d88c8333-a652-4476-b225-2e9284eb59f1" ] || _fail "btrfstune metadata UUID change failed"
+	[ "$old_metadata_uuid" = "$metadata_uuid" ] || _fail "Metadata uuid change unexpectedly"
+
+	echo "Checking for incompat textual representation" >> "$RESULTS"
+	#check for textual output of the new incompat feature
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | grep -q METADATA_UUID
+	[ $? -eq 0 ] || _fail "Didn't find textual representation of METADATA_UUID feature"
+
+	echo "Checking setting fsid back to original" >> "$RESULTS"
+	#ensure that  setting the fsid back to the original works
+	run_check $SUDO_HELPER "$TOP/btrfstune" -M "$old_metadata_uuid" "$TEST_DEV"
+
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+
+	[ "$fsid" = "$metadata_uuid" ] || _fail "FSID and METADATA_UUID don't match"
+	run_check_stdout $SUDO_HELPER "$TOP/btrfs" inspect-internal dump-super \
+		"$TEST_DEV" | grep -q METADATA_UUID
+	[ $? -eq 1 ] || _fail "METADATA_UUID feature still shown as enabled"
+}
+
+function check_image_restore {
+	local metadata_uuid
+	local fsid
+	local fsid_restored
+	local metadata_uuid_restored
+
+	echo "TESTING btrfs-image restore" >> "$RESULTS"
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfstune" -m "$TEST_DEV"
+	fsid=$(read_fsid "$TEST_DEV")
+	metadata_uuid=$(read_metadata_uuid "$TEST_DEV")
+	run_mayfail $SUDO_HELPER "$TOP/btrfs-image" "$TEST_DEV" /tmp/test-img.dump
+	# erase the fs by creating a new one, wipefs is not sufficient as it just 
+	# deletes the fs magic string
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfs-image" -r /tmp/test-img.dump "$TEST_DEV"
+	fsid_restored=$(read_fsid "$TEST_DEV")
+	metadata_uuid_restored=$(read_metadata_uuid "$TEST_DEV")
+
+	[ "$fsid" = "$fsid_restored" ] || _faild "FSID don't match after restore"
+	[ "$metadata_uuid" = "$metadata_uuid_restored" ] || _faild "metadata uuids don't match after restore"
+}
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_btrfstune
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_dump_super_output
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+check_image_restore
-- 
2.7.4

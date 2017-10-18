Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753265AbdJRNI4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 09:08:56 -0400
Date: Wed, 18 Oct 2017 15:07:08 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: test: add new cli-test for subvol
 get/set-default
Message-ID: <20171018130707.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ac41cb86-7571-0c56-aa3b-29696bb1389b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac41cb86-7571-0c56-aa3b-29696bb1389b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 18, 2017 at 11:00:43AM +0900, Misono, Tomohiro wrote:
> Add new test to check functionality of subvol get/set-default.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Thanks, applied with the following diff to fix style and failures
when the test is not run as root initially:

- no command shortcuts
- the subvolume id for set-default should be read from rootid
- add missing SUDO_HELPER
- prepare_test_dev without the device size (unless justified)

--- a/tests/cli-tests/008-subvolume-get-set-default/test.sh
+++ b/tests/cli-tests/008-subvolume-get-set-default/test.sh
@@ -3,7 +3,7 @@

 check_default_id()
 {
-       id=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" sub get-def .) \
+       id=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" subvolume get-default .) \
                || { echo "$id"; exit 1; }
        if $(echo "$id" | grep -vq "ID $1"); then
                _fail "subvolume get-default: default id is not $1, but $id"
@@ -16,7 +16,7 @@ check_prereq mkfs.btrfs
 check_prereq btrfs

 setup_root_helper
-prepare_test_dev 2g
+prepare_test_dev

 run_check "$TOP/mkfs.btrfs" -f "$TEST_DEV"
 run_check_mount_test_dev
@@ -25,21 +25,23 @@ cd "$TEST_MNT"
 check_default_id 5

 # check "subvol set-default <subvolid> <path>"
-run_check "$TOP/btrfs" subvol create sub
-run_check $SUDO_HELPER "$TOP/btrfs" subvol set-default 257 .
-check_default_id 257
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub
+id=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub)
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume set-default "$id" .
+check_default_id "$id"

 run_mustfail "set-default to non existent id" \
-       $SUDO_HELPER "$TOP/btrfs" subvol set-default 100 .
+       $SUDO_HELPER "$TOP/btrfs" subvolume set-default 100 .

 # check "subvol set-default <subvolume>"
-run_check "$TOP/btrfs" subvol create sub2
-run_check $SUDO_HELPER "$TOP/btrfs" subvol set-default ./sub2
-check_default_id 258
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume create sub2
+id=$(run_check_stdout "$TOP/btrfs" inspect-internal rootid sub2)
+run_check $SUDO_HELPER "$TOP/btrfs" subvolume set-default ./sub2
+check_default_id "$id"

-run_check mkdir sub2/dir
+run_check $SUDO_HELPER mkdir sub2/dir
 run_mustfail "set-default to normal directory" \
-       $SUDO_HELPER "$TOP/btrfs" subvol set-default ./sub2/dir
+       $SUDO_HELPER "$TOP/btrfs" subvolume set-default ./sub2/dir

 cd ..
 run_check_umount_test_dev

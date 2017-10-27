Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50427 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdJ0Axc (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 26 Oct 2017 20:53:32 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 1/2] btrfs-progs: test/common: Introduce run_mustfail_stdout and enhance prepare_test_dev
Date: Fri, 27 Oct 2017 08:53:23 +0800
Message-Id: <20171027005324.17950-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, run_mustfail_stdout(), which is similar to
run_mustfail(), with extra output redirection.
Also this new run_mustfail_stdout() doesn't set pipefail and use
temporary file to catch the output.
So it doesn't support command with pipeline.

Also enhance prepare_test_dev() to truncates the file even it already
exists.
So test device size will be reset each time prepare_test_dev() get
called.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Nothing
v3:
  Split the test infrastructure modification into its own patch.
---
 tests/common | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index eb525a4d02c5..80392c3a6d7d 100644
--- a/tests/common
+++ b/tests/common
@@ -236,6 +236,58 @@ run_mustfail()
 	fi
 }
 
+# The first parameter is error message to print if it fails, just like
+# run_must_fail().
+# Also we don't use pipefail to avoid disturbing other script, so here we
+# use temporary output file.
+# So it doesn't support pipeline in the @cmd
+run_mustfail_stdout()
+{
+	local spec
+	local ins
+	local cmd
+	local msg
+	local ret
+	local tmp_output
+
+	tmp_output=$(mktemp --tmpdir btrfs-progs-test--mustfail-stdtout.XXXXXX)
+
+	msg="$1"
+	shift
+
+	if _is_file_or_command "$msg"; then
+		echo "ASSERTION FAIL: 1st argument of run_mustfail_stdout must be a message"
+		exit 1
+	fi
+
+	ins=$(_get_spec_ins "$@")
+	spec=$(($ins-1))
+	cmd=$(eval echo "\${$spec}")
+	spec=$(_cmd_spec "${@:$spec}")
+	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
+	echo "############### $@" >> "$RESULTS" 2>&1
+	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(mustfail): $@" > /dev/tty; fi
+	if [ "$1" = 'root_helper' ]; then
+		"$@" 2>&1 > "$tmp_output"
+	else
+		$INSTRUMENT "$@" 2>&1 > "$tmp_output"
+	fi
+	ret=$?
+
+	cat "$tmp_output" >> "$RESULTS"
+	cat "$tmp_output"
+	rm "$tmp_output"
+
+	if [ "$ret" != 0 ]; then
+		echo "failed (expected): $@" >> "$RESULTS"
+		return 0
+	else
+		echo "succeeded (unexpected!): $@" >> "$RESULTS"
+		_fail "unexpected success: $msg"
+		return 1
+	fi
+}
+
 check_prereq()
 {
 	if ! [ -f "$TOP/$1" ]; then
@@ -389,8 +441,12 @@ prepare_test_dev()
 	# num[K/M/G/T...]
 	local size="$1"
 
-	[[ "$TEST_DEV" ]] && return
 	[[ "$size" ]] || size='2G'
+	# Still truncate it to new size
+	if [[ "$TEST_DEV" ]]; then
+		truncate -s "$size" "$TEST_DEV"
+		return;
+	fi
 
 	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \
 		"$RESULTS"
-- 
2.14.3


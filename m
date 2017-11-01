Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40304 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754005AbdKABaw (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 21:30:52 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 2/4] btrfs-progs: test/common: Introduce run_mustfail_stdout
Date: Wed,  1 Nov 2017 09:30:41 +0800
Message-Id: <20171101013043.19294-3-wqu@suse.com>
In-Reply-To: <20171101013043.19294-1-wqu@suse.com>
References: <20171101013043.19294-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For later test case which needs info from stderr.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/common | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tests/common b/tests/common
index dec090fe5849..977bade201a6 100644
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
-- 
2.14.3


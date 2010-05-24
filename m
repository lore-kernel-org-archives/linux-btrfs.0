From: Shi Weihua <shiwh@cn.fujitsu.com>
Subject: Re: [PATCH 07/10] btrfs: fix wrong ctime when adding link
Date: Mon, 24 May 2010 14:37:04 +0800
Message-ID: <4BFA1E90.5050805@cn.fujitsu.com>
References: <4BF4E336.40603@cn.fujitsu.com> <20100520083300.GB11920@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100520083300.GB11920@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

cc xfstests ml

at 2010-5-20 16:33, Christoph Hellwig wrote:
> On Thu, May 20, 2010 at 03:22:30PM +0800, Miao Xie wrote:
>> the ctime of file has not been updated when I create a link for it.
>>
>> Steps to reproduce:
>>  # touch file1
>>  # stat -c %Z file1
>>  1273592239
>>  # link flink1 file1
>>  # stat -c %Z file1
>>  1273592239             <-- have not been updated
>>
>> This patch fix this problem.
> 
> Care to add a test to xfstests to check for this regression?

did it. 

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff -urpN xfstests.orig/229 xfstests/229
--- xfstests.orig/229	1970-01-01 08:00:00.000000000 +0800
+++ xfstests/229	2010-05-28 11:27:14.000000000 +0800
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 229
+#
+# Check ctime updated or not if file linked
+# See also http://marc.info/?l=linux-btrfs&m=127434439020230&w=2
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 FUJITSU LIMITED. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=shiwh@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+_cleanup()
+{
+	if [ -a $TEST_DIR/ouch2 ]; then
+		rm -f $TEST_DIR/ouch2
+	fi
+	if [ -a $TEST_DIR/ouch ]; then
+		rm -f $TEST_DIR/ouch
+	fi
+}
+
+here=`pwd`
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports fallocate
+_supported_os Linux
+
+# create a file and get its ctime
+touch $TEST_DIR/ouch
+ctime=`stat -c %Z $TEST_DIR/ouch`
+sleep 1
+
+# create a link to a file and get existing file's ctime 
+link $TEST_DIR/ouch $TEST_DIR/ouch2
+ctime2=`stat -c %Z $TEST_DIR/ouch`
+
+# check ctime updated
+if [ $ctime2 -le $ctime ]; then
+	echo "ctime: $ctime -> $ctime2 "
+	echo "Fatal error: ctime not updated after link"
+	_cleanup
+	exit 1
+fi
+
+_cleanup
+
+echo "Test over."
+# success, all done
+status=0
+exit
diff -urpN xfstests.orig/229.out xfstests/229.out
--- xfstests.orig/229.out	1970-01-01 08:00:00.000000000 +0800
+++ xfstests/229.out	2010-05-28 11:27:14.000000000 +0800
@@ -0,0 +1,2 @@
+QA output created by 229
+Test over.
diff -urpN xfstests.orig/group xfstests/group
--- xfstests.orig/group	2010-05-07 23:32:13.000000000 +0800
+++ xfstests/group	2010-05-28 11:27:02.000000000 +0800
@@ -342,3 +342,4 @@ deprecated
 226 auto enospc
 227 auto fsr
 228 rw auto prealloc quick
+229 auto


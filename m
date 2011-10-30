From: Hugo Mills <hugo@carfax.org.uk>
Subject: [RFC] [PROGS] Regression tests
Date: Sun, 30 Oct 2011 21:44:56 +0000
Message-ID: <b17197c7428fa5b75a2d9ac95806fdd41be60424.1320010556.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add a shell-script based test harness for performing regression tests
on btrfs tools. This is not intended as a test system for kernel
issues, but instead to put the userspace tools through their paces.

Currently implemented tests are compilation of all tools, and checking
argument counting on "btrfs sub snap". Other tests will follow.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---

   If nobody has any major comments or objections, I'll feed this up
to Chris from the integration branch when I next send him a stack of
patches.

   Hugo.


 Makefile          |    8 +++
 test/001u.sh      |   23 ++++++++++
 test/002s.sh      |   42 +++++++++++++++++
 test/functions.sh |  128 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/run-tests    |   13 +++++
 5 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100755 test/001u.sh
 create mode 100755 test/002s.sh
 create mode 100644 test/functions.sh
 create mode 100755 test/run-tests

diff --git a/Makefile b/Makefile
index edee1a0..24e1ce1 100644
--- a/Makefile
+++ b/Makefile
@@ -100,4 +100,12 @@ install: $(progs) install-man
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
 
+test: test-userspace test-root
+
+test-userspace:
+	./test/run-tests
+
+test-root:
+	sudo ./test/run-tests
+
 -include .*.d
diff --git a/test/001u.sh b/test/001u.sh
new file mode 100755
index 0000000..d2cadff
--- /dev/null
+++ b/test/001u.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+. test/functions.sh
+
+unset BTRFS_TESTS_VOLUMES
+
+announce compilation
+
+export CC=gcc-4.6
+catchclean
+make clean >/dev/null 2>&1
+
+catch make || fail Plain make failed
+#catch make dir-test || fail Failed to make dir-test
+catch make btrfs-zero-log || fail Failed to make btrfs-zero-log
+catch make btrfs-select-super || fail Failed to make btrfs-select-super
+catch make btrfstune || fail Failed to make btrfstune
+catch make btrfs-image || fail Failed to make btrfsimage
+catch make quick-test || fail Failed to make quick-test
+catch make convert || fail Failed to make btrfs-convert
+catch make ioctl-test || fail Failed to make ioctl-test
+
+summarise
diff --git a/test/002s.sh b/test/002s.sh
new file mode 100755
index 0000000..2c715b7
--- /dev/null
+++ b/test/002s.sh
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+. test/functions.sh
+
+MNT=./test-mountpoint
+
+function setup() {
+	setup_mkfs btrfs-tests $MNT
+
+	./btrfs subvolume create $MNT/source >/dev/null || return 1
+	dd if=/dev/urandom of=$MNT/source/file1 \
+		bs=1M count=1 >/dev/null 2>&1 || return 1
+}
+
+function teardown() {
+	teardown_rmfs $MNT
+}
+
+announce snapshot
+catchclean
+
+function test_ro() {
+	./btrfs subvolume snapshot -r $MNT/source $MNT/destination
+	echo foo >$MNT/destination/foo.txt
+}
+
+# Success modes
+catch ./btrfs subvolume snapshot $MNT/source $MNT/destination \
+	|| fail Failed to create rw snapshot
+catch ./btrfs subvolume snapshot -r $MNT/source $MNT/destination \
+	|| fail Failed to create ro snapshot
+catch test_ro && fail Failed to use read-only flag
+
+# Failure modes
+catch ./btrfs subvolume snapshot \
+	&& fail Accepted incorrect parameters \(0 params\)
+catch ./btrfs subvolume snapshot $MNT/source \
+	&& fail Accepted incorrect parameters \(1 param\)
+catch ./btrfs subvolume snapshot -r $MNT/source \
+	&& fail Accepted incorrect parameters \(1 param, ro\)
+
+summarise
diff --git a/test/functions.sh b/test/functions.sh
new file mode 100644
index 0000000..ca89c67
--- /dev/null
+++ b/test/functions.sh
@@ -0,0 +1,128 @@
+BTRFS_TESTS_VOLUMES="test1.img test2.img test3.img test4.img"
+TESTS_RUN=0
+TESTS_SUCCEEDED=0
+
+if [ -f .tests.conf ]; then
+	. .tests.conf
+fi
+
+function announce()
+{
+	echo --- $(basename $0) --- Testing "$@"
+}
+
+function summarise()
+{
+	echo === ${TESTS_RUN} tests run
+	echo === ${TESTS_SUCCEEDED} successes
+	echo === $((${TESTS_RUN}-${TESTS_SUCCEEDED})) failures
+}
+
+function catchclean()
+{
+	export SUITE=$(basename "$0" .sh)
+	rm -f ${SUITE}.out ${SUITE}.err
+	touch ${SUITE}.out ${SUITE}.err
+}
+
+# Internal function: set up/check the test volumes as requested
+function local_setup()
+{
+	# Set up for this test
+	VOLUMES=
+	for vol in $BTRFS_TESTS_VOLUMES; do
+		if [ ! -e $vol ]; then
+			dd if=/dev/zero of=$vol count=0 seek=4G bs=1 >/dev/null 2>&1 || return 1
+		fi
+		if [ -f $vol ]; then
+			vol=$(losetup -f --show $vol) || return 1
+			VOLUMES="$VOLUMES $vol"
+		elif [ -b $vol ]; then
+			VOLUMES="$VOLUMES $vol"
+		else
+			echo Don\'t know what to do with $vol
+		fi
+	done
+}
+
+# Internal function: destroy test volumes if we created them
+function local_teardown()
+{
+	for vol in $VOLUMES; do
+		if [ -b $vol ]; then
+			if losetup $vol >/dev/null 2>&1; then
+				file=$(losetup $vol | sed -e 's/^.* (\(.*\)).*$/\1/')
+				losetup -d $vol
+				rm $file
+			fi
+		fi
+	done
+	return 0
+}
+
+trap local_teardown EXIT
+
+function catch()
+{
+	TESTS_RUN=$((${TESTS_RUN}+1))
+
+	local_setup
+	if ! setup; then
+		teardown
+		local_teardown
+		return 1
+	fi
+
+	# Preemptively increase the success count: if we call fail, we'll
+	# decrease it again
+	TESTS_SUCCEEDED=$((${TESTS_SUCCEEDED}+1))
+
+	"$@" >>${SUITE}.out 2>>${SUITE}.err
+	rv=$?
+
+	# Undo any setup we did earlier
+	teardown
+	local_teardown
+
+	return ${rv}
+}
+
+function fail()
+{
+	echo "$@"
+	TESTS_SUCCEEDED=$((${TESTS_SUCCEEDED}-1))
+	summarise
+	exit 1
+}
+
+function setup()
+{
+	echo -n
+}
+
+function teardown()
+{
+	echo -n
+}
+
+function setup_mkfs()
+{
+	LABEL=$1
+	MNT=$2
+
+	mkdir -p $MNT
+	./mkfs.btrfs -L $LABEL $VOLUMES >/dev/null || return 1
+	mount LABEL=$LABEL $MNT || return 1
+}
+
+function teardown_rmfs()
+{
+	MNT=$1
+
+	sleeptime=1
+	while ! umount $MNT 2>/dev/null; do
+		sleep ${sleeptime}
+		sleeptime=$((${sleeptime}+2))
+	done
+	rmdir $MNT
+}
diff --git a/test/run-tests b/test/run-tests
new file mode 100755
index 0000000..981fc22
--- /dev/null
+++ b/test/run-tests
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+testdir=$(dirname $0)
+
+if [ $UID -eq 0 ]; then
+	type=s
+else
+	type=u
+fi
+
+for test in ${testdir}/[0-9][0-9][0-9]${type}.sh; do
+	${test}
+done
-- 
1.7.6.3


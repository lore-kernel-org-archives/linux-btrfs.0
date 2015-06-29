Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbbF2PmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 11:42:23 -0400
Date: Mon, 29 Jun 2015 17:42:21 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs-progs: add feature to get mininum size for
 resizing a fs/device
Message-ID: <20150629154221.GD726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434541495-14934-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434541495-14934-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 12:44:55PM +0100, fdmanana@kernel.org wrote:
> Currently there is not way for a user to know what is the minimum size a
> device of a btrfs filesystem can be resized to. Sometimes the value of
> total allocated space (sum of all allocated chunks/device extents), which
> can be parsed from 'btrfs filesystem show' and 'btrfs filesystem usage',
> works as the minimum size, but sometimes it does not, namely when device
> extents have to relocated to holes (unallocated space) within the new
> size of the device (the total allocated space sum).
> 
> This change adds the ability to reliably compute such minimum value and
> extents 'btrfs filesystem resize' with the following syntax to get such
> value:

The test fails after I do this before unmount:

$SUDO_HELPER $TOP/btrfs balance start -mconvert=single -sconvert=single -f $TEST_MNT
shrink_test

Output:

############### root_helper ../btrfs filesystem resize get_min_size ../tests/mnt
6480199680 bytes (6.04GiB)
min size = 6480199680
############### root_helper ../btrfs filesystem resize 6480199680 ../tests/mnt
ERROR: unable to resize '../tests/mnt' - No space left on device
Resize '../tests/mnt' of '6480199680'

Last successful resize before this was:
Resize '../tests/mnt' of '7553941504'

>    btrfs filesystem resize [devid:]get_min_size

I don't think this is the right interface, IMHO this fits into the
inspect-internal group. The syntax for 'fi resize' is a bit cumbersome, I'd
like to avoid complicating it further. But you can keep it as-is until the the
bugs are fixed.

> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -46,7 +46,7 @@ libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
>  libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
>  	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
>  	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
> -TESTS = fsck-tests.sh convert-tests.sh
> +TESTS = fsck-tests.sh convert-tests.sh shrink-min-size-tests.sh
>  
>  prefix ?= @prefix@
>  exec_prefix = @exec_prefix@
> @@ -161,6 +161,10 @@ $(BUILDDIRS):
>  	@echo "Making all in $(patsubst build-%,%,$@)"
>  	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
>  
> +test-shrink-min-size: btrfs mkfs.btrfs
> +	@echo "    [TEST]   shrink-min-size-tests.sh"
> +	$(Q)bash tests/shrink-min-size-tests.sh

Please move the test under the test-misc, for now it's a catch-all category.

General comments to the test script(s):
* the tests are supposed to be run unprivileged as much as possible, so the
  SUDO_HELPER needs to be used explicitly
* use the git binaries everywhere

(diff below)

> +shrink_test()
> +{
> +	min_size=$(btrfs filesystem resize get_min_size $TEST_MNT)

sudo helper, use binary from git

> +	if [ $? != 0 ]; then
> +		_fail "Failed to get minimum size"
> +	fi
> +	min_size=$(echo $min_size | cut -d ' ' -f 1)
> +	echo "min size = ${min_size}" >> $RESULTS
> +	run_check btrfs filesystem resize $min_size $TEST_MNT

sudo helper, use binary from git

> +}
> +
> +run_check truncate -s 20G $IMAGE
> +run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $IMAGE

sudo helper not necessary, it's a file-backed image

> +run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
> +
> +# Create 7 data block groups, each with a size of 1Gb.
> +for ((i = 1; i <= 7; i++)); do
> +	run_check fallocate -l 1G $TEST_MNT/foo$i

This failed as the mountpoint is created by root and I'm running the
test under my user. A chown after mount fixed it.

> +done
[...]

@@ -23,19 +23,23 @@ setup_root_helper

 shrink_test()
 {
-       min_size=$(btrfs filesystem resize get_min_size $TEST_MNT)
+       min_size=$(run_check_stdout $SUDO_HELPER $TOP/btrfs filesystem resize get_min_size $TEST_MNT)
        if [ $? != 0 ]; then
                _fail "Failed to get minimum size"
        fi
        min_size=$(echo $min_size | cut -d ' ' -f 1)
        echo "min size = ${min_size}" >> $RESULTS
-       run_check btrfs filesystem resize $min_size $TEST_MNT
+       run_check $SUDO_HELPER $TOP/btrfs filesystem resize $min_size $TEST_MNT
 }

 run_check truncate -s 20G $IMAGE
-run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $IMAGE
+run_check $TOP/mkfs.btrfs -f $IMAGE
 run_check $SUDO_HELPER mount $IMAGE $TEST_MNT

+user=$(id -un)
+group=$(id -gn)
+run_check $SUDO_HELPER chown $user:$group $TEST_MNT
+
 # Create 7 data block groups, each with a size of 1Gb.
 for ((i = 1; i <= 7; i++)); do
        run_check fallocate -l 1G $TEST_MNT/foo$i
@@ -43,7 +47,7 @@ done

 # Make sure they are persisted (all the chunk, device and block group items
 # added to the chunk/dev/extent trees).
-run_check btrfs filesystem sync $TEST_MNT
+run_check $TOP/btrfs filesystem sync $TEST_MNT

 # Now remove 3 of those 1G files. This will result in 3 block groups becoming
 # unused, which will be automatically deleted by the cleaner kthread, and this
@@ -58,9 +62,9 @@ run_check rm -f $TEST_MNT/foo6
 # groups - it could have been sleeping when they become unused. Then wait a bit
 # to allow the cleaner kthread to delete them and then finally ensure the
 # transaction started by the cleaner kthread is committed.
-run_check btrfs filesystem sync $TEST_MNT
+run_check $TOP/btrfs filesystem sync $TEST_MNT
 sleep 3
-run_check btrfs filesystem sync $TEST_MNT
+run_check $TOP/btrfs filesystem sync $TEST_MNT

 # Now attempt to get the minimum size we can resize the filesystem to and verify
 # the resize operation succeeds. This size closely matches the sum of the size
---

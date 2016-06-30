Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbcF3EHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 00:07:43 -0400
Date: Thu, 30 Jun 2016 12:07:27 +0800
From: Eryu Guan <eguan@redhat.com>
To: jeffm@suse.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs/124: test global metadata reservation
 reporting
Message-ID: <20160630040727.GQ23649@eguan.usersys.redhat.com>
References: <1467058454-25907-1-git-send-email-jeffm@suse.com>
 <1467058454-25907-3-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467058454-25907-3-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 04:14:12PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Btrfs can now report the size of the global metadata reservation
> via ioctl and sysfs.
> 
> This test confirms that we get sane results on an empty file system.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  .gitignore               |   1 +
>  common/btrfs             |  43 +++++++++++++++

We have all sorts of btrfs-specific helpers in common/rc now, and IIRC
Dave said he had a pending patch to move all the btrfs helpers to
commom/btrfs. So I think for now it's OK to add new btrfs helpers just
to common/rc.

>  src/Makefile             |   3 +-
>  src/btrfs_ioctl_helper.c | 132 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/124          |  84 ++++++++++++++++++++++++++++++
>  tests/btrfs/124.out      |   1 +
>  tests/btrfs/group        |   1 +
>  7 files changed, 264 insertions(+), 1 deletion(-)
>  create mode 100644 common/btrfs
>  create mode 100644 src/btrfs_ioctl_helper.c
>  create mode 100755 tests/btrfs/124
>  create mode 100644 tests/btrfs/124.out
> 
> diff --git a/.gitignore b/.gitignore
> index 28bd180..0e4f2a1 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -39,6 +39,7 @@
>  /src/append_reader
>  /src/append_writer
>  /src/bstat
> +/src/btrfs_ioctl_helper
>  /src/bulkstat_unlink_test
>  /src/bulkstat_unlink_test_modified
>  /src/dbtest
> diff --git a/common/btrfs b/common/btrfs
> new file mode 100644
> index 0000000..b972b13
> --- /dev/null
> +++ b/common/btrfs
> @@ -0,0 +1,43 @@
> +#!/bin/bash
> +# Functions for testing btrfs
> +
> +_btrfs_get_fsid()
> +{
> +	local mnt=$1
> +	if [ -z "$mnt" ]; then
> +		mnt=$TEST_DIR
> +	fi
> +	$BTRFS_UTIL_PROG filesystem show $mnt|awk '/uuid:/ {print $NF}'
> +}
> +
> +_btrfs_get_sysfs()
> +{
> +	local mnt=$1
> +	local fsid=$(_btrfs_get_fsid $mnt)
> +	echo "/sys/fs/btrfs/$fsid"
> +}
> +
> +_require_btrfs_sysfs()
> +{
> +	local mnt=$1
> +	if [ -z "$mnt" ]; then
> +		mnt=$TEST_DIR
> +	fi
> +	if [ ! -d "$(_btrfs_get_sysfs $mnt)" ];then
> +		_notrun "btrfs sysfs support not available."
> +	fi
> +}

I think this helper can be expended to accept an sysfs attribute and
test if the required attribute exists, and _notrun if not exist. So the
following piece of code can be omitted.

 +SYSFS_PREFIX="$(_btrfs_get_sysfs)/allocation"
 +[ -d "$SYSFS_PREFIX" ] || _notrun "sysfs directory not found"
 +

We can simply do "_require_btrfs_sysfs allocation" in the test.

> +_require_btrfs_ioctl()
> +{
> +	local ioctl=$1
> +	local mnt=$2
> +	shift 2
> +	if [ -z "$mnt" ]; then
> +		mnt=$TEST_DIR
> +	fi

Need a '_require_test_program "btrfs_ioctl_helper"' here to make sure
the binary is built.

> +	out=$(src/btrfs_ioctl_helper $mnt $ioctl $@)
> +	if [ "$out" = "Not implemented." ]; then
> +		_notrun "btrfs ioctl $ioctl not implemented."
> +	fi
> +}
> diff --git a/src/Makefile b/src/Makefile
> index 1bf318b..c467475 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -20,7 +20,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
>  	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
>  	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> -	renameat2 t_getcwd e4compact test-nextquota punch-alternating
> +	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> +	btrfs_ioctl_helper
>  
>  SUBDIRS =
>  
> diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
> new file mode 100644
> index 0000000..b6eb924
> --- /dev/null
> +++ b/src/btrfs_ioctl_helper.c
> @@ -0,0 +1,132 @@
> +#include <sys/ioctl.h>
> +#include <stdio.h>
> +#include <sys/fcntl.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +
> +#ifndef BTRFS_IOCTL_MAGIC
> +#define BTRFS_IOCTL_MAGIC 0x94
> +#endif
> +
> +#ifndef BTRFS_IOC_SPACE_INFO
> +struct btrfs_ioctl_space_info {
> +        uint64_t flags;
> +        uint64_t total_bytes;
> +        uint64_t used_bytes;
> +};
> +
> +struct btrfs_ioctl_space_args {
> +        uint64_t space_slots;
> +        uint64_t total_spaces;
> +        struct btrfs_ioctl_space_info spaces[0];
> +};
> +#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
> +                                    struct btrfs_ioctl_space_args)
> +#endif
> +#ifndef BTRFS_SPACE_INFO_GLOBAL_RSV
> +#define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
> +#endif
> +
> +static int global_rsv_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_space_args arg;
> +	struct btrfs_ioctl_space_args *args;
> +	int ret;
> +	int i;
> +	size_t size;
> +
> +	arg.space_slots = 0;
> +
> +	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, &arg);
> +	if (ret)
> +		return -errno;
> +
> +	size = sizeof(*args) + sizeof(args->spaces[0]) * arg.total_spaces;
> +	args = malloc(size);
> +	if (!args)
> +		return -ENOMEM;
> +
> +	args->space_slots = arg.total_spaces;
> +
> +	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, args);
> +	if (ret)
> +		return -errno;
> +
> +	for (i = 0; i < args->total_spaces; i++) {
> +		if (args->spaces[i].flags & BTRFS_SPACE_INFO_GLOBAL_RSV) {
> +			unsigned long long reserved;
> +			reserved = args->spaces[i].total_bytes;
> +			printf("%llu\n", reserved);
> +			return 0;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +#define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
> +	{ .name = #_ioctl_name, .ioctl_cmd = BTRFS_IOC_##_ioctl_name, \
> +	  .handler = _handler, }
> +
> +struct ioctl_table_entry {
> +	const char *name;
> +	unsigned ioctl_cmd;
> +	int (*handler)(int fd, int argc, char *argv[]);
> +};
> +
> +static struct ioctl_table_entry ioctls[] = {
> +	IOCTL_TABLE_ENTRY(SPACE_INFO, global_rsv_ioctl),
> +};
> +
> +int
> +main(int argc, char *argv[])
> +{
> +	int fd;
> +	int ret;
> +	struct ioctl_table_entry *entry = NULL;
> +	int i;
> +
> +	if (argc < 3) {
> +		fprintf(stderr,
> +			"usage: %s <fs mount point> <ioctl name> [args..]\n",
> +			argv[0]);
> +		return 1;
> +	}
> +
> +	fd = open(argv[1], O_RDONLY|O_DIRECTORY);
> +	if (fd < 0) {
> +		perror(argv[1]);
> +		return 1;
> +	}
> +
> +	for (i = 0; i < (sizeof(ioctls)/sizeof(ioctls[0])); i++) {
> +		if (strcmp(argv[2], ioctls[i].name) == 0) {
> +			entry = &ioctls[i];
> +			break;
> +		}
> +	}
> +
> +	if (!entry) {
> +		fprintf(stderr, "ERROR: unknown ioctl %s\n", argv[2]);
> +		close(fd);
> +		return 1;
> +	}
> +
> +	ret = entry->handler(fd, argc - 3, argv + 3);
> +	if (ret == -ENOTTY) {
> +		printf("Not implemented.\n");
> +		close(fd);
> +		return 0;
> +	} else if (ret) {
> +		fprintf(stderr, "ERROR: %s failed: %s\n",
> +			entry->name, strerror(-ret));
> +		close(fd);
> +		return 1;
> +	}
> +
> +	close(fd);
> +	return 0;
> +}
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> new file mode 100755
> index 0000000..2ab9dfb
> --- /dev/null
> +++ b/tests/btrfs/124
> @@ -0,0 +1,84 @@
> +#!/bin/bash
> +# FA QA Test No. 124
> +#
> +# Test global metadata reservation reporting
> +#
> +# 1) Create empty file system
> +# 2) Call the BTRFS_IOC_GLOBAL_RSV ioctl
> +# 3) Read the /sys/fs/btrfs/<fsid>/allocation/global_rsv_reserved file
> +#    and confirm it's a number
> +# 4) Compare the results between the two to confirm they match
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 SUSE, All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  12110-1301  USA
> +#-----------------------------------------------------------------------
> +
> +seq=$(basename $0)
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/btrfs
> +. ./common/filter.btrfs
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_test
> +_require_btrfs_ioctl SPACE_INFO
> +_require_btrfs_sysfs
> +
> +IOCTL="src/btrfs_ioctl_helper"
> +
> +SYSFS_PREFIX="$(_btrfs_get_sysfs)/allocation"

We usually use lowercase names for local use in fstests, reserve
uppercase names for global names like SCRATCH_DEV, MOUNT_PROG

> +[ -d "$SYSFS_PREFIX" ] || _notrun "sysfs directory not found"
> +
> +check_sysfs_output()
> +{
> +	reserved="$1"
> +	method="$2"
> +	if [ -n "$(echo $reserved | tr -d 0-9)" ]; then
> +		echo "$method: numerical value expected (got $reserved)"
> +	fi
> +}
> +
> +ioctl_reserved="$($IOCTL $TEST_DIR SPACE_INFO)"
> +
> +reserved="$(cat $SYSFS_PREFIX/global_rsv_reserved)"
> +check_sysfs_output "$reserved" "sysfs:reserved"
> +if [ "$reserved" != "$ioctl_reserved" ]; then
> +	echo "ioctl ($ioctl_reserved) != sysfs ($reserved)"
> +fi
> +size="$(cat $SYSFS_PREFIX/global_rsv_size)"
> +check_sysfs_output "$size" "sysfs:size"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/124.out b/tests/btrfs/124.out
> new file mode 100644
> index 0000000..0129e81
> --- /dev/null
> +++ b/tests/btrfs/124.out
> @@ -0,0 +1 @@
> +QA output created by 124

In fstests if the test doesn't print anything to stdout, some sentence
is needed to indicate the fact, usually it's "Silence is golden".

> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 5a26ed7..8b5050e 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -126,3 +126,4 @@
>  121 auto quick snapshot qgroup
>  122 auto quick snapshot qgroup
>  123 auto quick qgroup
> +124 auto quick metadata
> -- 
> 1.8.5.6
> 

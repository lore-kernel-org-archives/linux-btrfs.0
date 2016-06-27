Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbcF0HQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 03:16:50 -0400
Date: Mon, 27 Jun 2016 15:16:47 +0800
From: Eryu Guan <eguan@redhat.com>
To: jeffm@suse.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] fstests: btrfs/124: test global metadata reservation
 reporting
Message-ID: <20160627071647.GP23649@eguan.usersys.redhat.com>
References: <1466780914-23884-1-git-send-email-jeffm@suse.com>
 <1466780914-23884-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466780914-23884-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 11:08:32AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Btrfs can now report the size of the global metadata reservation
> via ioctl and sysfs.
> 
> This test confirms that we get sane results on an empty file system.
> 
> ENOTTY and missing /sys/fs/btrfs/<fsid>/allocation are not considered
> failures.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I'm reviewing mainly from the fstests perspective, need help from other
btrfs developers to review the test itself to see if it's a valid &
useful test.

> ---
>  common/rc                |   6 ++
>  src/Makefile             |   3 +-
>  src/btrfs_ioctl_helper.c | 220 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/124          |  90 +++++++++++++++++++
>  tests/btrfs/124.out      |   2 +
>  tests/btrfs/group        |   1 +
>  6 files changed, 321 insertions(+), 1 deletion(-)
>  create mode 100644 src/btrfs_ioctl_helper.c
>  create mode 100755 tests/btrfs/124
>  create mode 100644 tests/btrfs/124.out
> 
> diff --git a/common/rc b/common/rc
> index 3a9c4d1..4b05fcf 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -76,6 +76,12 @@ _btrfs_get_subvolid()
>  	$BTRFS_UTIL_PROG sub list $mnt | grep $name | awk '{ print $2 }'
>  }
>  
> +_btrfs_get_fsid()
> +{
> +	local dev=$1
> +	$BTRFS_UTIL_PROG filesystem show $dev|awk '/uuid:/ {print $NF}'
> +}
> +
>  # Prints the md5 checksum of a given file
>  _md5_checksum()
>  {
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

.gitignore needs an entry for new binary.

But I'm wondering that is this something that can be added to
btrfs-progs, either as part of the btrfs command or a seperate command?

>  
>  SUBDIRS =
>  
> diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
> new file mode 100644
> index 0000000..4344bdc
> --- /dev/null
> +++ b/src/btrfs_ioctl_helper.c
> @@ -0,0 +1,220 @@
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
> +#ifndef BTRFS_IOC_GET_FEATURES
> +struct btrfs_ioctl_feature_flags {
> +	uint64_t compat_flags;
> +	uint64_t compat_ro_flags;
> +	uint64_t incompat_flags;
> +};
> +
> +#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags)
> +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags[2])
> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
> +                                   struct btrfs_ioctl_feature_flags[3])
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
> +static int get_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags;
> +	int ret = ioctl(fd, BTRFS_IOC_GET_FEATURES, &flags);
> +	if (ret)
> +		return -errno;
> +
> +	printf("0x%llx 0x%llx 0x%llx\n",
> +	       (unsigned long long)flags.compat_flags,
> +	       (unsigned long long)flags.compat_ro_flags,
> +	       (unsigned long long)flags.incompat_flags);
> +	return 0;
> +}
> +
> +static int set_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags[2];
> +	uint64_t bit, *bits, *mask;
> +	if (argc != 3)
> +		goto usage;
> +
> +	memset(flags, 0, sizeof(flags));
> +
> +	errno = 0;
> +	bit = strtoull(argv[2], NULL, 10);
> +	if (errno)
> +		goto usage;
> +
> +	if (strcmp(argv[1], "compat") == 0) {
> +		mask = &flags[0].compat_flags;
> +		bits = &flags[1].compat_flags;
> +	} else if (strcmp(argv[1], "compat_ro") == 0) {
> +		mask = &flags[0].compat_ro_flags;
> +		bits = &flags[1].compat_ro_flags;
> +	} else if (strcmp(argv[1], "incompat") == 0) {
> +		mask = &flags[0].incompat_flags;
> +		bits = &flags[1].incompat_flags;
> +	} else
> +		goto usage;
> +
> +	*mask |= bit;
> +
> +	if (strcmp(argv[0], "set") == 0)
> +		*bits |= bit;
> +
> +	return ioctl(fd, BTRFS_IOC_SET_FEATURES, &flags);
> +usage:
> +	fprintf(stderr, "usage: SET_FEATURES <set|clear> <compat|compat_ro|incompat> <base-10 bitmask>\n");
> +	return -EINVAL;
> +}
> +
> +static int get_supported_features_ioctl(int fd, int argc, char *argv[])
> +{
> +	struct btrfs_ioctl_feature_flags flags[3];
> +	int ret;
> +	int i;
> +
> +	ret = ioctl(fd, BTRFS_IOC_GET_SUPPORTED_FEATURES, &flags);
> +	if (ret)
> +		return -errno;
> +
> +	for (i = 0; i < 3; i++)
> +		printf("0x%llx 0x%llx 0x%llx ",
> +		       (unsigned long long)flags[i].compat_flags,
> +		       (unsigned long long)flags[i].compat_ro_flags,
> +		       (unsigned long long)flags[i].incompat_flags);
> +
> +	printf("\n");
> +	return 0;
> +}
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
> +	IOCTL_TABLE_ENTRY(GET_FEATURES, get_features_ioctl),
> +	IOCTL_TABLE_ENTRY(SET_FEATURES, set_features_ioctl),
> +	IOCTL_TABLE_ENTRY(GET_SUPPORTED_FEATURES, get_supported_features_ioctl),
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
> index 0000000..4e6e6eb
> --- /dev/null
> +++ b/tests/btrfs/124
> @@ -0,0 +1,90 @@
> +#!/bin/bash
> +# FA QA Test No. 124
> +#
> +# Test global metadata reservation reporting
> +#
> +# 1) Create empty file system
> +# 2) Call the BTRFS_IOC_GLOBAL_RSV ioctl and confirm it is 0 < x < 32MB
> +# 3) Read the /sys/fs/btrfs/<fsid>/allocation/global_rsv_reserved file
> +#    and confirm the value is 0 < x < 32 MB
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SUSE, All Rights Reserved.
                   ^^^^ 2016
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
> +echo "== QA output created by $seq"

No need to change the default, so it's consistent with other tests

"QA output created by $seq"

> +
> +here=$(pwd)
> +tmp=/tmp/$$
> +status=1

You're missing a _cleanup function and its trap

trap "_cleanup; exit $status" 0 1 2 3 15

Please use "./new btrfs" and follow the template to create new test for
btrfs.

> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount

There should be some kind of "_require_xxx" or something like that to
_notrun if current running kernel doesn't have global metadata
reservation report implemented.

> +
> +# Check to see if the reservation is 0 < x <= 32MB
> +check_reserved() {
> +	reserved="$2"
> +	method="$3"
> +	if [ "$1" != 0 ]; then
> +		echo "$method: failed: $reserved"
> +		exit 1

No need to check the return value, if ioctl fails, $reserved contains
some kind of error message, which should fail one of the following
checks. The whole point of "golden image matching" is what we don't have
to check commands return value :)

> +	fi
> +	if [ "$reserved" = "Not implemented." ]; then
> +		echo "Skipping ioctl test. Not implemented." >> $seqres.full
> +		return

This doesn't belong here, it should call '_notrun' if the ioctl is not
implemented.

> +	fi
> +	if [ -n "$(echo $reserved | tr -d 0-9)" ]; then
> +		echo "ERROR: numerical value expected (got $reserved)"
> +		exit 1

No need to exit the whole test, just return should be fine.

> +	fi
> +	if [ "$reserved" -le 0 -o \
> +	       "$reserved" -gt "$(( 32 * 1024 * 1024 ))" ]; then

Need some comments about the range, why is it 0-32M?

> +		echo "$method: out of range: $reserved."
> +		exit 1

Don't exit.

> +	fi
> +}
> +
> +# ioctl
> +ioctl_reserved="$(src/btrfs_ioctl_helper $SCRATCH_MNT SPACE_INFO 2>&1)"
> +check_reserved $? "$ioctl_reserved" "ioctl"
> +
> +# sysfs
> +# If this directory is here, the files must be here as well
> +SYSFS_PREFIX="/sys/fs/btrfs/$(_btrfs_get_fsid $SCRATCH_DEV)/allocation"
> +if [ -d "$SYSFS_PREFIX" ]; then

_notrun if the sysfs entry doesn't exist.

> +	reserved="$(cat $SYSFS_PREFIX/global_rsv_reserved 2>&1)"
> +	check_reserved $? "$reserved" "sysfs:reserved"
> +	if [ "$reserved" != "$ioctl_reserved" ]; then
> +		echo "ioctl ($ioctl_reserved) != sysfs ($reserved)"
> +		exit 1

Don't exit.

Thanks,
Eryu
> +	fi
> +	size="$(cat $SYSFS_PREFIX/global_rsv_size 2>&1)"
> +	check_reserved $? "$size" "sysfs:size"
> +fi
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/124.out b/tests/btrfs/124.out
> new file mode 100644
> index 0000000..aeeb0e9
> --- /dev/null
> +++ b/tests/btrfs/124.out
> @@ -0,0 +1,2 @@
> +== QA output created by 124
> +Silence is golden
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
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

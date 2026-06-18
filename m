Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EF62459EA;
	Thu, 18 Jun 2026 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781796044; cv=none; b=KKgQxySGtPuTm42ZoiYU2YT2Z/oVXPVPK4ySorXhytYENwOHAHERiJ0YTb7a3PdBp6ezEtkrlsM7soW0cQhgb7Dfh2BfKzFKiLDiTYJVyHAl1gxO+mDFW+nZQU1WZRTG2glI++Fai1LUbfvD9IEnWwuSRze9zajtzQCZRm2rdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781796044; c=relaxed/simple;
	bh=+0/6DaKFjBOYg5GxY61A3JmmrX/ZIYn32XyflZQLVcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oafhDAtNfYnX0rRfa/q8bzDeAzU/RwuJkOF0M3fk2+1xXCGPpaCE8joPDHztjBW6l1evv0gdJJsaBMSySSqX0aYhL/SUxwFWG5nI1L7A9Dzw4+9YJwmiXWKRtCMRuXzBcwrUM6OpSYZ3Na7+ZLyxFeQ/+wi5/n1zasY1i7+ncIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+oHiZ9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+oHiZ9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32371F000E9;
	Thu, 18 Jun 2026 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781796043;
	bh=u9gv1segxcHk0Sp1tiyseXwisFAG7VRH11JpdxEyrFY=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=V+oHiZ9uQOkoSyZp/Ll9XaCqpNuY44H8MspXf7LQ8kyxJTd+xFrNAs1FMXlB1eplJ
	 ESAOyuPLdIyM4iainXJaVTul4/t+QagXAZ3/bM9JoBVRsyiELh9XMIpBRF56xwZZfS
	 AKctuU1RjEHSOAi8cXjLBBrUucYXOS6dN7fXaoZYPreJutM4syUGFrKjtZLCeztLZw
	 rXEcjSAO5GQq1SRi+GBFzhPcqDB1I2Ydch/cWKiC4QON1gnPMgGn9p1C/31TBmRsyX
	 vqQu6sCpnBAr6eF610k4a4hkMB0ZfEl8eSwig8x4QWgqPv0SJA+FZLfs8BGALRzu/D
	 KqaXNKmBF2tHA==
Message-ID: <a2a7aea4-a4ba-4746-aed3-3f2d91134be2@kernel.org>
Date: Thu, 18 Jun 2026 23:19:49 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: add a test case for btrfs get_subvol_info ioctl
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <20260618100521.91162-1-wqu@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <20260618100521.91162-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/6/26 18:05, Qu Wenruo wrote:
> There is a regression caused by upstream kernel commit 538e5bdbc899
> ("btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO"), where
> the unprivileged get_subvol_info ioctl is returning incorrect results.
> 
> Unfortunately that bug is not covered by fstests, and only exposed by
> btrfs-progs libbtrfsutil python tests, which is not a short run.
> 
> So add a new test case for such btrfs ioctl:
> 
> - Introduce a helper program, btrfs_ioctl
>   Which will call the dedicated ioctl, print all of its structure
>   members.
> 
>   For now only get_subvol_info is supported, but it can be easily
>   appended for new ones.
> 
> - Mkfs and create a subvolume on btrfs
> 
> - Use "_btrfs_get_subvolid()" to grab the subvolid
>   That function is utilizing "btrfs subvolume list" to grab the info,
>   which is not utilizing the unprivileged ioctl.
> 
> - Use "btrfs_ioctl get_subvol_info" to grab the subvolid
> 
> - Compare the two subvolids
> 
> This should be enough to detect the regression.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  .gitignore          |   1 +
>  src/Makefile        |   2 +-
>  src/btrfs_ioctl.c   | 103 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/351     |  47 ++++++++++++++++++++
>  tests/btrfs/351.out |   2 +
>  5 files changed, 154 insertions(+), 1 deletion(-)
>  create mode 100644 src/btrfs_ioctl.c
>  create mode 100755 tests/btrfs/351
>  create mode 100644 tests/btrfs/351.out
> 
> diff --git a/.gitignore b/.gitignore
> index dd77ee30..0b6b9452 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -215,6 +215,7 @@ tags
>  /src/file_attr
>  /src/truncate
>  /src/t_btrfs_received_uuid_ioctl
> +/src/btrfs_ioctl
>  
>  # Symlinked files
>  /tests/generic/035.out
> diff --git a/src/Makefile b/src/Makefile
> index 31ac43b2..76cf50c3 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
>  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>  	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
> -	rw_hint fs-monitor
> +	rw_hint fs-monitor btrfs_ioctl
>  
>  EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>  	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
> diff --git a/src/btrfs_ioctl.c b/src/btrfs_ioctl.c
> new file mode 100644
> index 00000000..4114fa88
> --- /dev/null
> +++ b/src/btrfs_ioctl.c
> @@ -0,0 +1,103 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) SUSE S.A.
> +
> +#include <stdio.h>
> +#include <string.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <uuid/uuid.h>
> +#include <linux/btrfs.h>
> +
> +#define subvol_info_printf_u64(info, name)	\
> +	printf(#name ": %llu\n", (info).name)
> +


> +#define subvol_info_printf_timestamp(info, name)	\

> +	printf(#name ": %llu.%09u\n", (info).name.sec, (info.name.nsec))
> +

Only the first match (info) get replaced per macro, not 2nd
(info.name.nsec); why?


> +#define subvol_info_printf_uuid(info, name)	\
> +{						\
> +	char uuidbuf[UUID_STR_LEN];		\
> +						\
> +	uuid_unparse((info).name, uuidbuf);	\
> +	printf(#name ": %s\n", (info).name);	\
> +}

It's
printf(#name ": %s\n", uuidbuf);


> +
> +void get_subvol_info(int fd)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args info = { 0 };
> +	int ret;
> +
> +	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &info);
> +	if (ret < 0) {
> +		fprintf(stderr, "ioctl failed: %m\n");
> +		return;
> +	}
> +
> +	subvol_info_printf_u64(info, treeid);
> +	printf("name: %.*s\n", BTRFS_VOL_NAME_MAX, info.name);
> +	subvol_info_printf_u64(info, parent_id);
> +	subvol_info_printf_u64(info, dirid);
> +	subvol_info_printf_u64(info, generation);
> +	printf("flags: 0x%llx\n", info.flags);
> +	subvol_info_printf_uuid(info, uuid);
> +	subvol_info_printf_uuid(info, parent_uuid);
> +	subvol_info_printf_uuid(info, received_uuid);
> +	subvol_info_printf_u64(info, ctransid);
> +	subvol_info_printf_u64(info, otransid);
> +	subvol_info_printf_u64(info, stransid);
> +	subvol_info_printf_u64(info, rtransid);
> +	subvol_info_printf_timestamp(info, ctime);
> +	subvol_info_printf_timestamp(info, otime);
> +	subvol_info_printf_timestamp(info, stime);
> +	subvol_info_printf_timestamp(info, rtime);
> +}
> +
> +const struct ioctl {
> +	const char *name;
> +	void (*func)(int fd);
> +} supported_ioctls[] = {
> +	{
> +		.name = "get_subvol_info",
> +		.func = get_subvol_info,
> +	},
> +};
> +
> +static void usage()
> +{
> +	fprintf(stderr, "Usage: btrfs_ioctl <ioctl_name> <path>\n");
> +}
> +int main(int argc, char **argv)
> +{
> +	const char *ioctl_name;
> +	int done = 0;
> +	int fd;
> +	int ret = 0;
> +

> +	if (argc != 3) {
> +		usage();
> +		return ret;
> +	}

ret is initialized to 0; instead, please return 1 here.


> +	fd = open(argv[2], O_RDONLY);
> +	if (fd < 0) {
> +		fprintf(stderr, "failed to open %s: %m", argv[2]);
> +		return 1;
> +	}

	\n is missing in fprintf().

Thanks.


> +	ioctl_name = argv[1];
> +
> +	for (int i = 0; i < sizeof(supported_ioctls) / sizeof(supported_ioctls[0]); i++) {
> +		const struct ioctl *ioctl = &supported_ioctls[i];
> +
> +		if (!strncasecmp(ioctl->name, ioctl_name, strlen(ioctl->name))) {
> +			ioctl->func(fd);
> +			done = 1;
> +			break;
> +		}
> +	}
> +	if (!done) {
> +		fprintf(stderr, "ioctl \"%s\" is not recognized\n", ioctl_name);
> +		ret = 1;
> +	}
> +	close(fd);
> +	return ret;
> +}
> diff --git a/tests/btrfs/351 b/tests/btrfs/351
> new file mode 100755
> index 00000000..e92ddf1b
> --- /dev/null
> +++ b/tests/btrfs/351
> @@ -0,0 +1,47 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 351
> +#
> +# Make sure the unprivileged get_subvol_info ioctl is providing the correct
> +# result.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"Revert \"btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO\""
> +
> +_require_test_program btrfs_ioctl
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_btrfs subvolume create $SCRATCH_MNT/subv1
> +
> +# The id is get through "btrfs subvolume list" command, which doesn't utilize the
> +# unprivileged version.
> +subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT subv1)
> +echo "subvolid=$subvolid" >> $seqres.full
> +
> +# Do a basic check in case "btrfs subvolume list" doesn't get a correct subvolid
> +if [ -z "$subvolid" -o "$subvolid" -lt 256 ]; then
> +	_fail "\"btrfs subvolume list\" returned an invalid subvolid"
> +fi
> +
> +# Get the id again through the unprivileged get_subvol_info ioctl
> +$here/src/btrfs_ioctl get_subvol_info $SCRATCH_MNT/subv1 >> $tmp.output
> +cat $tmp.output >> $seqres.full
> +ioctl_subvolid=$(grep treeid: $tmp.output | cut -f 2 -d\ )
> +
> +if [ "$ioctl_subvolid" -ne "$subvolid" ]; then
> +	_fail "get_subvol_info ioctl returned an incorrect treeid"
> +fi
> +
> +_scratch_unmount
> +
> +echo "Silence is golden"
> +# success, all done
> +_exit 0
> diff --git a/tests/btrfs/351.out b/tests/btrfs/351.out
> new file mode 100644
> index 00000000..49b14639
> --- /dev/null
> +++ b/tests/btrfs/351.out
> @@ -0,0 +1,2 @@
> +QA output created by 351
> +Silence is golden


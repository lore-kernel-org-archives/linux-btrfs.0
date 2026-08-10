Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3E306B3D;
	Mon, 10 Aug 2026 21:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786396616; cv=none; b=gZfevdJ1YgrfBK76Ve/bl665ZoAMuhmjOjq7Z6CMZrx7W7wnFxP0q4QolBhKPUmi30vMMUWRKckeyJIU6MwNZPCWGwkg2f8mUb+hivSBDUBCJ/yqoGaCgqH9q1GBWWAQL/7ae7L8S08T/tLhNF/nemzpqc3ulCYswdj5IvIk6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786396616; c=relaxed/simple;
	bh=Rmno2zC8CwexWBw2mAAM26anyZeYpZ7eH6U4q+CzWi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNgZa92LMHI2oM0MJ+qK74XKT8sxutLPCDPBgN5g1ee+a8145OYbZ/m2RoVJw8diavg3fwVf7Y/hCzTI02kGfBleddbnmLRMz6wTVXBrg3WRI5lMOtsvoQnSjFwrYtwOyjzAP5Y/WrJfDdchHPkgQb9svYG5ivvx4dvw+bLRgKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQcJ+3/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQcJ+3/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F06E1F00A3A;
	Mon, 10 Aug 2026 21:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786396614;
	bh=AggEVfg3/IbmxO0E6DX/zUSz2hix7aMWXBecrb9nR5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mQcJ+3/F9NaUz7EPG0KvWqWS85YTD40MfNjuMVTjkahoa0AYsAvDxNiVD3Bgou4QC
	 ImaHJw7PVDgXNJqh8lO3OOjgG9k8mMKMxAcGw0RHXOSciZx03v38WBifsK8McPNU7D
	 CY8twdvpEBDov6z765HlBS9kE9KhpWHLpnGiawZ4tsXeIrE/O/WTpxRTJjJTntFps8
	 8sUF1mG8bPX63RSMjeIv0xztgOy6jXmr8g8ssHV1wKa13hPS9e9orEear0de+ftC9I
	 qw8oEhD47GegZYk4ow8FjJEGD7JQkFwIhnCmknPBq7FUzifm7ttQQ32Q34yiUr/dcF
	 hhT2hxM7oyCyw==
Date: Tue, 11 Aug 2026 05:16:49 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v2] fstests: add a dio-read-into-mmap and sync race test
 case
Message-ID: <ano-7hg-kmiYaqia@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260803235514.25815-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803235514.25815-1-wqu@suse.com>

On Tue, Aug 04, 2026 at 09:25:14AM +0930, Qu Wenruo wrote:
> There is a report that on btrfs, if the following workload are running,
> btrfs can fail:
> 
> - A dio read into a mmaped range
>   Only the mmap range needs to be on btrfs.
>   The dio read source makes no difference.
> 
> - Sync_range on the mapped range
> 
> The btrfs errors include:
> 
> - Hang during data writeback
> - Filesystem flips RO
> 
> The mmap range is dirtied but written back by the sync_range process,
> then dio read finished and found that the folios are no longer dirty,
> so dio endio will mark those folios dirty again so that the fs can write
> them back again.
> 
> However for non-experimental btrfs with 4K block size and 4K page size,
> there is a regression in v7.2 that such case is no longer handled
> properly, due to the enablement of large folios and removal of cow
> fixup.
> And btrfs can never handle it for bs < ps from day 1.
> 
> Add a regression test for it.
> 
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Rebased to the latest patches-in-queue branch
>   The old number is taken by another test case, now this one got the
>   number 800.
> 
> - Fix a bug when the direct read failed short, the read buffer is not
>   advanced
> 
> - Add _require_odirect
> 
> - Add _require_xfs_io_command sync_range
> 
> - Add missing tmp files cleanup
> 
> - Remove unneessary trap command for the main process
> 
> - Fix the unset command
> ---
>  .gitignore               |  1 +
>  src/Makefile             |  2 +-
>  src/dio-read-into-mmap.c | 81 ++++++++++++++++++++++++++++++++++++++++
>  tests/generic/800        | 79 +++++++++++++++++++++++++++++++++++++++
>  tests/generic/800.out    |  2 +
>  5 files changed, 164 insertions(+), 1 deletion(-)
>  create mode 100644 src/dio-read-into-mmap.c
>  create mode 100755 tests/generic/800
>  create mode 100644 tests/generic/800.out
> 
> diff --git a/.gitignore b/.gitignore
> index 0b6b9452..d52ba4ad 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -216,6 +216,7 @@ tags
>  /src/truncate
>  /src/t_btrfs_received_uuid_ioctl
>  /src/btrfs_ioctl
> +/src/dio-read-into-mmap
>  
>  # Symlinked files
>  /tests/generic/035.out
> diff --git a/src/Makefile b/src/Makefile
> --- a/src/Makefile
> index e8da2636..ea3d77b2 100644
> +++ b/src/Makefile
> @@ -21,7 +21,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale \
>  	t_mmap_cow_memory_failure fake-dump-rootino dio-buf-fault rewinddir-test \
>  	readdir-while-renames dio-append-buf-fault dio-write-fsync-same-fd \
> -	dio-writeback-race unlink-fsync truncate
> +	dio-writeback-race unlink-fsync truncate dio-read-into-mmap
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/dio-read-into-mmap.c b/src/dio-read-into-mmap.c
> new file mode 100644
> index 00000000..2a5ad085
> --- /dev/null
> +++ b/src/dio-read-into-mmap.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) SUSE S.A.
> +
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <err.h>
> +
> +static int read_source_fd = -1;
> +static int mmap_dest_fd = -1;
> +static void *buf = NULL;
> +static int iosize = 4 * 1024 * 1024;
> +
> +static void usage()
> +{
> +	fprintf(stderr,
> +	"Usage: dio-read-into-mmap <read_source> <mmap_dest>\n");
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int ret = -EINVAL;
> +	const int pagesize = sysconf(_SC_PAGESIZE);
> +	unsigned int cur = 0;
> +
> +	if (argc != 3) {
> +		usage();
> +		goto error;
> +	}
> +	if (iosize < pagesize) {
> +		ret = -EINVAL;
> +		fprintf(stderr, "blocksize smaller than pagesize\n");
> +		goto error;
> +	}
> +
> +	read_source_fd = open(argv[1], O_RDONLY | O_DIRECT, 0600);
> +	if (read_source_fd < 0) {
> +		ret = -errno;
> +		fprintf(stderr, "failed to open '%s': %m", argv[1]);
> +		goto error;
> +	}
> +	mmap_dest_fd = open(argv[2], O_RDWR, 0600);
> +	if (mmap_dest_fd < 0) {
> +		ret = -errno;
> +		fprintf(stderr, "failed to open '%s': %m", argv[2]);
> +		goto error;
> +	}
> +	buf = mmap(NULL, iosize, PROT_WRITE, MAP_SHARED, mmap_dest_fd, 0);
> +	if (buf == MAP_FAILED) {
> +		buf = NULL;
> +		fprintf(stderr, "failed to mmap: %m");
> +		return -errno;
> +	}
> +	while (cur < iosize) {
> +		ret = pread(read_source_fd, buf + cur, iosize - cur, cur);
> +		if (ret == 0) {
> +			ret = -EINVAL;
> +			fprintf(stderr, "reached EOF");
> +			goto error;
> +		}
> +		if (ret < 0) {
> +			ret = -errno;
> +			fprintf(stderr, "failed to read: %m");
> +			goto error;
> +		}
> +		cur += ret;
> +	}
> +error:
> +	close(read_source_fd);
> +	close(mmap_dest_fd);
> +	if (buf)
> +		munmap(buf, iosize);
> +	if (ret < 0)
> +		return EXIT_FAILURE;
> +	return EXIT_SUCCESS;
> +}
> diff --git a/tests/generic/800 b/tests/generic/800
> new file mode 100755
> index 00000000..980d1734
> --- /dev/null
> +++ b/tests/generic/800
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 800
> +#
> +# Test direct read into a mmaped range meanwhile doing data sync for the mmaped
> +# range.
> +# Such racy workload should cause direct endio function to mark the folio
> +# dirty without going through buffered write nor page_mkwrite().
> +#
> +# Make sure the fs can handle such ->dirty_folio() callback correctly.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw mmap
> +
> +_require_test_program dio-read-into-mmap
> +_require_scratch
> +_require_test
> +_require_odirect
> +_require_xfs_io_command sync_range
> +
> +_cleanup()
> +{
> +	cd /
> +	[ -n "$mount_pid" ] && kill $mount_pid &> /dev/null
> +	[ -n "$remount_pid" ] && kill $remount_pid &> /dev/null

I think you mean "read_pid" and "sync_pid" here :)

Others look good to me, I'll help to fix above typo problems when I merge it,
if there's not more review points from btrfs list.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +	wait
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +# Create the 4MiB target file on TEST_MNT as the read source.
> +$XFS_IO_PROG -f -c "pwrite -i /dev/urandom 0 4M" "$TEST_MNT/dio-read-source" >> $seqres.full
> +
> +# Another 4MiB target file on SCRATCH_MNT as the mmap dest
> +$XFS_IO_PROG -f -c "pwrite 0 4M" "$SCRATCH_MNT/mmap-dest" >> $seqres.full
> +
> +read_workload()
> +{
> +	_register_cleanup "wait"
> +	while true; do
> +		$here/src/dio-read-into-mmap "$TEST_MNT/dio-read-source" \
> +			"$SCRATCH_MNT/mmap-dest" &> /dev/null
> +		if [ $? -ne 0 ]; then
> +			echo "dio read failed"
> +			break;
> +		fi
> +	done
> +}
> +
> +sync_workload()
> +{
> +	_register_cleanup "wait"
> +	while true; do
> +		$XFS_IO_PROG -c "sync_range 0 4m" "$SCRATCH_MNT/mmap-dest"
> +		if [ $? -ne 0 ]; then
> +			echo "sync_range failed"
> +			break;
> +		fi
> +	done
> +}
> +
> +read_workload &
> +read_pid=$!
> +
> +sync_workload &
> +sync_pid=$!
> +
> +sleep $((15 * $TIME_FACTOR))
> +
> +kill "$read_pid" "$sync_pid" &> /dev/null
> +unset read_pid sync_pid
> +wait
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/800.out b/tests/generic/800.out
> new file mode 100644
> index 00000000..bdfaa2ce
> --- /dev/null
> +++ b/tests/generic/800.out
> @@ -0,0 +1,2 @@
> +QA output created by 800
> +Silence is golden
> -- 
> 2.51.2
> 
> 

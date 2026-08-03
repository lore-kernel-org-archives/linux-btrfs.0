Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31133937D;
	Mon,  3 Aug 2026 10:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753361; cv=none; b=qxv1of1rzR5MhlPrpXAOtYAy94nwdTlBl2NFCYw0OcROkG7IGjkHku5F3T10hFhMuJwetDNshw3PH9i9zw6BkDnn+X39pVs4akAVlm5nSE9XWD8Osvy96LbLIQ73ZhFxGM6ofCz/fm2oAt0oIVkiHlo8Sadkf5HJZZJsgRk26Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753361; c=relaxed/simple;
	bh=70jrXQm3Y5T/5abE/86FAPGdZSAeQC2Zyv44Lh4Gs0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPYminVcI41ImImUQrStt96ElcHl91arWueqkDf+y3BZYjdroHiUk8AHstnlufHO6SFwqUdpb8S4OdpD1zzK4WKgGv0UZTj2idWlPYYC7pkCFfsvED+E1RiLkpqHbiydcTUZT+V0lRFdjSXO2tZFVMYPax7RYwOo0kD0ezyPfGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MydjvTYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MydjvTYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7431F000E9;
	Mon,  3 Aug 2026 10:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753359;
	bh=LrRSxbbl1lSdwJVlRx0yjXe3cKVkB7SOQ5yrK3I68CM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MydjvTYNS6FHpLXFppsdFxLy3+ZykqfM7myMgLXrUFCnlIlG8H4Kfk+bwjAyd9w44
	 bgAU8jhyRNdjRlHi9oZgpAGNVBscqkKxh6qeXi4rEAKJnV7iSrbQLzHT0c5eW7AWzG
	 FT4mSkB+gcKenGktsfsGF9ofzZ2JqwH/kCWTkNa4z9vo59mVZ2+p4MYZTeSZSaqy9V
	 4tD5czKKLkcId+Vp5uq1UA8e+cSlIZY6IPP1QPmXIQH7fFIOGWZpz+bhqQ8dasdfXT
	 jCOpXPAv62iyM2/MdRYaJcd2LYi1DXjpL+jwryFQkI+yI/jcuMnRMXXAUsvwPvVC6X
	 tsIv1Bet5Urcw==
Date: Mon, 3 Aug 2026 18:35:51 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] fstests: add a dio-read-into-mmap and sync race test case
Message-ID: <anBiV3ta3qe5Kzfo@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260725110724.75124-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725110724.75124-1-wqu@suse.com>

On Sat, Jul 25, 2026 at 08:37:24PM +0930, Qu Wenruo wrote:
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

Hi Wenruo,

Thanks for this new test!

>  .gitignore               |  1 +
>  src/Makefile             |  2 +-
>  src/dio-read-into-mmap.c | 81 ++++++++++++++++++++++++++++++++++++++++
>  tests/generic/799        | 81 ++++++++++++++++++++++++++++++++++++++++
>  tests/generic/799.out    |  2 +
>  5 files changed, 166 insertions(+), 1 deletion(-)
>  create mode 100644 src/dio-read-into-mmap.c
>  create mode 100755 tests/generic/799
>  create mode 100644 tests/generic/799.out
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
> index 76cf50c3..f64e153a 100644
> --- a/src/Makefile
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
> index 00000000..07842c48
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
> +		ret = pread(read_source_fd, buf, iosize - cur, cur);

Don't we need "(char *)buf + cur" at here?

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
> diff --git a/tests/generic/799 b/tests/generic/799
> new file mode 100755
> index 00000000..b6851f69
> --- /dev/null
> +++ b/tests/generic/799
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 799
> +#
> +# Test direct read into a mmaped range meanwhile doing data sync for the mmaped
> +# range.
> +# Such racy workload should cause direct endio function to mark the folio
> +# dirty without going through buffered write nor page_mkwrite().
> +#
> +# Make sure the fs can handle such ->dirty_folio() callback correctly.
> +#
> +. ./common/preamble
> +. ./common/filter
> +_begin_fstest auto rw mmap
> +
> +_require_test_program dio-read-into-mmap
> +_require_scratch
> +_require_test

_require_odirect ?

> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxxxx \
> +	"btrfs: trigger cow fixup via dirty_folio()"
> +
> +_cleanup()
> +{
> +	cd /
> +	[ -n "$mount_pid" ] && kill $mount_pid &> /dev/null
> +	[ -n "$remount_pid" ] && kill $remount_pid &> /dev/null
> +	wait

rm -r -f $tmp.*

> +}
> +
> +trap "_cleanup; exit \$status" SIGINT SIGTERM

If you need extra signal, you can run _register_cleanup, but as you
just need INT and TERM, so this line can be removed.

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
> +	trap "wait; exit" SIGTERM
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
> +	trap "wait; exit" SIGTERM
> +	while true; do
> +		$XFS_IO_PROG -c "sync_range 0 4m" "$SCRATCH_MNT/mmap-dest"

_require_xfs_io_command sync_range

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

How about:
  kill -TERM -"$read_pid" -"$sync_pid" &> /dev/null
?

As the (man 1 kill) says:

  pid
    Each pid can be expressed in one of the following ways:
    ...
    -n
       where n is larger than 1. All processes in process group n are signaled.
       When an argument of the form '-n' is given, and it is meant to denote a
       process group, either a signal must be specified first, or the argument
       must be preceded by a '--' option, otherwise it will be taken as the
       signal to send.

I didn't give it a try, but I think this might help to kill the
dio-read-into-mmap and sync_range process too.

(same in _cleanup)

> +unset "$read_pid" "$sync_pid"

unset read_pid sync_pid

> +wait
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/799.out b/tests/generic/799.out
> new file mode 100644
> index 00000000..f3fd9fa2
> --- /dev/null
> +++ b/tests/generic/799.out
> @@ -0,0 +1,2 @@
> +QA output created by 799
> +Silence is golden
> -- 
> 2.51.2
> 
> 

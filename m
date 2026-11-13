Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589775;
	b=iZKvMyg5IYlADW7ERz0Sl7C1VssExxpDT/CgX/NfQ3q70aL5ncnKXogITmCaHCognYIz
	 +C48/BeXIWcfSdWFB1E1Gx0YPXIOaNIqhbNRKn6ihQ2036k9Z8ONSTxqH80S7s82XhkCs
	 jL1R5trpYiXGbI3iSzZyN7WLF7hTHHFViyuwQR97ElsDUMkOvAnsSx2QVZMFMbZoVykw5
	 dzA0v4U//+Iw5p2vENK2+1hudXicMgg7N12tuQJznZFxnFyEeW7elkaPyElZmRmNP9O7y
	 HK3A6f5k0TBds1+ghkUQEO0x2C5/X9UXo57XkeysmgYi6abLMwi05OScj2vNh5livnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4l1cfrZxt+crpEjRL7Ym2PTiRtxyCRYhZeBH+kog4UQ=;
	b=HZ34Yq5nR22md8vqhQUv9Cow1MX8I2p7CHiV8hJi0vvvpXAFp21H/B+Cnn+hc6+z6vrJ
	 R2HdbNjCHJFb2p5KYxacrGL92j4BZ5PV5ect8u6IjcnGVWUcAD/CbBEwOWKi8aFSPiUnu
	 DX836TPoEAu95KInHCWD5r8UlmRFuH3UegSqPqM6Okw3hzKGbfBe5AwZWnKA9X2oqBDpE
	 hdbHdBzmYnqn3nD5roMFgzchwkabyhuguQyVrM0sYefvbgRMMxJB7k/6vtf1NgrSHS/Xs
	 568ZLdHx6zDIgSZQe02qlCAvZTm+ki9Lbfd/XzRJOYKeZ1+hcnJvE8pBQr0C4jF3kVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elPWGu5s;
	arc=none smtp.remote-ip=209.85.128.176
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDCE606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 17:09:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CDCE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elPWGu5s
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b3541bb1a2so7497857b3.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 09:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794589774; x=1795194574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4l1cfrZxt+crpEjRL7Ym2PTiRtxyCRYhZeBH+kog4UQ=;
        b=elPWGu5sS1pA8KRFL4pXWrz9QFRebKuKe+lPLmSGl+vKEtCNfSgTZgavjJPH6l47S/
         Boamr/ophshle9xAkCxOjT6Pg0gvvxkCTYeOdLP5jFr2d37hcuIKHIruaPzP+Ew7LhzI
         iDh6yQvMfq04p3PBrBEqGohMCVItqNiIG7XAnpmSdLDZ4lwe3duvgtEyursdeMG1ZyH/
         M9PbGJ+QXaaJ/psZn9WqSowESdGSqCUhV33GNxoFEyDVpXYqJrpgWpYHKpgayaqndKE8
         AdeyeHIwo1CgvGMeLr/xWNBN4vvEzesdqRy7/yAfcHmy/Z2tIxijOkJiQEP30ae1q1vk
         m8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589774; x=1795194574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4l1cfrZxt+crpEjRL7Ym2PTiRtxyCRYhZeBH+kog4UQ=;
        b=VAiVtOV7NlVOU3w2orf91QC2FqixWj+w4/IqiT+TihOWiAMx3N33UT2+wLwVtoMXNs
         2cCrAExpwd9q/eMj51iYPxXBStJuEudHvdxsswxdwMP1meIJI8vkhXW2QFOFeGzilEst
         sXo+m4Y+kGrsXcdZPa/BneiScmL71v8bfRmJpzz6QWrWX2GjWzTSbPDRF3RL7bqNunks
         80Y7Ovy08ytLniwu+jilH4U/JWKoQvuoPDQuwjKk4+W9LETnX0jVz65yt6pobBjyIl3p
         7JZSyIAuOUj9Ofsz+O3qv5AJ5aMf9j4FOR0ZsNDGSu3u36noqPEtaBts1Hq9DFZG4gu2
         j+bg==
X-Forwarded-Encrypted: i=1; AL+hErF8mBcw5B9UCCb/iydXFmTgwI1/zT+ZFxR8mmtHaVygFGLwdzBH7vtyCHfI6UKpdqxh74BQbQgYZvENAg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/rV4+mRrj9B1MBZ4+3si3CkqiQCVrBihfY7RZyzmcCNVTkNzdQ
	NOhhDRAahrp64SZpN+3vdzMuEB+kb/NbpNw/FwKewjqH6BQVirfM6tBQ
X-Gm-Gg: AYBFou27oViQT4iQwwJePfGpQKM68A2ChH0piXufIJ/6yp8OeBToYJYMQlzg6aL+BnX
	uTCHLSoiOmykJ/Wx9zaS0uaHadRWQ7WmFhNuaC7Fn9ajpR42v9V9tKC5S+N2LgEA33dmeXv0iHw
	QoH5kiaf00xFm/jWomo+JMNdlLi308bXAjkA2HjxIk64hTCLN+0eq36KyBREQPhqybsF7oR7nbZ
	J29mz+sn7NfpKMSTmxd40BVe7Umrni4J5dTNxhO6h7kQD+lhAbCIpyXNIgCLy/NFQiM6go2sJK7
	NuIeaITu8snrNH5uHx1qqioEVZJovv5kLAM9uiGANFebH43SutPoLuodPY4EyAV/9t0A7zxWIzL
	52IRRje7f+kdVWKFEJPw88mdmTTGhEqCRMPP/LFnqfUMijmbMope+05qYAdHu2GXiJrBq3dDroe
	8lXfgfWkPFs7pXSIeARWPLN5kmQxPWIhkd+FPTDT3sbUHBgsye+h5oi5sX/0mUYJ4uZ5cPC3HRg
	Vxmu+44/HxJhnBlVdnyzBU0loUxoKSkUTtlpRkYtCcpXsuFXGACOsk1rwA7vcalfYFUhTDslJqX
	OQZy+vwa4S88rtHpO20czw==
X-Received: by 2002:a05:690c:d87:b0:8b3:4911:2dbd with SMTP id 00721157ae682-8b4aa2f3717mr19185707b3.54.1794589774165;
        Fri, 13 Nov 2026 09:09:34 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9c79d3sm24049457b3.34.2026.11.13.09.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:09:33 -0800 (PST)
From: Vlad Poenaru <vlad.wing@gmail.com>
To: dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: mason@kernel.org,
	osandov@osandov.com,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	boris@bur.io,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: fix bytes_may_use underflow after a failed tree block allocation
Date: Fri, 13 Nov 2026 09:09:26 -0800
Message-ID: <20261113170926.1468850-1-vlad.wing@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When btrfs_alloc_tree_block() fails after btrfs_reserve_extent() has
succeeded, it frees the reserved extent and then calls
btrfs_unuse_block_rsv(), which credits blocksize to the block reserve.
That counts the block twice. btrfs_add_reserved_bytes() already took
blocksize out of bytes_may_use when it reserved the extent, and
btrfs_free_reserved_extent() releases it from bytes_reserved without
returning it to bytes_may_use. bytes_may_use is left a block short of
what the reserves hold, one more block for every such failure. It
underflows when the global block reserve is released at unmount, or
earlier, while the filesystem is in use, once the deficit outgrows the
reservations outstanding at that moment.

Return without crediting the reserve once the extent has been reserved:
by then btrfs_add_reserved_bytes() has consumed the block, whether
btrfs_use_block_rsv() took it from a block reserve or reserved it
directly in bytes_may_use. The out_unuse path, taken when
btrfs_reserve_extent() itself fails, still credits the reserve, which is
correct there because bytes_may_use still holds the block.

Since commit 19d7f65f032f ("btrfs: convert the buffer_radix to an
xarray") in v6.16, the failure path is reachable under memory cgroup
pressure. fs_info->buffer_tree is XA_FLAGS_ACCOUNT, so the GFP_NOFS
xarray node allocated in alloc_extent_buffer() is charged to the
caller's cgroup. On cgroup v2, try_charge_memcg() fails that charge with
-ENOMEM when the cgroup or an ancestor is at its limit in these cases,
among others:

- the charging task is dying (an OOM victim, fatally signalled or
  exiting) after memcg OOM handling has already been invoked for this
  charge;
- the charging task is an OOM victim whose mm is already marked
  MMF_OOM_SKIP, a case added in v7.3 by
  commit 6b0d1083364f ("memcg: bypass the reclaim and oom killer for
  dying tasks once oom_reaper is done");
- no task in the cgroup at its limit can be OOM-killed.

Before the xarray conversion, buffer_radix was not memcg-accounted: it
was initialised with GFP_ATOMIC and preloaded with GFP_NOFS, neither of
which carries __GFP_ACCOUNT. Older kernels have the same bug, but there
it takes an allocation failure outside memcg (or a corruption error),
which is rare; hence the 6.16+ stable tag.

We hit this on a large fleet running a 6.16-based kernel, at unmount,
when close_ctree() releases the global block reserve:

  WARNING: CPU: 1 PID: 855255 at fs/btrfs/space-info.h:265 btrfs_block_rsv_release+0x287/0x290
  Call Trace:
   btrfs_release_global_block_rsv+0x1e/0x90
   btrfs_free_block_groups+0x30e/0x370
   close_ctree+0x3cc/0x460

Over about eight days of warning logs, 186 hosts logged this warning,
once each. In the 183 whose register dump could be matched to the
warning, bytes_may_use was short of the global reserve by a whole number
of 16K nodes, from 1 to 78 and never a fraction of a node, consistent
with one node per failed allocation. 84% of the hosts that warned had
also logged a memcg OOM, against 7% of a random sample of hosts that
rebooted on the 6.16 builds most of them ran. No host running 6.13,
which predates the xarray conversion, has logged the warning in 120
days, although about 150,000 hosts still boot 6.13 every three days.

To reproduce, put a cgroup at its limit with no task that can be
OOM-killed, the last case above, and update metadata from inside it:

1. Mount a btrfs filesystem on a loop device and create 64 empty files
   on it.
2. Create a cgroup v2 group with memory.swap.max set to 0.
3. Run a single task in the group with oom_score_adj -1000, so nothing
   in the group can be OOM-killed. The task mlocks 64MiB of anonymous
   memory and lowers memory.max to 16MiB. It then sets a new 2KiB user
   xattr on every file, 300 times.
4. Meanwhile, from a task outside the group, run `sync -f` on the
   filesystem every 0.2 seconds so that each round COWs new tree
   blocks.

Some setxattr() calls fail with -ENOMEM without aborting the
transaction. Once the filesystem is idle, the metadata bytes_may_use in
sysfs is below the global reserve by a multiple of the nodesize, and
unmount warns:

  WARNING: fs/btrfs/space-info.h:282 at btrfs_space_info_update_bytes_may_use+0x4d/0x120, CPU#2: umount/664

On v7.4-rc2-108-g79eb6679ef6a without this patch, all 12 runs of this
workload that read bytes_may_use left it short of the global reserve: by
130 to 276 nodes of 16K in nine runs, and down to 0 in three. In the
four runs that also counted btrfs_alloc_tree_block() failures with a
kretprobe and did not reach 0, the shortfall equalled the failure count
exactly (130, 161, 187 and 242). The run quoted above left bytes_may_use
at 1933312 against a 5767168 global reserve, short by 234 nodes.

With this patch, bytes_may_use matched the global reserve in all 12 runs
that read it, and no run whose log check covered the unmount saw a
warning. fstests btrfs/002, btrfs/220, generic/475 and generic/476 also
pass with -o compress-force=zstd:3. Testing on v7.4-rc2 was on x86_64
without debug options. On 6.16, the same change also passed this
workload on x86_64 with lockdep and KASAN and on arm64 under QEMU, where
the unpatched kernel failed.

The same bug class was fixed for data extents by commit a4fe134fc1d8
("btrfs: fix a double release on reserved extents in cow_one_range()")
and commit 82323b1a7088 ("btrfs: fix double-decrement of bytes_may_use
in submit_one_async_extent()").

Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
---
Reproducer: save the two files below in one directory and run
`bash repro.sh` there as root, in a VM you can lose. After the workload
it prints how many setxattr() calls failed with ENOMEM. A run where none
failed is not a valid test. It then prints bytes_may_use and global_rsv
from sysfs, then any space-info.h warning among the last 100 kernel log
lines, which end with the unmount. On an affected kernel bytes_may_use
is below global_rsv and a WARNING follows; on a fixed kernel the two
numbers match and it prints "no space-info.h warnings".

With vm.panic_on_oom=2 its memcg OOMs panic the machine, and with
panic_on_warn an affected kernel panics when bytes_may_use underflows,
at unmount or earlier. It needs cgroup v2 at /sys/fs/cgroup, btrfs-progs
and a C compiler, and uses /tmp/repro.img (4G, sparse), /tmp/repro.done,
/mnt/repro and /sys/fs/cgroup/repro. It enables the memory controller in
the root cgroup's cgroup.subtree_control and leaves it enabled. Every
charge that reaches the memcg OOM killer prints an OOM report, a few
hundred per run; `dmesg -n 1` keeps them off a slow console. An fstests
case will follow.

==> repro.sh <==
#!/bin/bash
# Reproducer for the bytes_may_use underflow after a failed tree block
# allocation. Run as root next to memcg_setxattr.c.
set -e
cd "$(dirname "$0")"
MNT=/mnt/repro
CG=/sys/fs/cgroup/repro
IMG=/tmp/repro.img
DONE=/tmp/repro.done

cleanup()
{
	touch $DONE
	[ -n "$syncer" ] && wait $syncer
	rm -f $DONE
	rmdir $CG 2> /dev/null || :
	umount $MNT 2> /dev/null || :
	rmdir $MNT 2> /dev/null || :
	rm -f $IMG memcg_setxattr
}
trap cleanup EXIT

cc -O2 -o memcg_setxattr memcg_setxattr.c
truncate -s 4G $IMG
mkfs.btrfs -q -f $IMG
mkdir -p $MNT
mount -o loop $IMG $MNT
mkdir $MNT/d
touch $MNT/d/f{0..63}
sync

echo +memory > /sys/fs/cgroup/cgroup.subtree_control
mkdir $CG
[ -f $CG/memory.swap.max ] && echo 0 > $CG/memory.swap.max

# Commit from outside the cgroup, so each round COWs new tree blocks.
rm -f $DONE
( set +e; while [ ! -f $DONE ]; do sync -f $MNT; sleep 0.2; done ) &
syncer=$!
./memcg_setxattr $CG $MNT/d 64 300
touch $DONE
wait $syncer
syncer=

sync -f $MNT
alloc=/sys/fs/btrfs/$(findmnt -n -o UUID $MNT)/allocation
echo "bytes_may_use=$(cat $alloc/metadata/bytes_may_use)" \
	"global_rsv=$(cat $alloc/global_rsv_reserved)"
umount $MNT
# OOM reports can push older lines out of the log; the unmount is last.
dmesg | tail -n 100 | grep 'space-info.h' || echo "no space-info.h warnings"

==> memcg_setxattr.c <==
// SPDX-License-Identifier: GPL-2.0
/*
 * memcg_setxattr <cgroup> <dir> <nfiles> <iters> [max_enomem]
 *
 * Join <cgroup> with oom_score_adj -1000, lock 64MiB of anonymous memory,
 * lower memory.max to 16MiB, then set a new 2KiB xattr on <dir>/f0 ..
 * f<nfiles-1>, <iters> times. Nothing in the cgroup can be OOM-killed, so
 * memcg-charged GFP_NOFS allocations fail with -ENOMEM. Stop after
 * max_enomem failures if it is given and not 0.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/xattr.h>
#include <unistd.h>

static int open_file(const char *dir, const char *file)
{
	char path[4096];
	int fd;

	snprintf(path, sizeof(path), "%s/%s", dir, file);
	fd = open(path, O_WRONLY);
	if (fd < 0) {
		perror(path);
		exit(1);
	}
	return fd;
}

static void put(int fd, const char *val)
{
	if (pwrite(fd, val, strlen(val), 0) < 0) {
		perror("write");
		exit(1);
	}
}

static long number(const char *arg, long min)
{
	char *end;
	long val;

	errno = 0;
	val = strtol(arg, &end, 10);
	if (errno || *arg == '\0' || *end != '\0' || val < min) {
		fprintf(stderr, "invalid number: %s\n", arg);
		exit(2);
	}
	return val;
}

int main(int argc, char **argv)
{
	static char value[2048], path[4096], name[64];
	long ok = 0, enomem = 0, other = 0;
	long nfiles, iters, max_enomem = 0;
	char stack[256 << 10];
	char *fill;
	int max_fd;

	if (argc != 5 && argc != 6) {
		fprintf(stderr,
			"usage: %s <cgroup> <dir> <nfiles> <iters> [max_enomem]\n",
			argv[0]);
		return 2;
	}
	nfiles = number(argv[3], 1);
	iters = number(argv[4], 1);
	if (argc == 6)
		max_enomem = number(argv[5], 0);

	put(open_file(argv[1], "cgroup.procs"), "0");
	put(open_file("/proc/self", "oom_score_adj"), "-1000");
	/*
	 * Open memory.max now: once the limit is lowered, nothing can be
	 * killed and opening a file can fail to charge its struct file.
	 */
	max_fd = open_file(argv[1], "memory.max");
	/*
	 * Fault in the stack and lock everything: a page fault charged after
	 * the limit is lowered retries forever when nothing can be killed.
	 * The barrier keeps the compiler from dropping the unused memset.
	 */
	memset(stack, 0, sizeof(stack));
	asm volatile("" : : "r" (stack) : "memory");
	memset(value, 'v', sizeof(value));
	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
		perror("mlockall");
		return 1;
	}
	fill = mmap(NULL, 64 << 20, PROT_READ | PROT_WRITE,
		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
	if (fill == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	memset(fill, 1, 64 << 20);
	put(max_fd, "16777216");

	for (long i = 0; i < iters; i++) {
		snprintf(name, sizeof(name), "user.k%ld", i);
		for (long f = 0; f < nfiles; f++) {
			snprintf(path, sizeof(path), "%s/f%ld", argv[2], f);
			if (!setxattr(path, name, value, sizeof(value), 0))
				ok++;
			else if (errno == ENOMEM)
				enomem++;
			else
				other++;
			if (max_enomem && enomem >= max_enomem)
				goto out;
		}
	}
out:
	munmap(fill, 64 << 20);
	put(max_fd, "max");
	printf("setxattr: ok=%ld enomem=%ld other=%ld\n", ok, enomem, other);
	return 0;
}

 fs/btrfs/extent-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3c..9e93f35489cf2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5433,6 +5433,13 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	free_extent_buffer(buf);
 out_free_reserved:
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, false);
+	/*
+	 * btrfs_reserve_extent() moved blocksize from bytes_may_use to
+	 * bytes_reserved, and freeing the extent does not give it back to
+	 * bytes_may_use, so the reservation is consumed. Crediting block_rsv
+	 * here, as out_unuse does, would count the block twice.
+	 */
+	return ERR_PTR(ret);
 out_unuse:
 	btrfs_unuse_block_rsv(fs_info, block_rsv, blocksize);
 	return ERR_PTR(ret);

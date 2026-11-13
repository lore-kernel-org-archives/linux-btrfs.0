Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600727;
	b=u7ENpQ1e6v6zT++97epjkROS/1Az2IH3qgFMWLa4iMf6XKywyneEW2SMGNfeplK5OYBN
	 gA/jnTB4fErjuhBqfe9oOTiHMtwFlQDsQBpzvxM1A6qOFvRgmilxjwvzuceL7X2yv6Lm1
	 F/3/5ZvzuAS6LdiJf7Y0UWYRipQjIygMvYKvX7GPVZSFmBJ/41MMbm67W06/JvOCuBgOo
	 e95l57BrC3j1XTPGtbdQOZ092JtnJ9AZipLDljka2yAlxTSga1D00hhx4y6+/i4LbgDOe
	 UusipVasJ9zylbro+/KiYT6LNMHvSNhXC4ZAlcuM6B6wXab2szi+0CVxZi7S1MR11Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600727;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=CAeDpY8x4zKPl+KlIuLs2k13rDII/efkiUw7qOtGknw=;
	b=rHvNDdWUzkgKPkUeSDNnXCj1vuaEpUsuvZuKEebndm8QmJydb3EW2M5PqJ+wv2LNKgsJ
	 sjpuitipkro5w0nn83NaVAhvnLgUrZBrfyB3EN2C+rKukP2vW7HiFxR0OgnGwlprLr/Rm
	 ieKxz58x2nED28X3QunY2mYZ06XjVDAAHkWFKqHYAn0757LqfI9GbRJskSE1o5Oj5WowX
	 2EybBhGKUj3PVRpWqE+qB0vwPL3EGBI8ix/jygGSkIqBwIHBTiKSlIT/cVbiq3WyPlK4a
	 jkzv5TKQ2uDQIjRLtu1m0B06pvOZj4KkiMaUS/y5tb6wyijk25QmzFrbbk+GJfFXT2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=jYPPDjaZ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LA49Pcar;
	arc=none smtp.remote-ip=103.168.172.142
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0B4606A32E
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 20:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C0B4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=jYPPDjaZ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LA49Pcar
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 3043C1381A7C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 15:12:05 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 13 Nov 2026 15:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794600725; x=1794607925; bh=CAeDpY8x4z
	KPl+KlIuLs2k13rDII/efkiUw7qOtGknw=; b=jYPPDjaZo8g0ET7Pyf2lMHOcnN
	ysZl29GBXBw46d0+0+dIIf8tH3EJYiVR3zmof0oXsu4A65xNftcvkabYu2YIQ2//
	3LzGz5mbeiTvhuNJMPwEzmkOaK9ooaF/jPvaAy3TOP3vxiLGu/dqgn1ROyFf+ekw
	O7G11poqmYCufdlpdCIWUOOJD+o/TywROvbhIeIWibz2oNOyFOCOMRtKMiK3PKmt
	gVxMN6YzOhdBn0jOnyuKxz54+ZIAZJef8Wa7BOA4AE8gZV40bSCcRlcdM6WoBQ4G
	3exxT4imAEhsNhcZS2MXo6rJHq/PyDBPWpJninYbIjblzHc9R/13EngzAV/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794600725; x=1794607925; bh=CAeDpY8x4zKPl+KlIuLs2k13rDII/efkiUw
	7qOtGknw=; b=LA49PcarqJawOFge7cT53onISZhmDvVmWUH2VsTRNCrdLw0cC55
	4m6x5dca7sn6kdSyGvM46+oGyILyZLIOHEFv07A/zqMITBfu3NAEhoKEqwNc5ORO
	psA99XOustfL/AKv+suqK9U8oRJYFoPCwhtmW81bxMrRw252MsK6PQ1VVDbJTPqb
	QUy6TmXMccLG7tc5Ctfm0p4Dxuux5HnFLGJceLr7pBxiBYTstBXiVWxtwkSlHcAj
	4SuaMeo1gPRzJPs1WHxhhWtP8h5XmsQ+hCTJJWz12cg0ng04YpNMPOKNt6e8ZmQl
	BJTlLSKBH6ffbbVy4knXTpYbAA8rV+a4PMg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794600725; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:Aw0xkPWf7lfFiE6KO3org5DG8beAAKgath1DMEjiaRhBZ8Q
	8jiMh0aC10er4nm8zs6YBiLam9/atnIQzFq2WXVOy9+l2pTQ7tKo2SSaEwaSfanH
	/HSI20F/JyaNsOVNCIWXZfOXHBGmb2DMXG+GU7NOGyG1O+xWauTBOZRQWN8urCWh
	iZghi78jHWGvEiYBs7aBbWMhPwf6GgoHHqmMrkjwjPGm3BubBmNQ3gSX0vUvt8Ap
	FiFt6RGojubdkkwCIO5EXlusW4nDUpVZP6B3BGynYKWUv82PyUFwWmTSGkE0vrva
	gsm3FGM2wFDSCJkU3GJwxd+/gAKD6gEx/LxPTfA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:3bfMG5fa6EQRaQItVg8CFVfukR6OLZp1Y93VlCN3jdc=:9gqjxqgBoKk3ZeHTKquKgIoijLvu9SMXzj7sDnqHHkA=;
X-ME-Sender: <xms:FG_3agfWqLHPOZLj-bTUB9LBR4i8ppozRvmFycR9FaNctueYA124-Q>
    <xme:FG_3aoPio44MQx_g_3EtvUJ48vOxmSo0OEN0blCzY4amk-h4eyqZPi3vkiWSD4RLg
    5rYcX4JiUgN6WgJZhL7cRTxLi3Dkkr1u3_b7pPuAcJwo6a4uhExspc>
X-ME-Received: <xmr:FG_3asWMzffPiJ3ywMM3ueIof5BRE1F0sIVYjXt2xBeQvyTtYgteJL2g>
X-ME-Proxy-Cause: dmFkZTGfRpV/VZVq3XvwK+OZMzFzSU7somMcxre6I910oGaRveAf80c0gxwjjaKRSrutGE
    O3+AJlgtQunPE25BAqAnEaKWlXA5y7a378J0JLlmxXKHLMZhE3cu15ULGRBiZjyFh17JTA
    SmI7wHMVxd/eYGL2vhCxrOTmI60VeF/AWnTCG21D9u+rV6wW5Ipmdo6gZmYxEvbMAbHpuX
    1DodrBOSVEyitAL9YxJLURJYwYZC8ec9jzM4YpXVtAhGawANMRRQGOmNH+poSLhdUifTRz
    mcfmKeWslFhTaYLDFeB3TbEGZgTY6f9kdmmVmPKY68Qm6bPp/UR/hwOVzceIvO6D3AAsRZ
    2l70m5kt0c0RX+SdIKFS8aFzhuJmbnH50nlklgBclSkOOhZ5OkndGO4ZXVqzeu0/P93BPu
    OaOmr0dDAQ49s8ljOnDIT1M3EWi5/LZMs+M4g+8WPmwK6CxFS5yBEA7ONRzWt+ypi8R4Hl
    c3aDqibdeJm4xiB4dOIyCdpY5f1Dz8cBv7n7L/Mm3OI78gDo5x+EQCtUJQ+zTy8KtXd7BS
    FYBh3adAdYw566wG68BVWt9RpMVrR4xz/C3/mIIdMYviSurBZul7hhnkvnaDjZH5QULdiv
    YwTxQ2lhinlx7Oo0oPqRki+owsz5X30QvWj0auETAOr67M2RJjddcqLzXZ6g
X-ME-Proxy: <xmx:FG_3aoz-C43dAzx67QfZIimzRltE4288ALXCK6FLTz5EgqFJf3cjpw>
    <xmx:FG_3ar_rV28mcvaP-0o4O5J5lFVayTCediqJ53usX_Ln4i08eNjxZQ>
    <xmx:FG_3al-Ayb75Pkq6gG8pY_WvrKhqOJ_y1IGvUmRikcq7h0W63Ezw3Q>
    <xmx:FG_3aiVGA_aDXNHzbTJUXUsG6haCoMa_ddC8Qw78fFZskYV-iIKzgg>
    <xmx:FW_3ancCdZLV_QX4yOsxWcmUteAENwscg_HY2hvqJfClH20IhRLZwHRm>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 15:12:04 -0500 (EST)
Date: Fri, 13 Nov 2026 12:12:06 -0800
From: Boris Burkov <boris@bur.io>
To: Vlad Poenaru <vlad.wing@gmail.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org, mason@kernel.org,
	osandov@osandov.com, josef@toxicpanda.com, fdmanana@suse.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bytes_may_use underflow after a failed tree
 block allocation
Message-ID: <20261113201206.GA1806724@zen.localdomain>
References: <20261113170926.1468850-1-vlad.wing@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113170926.1468850-1-vlad.wing@gmail.com>

On Fri, Nov 13, 2026 at 09:09:26AM -0800, Vlad Poenaru wrote:
> When btrfs_alloc_tree_block() fails after btrfs_reserve_extent() has
> succeeded, it frees the reserved extent and then calls
> btrfs_unuse_block_rsv(), which credits blocksize to the block reserve.
> That counts the block twice. btrfs_add_reserved_bytes() already took
> blocksize out of bytes_may_use when it reserved the extent, and
> btrfs_free_reserved_extent() releases it from bytes_reserved without
> returning it to bytes_may_use. bytes_may_use is left a block short of
> what the reserves hold, one more block for every such failure. It
> underflows when the global block reserve is released at unmount, or
> earlier, while the filesystem is in use, once the deficit outgrows the
> reservations outstanding at that moment.
> 
> Return without crediting the reserve once the extent has been reserved:
> by then btrfs_add_reserved_bytes() has consumed the block, whether
> btrfs_use_block_rsv() took it from a block reserve or reserved it
> directly in bytes_may_use. The out_unuse path, taken when
> btrfs_reserve_extent() itself fails, still credits the reserve, which is
> correct there because bytes_may_use still holds the block.
> 
> Since commit 19d7f65f032f ("btrfs: convert the buffer_radix to an
> xarray") in v6.16, the failure path is reachable under memory cgroup
> pressure. fs_info->buffer_tree is XA_FLAGS_ACCOUNT, so the GFP_NOFS
> xarray node allocated in alloc_extent_buffer() is charged to the
> caller's cgroup. On cgroup v2, try_charge_memcg() fails that charge with
> -ENOMEM when the cgroup or an ancestor is at its limit in these cases,
> among others:
> 
> - the charging task is dying (an OOM victim, fatally signalled or
>   exiting) after memcg OOM handling has already been invoked for this
>   charge;
> - the charging task is an OOM victim whose mm is already marked
>   MMF_OOM_SKIP, a case added in v7.3 by
>   commit 6b0d1083364f ("memcg: bypass the reclaim and oom killer for
>   dying tasks once oom_reaper is done");
> - no task in the cgroup at its limit can be OOM-killed.
> 
> Before the xarray conversion, buffer_radix was not memcg-accounted: it
> was initialised with GFP_ATOMIC and preloaded with GFP_NOFS, neither of
> which carries __GFP_ACCOUNT. Older kernels have the same bug, but there
> it takes an allocation failure outside memcg (or a corruption error),
> which is rare; hence the 6.16+ stable tag.
> 
> We hit this on a large fleet running a 6.16-based kernel, at unmount,
> when close_ctree() releases the global block reserve:
> 
>   WARNING: CPU: 1 PID: 855255 at fs/btrfs/space-info.h:265 btrfs_block_rsv_release+0x287/0x290
>   Call Trace:
>    btrfs_release_global_block_rsv+0x1e/0x90
>    btrfs_free_block_groups+0x30e/0x370
>    close_ctree+0x3cc/0x460
> 
> Over about eight days of warning logs, 186 hosts logged this warning,
> once each. In the 183 whose register dump could be matched to the
> warning, bytes_may_use was short of the global reserve by a whole number
> of 16K nodes, from 1 to 78 and never a fraction of a node, consistent
> with one node per failed allocation. 84% of the hosts that warned had
> also logged a memcg OOM, against 7% of a random sample of hosts that
> rebooted on the 6.16 builds most of them ran. No host running 6.13,
> which predates the xarray conversion, has logged the warning in 120
> days, although about 150,000 hosts still boot 6.13 every three days.
> 
> To reproduce, put a cgroup at its limit with no task that can be
> OOM-killed, the last case above, and update metadata from inside it:
> 
> 1. Mount a btrfs filesystem on a loop device and create 64 empty files
>    on it.
> 2. Create a cgroup v2 group with memory.swap.max set to 0.
> 3. Run a single task in the group with oom_score_adj -1000, so nothing
>    in the group can be OOM-killed. The task mlocks 64MiB of anonymous
>    memory and lowers memory.max to 16MiB. It then sets a new 2KiB user
>    xattr on every file, 300 times.
> 4. Meanwhile, from a task outside the group, run `sync -f` on the
>    filesystem every 0.2 seconds so that each round COWs new tree
>    blocks.
> 
> Some setxattr() calls fail with -ENOMEM without aborting the
> transaction. Once the filesystem is idle, the metadata bytes_may_use in
> sysfs is below the global reserve by a multiple of the nodesize, and
> unmount warns:
> 
>   WARNING: fs/btrfs/space-info.h:282 at btrfs_space_info_update_bytes_may_use+0x4d/0x120, CPU#2: umount/664
> 
> On v7.4-rc2-108-g79eb6679ef6a without this patch, all 12 runs of this
> workload that read bytes_may_use left it short of the global reserve: by
> 130 to 276 nodes of 16K in nine runs, and down to 0 in three. In the
> four runs that also counted btrfs_alloc_tree_block() failures with a
> kretprobe and did not reach 0, the shortfall equalled the failure count
> exactly (130, 161, 187 and 242). The run quoted above left bytes_may_use
> at 1933312 against a 5767168 global reserve, short by 234 nodes.
> 
> With this patch, bytes_may_use matched the global reserve in all 12 runs
> that read it, and no run whose log check covered the unmount saw a
> warning. fstests btrfs/002, btrfs/220, generic/475 and generic/476 also
> pass with -o compress-force=zstd:3. Testing on v7.4-rc2 was on x86_64
> without debug options. On 6.16, the same change also passed this
> workload on x86_64 with lockdep and KASAN and on arm64 under QEMU, where
> the unpatched kernel failed.
> 
> The same bug class was fixed for data extents by commit a4fe134fc1d8
> ("btrfs: fix a double release on reserved extents in cow_one_range()")
> and commit 82323b1a7088 ("btrfs: fix double-decrement of bytes_may_use
> in submit_one_async_extent()").
> 
> Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
> Cc: stable@vger.kernel.org # 6.16+

I think the bug is real and the fix is logical, but I have a question
about the best possible control flow inline. Either way, thanks for the
fix.

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>
> ---
> Reproducer: save the two files below in one directory and run
> `bash repro.sh` there as root, in a VM you can lose. After the workload
> it prints how many setxattr() calls failed with ENOMEM. A run where none
> failed is not a valid test. It then prints bytes_may_use and global_rsv
> from sysfs, then any space-info.h warning among the last 100 kernel log
> lines, which end with the unmount. On an affected kernel bytes_may_use
> is below global_rsv and a WARNING follows; on a fixed kernel the two
> numbers match and it prints "no space-info.h warnings".
> 
> With vm.panic_on_oom=2 its memcg OOMs panic the machine, and with
> panic_on_warn an affected kernel panics when bytes_may_use underflows,
> at unmount or earlier. It needs cgroup v2 at /sys/fs/cgroup, btrfs-progs
> and a C compiler, and uses /tmp/repro.img (4G, sparse), /tmp/repro.done,
> /mnt/repro and /sys/fs/cgroup/repro. It enables the memory controller in
> the root cgroup's cgroup.subtree_control and leaves it enabled. Every
> charge that reaches the memcg OOM killer prints an OOM report, a few
> hundred per run; `dmesg -n 1` keeps them off a slow console. An fstests
> case will follow.
> 
> ==> repro.sh <==
> #!/bin/bash
> # Reproducer for the bytes_may_use underflow after a failed tree block
> # allocation. Run as root next to memcg_setxattr.c.
> set -e
> cd "$(dirname "$0")"
> MNT=/mnt/repro
> CG=/sys/fs/cgroup/repro
> IMG=/tmp/repro.img
> DONE=/tmp/repro.done
> 
> cleanup()
> {
> 	touch $DONE
> 	[ -n "$syncer" ] && wait $syncer
> 	rm -f $DONE
> 	rmdir $CG 2> /dev/null || :
> 	umount $MNT 2> /dev/null || :
> 	rmdir $MNT 2> /dev/null || :
> 	rm -f $IMG memcg_setxattr
> }
> trap cleanup EXIT
> 
> cc -O2 -o memcg_setxattr memcg_setxattr.c
> truncate -s 4G $IMG
> mkfs.btrfs -q -f $IMG
> mkdir -p $MNT
> mount -o loop $IMG $MNT
> mkdir $MNT/d
> touch $MNT/d/f{0..63}
> sync
> 
> echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> mkdir $CG
> [ -f $CG/memory.swap.max ] && echo 0 > $CG/memory.swap.max
> 
> # Commit from outside the cgroup, so each round COWs new tree blocks.
> rm -f $DONE
> ( set +e; while [ ! -f $DONE ]; do sync -f $MNT; sleep 0.2; done ) &
> syncer=$!
> ./memcg_setxattr $CG $MNT/d 64 300
> touch $DONE
> wait $syncer
> syncer=
> 
> sync -f $MNT
> alloc=/sys/fs/btrfs/$(findmnt -n -o UUID $MNT)/allocation
> echo "bytes_may_use=$(cat $alloc/metadata/bytes_may_use)" \
> 	"global_rsv=$(cat $alloc/global_rsv_reserved)"
> umount $MNT
> # OOM reports can push older lines out of the log; the unmount is last.
> dmesg | tail -n 100 | grep 'space-info.h' || echo "no space-info.h warnings"
> 
> ==> memcg_setxattr.c <==
> // SPDX-License-Identifier: GPL-2.0
> /*
>  * memcg_setxattr <cgroup> <dir> <nfiles> <iters> [max_enomem]
>  *
>  * Join <cgroup> with oom_score_adj -1000, lock 64MiB of anonymous memory,
>  * lower memory.max to 16MiB, then set a new 2KiB xattr on <dir>/f0 ..
>  * f<nfiles-1>, <iters> times. Nothing in the cgroup can be OOM-killed, so
>  * memcg-charged GFP_NOFS allocations fail with -ENOMEM. Stop after
>  * max_enomem failures if it is given and not 0.
>  */
> #define _GNU_SOURCE
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/xattr.h>
> #include <unistd.h>
> 
> static int open_file(const char *dir, const char *file)
> {
> 	char path[4096];
> 	int fd;
> 
> 	snprintf(path, sizeof(path), "%s/%s", dir, file);
> 	fd = open(path, O_WRONLY);
> 	if (fd < 0) {
> 		perror(path);
> 		exit(1);
> 	}
> 	return fd;
> }
> 
> static void put(int fd, const char *val)
> {
> 	if (pwrite(fd, val, strlen(val), 0) < 0) {
> 		perror("write");
> 		exit(1);
> 	}
> }
> 
> static long number(const char *arg, long min)
> {
> 	char *end;
> 	long val;
> 
> 	errno = 0;
> 	val = strtol(arg, &end, 10);
> 	if (errno || *arg == '\0' || *end != '\0' || val < min) {
> 		fprintf(stderr, "invalid number: %s\n", arg);
> 		exit(2);
> 	}
> 	return val;
> }
> 
> int main(int argc, char **argv)
> {
> 	static char value[2048], path[4096], name[64];
> 	long ok = 0, enomem = 0, other = 0;
> 	long nfiles, iters, max_enomem = 0;
> 	char stack[256 << 10];
> 	char *fill;
> 	int max_fd;
> 
> 	if (argc != 5 && argc != 6) {
> 		fprintf(stderr,
> 			"usage: %s <cgroup> <dir> <nfiles> <iters> [max_enomem]\n",
> 			argv[0]);
> 		return 2;
> 	}
> 	nfiles = number(argv[3], 1);
> 	iters = number(argv[4], 1);
> 	if (argc == 6)
> 		max_enomem = number(argv[5], 0);
> 
> 	put(open_file(argv[1], "cgroup.procs"), "0");
> 	put(open_file("/proc/self", "oom_score_adj"), "-1000");
> 	/*
> 	 * Open memory.max now: once the limit is lowered, nothing can be
> 	 * killed and opening a file can fail to charge its struct file.
> 	 */
> 	max_fd = open_file(argv[1], "memory.max");
> 	/*
> 	 * Fault in the stack and lock everything: a page fault charged after
> 	 * the limit is lowered retries forever when nothing can be killed.
> 	 * The barrier keeps the compiler from dropping the unused memset.
> 	 */
> 	memset(stack, 0, sizeof(stack));
> 	asm volatile("" : : "r" (stack) : "memory");
> 	memset(value, 'v', sizeof(value));
> 	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
> 		perror("mlockall");
> 		return 1;
> 	}
> 	fill = mmap(NULL, 64 << 20, PROT_READ | PROT_WRITE,
> 		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
> 	if (fill == MAP_FAILED) {
> 		perror("mmap");
> 		return 1;
> 	}
> 	memset(fill, 1, 64 << 20);
> 	put(max_fd, "16777216");
> 
> 	for (long i = 0; i < iters; i++) {
> 		snprintf(name, sizeof(name), "user.k%ld", i);
> 		for (long f = 0; f < nfiles; f++) {
> 			snprintf(path, sizeof(path), "%s/f%ld", argv[2], f);
> 			if (!setxattr(path, name, value, sizeof(value), 0))
> 				ok++;
> 			else if (errno == ENOMEM)
> 				enomem++;
> 			else
> 				other++;
> 			if (max_enomem && enomem >= max_enomem)
> 				goto out;
> 		}
> 	}
> out:
> 	munmap(fill, 64 << 20);
> 	put(max_fd, "max");
> 	printf("setxattr: ok=%ld enomem=%ld other=%ld\n", ok, enomem, other);
> 	return 0;
> }
> 
>  fs/btrfs/extent-tree.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3c..9e93f35489cf2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5433,6 +5433,13 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>  	free_extent_buffer(buf);
>  out_free_reserved:
>  	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, false);
> +	/*
> +	 * btrfs_reserve_extent() moved blocksize from bytes_may_use to
> +	 * bytes_reserved, and freeing the extent does not give it back to
> +	 * bytes_may_use, so the reservation is consumed. Crediting block_rsv
> +	 * here, as out_unuse does, would count the block twice.
> +	 */

I think this comment is a bit gratuitous. If it is needed then I think
the control flow is not clear enough. Perhaps it is easier to understand
with a flag that means whether or not we need to return to the
block_rsv.

> +	return ERR_PTR(ret);
>  out_unuse:
>  	btrfs_unuse_block_rsv(fs_info, block_rsv, blocksize);
>  	return ERR_PTR(ret);

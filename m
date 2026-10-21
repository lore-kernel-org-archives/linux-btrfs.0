Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792603267;
	b=yap0Y4kczDt35XWx1jTBKVD+k6k8+lqD1BjZIOj0ianKYhrVreVckn2Mp6fCkFPxK7bO
	 WZLeLqEfJvfPVuLPelvgjE3PBT1RzgOFm2KJKi6qhIt+oYoQGCS4fA49mmUNB+GRVDLhD
	 CkNKlrGhcxywyc0xtS5XaWoLW9zC8eqelNcw/u4e+mnvgIJsZTGC1JhuA3CsFUQHESUd9
	 6fnuvqJeLtHOth+htnCCjSMbqE2QYrJATUxhDip6DB3FdI1VuIZLGa6WoNzNK5TueM4ns
	 B9yUi9CXyeamSXw6Jmb4rUjYA4aIi+l6EhvhfKia382qqys8tUGDUENp76pxN/z7+YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603267;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=kdDm2D3+zT6wf0nOyXjJoXtYRQlFcHHl3U5EpV07zvk=;
	b=vytnbZZJ8iCHfmp/Q0a3ytdiuH/TSjk730bwEer8SpFi+fQrw2mGO+yAeJGa66v81yrC
	 DGIeVEVnLXSh/jGB2Ar+Oo3c4TlTsYYja1ezCli/tw0mYBz2zTFQJx05BIOJQ2iXW4GYb
	 YzcvV/hPJ+lckkS2w6f/Qe0CXlDw+W9lciKBAGj0e5FKRTd5iouvULMYE8LM4ELz3Mr3t
	 n0QfH/vMvwOe8MtqXhiCz2bXMfzMXJQjwJqwUVqUzEJII5Ceo6d4ZC42VPITP6QGDhjyq
	 AeG9Tz9tfuymvAr5mAUjWEisBK4XQ9418U5zvusiM7eACjzmG9gIkUW7J0VySLhlejA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kv3eNR/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8853606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kv3eNR/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA2D1F000C4
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792603266;
	bh=kdDm2D3+zT6wf0nOyXjJoXtYRQlFcHHl3U5EpV07zvk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kv3eNR/T4cFfWoDzASPhoWcIP2tIjJc2msZPHIKfUpmje0GrrEInjnxPpmWBH/q/1
	 CkgJQLosr2VMnLmd/5bxavWA6ZZZIyoiN5JkIayYgiQMYWNYZfaHb0Nf6/vor5awFy
	 dppxsPfsU5miz9rTV/MFydbC38TcZdFeVkr3cRPG6gM4fNhZKP9vIEbKWMzqeLFBs4
	 flgZujGsaw1gpAgoZ677M2zfTQvUw+zjEPLVSrm24PoefU8L4ar4/n3JV1da/1p+Sl
	 cE6rIVEXZNFtQLtHeBg91zhYH1S3WKcW74ZcPzhFQuv7qLSIHs7or9o3tzWmdbBqGG
	 L0RIWXzfiPB8Q==
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-9906034086cso340295241.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 10:21:06 -0700 (PDT)
X-Gm-Message-State: AFq9FYJHn8kKKBd1VSxr3VU28LcVNHjlf8glTQxoKhP7G5+QyWbOl/wO
	KSdtfIHggNOp3FWyK6tvpTjpMNGkGw0/RtZ1yN4lchB6oXeTltqPjU940rogef7vN5o9C2SDe+T
	Ws/v1cuc6JCK+e10jMpfuTdUc3r0hp8c=
X-Received: by 2002:a05:6102:3fab:b0:7b8:1a1b:8e79 with SMTP id
 ada2fe7eead31-7cc9225029emr1048595137.0.1792603265671; Wed, 21 Oct 2026
 10:21:05 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021164637.2439627-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261021164637.2439627-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 18:20:29 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7tQKjPj_A72PBuwBO8Pp_McqPkGpP5hH+BvSjTXHmu2w@mail.gmail.com>
X-Gm-Features: AclHuK8nWHJNH19-35Hq6jV9auf52pt-A3UKkKYcVivdrX3Z-LJWTaTOsC0hyo4
Message-ID: <CAL3q7H7tQKjPj_A72PBuwBO8Pp_McqPkGpP5hH+BvSjTXHmu2w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 5:47=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> A data extent in a block-group that uses the RAID stripe tree has its log=
ical
> to physical mapping stored in that tree, which only becomes durable when =
the
> stripe tree is written out at transaction commit. The log tree cannot car=
ry
> that mapping, so a fast fsync logged a file-extent item whose logical ran=
ge
> could not be resolved afterwards. Log replay restored the file with the
> correct size, but reading it failed with EIO.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  tests/btrfs/363     | 56 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/363.out |  8 +++++++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/btrfs/363
>  create mode 100644 tests/btrfs/363.out
>
> diff --git a/tests/btrfs/363 b/tests/btrfs/363
> new file mode 100755
> index 00000000..68723f28
> --- /dev/null
> +++ b/tests/btrfs/363
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 363
> +#
> +# Test that data fsynced on a RAID stripe tree file system is still read=
able
> +# after a power failure.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log volume raid-stripe-tree
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +       "btrfs: force a transaction commit when fsyncing stripe tree exte=
nts"
> +
> +_cleanup()
> +{
> +       _cleanup_flakey
> +       rm -fr $tmp
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_btrfs_mkfs_feature "raid-stripe-tree"
> +_require_btrfs_fs_feature "raid_stripe_tree"
> +_require_scratch
> +_require_dm_target flakey
> +_require_btrfs_no_compress
> +
> +# DUP is one of the profiles that keeps its mapping in the stripe tree, =
so a
> +# single device is enough and dm-flakey can be layered on top of it.
> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || =
\
> +       _fail "mkfs failed"
> +
> +_init_flakey
> +_scratch_mount
> +
> +# Get the file committed first, so that the overwrite below takes the fa=
st
> +# fsync path through the log tree rather than committing the transaction=
.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/foo | \
> +       _filter_xfs_io
> +_scratch_sync

Doing an fsync followed by _scratch_sync is going to be confusing for
most readers.
This should explain that the fsync triggers a full fsync so that the
next fsync will be a fast fsync.

I also think we should expand the test to cover both the fast and full
fsync paths, as we don't have any tests covering the full fsync case
IIRC.

Thanks.



> +
> +# Overwrite it and fsync only. Nothing will commit the stripe tree after=
 this.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/foo | \
> +       _filter_xfs_io
> +
> +_flakey_drop_and_remount
> +_hexdump $SCRATCH_MNT/foo
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
> new file mode 100644
> index 00000000..02adaec5
> --- /dev/null
> +++ b/tests/btrfs/363.out
> @@ -0,0 +1,8 @@
> +QA output created by 363
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >...............=
.<
> +*
> +020000
> --
> 2.56.0
>
>

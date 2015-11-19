Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbbKSDVt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 22:21:49 -0500
Date: Thu, 19 Nov 2015 11:21:45 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: fix btrfs/091 failure due to not found
 _require_cp_reflink
Message-ID: <20151119032145.GL2535@eguan.usersys.redhat.com>
References: <1447862876-18701-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447862876-18701-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 18, 2015 at 04:07:56PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 20d7bfad2d38 ("reflink: add test support routines to a separate
> file") moved the function _require_cp_reflink to the new file
> common/reflink but forgot to make btrfs/091 source that file, leading
> to the following failure:
> 
> $ ./check btrfs/091
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 debian3 4.3.0-rc5-btrfs-next-17+
> MKFS_OPTIONS  -- /dev/sdc
> MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1
> 
> btrfs/091 1s ... - output mismatch (see .../results//btrfs/091.out.bad)
>     --- tests/btrfs/091.out	2015-05-03 01:19:42.128976975 +0100
>     +++ .../results/btrfs/091.out.bad	2015-11-18 15:56:35.332745132 +0000
>     @@ -1,4 +1,5 @@
>      QA output created by 091
>     +./tests/btrfs/091: line 49: _require_cp_reflink: command not found
>      wrote 262144/262144 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>      65536 65536
>     ...
>     (Run 'diff -u tests/btrfs/091.out .../results/btrfs/091.out.bad'  \
>         to see the entire diff)
> 
> So just make btrfs/091 source common/reflink in order to know the
> definition of _require_cp_reflink.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Eryu Guan <eguan@redhat.com>


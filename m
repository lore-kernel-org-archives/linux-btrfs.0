Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751612AbdGRSW1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:22:27 -0400
Date: Tue, 18 Jul 2017 20:21:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170718182111.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629194108.1674498-4-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:41:07PM -0700, Nick Terrell wrote:
> +static void zstd_free_workspace(struct list_head *ws)
> +{
> +	struct workspace *workspace = list_entry(ws, struct workspace, list);
> +
> +	vfree(workspace->mem);
> +	kfree(workspace->buf);
> +	kfree(workspace);
> +}
> +
> +static struct list_head *zstd_alloc_workspace(void)
> +{
> +	ZSTD_parameters params =
> +			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
> +	struct workspace *workspace;
> +
> +	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
> +	if (!workspace)
> +		return ERR_PTR(-ENOMEM);
> +
> +	workspace->size = max_t(size_t,
> +			ZSTD_CStreamWorkspaceBound(params.cParams),
> +			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
> +	workspace->mem = vmalloc(workspace->size);
> +	workspace->buf = kmalloc(PAGE_SIZE, GFP_NOFS);
> +	if (!workspace->mem || !workspace->buf)
> +		goto fail;
> +
> +	INIT_LIST_HEAD(&workspace->list);
> +
> +	return &workspace->list;
> +fail:
> +	zstd_free_workspace(&workspace->list);
> +	return ERR_PTR(-ENOMEM);
> +}

In the next iteration, please update the workspace allocations so that
they use kvmalloc/kvfree and GFP_KERNEL (eg. 6acafd1eff426).

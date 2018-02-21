Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46015 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932268AbeBUSyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:54:16 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A64D8AD91
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 18:54:15 +0000 (UTC)
Date: Wed, 21 Feb 2018 16:40:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 06/10] btrfs-progs: kernel-lib: Port kernel sort() to
 btrfs-progs
Message-ID: <20180221154033.GG1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-8-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180209074428.29187-8-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 09, 2018 at 03:44:24PM +0800, Qu Wenruo wrote:
> Used by later btrfs_alloc_chunk() rework.

We have the libc provided qsort, so please don't pull another
implementation but rather add a wrapper.

> --- /dev/null
> +++ b/kernel-lib/sort.c
> @@ -0,0 +1,104 @@
> +/*
> + * taken from linux kernel lib/sort.c, removed kernel config code and adapted
> + * for btrfsprogs
> + */
> +
> +#include "sort.h"
> +
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * A fast, small, non-recursive O(nlog n) sort for the Linux kernel
> + *
> + * Jan 23 2005  Matt Mackall <mpm@selenic.com>
> + */

When taking files from kernel: take the file as is and insert notes for
btrfs-progs below the comments. The SPDX line must be first.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853Ab2JXXtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 19:49:23 -0400
Date: Thu, 25 Oct 2012 07:49:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: raghu.prabhu13@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@gmail.com, zheng.z.yan@intel.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH v2] Change the check for PageReadahead into an else-if
Message-ID: <20121024234918.GA7655@localhost>
References: <05ff4f71283e84be8ab1b312864168d89535239f.1351113536.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <05ff4f71283e84be8ab1b312864168d89535239f.1351113536.git.rprabhu@wnohang.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 02:56:04AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> >From 51daa88ebd8e0d437289f589af29d4b39379ea76, page_sync_readahead coalesces
> async readahead into its readahead window, so another checking for that again is
> not required.
> 
> Version 2: Fixed the incorrect indentation.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/btrfs/relocation.c | 4 +---
>  mm/filemap.c          | 3 +--
>  2 files changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!

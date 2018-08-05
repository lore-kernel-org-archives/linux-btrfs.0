Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbeHEVUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 17:20:06 -0400
Subject: Re: [PATCH 0/3] Remove uneeded variable "err"
To: zhong jiang <zhongjiang@huawei.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c9f07f02-38c0-7491-3b48-0dda20f60d13@suse.com>
Date: Sun, 5 Aug 2018 22:14:29 +0300
MIME-Version: 1.0
In-Reply-To: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.08.2018 18:02, zhong jiang wrote:
> 
> zhong jiang (3):
>   fs/btrfs/disk-io: Remove unneeded variable "err"
>   fs/btrfs/extent-tree: remove redudant variable "err"
>   fs/btrfs/tree-log: remove the unneeded variable "err"
> 
>  fs/btrfs/disk-io.c     | 12 ++++--------
>  fs/btrfs/extent-tree.c |  6 ++----
>  fs/btrfs/tree-log.c    |  5 +----
>  fs/btrfs/tree-log.h    |  2 +-
>  4 files changed, 8 insertions(+), 17 deletions(-)
> 


NAK on the whole series on the basis of using a bulk commit message
which doesn't really describe the changes of each individual commit. If
you want those changes to eventually be merged resubmit the series with
individual reasoning for every commit.

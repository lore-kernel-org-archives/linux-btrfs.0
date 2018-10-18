Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBBAECDE42
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5BC204EC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 00:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D5BC204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ZenIV.linux.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbeJRIqu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 04:46:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39488 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeJRIqu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 04:46:50 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gCwUF-0003Z5-0X; Thu, 18 Oct 2018 00:48:27 +0000
Date:   Thu, 18 Oct 2018 01:48:26 +0100
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 09/29] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181018004826.GB12386@ZenIV.linux.org.uk>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981631706.5568.6473120432728396978.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153981631706.5568.6473120432728396978.stgit@magnolia>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 03:45:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Combine the clone_file_range and dedupe_file_range operations into a
> single remap_file_range file operation dispatch since they're
> fundamentally the same operation.  The differences between the two can
> be made in the prep functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/vfs.txt |   13 +++++------
>  fs/btrfs/ctree.h                  |    8 ++-----
>  fs/btrfs/file.c                   |    3 +-
>  fs/btrfs/ioctl.c                  |   45 +++++++++++++++++++------------------
>  fs/cifs/cifsfs.c                  |   22 +++++++++++-------
>  fs/nfs/nfs4file.c                 |   10 ++++++--
>  fs/ocfs2/file.c                   |   24 +++++++-------------
>  fs/overlayfs/file.c               |   30 ++++++++++++++-----------
>  fs/read_write.c                   |   18 +++++++--------
>  fs/xfs/xfs_file.c                 |   23 ++++++-------------
>  include/linux/fs.h                |   20 +++++++++++++---
>  11 files changed, 110 insertions(+), 106 deletions(-)
> 
> 
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index a6c6a8af48a2..bb3183334ab9 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -883,8 +883,9 @@ struct file_operations {
>  	unsigned (*mmap_capabilities)(struct file *);
>  #endif
>  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				u64 len, unsigned int remap_flags);
>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
>  };

Documentation/filesystems/porting part, please.  And document remap_flags.

> +#define REMAP_FILE_DEDUP		(1 << 0)
> +
> +/*
> + * These flags should be taken care of by the implementation (possibly using
> + * vfs helpers) but can be ignored by the implementation.
> + */
> +#define REMAP_FILE_ADVISORY		(0)

???

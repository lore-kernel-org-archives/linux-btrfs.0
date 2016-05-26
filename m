Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbcEZIEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 04:04:25 -0400
Date: Thu, 26 May 2016 01:04:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 6/7] xfs: test rmap behavior when multiple bmbt records
 map to a single rmapbt record
Message-ID: <20160526080424.GA8469@infradead.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> --- a/src/t_immutable.c
> +++ b/src/t_immutable.c
> @@ -38,10 +38,10 @@
>  #include <libgen.h>
>  #include <sys/acl.h>
>  #include <attr/xattr.h>
> +#include <linux/fs.h>
>  #include <xfs/xfs.h>
>  #include <xfs/handle.h>
>  #include <xfs/jdm.h>
> -#include <linux/fs.h>
>  #include <linux/magic.h>
>  
>  #ifndef XFS_SUPER_MAGIC

How does this belong into the patch?

> diff --git a/tests/xfs/group b/tests/xfs/group
> index f0ca410..0e34f9a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -288,3 +288,4 @@
>  853 auto quick clone
>  854 auto quick clone
>  855 auto clone
> +856 auto clone rmap reflink

This is the only test in the reflink group, how is this group different
from the clone one?

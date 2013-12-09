Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16752 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab3LIOcM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 09:32:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1386581671-4639-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1386581671-4639-1-git-send-email-bo.li.liu@oracle.com>
Message-ID: <20131209142005.20371.31891@ret.masoncoding.com>
Subject: Re: [PATCH] Btrfs: avoid building inode cache repeatly
Date: Mon, 9 Dec 2013 09:20:05 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Liu Bo (2013-12-09 04:34:31)
> Inode cache is similar to free space cache and in fact shares the same
> code, however, we don't load inode cache unless we're about to allocate
> inode id, then there is a case where we only commit the transaction during
> other operations, such as snapshot creation, we now update fs roots' generation
> to the new transaction id, after that when we want to load the inode cache,
> we'll find that it's not valid thanks to the mismatch of generation, and we
> have to push btrfs-ino-cache thread to build inode cache from disk, and
> this operation is sometimes time-costing.
> 
> So to fix the above, we load inode cache into memory during reading fs root.

Thanks Liu.  Have you tested this with orphan replay?  I'd like to make
sure the new ordering of starting caching isn't causing problems with
finding and processing the orphan items.

-chris

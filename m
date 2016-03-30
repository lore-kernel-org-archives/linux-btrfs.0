Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcC3R2Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:28:24 -0400
Date: Wed, 30 Mar 2016 10:28:20 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: good documentation on btrfs internals and on disk layout
Message-ID: <20160330172819.GD20816@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <loom.20160330T155403-473@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20160330T155403-473@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 01:58:03PM +0000, sri wrote:
> Hi,
> 
> I could find very limited documentation related to on disk layout of btrfs 
> and how all trees are related to each other. Except wiki which has very 
> specific top level details I couldn't able to find more details on btrfs.
> 
> FSs such as zfs, ext3/4 and XFS there are documents which explains ondisk 
> layout of the file systems.
> 
> Could anybody please provide pointers for the same for better 
> understanding of btrfs on disk layout and how each tree interacts provided 
> multiple disks are configured for btrfs.

There is a paper[1] about btrfs filesystem which covers all the details.

[1]: BTRFS: The Linux B-Tree Filesystem

Thanks,

-liubo

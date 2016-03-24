Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbcCXIbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 04:31:05 -0400
Date: Thu, 24 Mar 2016 16:31:02 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160324083102.GR11419@eguan.usersys.redhat.com>
References: <1458255398-26833-1-git-send-email-bo.li.liu@oracle.com>
 <1458795352-13404-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458795352-13404-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 09:55:52PM -0700, Liu Bo wrote:
> This is to test if COW enabled btrfs can end up with single 4k extents
> when doing subpagesize buffered writes.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

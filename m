Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab3AWGI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 01:08:57 -0500
Date: Wed, 23 Jan 2013 14:06:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
Message-ID: <20130123060618.GC17162@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <50FE6E9C.2040803@cn.fujitsu.com>
 <20130122142414.GA15978@liubo>
 <50FF50EF.9010907@cn.fujitsu.com>
 <20130123035647.GB17162@liubo.jp.oracle.com>
 <50FF6AC1.6030602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FF6AC1.6030602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 12:44:49PM +0800, Miao Xie wrote:
> No, we can't. The other tasks which flush the delalloc data may remove the inode
> from the delalloc list/splice list. If we release the lock, we will meet the race
> between list traversing and list_del().

OK, then please merge patch 1 and 4 so that we can backport 1 less patch
at least.

thanks,
liubo

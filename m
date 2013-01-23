Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab3AWGcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 01:32:50 -0500
Message-ID: <50FF8437.3010703@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 14:33:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
References: <50FE6E9C.2040803@cn.fujitsu.com> <20130122142414.GA15978@liubo> <50FF50EF.9010907@cn.fujitsu.com> <20130123035647.GB17162@liubo.jp.oracle.com> <50FF6AC1.6030602@cn.fujitsu.com> <20130123060618.GC17162@liubo.jp.oracle.com>
In-Reply-To: <20130123060618.GC17162@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 23 Jan 2013 14:06:21 +0800, Liu Bo wrote:
> On Wed, Jan 23, 2013 at 12:44:49PM +0800, Miao Xie wrote:
>> No, we can't. The other tasks which flush the delalloc data may remove the inode
>> from the delalloc list/splice list. If we release the lock, we will meet the race
>> between list traversing and list_del().
> 
> OK, then please merge patch 1 and 4 so that we can backport 1 less patch
> at least.

I don't think we should merge these two patch because they do two different things - one
is bug fix, and the other is just a improvement, and this improvement changes the logic
of the code and might be argumentative for some developers. So 2 patches is  better than one,
I think.

Thanks
Miao


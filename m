Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47275 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3C1NV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 09:21:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 208237C068A
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 07:21:56 -0600 (MDT)
Date: Thu, 28 Mar 2013 09:21:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "wangsl-fnst@cn.fujitsu.com" <wangsl-fnst@cn.fujitsu.com>
Subject: Re: [PATCH V2 5/6] Btrfs: fix missing check before
 assigning/removing qgroup relation
Message-ID: <20130328132153.GO28030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1364468087-1702-4-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1364468087-1702-4-git-send-email-wangshilong1991@gmail.com>

On Thu, Mar 28, 2013 at 04:54:46AM -0600, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> If the specified qgroup relation dosen't exist, removing qgroup operations
> will return -ENOENT;
> 
> If the specified qgroup relation exists, assigning qgroup relations will
> return -EEXIST.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

Fails to compile with

fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_qgroup_assign’:
fs/btrfs/ioctl.c:3771:2: error: implicit declaration of function
‘btrfs_may_assign_qgroup’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Please fix and resubmit.  Thanks,

Josef

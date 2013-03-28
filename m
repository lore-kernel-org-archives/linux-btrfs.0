Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63767 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3C1OGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 10:06:40 -0400
Received: by mail-pd0-f178.google.com with SMTP id u10so4045950pdi.23
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 07:06:40 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V2 5/6] Btrfs: fix missing check before assigning/removing qgroup relation
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130328132153.GO28030@localhost.localdomain>
Date: Thu, 28 Mar 2013 22:06:33 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "wangsl-fnst@cn.fujitsu.com" <wangsl-fnst@cn.fujitsu.com>
Message-Id: <73320F50-8452-450B-9C1A-33D95FF388CB@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1364468087-1702-1-git-send-email-wangshilong1991@gmail.com>


Hello,
> On Thu, Mar 28, 2013 at 04:54:46AM -0600, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> 
>> If the specified qgroup relation dosen't exist, removing qgroup operations
>> will return -ENOENT;
>> 
>> If the specified qgroup relation exists, assigning qgroup relations will
>> return -EEXIST.
>> 
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> Fails to compile with
> 
> fs/btrfs/ioctl.c: In function ¡®btrfs_ioctl_qgroup_assign¡¯:
> fs/btrfs/ioctl.c:3771:2: error: implicit declaration of function
> ¡®btrfs_may_assign_qgroup¡¯ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Please fix and resubmit.  Thanks,

Sorry for such stupid errors, i promise that i have compile and test patch-set.

Things go like this, because when i compile kernel with patch-set , this errors happen,
i just fix it but don't update commit.

However, when i pass the test, i forget the compile errors¡­..

Next time, i will take care of that¡­

Thanks very much for your testing!


Thanks,
Wang

> 
> Josef


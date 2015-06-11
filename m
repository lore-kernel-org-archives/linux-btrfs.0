Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35261 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbFKGIQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 02:08:16 -0400
Received: by pacyx8 with SMTP id yx8so47396810pac.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 23:08:15 -0700 (PDT)
Date: Wed, 10 Jun 2015 23:08:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, "'Miao Xie'" <miaoxie@huawei.com>,
        "'Philip'" <bugzilla@philip-seeger.de>
Subject: Re: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
Message-ID: <20150611060813.GA16231@mew>
References: <cover.1431330020.git.osandov@osandov.com>
 <20150526170547.GA21342@mew.lv.cox.net>
 <031201d0a3fa$0af404a0$20dc0de0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <031201d0a3fa$0af404a0$20dc0de0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 11:52:30AM +0800, Zhao Lei wrote:
> Hi, Omar Sandoval
> 
> I tested this patchset with my script, but see general protection fault
> again.
> NODE: kvm with virtio disk
> ROOTFS: RHEL6 with btrfs-progs v4.0
> KERNEL: v4.1-rc6 with 4 patchs in this patchset
> 
> Maybe my test have small different with yours,
> but it seems is similar bug, could you check it?
> 

Hi, Zhao Lei,

Thanks for taking a look! I was able to reproduce this and it looks like
a similar bug, this time coming from the parity scrubbing code instead
of the data scrubbing code. I didn't test scrubbing a degraded
filesystem, only replacing a missing device, so that's probably why I
didn't run into it. I'll take a closer look.

Thanks,
-- 
Omar

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37630 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751641AbdFVAjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 20:39:14 -0400
Subject: Re: [PATCH] btrfs: DEBUG fiemap: Show more info about extent_fiemap
To: Adam Borowski <kilobyte@angband.pl>
CC: <linux-btrfs@vger.kernel.org>
References: <20170621092850.18394-1-quwenruo@cn.fujitsu.com>
 <20170621121021.3lx3chb23flvu2re@angband.pl>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <82f31b8f-63b2-ff24-4deb-51561a60b2ba@cn.fujitsu.com>
Date: Thu, 22 Jun 2017 08:39:09 +0800
MIME-Version: 1.0
In-Reply-To: <20170621121021.3lx3chb23flvu2re@angband.pl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/21/2017 08:10 PM, Adam Borowski wrote:
> On Wed, Jun 21, 2017 at 05:28:50PM +0800, Qu Wenruo wrote:
>> Would you please try this patch based on v4.12-rc5 and try to reproduce
>> the kernel warning?
>>
>> It would be better to eliminate the noisy by ensure there is no other fiemap
>> caller on btrfs.
> 
> Here's my current dmesg buffer from a single dpkg --reinstall invocation.
>

Thanks for the dmesg!

The problem is if the fiemap range is smaller than the extent, we will 
exit without emit fiemap extent to VFS, leaving it cached.

As shown in your dmesg:
---
  extent_fiemap: enter: root=10152 inode=5353157 start=0 len=4096
  emit_fiemap_extent: entered: offset=0 phys=2012381351936 len=131072 
flags=0x2008
  emit_fiemap_extent: assigning new fiemap
  emit_fiemap_extent: last exit ret=0
  ------------[ cut here ]------------
---

Your dmesg really helps a lot!

I'll send the fix in this week.

Thanks,
Qu



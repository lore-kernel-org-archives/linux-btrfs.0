Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8761 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S966964Ab3HIF5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 01:57:49 -0400
Message-ID: <52048483.1010809@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 13:56:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup destroy -> ERROR: unable to create quota group:
 Device or resource busy
References: <20130809133933.2fbfc6e4@virtall.com>
In-Reply-To: <20130809133933.2fbfc6e4@virtall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On 08/09/2013 01:39 PM, Tomasz Chmielewski wrote:
> I'm using qgroups and have created a few hundreds of subvolumes in the
> past.
> 
> It seems that btrfs automatically assigns a qgroup to newly created
> snapshot/subvolume, but does not destroy the qgroup when the subvolume
> is deleted.

This should be implemented. And will soon.

> 
> So I've tried to destroy the unused qgroups, with mixed success. I was
> able to destroy most of them, but some are still failing, i.e.:
> 
> # btrfs qgroup destroy 4494 /mnt/lxc1
> ERROR: unable to create quota group: Device or resource busy

Just remove qgroup（4494）'s parent qgroup. then it can be removed.
Anyway, i think this is unnecessary.

Thanks,
Wang
> 
> 
> Note the negative number here, but I also have qgroups with both
> positive numbers, which I'm not able to destroy as well:
> 
> # btrfs qgroup show /mnt/lxc1 | grep 4494
> 0/4494 839516160 -69632
> 
> 
> qgroup 4494 is not used by any subvolume:
> 
> # btrfs sub list /mnt/lxc1 | grep 4494
> 
> 
> I did run "btrfs quota rescan" for this filesystem, hoping it will fix
> the problem, but it didn't.
> 
> 
> Any advice?
> 
> 


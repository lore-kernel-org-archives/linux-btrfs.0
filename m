Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:44079 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKMXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 08:23:35 -0400
Date: Wed, 11 Jun 2014 14:23:31 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix race condition between btrfs and udev
Message-ID: <20140611122330.GA22226@mother.pipebreaker.pl>
References: <1402488698-12518-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402488698-12518-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 11, 2014 at 08:11:38PM +0800, Wang Shilong wrote:
> So the problem is RW opening would trigger udev event which will
> call btrfs_scan_one_device(). In btrfs_scan_one_device(), it
> would open the block device with EXCL flag..meanwhile if another
> program try to open that device with O_EXCL, it would fail with
> EBUSY.
> 
> This happen seldomly in the real world, but if we use loop device
> for test, we may hit this annoying problem.

  Hi,

udev just changed the locking semantics, see description in
http://cgit.freedesktop.org/systemd/systemd/commit/NEWS?id=4196a3ead3cfb823670d225eefcb3e60e34c7d95
 

-- 
Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49738 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753019AbaB0Tvc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 14:51:32 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:61318 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WJ6zT-002JWz-7p
	for linux-btrfs@vger.kernel.org; Thu, 27 Feb 2014 12:51:31 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com>
Date: Thu, 27 Feb 2014 12:51:29 -0700
Message-Id: <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 12:27 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is on i686?
> 
> The kernel page cache is limited to 16TB on i686, so effectively your block device is limited to 16TB. While the file system successfully creates, I think it's a bug that the mount -t btrfs command is probably a btrfs bug.

Yes Chris, circular logic day. It's probably a btrfs bug that the mount command succeeds.

So let us know if this is i686 or x86_64, because if it's the former it's a bug that should get fixed.


Chris Murphy


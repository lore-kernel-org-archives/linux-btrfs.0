Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42762 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaBYRaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:30:30 -0500
Date: Tue, 25 Feb 2014 09:30:22 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140225173022.GF3521@merlins.org>
References: <20140225063652.GD3521@merlins.org>
 <530C4B37.9000402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530C4B37.9000402@cn.fujitsu.com>
Subject: Re: 3.14.0rc3: btrfs send ioctl failed with -5: Input/output error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 25, 2014 at 03:50:15PM +0800, Wang Shilong wrote:
> Hi Marc,
> 
> This seems a regression which has been fixed by the following
> commit(only pushed into btrfs-next):
> 
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=1334bebe71bebbca47b3b92f25511ea980fdeab8

I'll revert this, thanks.

Mmmh, but I just found another problem I didn't have before upgrading to 3.14.0-rc3
(on my laptop this time):

+ btrfs send -p /mnt/btrfs_pool1/var_ro.20140224_14:01:54 var_ro.20140225_09:27:57
+ btrfs receive /mnt/btrfs_pool2//
At subvol var_ro.20140225_09:27:57
At snapshot var_ro.20140225_09:27:57
ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.

Is it another different regression?

Currently it's only happening on one of my subvolumes. The other ones
are still syncing ok.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

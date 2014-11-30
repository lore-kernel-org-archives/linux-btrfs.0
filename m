Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39859 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaK3EVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 23:21:46 -0500
Date: Sat, 29 Nov 2014 20:21:23 -0800
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20141130042123.GD8916@merlins.org>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
Subject: Re: Moving an entire subvol?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 09:01:42AM +0530, Shriramana Sharma wrote:
> So the Ubuntu Wiki BtrFS entry advises against using subvol
> set-default because it boots its kernel using root=subvol=@ and home
> as subvol=@home, and these two subvols are only present under the
> subvol with ID 5. But isn't it just possible to move i.e. reparent a
> subvol so I can move these two under another subvol and have that as
> default?

Make a new subvolume called /root and just mount subvol=root
Note that you can't mount subvols recursively in one mount AFAIK.

This is what my system looks like:
LABEL=btrfs_pool1 /               btrfs    subvol=root,defaults,compress=lzo,discard,skip_balance,noatime 0       0
LABEL=btrfs_pool1 /usr            btrfs    subvol=usr,defaults,compress=lzo,discard,skip_balance,noatime  0       0
LABEL=btrfs_pool1 /var            btrfs    subvol=var,defaults,compress=lzo,discard,skip_balance,noatime  0       0
LABEL=btrfs_pool1 /home           btrfs    subvol=home,defaults,compress=lzo,discard,skip_balance,noatime 0       0
LABEL=btrfs_pool1 /tmp            btrfs    subvol=tmp,defaults,compress=lzo,discard,skip_balance,noatime,noexec  0       0
LABEL=btrfs_pool1 /mnt/btrfs_pool1 btrfs   defaults,compress=lzo,discard,skip_balance,noatime,subvolid=0         0       0

Hope this helps.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

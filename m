Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41915 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbaEJOCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 10:02:45 -0400
Date: Sat, 10 May 2014 07:02:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Korent <ckorent@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unable to mount filesystem
Message-ID: <20140510140240.GH9276@merlins.org>
References: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 01:06:25PM +0000, Chris Korent wrote:
> This seemed to happen after a power failure. I rebooted and the FS was
> mounted, but read-only and there were some errors (journalctl not able
> to start. I did not capture all the errors). I rebooted again and then
> it wouldn't mount at all. Is there anything else I can do?

You did some things, but look at the checklist I put on 
https://btrfs.wiki.kernel.org/index.php/Btrfsck
1) use -o recovery,ro, not -o recovery)
2) does btrfs restore work?
3) btrfs check is your last option.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

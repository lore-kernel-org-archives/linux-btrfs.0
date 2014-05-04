Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34579 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaEDHe0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:34:26 -0400
Date: Sun, 4 May 2014 00:28:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copying related snapshots to another server with btrfs
 send/receive?
Message-ID: <20140504072829.GK9061@merlins.org>
References: <20140504031231.GG9061@merlins.org>
 <5365E932.20602@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5365E932.20602@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 09:16:02AM +0200, Brendan Hide wrote:
> Sending one-at-a-time, the shared-data relationship will be kept by
> using the -p (parent) parameter. Send will only send the differences
> and receive will create a new snapshot, adjusting for those
> differences, even when the receive is run on a remote server.
> 
> $ btrfs send backup | btrfs receive $path/
> $ btrfs send -p backup backup.sav1 | btrfs receive $path/
> $ btrfs send -p backup.sav1 backup.sav2 | btrfs receive $path/
> $ btrfs send -p backup.sav2 backup.sav3 | btrfs receive $path/
> $ btrfs send -p backup.sav3 backup.sav4 | btrfs receive $path/

So this is exactly the same than what I do incremental backups with
brrfs send, but -p only works if the snapshot is read only, does it not?
I do use that for my incremental syncs and don't mind read only
snapshots there, but if I have read/write snapshots that are there for
other reasons than btrfs send incrementals, can I still send them that
way with -p?
(I thought that wouldn't work)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

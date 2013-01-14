Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48999 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3ANRcv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 12:32:51 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1Tuntz-0006n4-0s
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 09:32:51 -0800
Date: Mon, 14 Jan 2013 09:32:50 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Can moving data to a subvolume not take as long as a fully copy?
Message-ID: <20130114173250.GA23026@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I made a mistake and copied data in the root of a new btrfs filesystem.
I created a subvolume, and used mv to put everything in there.
Something like:
cd /mnt
btrfs subvolume create dir
mv * dir

Except it's been running for over a day now (ok, it's 5TB of data)

Looks like mv is really copying all the data as if it were an entirely
different filesystem.

Is there not a way to short circuit this and only update the metadata?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40018 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaAYHEP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 02:04:15 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1W6xHr-0001YZ-6l
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 23:04:15 -0800
Date: Fri, 24 Jan 2014 23:04:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Is there a lightweight copy from one subvolume to another?
Message-ID: <20140125070415.GB14998@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I have 
/mnt/btrfs1/subvol1
/mnt/btrfs1/subvol2

Can I copy/move data from subvol1 to subvol2 without having to physically
copy all the blocks as if it were an entirely different filesystem?

reflink doesn't work for this:
gargamel [mc]# cp -av --reflink=always misc/olympic Video/misc/
`misc/olympic' -> `Video/misc/olympic'
`misc/olympic/file.avi' -> `Video/misc/olympic/file.avi'
cp: failed to clone `Video/misc/olympic/file.avi' from `misc/olympic/file.avi': Invalid cross-device link

Was there another way?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

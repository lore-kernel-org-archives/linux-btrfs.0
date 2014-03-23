Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58653 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaCWWog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 18:44:36 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WRr87-0005cB-BB
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 15:44:35 -0700
Date: Sun, 23 Mar 2014 15:44:35 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Any use for mkfs.btrfs -d raid5 -m raid1 ?
Message-ID: <20140323224435.GC18293@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I lose 2 drives on a raid5, -m raid1 should ensure I haven't lost my
metadate.
>From there, would I indeed have small files that would be stored entirely on
some of the drives that didn't go missing, and therefore I could recover
some data with 2 missing drives?

Or is it kind of pointless/waste of space?

Actually, would it make btrfs faster for metadata work since it can read
from n drives in parallel and get data just a bit faster, or is that mostly
negligeable?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

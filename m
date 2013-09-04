Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54816 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab3IDSPN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 14:15:13 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1VHHbk-0007pm-Jm
	for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 11:15:12 -0700
Date: Wed, 4 Sep 2013 11:15:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Newer kernels do not oops if log cannot be re-read at mount
Message-ID: <20130904181512.GU5342@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just wanted to confirm that the crash on unexpected log read during mount
is indeed fixed for me, I now just get a log read failed message.

I've filed a bug with debian to encourage them to add btrfs-zero-log as a
tool in the initrd so that one can have the choice of running this on a non
mounting root filesystem.

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=721857

Thanks for having fixed this.

In case someone is wondering why I'm still sticking with my SSD :) I'm holding
off just a bit longer for the next generation of SSDs coming out now so that
I can switch away from that questionable line of OCZ Vertex 4 (I tried 4,
they all have this problem of not writing everything correctly when they
hang, which fortunately is rarely).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

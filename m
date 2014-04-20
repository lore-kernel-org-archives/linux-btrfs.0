Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38125 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbaDTT7J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 15:59:09 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:50974 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WbxtG-0008NF-PY by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 12:59:08 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WbxtG-0001m0-1b
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 12:59:02 -0700
Date: Sun, 20 Apr 2014 12:59:01 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140420195901.GP7884@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Do quota groups cost noticeable performance in 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was looking at using qgroups for my backup server, which will be
filled with millions of files in subvolumes with snapshots.

I read a warning that quota groups had performance issues, at least in
the past.

Is it still true? 
If there is a performance issue, is it as simple as just turning off
quota support and then things go back to normal?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38839 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaEGLc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 07:32:58 -0400
Received: from p2237-ipad08yosemiya.okinawa.ocn.ne.jp ([124.97.214.237]:55669 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wi05q-0004ZA-5a by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 04:32:58 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wi05l-0001Mr-94
	for linux-btrfs@vger.kernel.org; Wed, 07 May 2014 04:32:53 -0700
Date: Wed, 7 May 2014 04:19:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs snapshot sizes
Message-ID: <20140507111949.GT10159@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So have others found a good way to have an idea about how much space is
taken by each snapshot?

I've tried quota trees, but I'm not sure how to read the output, or if it's
correct (including the negative numbers some have mentioned). Are there
other options?

I think the main problem is that the shared data field is not working,
making it harder to know which blocks are only used in a given snapshot.


subvol                                          group         total    unshared  
------------------------------------------------------------------------------- 
backup/debian32                                 0/262       403.84G      -5.46G  
backup/debian32_daily_20140504_00:03:01         0/3660      446.45G       0.00G  
backup/debian32_daily_20140505_00:03:01         0/3687      431.11G       0.00G  
backup/debian32_daily_20140506_00:03:00         0/3705      420.83G       0.00G  
backup/debian32_daily_20140507_00:03:01         0/3724      411.87G       0.00G  
backup/debian32_weekly_20140504_00:04:01        0/3675      446.45G       0.00G  

backup/debian64                                 0/263       855.97G      -1.50G  
backup/debian64_daily_20140504_00:03:01         0/3662      860.19G       0.00G  
backup/debian64_daily_20140505_00:03:01         0/3690      859.32G       0.00G  
backup/debian64_daily_20140506_00:03:00         0/3707      858.15G       0.00G  
backup/debian64_daily_20140507_00:03:01         0/3726      857.47G       0.00G  
backup/debian64_weekly_20140504_00:04:01        0/3676      860.19G       0.00G  

backup/ubuntu                                   0/264       360.28G       0.00G  
backup/ubuntu_daily_20140504_00:03:01           0/3664      364.53G       0.00G  
backup/ubuntu_daily_20140505_00:03:01           0/3692      362.44G       0.00G  
backup/ubuntu_daily_20140506_00:03:00           0/3709      360.91G       0.00G  
backup/ubuntu_daily_20140507_00:03:01           0/3727      360.33G       0.00G  
backup/ubuntu_weekly_20140504_00:04:01          0/3677      364.53G       0.00G  


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

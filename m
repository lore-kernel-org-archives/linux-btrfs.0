Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:47257 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaEHLsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 07:48:05 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 62073445350
	for <linux-btrfs@vger.kernel.org>; Thu,  8 May 2014 13:48:02 +0200 (CEST)
Received: from s9 (unknown [88.214.162.134])
	by mail.virtall.com (Postfix) with ESMTPSA id EE54044533A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 May 2014 13:48:01 +0200 (CEST)
Date: Thu, 8 May 2014 12:47:58 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Balance performance problem with 3.14.1
Message-ID: <20140508124758.2085f89e@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I canceled the balance after 
> about 5 days when it had been claiming to be about 65% done for a day
> while doing a lot of disk IO.

I can see similar behaviour with 3.14.2 - after 4 days, it's only 25% done:

root      8382  2.1  0.0  17840   628 pts/1    D+   May04 124:12      \_ btrfs balance start /mnt/lxc1 -v

# btrfs balance status /mnt/lxc1
Balance on '/mnt/lxc1' is running
611 out of about 2492 chunks balanced (612 considered),  75% left


The reason I'm running balance here is that 3.15-rc* had the filesystem hanging for me when doing rsync
(and sometimes hanging during snapshotting), so I've downgraded to 3.14.2 (no hanging so far).


-- 
Tomasz Chmielewski
http://wpkg.org

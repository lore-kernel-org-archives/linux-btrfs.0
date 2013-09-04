Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50857 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3IDF1q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 01:27:46 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should btrfs fi balance take?
Date: Wed, 4 Sep 2013 15:27:42 +1000
Cc: linux-btrfs@vger.kernel.org
References: <201309031821.35507.russell@coker.com.au> <pan$2cffb$e1ffc74d$ec98967$4c4556a7@cox.net>
In-Reply-To: <pan$2cffb$e1ffc74d$ec98967$4c4556a7@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201309041527.42347.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 4 Sep 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> But either way, seven hours for about a hundred gig on what should be a 
> reasonably fast SSD, yes, there's definitely something wrong.  I'd reboot 
> and see if the balance completes then and/or if you can run a balance in 
> reasonable time after the reboot.

Thanks for the suggestion.  I rebooted and then ran a balance again which 
completed in 8 minutes.

Then I attempted another balance without rebooting and it hung again.  Maybe a 
balance after the cron job had created a new snapshot causes the problem.  
I'll have to reboot and try it again.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

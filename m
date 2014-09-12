Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60588 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751469AbaILG10 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 02:27:26 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:54694 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XSKKL-002jbn-HV
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 00:27:25 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: how long should "btrfs device delete missing ..."  take?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1efa888d-1695-4ad0-8e04-f6b2fe87314e@email.android.com>
Date: Fri, 12 Sep 2014 00:27:24 -0600
Message-Id: <0AB58DC8-B433-4614-BE51-146D31DDB6D9@colorremedies.com>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com> <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net> <4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com> <pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net> <6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com> <1efa888d-1695-4ad0-8e04-f6b2fe87314e@email.android.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 11, 2014, at 11:19 PM, Russell Coker <russell@coker.com.au> wrote:

> It would be nice if a file system mounted ro counted as ro snapshots for btrfs send.
> 
> When a file system is so messed up it can't be mounted rw it should be regarded as ro for all operations.

Yes it's come up before, and there's a question whether mount -o ro is reliably ro enough for this. Maybe a force option?

But then another one is a recursive btrfs send to go along with the above. I might want them all, or I might want all of the ones in two particular subvolumes, etc. And even combine the recursive ro snapshot and recursive send as a btrfs rescue option that would work even if the volume is mounted read-only.


Chris Murphy
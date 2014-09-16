Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43110 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753916AbaIPBTy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 21:19:54 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49357 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XThQv-000n6y-CJ
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 19:19:53 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs balance enospc
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
Date: Mon, 15 Sep 2014 19:19:52 -0600
Message-Id: <21267DAB-22F6-458E-A0F7-7EAEE6471335@colorremedies.com>
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune> <541723EA.6010608@intellasoft.net> <657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com> <pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 15, 2014, at 6:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Assuming such a conversion, did you delete the subvolume containing the 
> original ext* yet, or not?  If not, that may be the problem, because that 
> subvolume must be left intact in ordered to allow rollback to ext* if 
> desired.  If you know you won't be rolling back, delete the ext* reserved 
> subvolume as described on the wiki.

Good catch, I always forget this.


Chris Murphy


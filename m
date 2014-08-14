Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52936 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752200AbaHNCGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 22:06:08 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:60490 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XHkQZ-003iM3-6V
	for linux-btrfs@vger.kernel.org; Wed, 13 Aug 2014 20:06:07 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: delete missing /dev/sdd which is now added as /dev/sdd1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$d18a1$d124172b$7cfbfa6b$9072ec25@cox.net>
Date: Wed, 13 Aug 2014 20:06:04 -0600
Message-Id: <C14B310E-5F2B-4762-884B-AA11108373D3@colorremedies.com>
References: <53EAF935.4040605@rasmusa.net> <20140813145155.GA20611@merlins.org> <1407944166.3763056.152323965.0FFD88B6@webmail.messagingengine.com> <pan$d18a1$d124172b$7cfbfa6b$9072ec25@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 13, 2014, at 5:19 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> 2) Wait for the patch to make it into kernel 3.17 and go from there.

Based on integration right now it looks like a lot of stuff.


> 3) Go read the list and find and cherrypick that patch, then rebuild with
> it included, and go from there.

Could be this one:
http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/patch/?id=0c414ebcd5ba515b58249099619a5d9dbcc1a3b8


Chris Murphy


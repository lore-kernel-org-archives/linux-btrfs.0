Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47161 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbaFFAYh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 20:24:37 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49620 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WshxV-004D8H-3F
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 18:24:37 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Using BTRFS on SSD now ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <yq14mzyzz6l.fsf@sermon.lab.mkp.net>
Date: Thu, 5 Jun 2014 18:24:35 -0600
Message-Id: <7465EECE-652F-4B18-B149-D761DE19CCEB@colorremedies.com>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org> <FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com> <20140605190526.GS7210@merlins.org> <pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net> <yq14mzyzz6l.fsf@sermon.lab.mkp.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 5, 2014, at 5:58 PM, "Martin K. Petersen" <martin.petersen@oracle.com> wrote:
> 
> Queued trim has started to appear in consumer SSDs. However, since we're
> the only OS that supports it the feature has come off to a bumpy start.
> We tried to enable it on a drive model that passed testing here but we
> had to revert to unqueued when bug reports started rolling in this week.

There's a RHBZ I ran across ~6 months ago with a purportedly SATA rev 3.1 SSD, (m?)SATA, and queued trim caused some big enough of a problem that the model is black listed for queued trim. I don't remember if it was massive fs corruption or if it bricked the drive or what. So yeah they're rare enough that it's like, OK we're sorta starting over from scratch.

Chris Murphy
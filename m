Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51646 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753786AbaCNDjE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 23:39:04 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:61142 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WOIxb-003Vua-EP
	for linux-btrfs@vger.kernel.org; Thu, 13 Mar 2014 21:39:03 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: discard synchronous on most SSDs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140314021159.GQ18959@merlins.org>
Date: Thu, 13 Mar 2014 21:39:02 -0600
Message-Id: <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <3438733.p6vCjojJlH@merkaba> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 13, 2014, at 8:11 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
>> discard is, except on the very latest hardware, a synchronous command
>> (it's a limitation of the SATA standard), and therefore results in
>> very very poor performance.
> 
> Interesting. How do I know if a given SSD will hang on discard?
> Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)

smartctl -a or -x will tell you what SATA revision is in place. The queued trim support is in SATA Rev 3.1. I'm not certain if this requires only the drive to support that revision level, or both controller and drive.

Chris Murphy
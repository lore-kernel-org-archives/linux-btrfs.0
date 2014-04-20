Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33896 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750959AbaDTVEO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 17:04:14 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:63196 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WbyuL-00181T-Pv
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 15:04:13 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size Drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
Date: Sun, 20 Apr 2014 15:04:12 -0600
Message-Id: <71117784-D7D7-47CF-AB40-C42F860EA17E@colorremedies.com>
References: <53540367.4050707@aeb.io> <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 2:54 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> Ergo, there is no such thing as single device raid0, so the point at which all but 1 drive is full, writes fail.

Correction. Data writes fail. Metadata writes apparently still succeed, as zero length files are created. I now have several hundred such files. But no implosion, and the file system continues to work.

-rwxr-x---. 1 root root      0 Apr 20 15:01 IMG_3328.dng

I suppose this has pros and cons.


Chris Murphy


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46956 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752355AbaIKVZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 17:25:54 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52597 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XSBsG-002bbC-LJ
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 15:25:52 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: how long should "btrfs device delete missing ..."  take?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
Date: Thu, 11 Sep 2014 15:25:51 -0600
Message-Id: <4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com> <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 11, 2014, at 1:31 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> I wouldn't try defragging now, but it might be worthwhile to stop the
> device delete (rebooting to do so since I don't think there's a cancel)

'btrfs replace cancel' does exist, although I haven't tried it.

Something isn't right though, because it's clearly neither reading nor writing at anywhere close to 1/2 the drive read throughput. I'm curious what 'iotop -d30 -o' shows (during the replace, before cancel), which should be pretty consistent by averaging 30 seconds worth of io. And then try 'iotop -d3 -o' and see if there are spikes. I'm willing to bet there's a lot of nothing going on, with occasional spikes, rather than a constant trickle. 

And then the question is to find out what btrfs is thinking about while nothing is reading or writing. Even though it's not 5000+ snapshots, I wonder if the balance code (and hence btrfs replace) makes extensive use of fiemap that's causing this to go catatonic. http://comments.gmane.org/gmane.comp.file-systems.btrfs/35724

Chris Murphy


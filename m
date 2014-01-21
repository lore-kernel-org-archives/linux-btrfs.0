Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44797 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755115AbaAURiH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 12:38:07 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:62920 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W5fH3-004Kfk-Dw
	for linux-btrfs@vger.kernel.org; Tue, 21 Jan 2014 10:38:05 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Scrubbing with BTRFS Raid 5
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52DEABC9.2040205@jrs-s.net>
Date: Tue, 21 Jan 2014 10:38:07 -0700
Message-Id: <D97DCF6D-6057-41FC-95B7-AC4127F51B16@colorremedies.com>
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com> <pan$226f4$e1329373$53c2dcca$438e95e@cox.net> <52DEABC9.2040205@jrs-s.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 21, 2014, at 10:18 AM, Jim Salter <jim@jrs-s.net> wrote:

> Would it be reasonably accurate to say "btrfs' RAID5 implementation is likely working well enough and safe enough if you are backing up regularly and are willing and able to restore from backup if necessary if a device failure goes horribly wrong", then?

It's for testing purposes. If you really want to commit a production machine for testing a file system, and you're prepared to lose 100% of changes since the last backup, OK do that.

> If the worst thing wrong with RAID5/6 in current btrfs is "might not deal as well as you'd like with a really nasty example of single-drive failure", that would likely be livable for me.

It was just one hypothetical scenario, it's not the only one. If it's really truly seriously being tested, eventually you'll break it.

Chris Murphy
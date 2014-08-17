Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36288 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652AbaHQVRg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 17:17:36 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:60972 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XJ7pX-001j97-BC
	for linux-btrfs@vger.kernel.org; Sun, 17 Aug 2014 15:17:35 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Ideas for a feature implementation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53EB4581.8050104@chrestomanci.org>
Date: Sun, 17 Aug 2014 15:17:35 -0600
Message-Id: <6F8832C7-D1D2-4D73-A304-6FAC6C4C54C9@colorremedies.com>
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E9F3D6.9040502@gmail.com> <53EB4581.8050104@chrestomanci.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 13, 2014, at 5:01 AM, David Pottage <david@chrestomanci.org> wrote:

> At present, you can write RAID 5 or 6 data, but if anything goes wrong, btrfs cannot use the parity information to help you get your data back, so in general you are better off with RAID 1 or 10.

Btrfs RAID5/6 normally mounted will reconstruct data from parity if there's a data checksum mismatch indicating data block(s) are corrupt. It'll also reconstruct from parity in the case of degraded mounts, and when doing a balance. What's missing is scrub.


> Also, I don't think I/O done in parallel so you get no speed advantage from having multiple discs either.

Hmm I thought that was just single and raid1?


Chris Murphy
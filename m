Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59823 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754682AbaHKU1w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 16:27:52 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49200 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XGwC7-001dlt-U4
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 14:27:51 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Ideas for a feature implementation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53E83035.8010603@gmail.com>
Date: Mon, 11 Aug 2014 14:27:51 -0600
Message-Id: <678801E6-E1C8-42B5-8D50-C59B68549EC4@colorremedies.com>
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 10, 2014, at 8:53 PM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> 
> Another thing that isn't listed there, that I would personally love to
> see is support for secure file deletion.  To be truly secure though,
> this would need to hook into the COW logic so that files marked for
> secure deletion can't be reflinked (maybe make the automatically NOCOW
> instead, and don't allow snapshots?), and when they get written to, the
> blocks that get COW'ed have the old block overwritten.

If the file is reflinked or snapshot, then it can it be secure deleted? Because what does it mean to secure delete a file when there's a completely independent file pointing to the same physical blocks? What if someone else owns that independent file? Does the reflink copy get rm'd as well? Or does the file remain, but its blocks are zero'd/corrupted?

For SSDs, whether it's an overwrite or an FITRIM ioctl it's an open question when the data is actually irretrievable. It may be seconds, but could be much longer (hours?) so I'm not sure if it's useful. On HDD's using SMR it's not necessarily a given an overwrite will work there either.


Chris Murphy
Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41895 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755742AbcH1SAI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 14:00:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1be47n-0000uF-PO
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 19:44:03 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfstune settings
Date: Sun, 28 Aug 2016 19:41:46 +0200
Message-ID: <20160828194146.7349d29a@jupiter.sol.kaishome.de>
References: <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
        <df5ff0e5-f07b-72ca-f49f-e9cf2e2c6e39@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 28 Aug 2016 18:18:52 +0200
schrieb Oliver Freyermuth <o.freyermuth@googlemail.com>:

> That would certainly be the best option, however, 
> I have two issues with that: 
> - Any replay of a backup will do a lot of writes on the SSD, 
>   reducing lifetime. 

I'm using bcache in front of my harddisks (writeback mode) to get
almost-SSD performance. That way, when I restore, I can simply switch
to writearound mode, restore, then switch back to writeback mode.

But in the long term, writeback mode will be extremely heavy on SSD
wearing when the bcache is small because it will have to evict a lot of
data from the cache. I'm using 500GB bcache for 3x 1TB harddisk. 500GB
is more than my usual working set so bcache almost never has to evict
data from the cache.

-- 
Regards,
Kai

Replies to list-only preferred.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935171AbcIGOys (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Sep 2016 10:54:48 -0400
Date: Wed, 7 Sep 2016 16:53:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v12.2 01/15] btrfs: expand btrfs_set_extent_delalloc()
 and its friends to support in-band dedupe and subpage size patchset
Message-ID: <20160907145314.GJ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160719085050.30564-1-quwenruo@cn.fujitsu.com>
 <20160719085050.30564-2-quwenruo@cn.fujitsu.com>
 <6094f5c2-67ae-a58d-2215-77291532b5f0@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6094f5c2-67ae-a58d-2215-77291532b5f0@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 09, 2016 at 09:19:08AM +0800, Qu Wenruo wrote:
> Hi David and Chandan,
> 
> I see the expansion of cow_file_range() function got merged into 4.8 
> window, while this patch is still not merged yet, is there anything 
> wrong with this patch?

Now added to the 4.9 queue, sorry for the delay.

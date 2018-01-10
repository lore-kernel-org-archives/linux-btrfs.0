Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932956AbeAJPd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:33:28 -0500
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
 <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d9ab30af-0b3a-7021-876c-5e545b417d40@suse.com>
Date: Wed, 10 Jan 2018 17:33:25 +0200
MIME-Version: 1.0
In-Reply-To: <b9da1d4e-f32c-d923-1e9c-243f753ffa20@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.01.2018 03:30, Qu Wenruo wrote:
> That system chunk can be relocated by balance, and in that case new
> chunk may start beyond 1M.
> 
> So the most reliable method would be manually checking the the first
> device extent of this device, and to determine if we should minus that 1M.
> 
> If the first device extent starts beyond 1M, reducing 1M would be good.
> Or don't modify it.

So assuming I run generic/015 on a system with your mkfs patches to put
system chunk after 1mb and I implement a logic in
btrfs_calc_avail_data_space to subtract 1mb if the first extent of a
device starts at 1mb. In that case the test is still going to fail i.e
have the discrepancy of 1mb due to 1mb being subtracted first due to
there being unallocated space on the device, but then on the second df
btrfs_calc_avail_data_space will return 0 so df is going to report space
only from the block groups.


Thinking a bit more I think with your mkfs.btrfs patch there is no need
to check where the device extent starts, since now we are guaranteed to
always have a hole of at least 1mb at the beginning.

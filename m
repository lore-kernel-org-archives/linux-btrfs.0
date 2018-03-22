Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754943AbeCVNHG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:07:06 -0400
Subject: Re: [PATCH] btrfs-progs: wipe all copies of the stale superblock
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180321101920.9004-1-anand.jain@oracle.com>
 <e16124c3-7f57-6a2f-f760-5164f7c10ad1@suse.com>
 <d2fbba43-dff3-3909-a794-69c4a8ed4ace@oracle.com>
 <cb036707-14b7-578a-2051-56768a729771@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <16a28a3b-7850-8a87-4649-c24aadb2600b@oracle.com>
Date: Thu, 22 Mar 2018 21:08:54 +0800
MIME-Version: 1.0
In-Reply-To: <cb036707-14b7-578a-2051-56768a729771@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> So I misread the code in the beginning, so the actual btrfs SB are being
> wiped out by the for loop which calls zer_dev_clamped. And in there all
> superblocks between  0 - block_count are zeored. And block_count is
> actual physical size of the device, right. And this value can further be
> limited by the max_block_count being passed, which in mkfs case is
> what's passed to -b.
> 
> So instead of adding more code, why not just call zero_dev_clamped with
> the return value of btrfs_device_size rather than the possibly clamped
> one block_count? That you always unconditionally will be sure to zero
> out all the sb which are on the device, irrespective of the size of the
> fs? Something like :

Hm. Actually I didn't want to zero unless I find a valid SB at the 
copy#2. I was kind of wanted suggestions if there is something that I am 
missing if I write beyond the -b <blockcount>. I don't find anything 
wrong though. I look at it as a kind of wipeall.

Thanks, Anand

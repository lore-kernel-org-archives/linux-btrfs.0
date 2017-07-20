Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59205 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933027AbdGTJkQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:40:16 -0400
Subject: Re: [PATCH] btrfs-progs: Use '-t btrfs' mount option in tests.
To: dsterba@suse.cz, Adam Buchbinder <abuchbinder@google.com>,
        linux-btrfs@vger.kernel.org
References: <20170712200522.18830-1-abuchbinder@google.com>
 <20170712215259.GL2866@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <70c530f5-24fa-c2ff-6aa1-a3f9e7963e47@gmx.com>
Date: Thu, 20 Jul 2017 17:40:00 +0800
MIME-Version: 1.0
In-Reply-To: <20170712215259.GL2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月13日 05:52, David Sterba wrote:
> On Wed, Jul 12, 2017 at 01:05:22PM -0700, Adam Buchbinder wrote:
>> Without it, mount (at least from util-linux 2.20.1) tries (and
>> fails) to mount some filesystems as NTFS.
>>
>> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> 
> Applied, thanks.

This patch will break convert self test.

Convert test will try to mount ext* filesystem and re-check its content.

So I'm afraid it's not suitable for test cases.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

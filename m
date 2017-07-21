Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:32805 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754504AbdGUPQ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 11:16:27 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: Adam Borowski <kilobyte@angband.pl>
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170721144922.2zriwspqixh7yt3l@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <2574118e-ac4d-9788-cf8f-f633d46cfd88@mendix.com>
Date: Fri, 21 Jul 2017 17:16:25 +0200
MIME-Version: 1.0
In-Reply-To: <20170721144922.2zriwspqixh7yt3l@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/2017 04:49 PM, Adam Borowski wrote:
> On Fri, Jul 21, 2017 at 01:47:11PM +0200, Hans van Kranenburg wrote:
>> The changes in here do the following:
>>
>> 1. Throw out the current ssd_spread behaviour.
>> 2. Move the current ssd behaviour to the ssd_spread option.
>> 3. Make ssd mode data allocation identical to tetris mode, like nossd.
>> 4. Adjust and clean up filesystem mount messages so that we can easily
>> identify if a kernel has this patch applied or not, when providing
>> support to end users.
> 
>> Notes for whoever wants to backport this patch on their 4.9 LTS kernel:
>> * First apply commit 8a83665a "btrfs: drop the nossd flag when
>>   remounting with -o ssd", or fixup the differences manually.
> 
> It's 951e7966 in mainline.  I see no 8a83665a anywhere -- most likely it's
> what you got after cherry-picking to 4.9.

Yes, that's exactly where it went wrong, thanks.

-- 
Hans van Kranenburg

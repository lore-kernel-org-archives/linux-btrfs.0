Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33289 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdGMMMR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 08:12:17 -0400
Received: by mail-it0-f67.google.com with SMTP id 188so6833125itx.0
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 05:12:17 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
To: Adam Borowski <kilobyte@angband.pl>, dsterba@suse.cz,
        Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
 <20170710211150.7210ac36@fire> <20170713005010.GA2866@twin.jikos.cz>
 <20170713010949.jyt24oebfwjngmcz@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4b993f48-a52e-cda4-fb20-9906aabbc77d@gmail.com>
Date: Thu, 13 Jul 2017 08:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <20170713010949.jyt24oebfwjngmcz@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-12 21:09, Adam Borowski wrote:
> On Thu, Jul 13, 2017 at 02:50:10AM +0200, David Sterba wrote:
>> On Mon, Jul 10, 2017 at 09:11:50PM +0300, Dmitrii Tcvetkov wrote:
>>> Tested on top of current mainline master (commit
>>> af3c8d98508d37541d4bf57f13a984a7f73a328c). Didn't find any
>>> regressions.
> 
> I've retested this yet again.  No regressions as well.
Same here, including checking on a number of MIPS, PPC, and ARM variants 
in QEMU.
> 
>> Thanks for testing.
>>
>> If anybody wants to get their Tested-by in the patches, please let me
>> know, I'll add the tags (can be done until rc6). Your efforts are
>> appreciated so you get the credit in the undying history log of linux
>> kernel.
> 
> Heh.  Let's not play such games but finally get this patch set in, it's by
> far the biggest problem for multi-device.
Agreed, this should have gone in back when the first version was posted...

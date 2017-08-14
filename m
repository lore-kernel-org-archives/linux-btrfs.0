Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64969 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753193AbdHNNRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:17:17 -0400
Subject: Re: btrfs-progs-v4.12: cross compiling
To: dsterba@suse.cz, Hallo32 <Hallo32@gmx.net>, linux-btrfs@vger.kernel.org
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
Date: Mon, 14 Aug 2017 21:17:08 +0800
MIME-Version: 1.0
In-Reply-To: <20170814130608.GS2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月14日 21:06, David Sterba wrote:
> On Mon, Aug 14, 2017 at 02:17:26PM +0200, Hallo32 wrote:
>> Since versions 4.12 btrfs-progs is complicated to cross compile for
>> other systems.
>> The problem is, that this version includes mktables, which needs to be
>> compiled for the host system and executed there for the creation of
>> tables.c.
>>
>> Are there any changes planed for the next version of btrfs-progs to make
>> the cross compiling as simple as in the past? A included tables.c for
>> example?
> 
> Yes, keeping the generated tables.c around is fine. There's no reason it
> needs to be generated each time during build. I'll fix that in 4.12.1.

But the number of lines and impossibility to review it makes it not 
suitable to be managed by git.

What about using script to generate it?

Thanks,
Qu

> Thanks for the report, cross-compilation should stay supported.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

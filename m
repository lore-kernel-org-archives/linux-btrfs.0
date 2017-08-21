Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51736 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750985AbdHUDbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 23:31:41 -0400
Subject: Re: BTRFS warning (device dm-0): unhandled fiemap cache detected
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1503282544.4669.10.camel@scientia.net>
 <d0d41a1e-7191-4c46-78a1-615dbcfe71c0@gmx.com>
 <1503286064.4669.12.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ff53b205-4bdd-a360-91d7-068b65b23dad@gmx.com>
Date: Mon, 21 Aug 2017 11:31:34 +0800
MIME-Version: 1.0
In-Reply-To: <1503286064.4669.12.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月21日 11:27, Christoph Anton Mitterer wrote:
> On Mon, 2017-08-21 at 10:43 +0800, Qu Wenruo wrote:
>> Harmless, it is only designed to merge fiemap output.
> Thanks for the info :)
> 
> 
> On Mon, 2017-08-21 at 10:57 +0800, Qu Wenruo wrote:
>> Quite strange, according to upstream git log, that commit is merged
>> between v4.12-rc7 and v4.12.
>> Maybe I misunderstand the stable kernel release cycle.
> 
> Seems it was only added in 4.12.7? Maybe a typo?

I'm talking about upstream, which is managed by Linus.
The 4.12.x is managed by maintainers of stable releases.

In Linus repo, the commit is between v4.12 and v4.12-rc7 tag.
Maybe v4.12.x is started before v4.12 release.

Thanks,
Qu

> 
> Cheers,
> Chris.
> 

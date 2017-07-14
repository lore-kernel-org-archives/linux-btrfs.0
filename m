Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16883 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdGNGPk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:15:40 -0400
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Jeffrey Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
 <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f88fe43a-6368-d017-5a8a-5513d6d47ace@oracle.com>
Date: Fri, 14 Jul 2017 14:22:14 +0800
MIME-Version: 1.0
In-Reply-To: <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/13/2017 09:58 PM, Holger Hoffstätte wrote:
> On 07/13/17 15:25, Jeffrey Mahoney wrote:
>> On 7/13/17 12:16 AM, Anand Jain wrote:
>>> As users generally organize the subvols and snapshots based on the subvol
>>> directory hierarchy. So providing an ability to sort them by topid would
>>> help. Thanks.
>>
>> What is a topid?  I needed to look at the code to discover this and it's
>> not even documented as part of the root_info structure.  Users are going
>> to have no idea what this means.
> 
> The idea seems similar to my attempt to add listing of toplevel-only
> (i.e. non-snapshot) subvolumes, which can be found here:

  No. Actually my idea wasn't about the eliminating the snapshots from
  the list. But to show in the order that user has organized their subvol
  and snapshots.

Thanks, Anand


> https://github.com/hhoffstaette/btrfs-progs/commit/f0a065e02b
> 
> I ended up not submitting it since nobody seemed interested at the time
> and I could work around it for my own purposes by filtering manually on
> parent uuid (more precisely the lack thereof).
> 
> cheers
> Holger
> 

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19525 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdGNGU4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 02:20:56 -0400
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
To: Jeffrey Mahoney <jeffm@suse.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
 <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
 <15530c86-cfa7-79c9-1606-1687c5fc0e3b@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <38602766-7ef7-d042-37da-338c9e511169@oracle.com>
Date: Fri, 14 Jul 2017 14:26:48 +0800
MIME-Version: 1.0
In-Reply-To: <15530c86-cfa7-79c9-1606-1687c5fc0e3b@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/13/2017 10:27 PM, Jeffrey Mahoney wrote:
> On 7/13/17 9:58 AM, Holger Hoffstätte wrote:
>> On 07/13/17 15:25, Jeffrey Mahoney wrote:
>>> On 7/13/17 12:16 AM, Anand Jain wrote:
>>>> As users generally organize the subvols and snapshots based on the subvol
>>>> directory hierarchy. So providing an ability to sort them by topid would
>>>> help. Thanks.
>>>
>>> What is a topid?  I needed to look at the code to discover this and it's
>>> not even documented as part of the root_info structure.  Users are going
>>> to have no idea what this means.
>>
>> The idea seems similar to my attempt to add listing of toplevel-only
>> (i.e. non-snapshot) subvolumes, which can be found here:
>>
>> https://github.com/hhoffstaette/btrfs-progs/commit/f0a065e02b
>>
>> I ended up not submitting it since nobody seemed interested at the time
>> and I could work around it for my own purposes by filtering manually on
>> parent uuid (more precisely the lack thereof).
> 
> I'm not debating the utility of the idea -- just that it is a completely
> opaque name for someone not already familiar with the internals. 

  Topid is the rootid one level up where the subvol belongs.
  It tells the user which subvol should be mounted to access
  a given subvol (in case if subvolid=5 is not mounted), by listing
  topid it closely matches with the way user has organized their
  subvols and snapshot.


> One of
> the biggest complaints I hear consistently about using btrfs is that the
> UI is difficult to use.  It's on my team's TODO list to fix some of
> this, but part of that is trying to make sure that new additions are
> easy to use.

  Thanks for doing this.

> This patch uses an abbreviation that's used nowhere outside of the code
> and offers no documentation for it.  That's what my issue is.

  Topid is already used in the table .. so we can't rename it now.
  But we can certainly add its info somewhere, man page ? But that's
  outside of this patch.

Thanks, Anand


> -Jeff
> 

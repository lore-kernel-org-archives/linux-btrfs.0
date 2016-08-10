Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:34711 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938629AbcHJTOm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 15:14:42 -0400
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <1c409a92-978d-a37a-75ae-8ff2e84f5674@techsquare.com>
To: Matt McKinnon <matt@techsquare.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: g6094199@freenet.de
Message-ID: <cf494b45-6d2e-18a8-b579-17f14b586598@chefmail.de>
Date: Wed, 10 Aug 2016 09:09:30 +0200
MIME-Version: 1.0
In-Reply-To: <1c409a92-978d-a37a-75ae-8ff2e84f5674@techsquare.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

from what i see you have a non finished balance ongoing, since you have
system and metadata DUP and single information on disk.

so you should (re)run a balance for this data.


sash


Am 10.08.2016 um 02:17 schrieb Matt McKinnon:
> -o usebackuproot worked well.
>
> after the file system settled, performing a sync and a clean umount, a
> normal mount works now as well.
>
> Anything I should be doing going forward?
>
> Thanks,
> Matt
>
> On 08/09/2016 08:01 PM, Chris Murphy wrote:
>> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com>
>> wrote:
>>> Hello,
>>>
>>> Our server recently crashed and was rebooted.  When it returned our
>>> BTRFS
>>> volume is mounting read-only:
>>
>> What happens when you try mounting with -o usebackuproot ?
>>
>> If that fails, what output do you get for 'btrfs check' (without
>> --repair)? If you only get some "errors 400, nbytes wrong" then
>> --repair should fix the problem.
>>
>>
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



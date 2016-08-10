Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:54849 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932452AbcHJART (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 20:17:19 -0400
To: Chris Murphy <lists@colorremedies.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <1c409a92-978d-a37a-75ae-8ff2e84f5674@techsquare.com>
Date: Tue, 9 Aug 2016 20:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-o usebackuproot worked well.

after the file system settled, performing a sync and a clean umount, a 
normal mount works now as well.

Anything I should be doing going forward?

Thanks,
Matt

On 08/09/2016 08:01 PM, Chris Murphy wrote:
> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com> wrote:
>> Hello,
>>
>> Our server recently crashed and was rebooted.  When it returned our BTRFS
>> volume is mounting read-only:
>
> What happens when you try mounting with -o usebackuproot ?
>
> If that fails, what output do you get for 'btrfs check' (without
> --repair)? If you only get some "errors 400, nbytes wrong" then
> --repair should fix the problem.
>
>
>

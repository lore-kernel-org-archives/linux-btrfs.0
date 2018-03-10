Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40121 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbeCJMN3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 07:13:29 -0500
Subject: Re: Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs
To: Martin Svec <martin.svec@zoner.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5a54af49-c18f-3534-7d58-5224363926c7@zoner.cz>
 <3622d05f-b31e-6f3d-a70c-d32c4667ef43@suse.com>
 <7ce06292-6598-2b97-11a3-93174ec597bc@zoner.cz>
 <8b2db87a-681f-d8b5-8b1b-f67ec9ff6917@zoner.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9f72fe11-69d4-140e-7895-5cf44ccc526f@suse.com>
Date: Sat, 10 Mar 2018 14:13:26 +0200
MIME-Version: 1.0
In-Reply-To: <8b2db87a-681f-d8b5-8b1b-f67ec9ff6917@zoner.cz>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



<snip>

>>> And then report back on the output of the extra debug 
>>> statements. 
>>>
>>> Your global rsv is essentially unused, this means 
>>> in the worst case the code should fallback to using the global rsv
>>> for satisfying the memory allocation for delayed refs. So we should
>>> figure out why this isn't' happening. 
>> Patch applied. Thank you very much, Nikolay. I'll let you know as soon as we hit ENOSPC again.
> 
> There is the output:
> 
> [24672.573075] BTRFS info (device sdb): space_info 4 has 18446744072971649024 free, is not full
> [24672.573077] BTRFS info (device sdb): space_info total=308163903488, used=304593289216, pinned=2321940480, reserved=174800896, may_use=1811644416, readonly=131072
> [24672.573079] use_block_rsv: Not using global blockrsv! Current blockrsv->type = 1 blockrsv->space_info = ffff999a57db7000 global_rsv->space_info = ffff999a57db7000
> [24672.573083] BTRFS: Transaction aborted (error -28)

Bummer, so you are indeed running out of global space reservations in
context which can't really use any other reservation type, thus the
ENOSPC. Was the stacktrace again during processing of running delayed refs?

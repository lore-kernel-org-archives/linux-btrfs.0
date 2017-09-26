Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:33196 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934183AbdIZIeO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:34:14 -0400
Subject: Re: btrfs scrub crashes OS
References: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
 <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
From: Lukas Pirl <btrfs@lukas-pirl.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <f01fc6f7-a0d4-dbae-b5fa-ea51842c4793@lukas-pirl.de>
Date: Tue, 26 Sep 2017 10:34:04 +0200
MIME-Version: 1.0
In-Reply-To: <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Qu,

thanks for your reply.

On 09/25/2017 12:19 PM, Qu Wenruo wrote as excerpted:
> Even no dmesg output using tty or netconsole?

And thanks for the pointer to netconsole, I tried that one.
No success. I set netconsole up, verified it worked, started a scrub,
the machine went away after a couple of hours, netconsole empty.

> That's strange.
> Normally it should be kernel BUG_ON() to cause such problem.
>  
> And if the system is still responsible (either from TTY or ssh), is
> there anything strange like tons of IO or CPU usage?

I can't tell, the machine just disappears from the network. Dead. IIRC,
it was also all dead when I sat in front of it.

> Btrfs-progs v4.13 should have fixed it.
> As long as v4.13 btrfs check reports no error, its metadata should be
> good.

I can try that one, if helpful.

> You could try the out-of-tree offline scrub to do a full scrub of your
> fs unmounted, so it won't crash your system (if nothing wrong happened)
> https://github.com/gujx2017/btrfs-progs/tree/offline_scrub

Did that, machine crashed again.

>>    MIXED_BACKREF, BIG_METADATA, EXTENDED_IREF, SKINNY_METADATA, NO_HOLES
> 
> Only NO_HOLES is not ordinary, but shouldn't cause a problem.

Would it be sensible to turn that feature off using `btrfstune` (if
possible at all)?

> Without kernel backtrace, it's tricky to locate the problem.
> So I would recommend to use netconsole (IIRC more reliable, as I use it
> on my test VM to capture the dying message) or TTY output to verify
> there is no kernel message/backtrace.

Yeah I see we are in a tricky situation here.

I will try to scrub with autodefrag and compression deactivated.

Could a full balance be of any help? At least to find out if it crashes
the machine as well?

Cheers,

Lukas

> Thanks,
> Qu
> 
>>    no quotas in use
>>    see also https://pastebin.com/4me6zDsN for more details
>> btrfs-progs v4.12
>> GNU/Linux 4.12.0-0.bpo.1-amd64 #1 SMP Debian 4.12.6-1~bpo9+1 x86_64
>>
>> The question, obviously, is how can I make this fs "scrubable" again?
>> Are the errors found by btrfsck safe to repair using btrfsck or some
>> other tool?
>>
>> Thank you so much in advance,
>>
>> Lukas
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


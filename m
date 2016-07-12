Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38213 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbcGLNr6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 09:47:58 -0400
Received: by mail-wm0-f52.google.com with SMTP id o80so26139368wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 06:47:56 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Add ratelimiting to printing facility
To: dsterba@suse.cz, jbacik@fb.com, clm@fb.com, operations@siteground.com,
        linux-btrfs@vger.kernel.org
References: <1468326012-15910-1-git-send-email-kernel@kyup.com>
 <20160712132044.GC10595@suse.cz>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <5784F509.8040200@kyup.com>
Date: Tue, 12 Jul 2016 16:47:53 +0300
MIME-Version: 1.0
In-Reply-To: <20160712132044.GC10595@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2016 04:20 PM, David Sterba wrote:
> On Tue, Jul 12, 2016 at 03:20:12PM +0300, Nikolay Borisov wrote:
>> Currently the btrfs printk infrastructure doesn't implement any
>> kind of ratelimiting.
> 
> If you count the whole infrastructure, it does. See ctree.h and macros
> ending with _rl (btrfs_err_rl), and should be used where the messages
> are likely to flood. Otherwise I think "more is better" regarding
> messages as this is helpful when debugging issues.

So I definitely didn't look at those. But now I have and it seems they
implement more or less the same thing. Also, if I'm reading the code
correctly, as it stands now using the _rl versions seem to be more
flexible as the limits is going to be per-message rather than
per-message class as it is in my proposal. So I'd rather move that
particular csum related message to the _rl infrastructure.

> 
>> Recently I came accross a case where due to
>> FS corruption an excessive amount of printk caused the softlockup
>> detector to trigger and reset the server. This patch aims to avoid
>> two types of issue: 
>>  * I want to avoid different levels of messages interefere with the
>>  ratelimiting of oneanother so as to avoid a situation where a 
>>  flood of INFO messages causes the ratelimit to trigger, 
>>  potentially leading to supression of more important messages. 
> 
> Yeah, that's my concern as well. What if there's a burst of several
> error messages that do not fit to the limit and some of them get
> dropped.
> 
>>  * Avoid a flood of any type of messages rendering the machine 
>>  unusable
> 
> While I'd rather set a per-message ratelimiting, it's possible that an
> unexpected error will start flooding. So some sort of per-level limiting
> could be implemented, as you propose, but I'd suggest to set the numbers
> higher. That way it would still flood up to certain level but should
> avoid the lockups.

Sure, I'm happy to set the limits higher and have it act as a safety
net. But then again, what would make a sensible limit - 100 messages in
5 seconds seems reasonable but this is completely arbitrary. Any thoughts?


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:48906 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbeGSWHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 18:07:04 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <pan$47c54$5df59e3d$ab971dce$aa203b1@cox.net>
 <20180718125017.GC21293@carfax.org.uk>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <f0f7e599-f824-0230-2be8-4621a090efce@dirtcellar.net>
Date: Thu, 19 Jul 2018 23:22:05 +0200
MIME-Version: 1.0
In-Reply-To: <20180718125017.GC21293@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hugo Mills wrote:
> On Wed, Jul 18, 2018 at 08:39:48AM +0000, Duncan wrote:
>> Duncan posted on Wed, 18 Jul 2018 07:20:09 +0000 as excerpted:
>>
>> Perhaps it's a case of coder's view (no code doing it that way, it's just
>> a coincidental oddity conditional on equal sizes), vs. sysadmin's view
>> (code or not, accidental or not, it's a reasonably accurate high-level
>> description of how it ends up working most of the time with equivalent
>> sized devices).)
> 
>     Well, it's an *accurate* observation. It's just not a particularly
> *useful* one. :)
> 
>     Hugo.
> 
A bit off topic perhaps - but I've got to give it a go:
Pretty please with sugar, nuts, a cherry and chocolate sprinkles dipped 
in syrup and coated with icecream on top , would it not be about time to 
update your online btrfs-usage calculator (which is insanely useful in 
so many ways) to support the new modes!?

In fact it would have been a great- / even better as a- cli-tool.
And yes, a while ago I toyed about porting it to C for own use mostly, 
but never got that far.


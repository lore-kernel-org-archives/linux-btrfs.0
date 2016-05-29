Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35106 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbcE2S35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 14:29:57 -0400
Received: by mail-oi0-f53.google.com with SMTP id w184so235562916oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 11:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r0nEFwj_rFzXTbyeCRNFc7bA3N7i7=nBze_67r+wO1J3w@mail.gmail.com>
References: <CAEtw4r2aknnz=+FCGq2ysSQT3K3ZHmZqnbPpyvr+C7QD6TyEAQ@mail.gmail.com>
	<CAGGqMYS_SLn9RY8Gtgf5nkwyXnOr57ehtYSH=HugiEeA8D_chw@mail.gmail.com>
	<CAEtw4r2mtxyz=_OfsgFSpGvUsYbdEqhOjOc-Dpvdd=aOwpeQ-Q@mail.gmail.com>
	<CAJCQCtTpnr6OLg=0pcovK8aYUAgPLDAsYv5sam9AzWSfOBzZcA@mail.gmail.com>
	<CAEtw4r0nEFwj_rFzXTbyeCRNFc7bA3N7i7=nBze_67r+wO1J3w@mail.gmail.com>
Date: Sun, 29 May 2016 12:29:56 -0600
Message-ID: <CAJCQCtRHEWNNSbD7NcHeiWWLPvvkpXuWJcukVJBf8RHd12gLVQ@mail.gmail.com>
Subject: Re: Resize doesnt work as expected
From: Chris Murphy <lists@colorremedies.com>
To: Peter Becker <floyd.net@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Alexander Fougner <fougner89@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 12:16 PM, Peter Becker <floyd.net@gmail.com> wrote:
> 2016-05-29 19:11 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>> On Sat, May 28, 2016 at 3:42 PM, Peter Becker <floyd.net@gmail.com> wrote:
>>> Thanks for the clarification. I've probably overlooked this.
>>>
>>> But should "resize max" does not do what you expect instead of falling
>>> back on an "invisible" 1?
>>
>> How does it know what the user expects?
>
> Then simply remove the default deviceid und let the user choise what the want.

They can already choose what they want, but they have to specify it,
it's not an interactive UI. Plus the shrink case has to be considered.

What it could do is state what happened rather than completing without
any message, i.e. if devid not specifed it would say something like:

devid 1 resized from X to X

At least there's feedback. It doesn't exactly make sense to require
the most common case, single device, to have to specify the single
device, hence why devid 1 is assumed.


> IMHO its a bad think to choise automaticly a option if its not clear
> what the user wants. And in spezial there is no hint in the output of
> the deviceid who is used.
> The output is:
>
> "Resize '/mnt' of 'max'" .. no hint the this only affect the deviceid
> 1. The suggestion for me is that the whole pool is resized to max.

That would mean the command affects all devid's at the same time. This
would require a lot more logic and safeguards for the shrink case. So
someone would need to do that work. I think such Ux improvements are
happening in a separate github thread on revising the btrfs-progs
UI/Ux.



>
> Possible solutions:
> 1. remove the default deviceid
> 2. resize without deviceid affects the whole pool
> 3. improve the output of the resize command by adding the deviceid
> 4. remove the inconsitent between add+remove and replace by triggering
> resize max after replace is finished.

1 negatively impacts single device setups.
2 doesn't account for shrink, where now every device is reduced by
some unknown amount and could end up a mess in some cases.
3 & 4 are reasonable

Right now the command is rather explicit with an exception for the
single device case. That's really what you're seeing here.


-- 
Chris Murphy

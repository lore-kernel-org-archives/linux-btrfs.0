Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:39323 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbaLWAIO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 19:08:14 -0500
Message-ID: <5498B26C.5010908@pobox.com>
Date: Mon, 22 Dec 2014 16:08:12 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Richard Sharpe <realrichardsharpe@gmail.com>
CC: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com>	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>	<5498829E.3060608@gmail.com>	<5498A0BD.3000300@pobox.com> <CACyXjPyVNGQLc6g4jGnDo=FM20qoyAfsk96zrkQfCYrjhOvMFg@mail.gmail.com>
In-Reply-To: <CACyXjPyVNGQLc6g4jGnDo=FM20qoyAfsk96zrkQfCYrjhOvMFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/22/2014 02:55 PM, Richard Sharpe wrote:
> On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote:
>> So skipping the full ADS, what's the current demand/payoff for large XATTR space?
>
> Windows Security Descriptors (sometimes incorrectly called ACLs)
> stored by Samba.

Ah.

I know that Linux ACLs are fairly small per entry, I take it Windows' 
can be much bigger?

Having just gone off an read a lot about the many ADS possible in 
windows, they've sort of treated ever file as if it were the name of a 
phantom directory limited depth... That is you seem to be able to create 
any name as a stream name but you can't create any pathname as same.

The system-level API -- that is the complete retooling of SYS_open et al 
-- and the requsite departure from POSIX -- seems unlikely.

On the antipode, it seems like being able to put an inode reference key 
type (e.g. a name,inode pair as one of the metadata entries) could 
relieve the space constraint for a limited number of entires. The 
contents of that inode's data region would become the value of the 
single attribute.

Does that relieve Security Descriptor burden? Is each descriptor a 
separate attribute or are all the descriptors held in one attribute as a 
list-of?

Going full "phantom directory" to match Windows just seems like we get 
into the business of replacing whole kernel tidbits a la the 
inner-system effect.





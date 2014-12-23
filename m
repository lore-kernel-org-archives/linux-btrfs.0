Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41959 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaLWBQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 20:16:17 -0500
Received: by mail-pd0-f179.google.com with SMTP id fp1so6861013pdb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 17:16:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5498B26C.5010908@pobox.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
	<5498829E.3060608@gmail.com>
	<5498A0BD.3000300@pobox.com>
	<CACyXjPyVNGQLc6g4jGnDo=FM20qoyAfsk96zrkQfCYrjhOvMFg@mail.gmail.com>
	<5498B26C.5010908@pobox.com>
Date: Mon, 22 Dec 2014 17:16:16 -0800
Message-ID: <CACyXjPxOcCrhXjg7mViHVeg7jjw4zesx52FafrBbB+KHvoJyQQ@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 4:08 PM, Robert White <rwhite@pobox.com> wrote:
>
> On 12/22/2014 02:55 PM, Richard Sharpe wrote:
>>
>> On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote:
>>>
>>> So skipping the full ADS, what's the current demand/payoff for large XATTR space?
>>
>>
>> Windows Security Descriptors (sometimes incorrectly called ACLs)
>> stored by Samba.
>
>
> Ah.
>
> I know that Linux ACLs are fairly small per entry, I take it Windows' can be
> much bigger?

An NTFS SD can be up to 64kiB in size. That allows for up to about
1,800 ACEs, although I have not seen that many. However, I have seen
some ACLs with several hundred ACEs. ACEs are around 30 bytes in
length (S-1-5-21-x-y-z-rid, plus perms etc)

--
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)

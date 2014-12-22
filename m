Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51801 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLVX6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 18:58:01 -0500
Received: by mail-pa0-f49.google.com with SMTP id eu11so6724928pac.8
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 15:58:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5498AF7B.2020002@pobox.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>
	<5498829E.3060608@gmail.com>
	<5498A0BD.3000300@pobox.com>
	<CAN05THTqyoVK6sH2JR9CTE77eHu_-um963r4M6jXJEUSWk7DJA@mail.gmail.com>
	<5498AF7B.2020002@pobox.com>
Date: Mon, 22 Dec 2014 15:58:00 -0800
Message-ID: <CACyXjPyzVRtD1gsKy1Mq9Uj8fhJ9kisxfk+=Ppd_tbM2XamvfA@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 3:55 PM, Robert White <rwhite@pobox.com> wrote:
> So I'll ask again...
>
> On 12/22/2014 03:15 PM, ronnie sahlberg wrote:
>>
>> On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote:
>>>
>>> So skipping the full ADS, what's the current demand/payoff for large
>>> XATTR
>>> space?
>
>
> ^^^^^^^^^^^^
>
> So skipping the full ADS, what is the current demand/payoff for large XATTR
> space?

As I said, NTFS Security Descriptors (sometimes incorrectly called
ACLs) as set by Samba.

I know of at least two products that use that approach, one on CentOS,
one on FreeBSD. There are likely others and there will be one more in
the near future.

-- 
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)

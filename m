Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:55105 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbaLWALz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 19:11:55 -0500
Message-ID: <5498B349.4030106@pobox.com>
Date: Mon, 22 Dec 2014 16:11:53 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Richard Sharpe <realrichardsharpe@gmail.com>
CC: ronnie sahlberg <ronniesahlberg@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com>	<CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>	<CACyXjPxj1f_iHjLW3vc6vtiPrzbrWZsD=ApmkAp9OZX23ff8bA@mail.gmail.com>	<5498829E.3060608@gmail.com>	<5498A0BD.3000300@pobox.com>	<CAN05THTqyoVK6sH2JR9CTE77eHu_-um963r4M6jXJEUSWk7DJA@mail.gmail.com>	<5498AF7B.2020002@pobox.com> <CACyXjPyzVRtD1gsKy1Mq9Uj8fhJ9kisxfk+=Ppd_tbM2XamvfA@mail.gmail.com>
In-Reply-To: <CACyXjPyzVRtD1gsKy1Mq9Uj8fhJ9kisxfk+=Ppd_tbM2XamvfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/22/2014 03:58 PM, Richard Sharpe wrote:
> On Mon, Dec 22, 2014 at 3:55 PM, Robert White <rwhite@pobox.com> wrote:
>> So I'll ask again...
>>
>> On 12/22/2014 03:15 PM, ronnie sahlberg wrote:
>>>
>>> On Mon, Dec 22, 2014 at 2:52 PM, Robert White <rwhite@pobox.com> wrote:
>>>>
>>>> So skipping the full ADS, what's the current demand/payoff for large
>>>> XATTR
>>>> space?
>>
>>
>> ^^^^^^^^^^^^
>>
>> So skipping the full ADS, what is the current demand/payoff for large XATTR
>> space?
>
> As I said, NTFS Security Descriptors (sometimes incorrectly called
> ACLs) as set by Samba.
>

yep, other branch of thread, my re-ask was towards Ronie Sahlberg as 
quoted... we passed each other on the backstretch... 8-)


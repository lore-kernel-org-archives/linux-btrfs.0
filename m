Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:49239 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3CJOKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 10:10:06 -0400
Received: by mail-we0-f181.google.com with SMTP id t44so2648673wey.40
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 07:10:04 -0700 (PDT)
Message-ID: <513C949C.6080009@gmail.com>
Date: Sun, 10 Mar 2013 15:11:40 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> (sfid-20130310_104347_651723_C84E4102) <201303101223.56805.Martin@lichtvoll.de>
In-Reply-To: <201303101223.56805.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 03/10/2013 12:23 PM, Martin Steigerwald wrote:
> Hi Hugo,
> 
> Am Samstag, 9. März 2013 schrieb Hugo Mills:
>>    Some time ago, and occasionally since, we've discussed altering the
>> "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
>> number of copies, m is the number of (data) devices in a stripe per copy,
>> and p is the number of parity devices in a stripe.
>>
>>    The current kernel implementation uses as many devices as it can in
>> the striped modes (RAID-0, -10, -5, -6), and in this implementation,
>> that is written as "mS" (with a literal "m"). The mS and pP sections are
>> omitted if the value is 1S or 0P.
>>
>>    The magic look-up table for old-style / new-style is:
>>
>> single           1C (or omitted, in btrfs fi df output)
>> RAID-0           1CmS
>> RAID-1           2C
>> DUP                      2CD
> 
> What does the "D" in "2CD" mean? Its not explained above, unless I miss 
> something.

This means DUP (two copy on the same disk); I understand that only
reading the code.

> 
>
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

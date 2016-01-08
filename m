Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35269 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcAHPEy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 10:04:54 -0500
Received: by mail-io0-f177.google.com with SMTP id 77so257515458ioc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jan 2016 07:04:54 -0800 (PST)
Subject: Re: send/receive for encrypted backup purposes
To: Christoph Anton Mitterer <calestyo@scientia.net>
References: <1827847.pVfOzZHEoP@merkaba>
 <1452261646.6727.12.camel@scientia.net> <4248922.XAnqWXRFKA@vajra>
 <1452262041.6727.15.camel@scientia.net> <568FCA55.90000@gmail.com>
 <1452264547.6727.23.camel@scientia.net>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <568FD001.3030204@gmail.com>
Date: Fri, 8 Jan 2016 10:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <1452264547.6727.23.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-08 09:49, Christoph Anton Mitterer wrote:
> On Fri, 2016-01-08 at 09:40 -0500, Austin S. Hemmelgarn wrote:
>> That said, if you're using forced compression
>> on
>> the source FS, that may weaken things a bit.
> The compression oracle it typically only then a problem, when the
> attacker can control the encrypted data.
> So that would depend mostly on his content...
>
> But better safe than sorry... compression should usually be avoided
> with crypto.
Oh, definitely.  And that goes double for cases where the compression 
algorithm is known in advance by the attacker (because if you pay 
attention, a lot of compression algorithms produce certain patterns, 
which makes breaking things a lot easier, even if you don't control part 
of the plaintext).

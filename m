Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback2.mail.ru ([94.100.179.22]:43563 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbKKM2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 07:28:06 -0500
Received: from smtp48.i.mail.ru (smtp48.i.mail.ru [94.100.177.108])
	by fallback2.mail.ru (mPOP.Fallback_MX) with ESMTP id 66DC964BD7C8
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 14:37:39 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:46924 helo=centurion)
	by smtp48.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ZwTib-0008U0-3D
	for linux-btrfs@vger.kernel.org; Wed, 11 Nov 2015 14:37:37 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 96D033833EB
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 12:37:35 +0100 (CET)
Subject: Re: Process is blocked for more than 120 seconds
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56374C7D.5080609@mail.ru> <563DECF0.8080901@mail.ru>
 <56409EE4.6070605@gmail.com>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <564328B8.2020509@mail.ru>
Date: Wed, 11 Nov 2015 12:38:32 +0100
MIME-Version: 1.0
In-Reply-To: <56409EE4.6070605@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-09 14:25, Austin S Hemmelgarn wrote:
> On 2015-11-07 07:22, Dmitry Katsubo wrote:
>> Hi everyone,
>>
>> I have noticed the following in the log. The system continues to run,
>> but I am not sure for how long it will be stable. Should I start
>> worrying? Thanks in advance for the opinion.
>>
> This just means that a process was stuck in the D state (uninterruptible
> I/O sleep) for more than 120 seconds.  Depending on a number of factors,
> this happening could mean:
> 1. Absolutely nothing (if you have low-powered or older hardware, for
> example, I get these regularly on a first generation Raspberry Pi if I
> don't increase the timeout significantly)
> 2. The program is doing a very large chunk of I/O (usually with the
> O_DIRECT flag, although this probably isn't the case here)
> 3. There's a bug in the blocked program (this is rarely the case when
> this type of thing happens)
> 4. There's a bug in the kernel (which is why this dumps a stack trace)
> 5. The filesystem itself is messed up somehow, and the kernel isn't
> handling it properly (technically a bug, but a more specific case of it).
> 6. You're hardware is misbehaving, failing, or experienced a transient
> error.
> 
> Assuming you can rule out possibilities 1 and 6, I think that 4 is the
> most likely cause, as all of the listed programs (I'm assuming that
> 'master' is from postfix) are relatively well audited, and all of them
> hit this at the same time.
> 
> For what it's worth, if you want you can do:
> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> like the message says to stop these from appearing in the future, or use
> some arbitrary number to change the timeout before these messages appear
> (I usually use at least 150 on production systems, and more often 300,
> although on something like a Raspberry Pi I often use timeouts as high
> as 1800 seconds).

Thanks for comments, Austin.

The system is "normal" PC, running Intel Core 2 Duo Mobile @1.66GHz.
"master" is indeed a postfix process.

I haven't seen anything like that when I was on 3.16 kernel, but after I
have upgraded to 4.2.3, I caught that message. I/O and CPU load are
usually low, but it could be (6) from your list, as the system is
generally very old (5+ years).

As the problem appeared only once for passed 15 days, I think it is just
a transient error. Thanks for clarifying the possible reasons.

-- 
With best regards,
Dmitry

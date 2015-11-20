Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp47.i.mail.ru ([94.100.177.107]:40731 "EHLO smtp47.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760213AbbKTQix (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 11:38:53 -0500
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:37692 helo=centurion)
	by smtp47.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1Zzoi1-0007wS-Ro
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 19:38:50 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id A79A248A902
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 17:38:49 +0100 (CET)
From: Dmitry Katsubo <dma_k@mail.ru>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564D1AE5.3000700@cn.fujitsu.com>
 <pan$61583$65d817c9$bfda2de6$465dca20@cox.net> <564F0671.8060402@mail.ru>
 <564F1E5B.6040004@gmail.com> <20151120132714.GK24333@carfax.org.uk>
 <564F2599.6050802@gmail.com>
Message-ID: <564F4CD2.9040102@mail.ru>
Date: Fri, 20 Nov 2015 17:39:46 +0100
MIME-Version: 1.0
In-Reply-To: <564F2599.6050802@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-20 14:52, Austin S Hemmelgarn wrote:
> On 2015-11-20 08:27, Hugo Mills wrote:
>> On Fri, Nov 20, 2015 at 08:21:31AM -0500, Austin S Hemmelgarn wrote:
>>> On 2015-11-20 06:39, Dmitry Katsubo wrote:
>>>> For those power users who really want to see the tiny details like
>>>> "System" and "GlobalReserve" I suggest to implement "-v" flag:
>>>>
>>>> # btrfs fi usage -v
>>> Actually, I really like this idea, one of the questions I get asked
>>> when I show people BTRFS is the difference between System and
>>> Metadata, and it's not always easy to explain to somebody who
>>> doesn't have a background in filesystem development.  For some
>>> reason, people seem to have trouble with the concept that the system
>>> tree is an index of the other trees.
>>
>>     Actually, it's not that in the system chunks. :)
>>
>>     System chunks contain the chunk tree, not the tree of tree roots.
>> They're special (and small) because they're listed explicitly by devid
>> and physical offset at the end of the superblock, and allow the FS to
>> read them first so that it can bootstrap the logical:physical mapping
>> table before it starts reading all the other metadata like the tree of
>> tree roots (which is "normal" metadata).
> I guess my understanding was wrong then.  Thanks for the explanation.

The size of "System" is anyway very small in comparison other types of
allocations. Adding it to "Metadata" or simply suppressing does not make
big difference. If shown, it actually raises "dummy" questions (Is
"System" area big enough? Can it run out of free space? How can I add
more space to it?).

-- 
With best regards,
Dmitry

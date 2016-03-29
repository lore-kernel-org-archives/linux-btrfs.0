Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34889 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbcC2UAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 16:00:47 -0400
Received: by mail-qg0-f54.google.com with SMTP id y89so21803776qge.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 13:00:47 -0700 (PDT)
Subject: Re: Global hotspare functionality
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        Anand Jain <anand.jain@oracle.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com> <20160329192428.GA27148@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FADEAE.3080801@gmail.com>
Date: Tue, 29 Mar 2016 15:59:42 -0400
MIME-Version: 1.0
In-Reply-To: <20160329192428.GA27148@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-29 15:24, Yauhen Kharuzhy wrote:
> On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
>>
>>   No. No. No please don't do that, it would lead to trouble in handing
>>   slow devices. I purposely didn't do it.
>
> Hmm. Can you explain please? Sometimes admins may want to have
> autoreplacement working automatically if drive was failed and removed
> before unmounting and remounting again. The simplest way to achieve this —
> add spare and always mount FS with 'degraded' option (we need to use
> this option in any case if we have root fs on RAID, for instance, to
> avoiding non-bootable state). So, if the autoreplacement code will check for
> missing drives also, this will working without user intervention. To
> allow user to decide if he wants autoreplacement, we can add mount
> option like '(no)hotspare' (I have done this already for our project and
> will send patch after rebasing onto your new series). Yes, there are
> side effects exists if you want to make some experiments with missing
> drives in FS, but you can disable autoreplacement for such case.
>
> If you know about any pitfalls in such scenarios, please point me to
> them, I am newbie in FS-related kernel things.
If a disk is particularly slow to start up for some reason (maybe it's 
going bad, maybe it's just got a slow interconnect (think SD cards), 
maybe it's just really cold so the bearings seizing up), then this would 
potentially force it out of the array when it shouldn't be.

That said, having things set to always allow degraded mounts is 
_extremely dangerous_.  If the user does not know anything failed, they 
also can't know they need to get anything fixed.  While notification 
could be used, it also introduces a period of time where the user is at 
risk of data loss without them having explicitly agreed to this risk (by 
manually telling it to mount degraded).

I could possibly understand doing this for something that needs to be 
guaranteed to come on line when powered on,  but **only** if it notifies 
responsible parties that there was a problem **and** it is explicitly 
documented, and even then I'd be wary of doing this unless there was 
something in place to handle the possibility of false positives (yes, 
they do happen), and to make certain that the failed hardware got 
replaced as soon as possible.

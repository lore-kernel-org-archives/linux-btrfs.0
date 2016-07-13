Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33467 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbcGML5p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 07:57:45 -0400
Received: by mail-io0-f196.google.com with SMTP id y195so2823305iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 04:57:25 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160711072612.GA1417185@mother.pipebreaker.pl>
 <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
 <20160711165822.GB1417185@mother.pipebreaker.pl>
 <adc6bbe4-48d8-27d2-468f-7e7816ae96cf@gmail.com> <5785C5F2.2040007@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ce52fa5e-b54f-7185-4acc-c1f5403f172d@gmail.com>
Date: Wed, 13 Jul 2016 07:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <5785C5F2.2040007@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-13 00:39, Andrei Borzenkov wrote:
> 12.07.2016 15:25, Austin S. Hemmelgarn пишет:
>>
>> I'm not changing my init system just to add functionality that should
>> already exist in btrfs-progs.  The fact that the balance ioctl is
>> synchronous was a poor design choice, and we need to provide the option
>> to work around that independent of what our users are running.  There's
>> been enough interest from other people that it should be obvious that
>> people want this _in_ btrfs-progs.  The point is to not _need_ anything
>> else to do this.
>
> May be I miss something obvious, but what is wrong with
>
> nohup btrfs balance start &
>
> nohup is definitely available on every system and so far I have been
> using it in exactly such cases when I needed to leave something running
> for a long time.
>
That does work, but it still falls into the category of needing external 
software to do it.  I'm trying to get something that works without any 
external software, and doesn't even depend on having a shell with job 
control.

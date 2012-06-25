Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:55233 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2FYTdN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 15:33:13 -0400
Message-ID: <4FE8BCF5.4080605@profihost.ag>
Date: Mon, 25 Jun 2012 21:33:09 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag> <4FE862D7.3060005@fusionio.com> <4FE870DF.90308@profihost.ag> <20120625142048.GB7404@localhost.localdomain> <4FE8796E.9030300@profihost.ag> <20120625144807.GC7404@localhost.localdomain> <4FE8A21E.7050104@profihost.ag> <20120625180252.GD7404@localhost.localdomain> <4FE8ADBA.20505@profihost.ag>
In-Reply-To: <4FE8ADBA.20505@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With v3.4 the same. Can't go back more as this really results in very 
fast corruption. Any ideas how to debug?

Stefan

Am 25.06.2012 20:28, schrieb Stefan Priebe:
> Am 25.06.2012 20:02, schrieb Josef Bacik:
>>>   >  Can you turn that off and see if you
>>>> can still reproduce the deadlock?  If so sysrq+w again, if not then
>>>> I know where
>>>> to look ;).  Thanks,
>>> without discard i can't reproduce but random write speed with ceph
>>> without discard is a LOT slower (around 8000 iops/s instead of
>>> 13000iops/s). So i don't know if it is discard or if i'm just not able
>>> to trigger it.
>>>
>>
>> Ouch, what kind of drive goes faster with discard _on_?  Anyway it
>> looks like
>> we're waiting for the discard to come back, so either its your drive
>> or theres a
>> bug in the block layer.  Maybe try an older kernel and see if it's
>> broken there,
>> and then bisect it down?  Thanks,
>
> Intel 520 series SSD. I can't try an older kernel version as ceph
> crashes with them pretty fast due to other bugs which where fixed with
> 3.5-rc1.
>
> Greets
> Stefan


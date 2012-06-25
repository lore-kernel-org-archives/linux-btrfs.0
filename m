Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:39452 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2FYRim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 13:38:42 -0400
Message-ID: <4FE8A21E.7050104@profihost.ag>
Date: Mon, 25 Jun 2012 19:38:38 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag> <4FE862D7.3060005@fusionio.com> <4FE870DF.90308@profihost.ag> <20120625142048.GB7404@localhost.localdomain> <4FE8796E.9030300@profihost.ag> <20120625144807.GC7404@localhost.localdomain>
In-Reply-To: <20120625144807.GC7404@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 25.06.2012 16:48, schrieb Josef Bacik:
> On Mon, Jun 25, 2012 at 08:45:02AM -0600, Stefan Priebe - Profihost AG wrote:
>>>
>>> Thats weird, sysrq+w should have a bunch of stacktraces but it's empty, so
>>> unless theres a bug theres nothing blocked.  Is the box actually hung or is it
>>> just taking forever?  Maybe try sysrq+w again to see if the one you pasted was
>>> just a fluke?  Thanks,
>>
>> This one looks better:
>> http://pastebin.com/raw.php?i=R4pztDRt
>>
>
> Ok looks like you have discard turned on.
Yes

 >  Can you turn that off and see if you
> can still reproduce the deadlock?  If so sysrq+w again, if not then I know where
> to look ;).  Thanks,
without discard i can't reproduce but random write speed with ceph 
without discard is a LOT slower (around 8000 iops/s instead of 
13000iops/s). So i don't know if it is discard or if i'm just not able 
to trigger it.

Thanks!

Stefan

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:35537 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3E3Mzz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 08:55:55 -0400
Message-ID: <51A74C5E.4030201@giantdisaster.de>
Date: Thu, 30 May 2013 14:55:58 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Papp Tamas <tompos@martos.bme.hu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
References: <51A73532.6060900@martos.bme.hu> <20130530123235.GA9829@localhost.localdomain>
In-Reply-To: <20130530123235.GA9829@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 30 May 2013 08:32:35 -0400, Josef Bacik wrote:
> On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
>> hi All,
>>
>> I'm new on the list.
>>
>> System:
>> Distributor ID:	Ubuntu
>> Description:	Ubuntu 13.04
>> Release:	13.04
>> Codename:	raring
>>
>> Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> The symptom is the same with Saucy 3.9 kernel.
> 
> Can you try btrfs-next
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> 
> if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
> the component is set to btrfs.  Thanks,

Papp is using an Intel X18-M/X25-M/X25-V G2 SSD. At least with an Intel
X25 SSD that identifies itself with "INTEL SSDSA2M080" and on one with
the ID "INTEL SSDSA2M040", I've tested whether they honor the flush
request. And these two SSDs don't do so, they ignore it. If you cut the
power after a flush request completes, the data that was written before
the flush request is gone, the write cache was _not_ flushed.

You can only disable the write cache during/after every boot "hdparm -W
0 /dev/sd..." (which reduces the SSDs write speed to about 4 MB/s), or
avoid such SSDs, or prepare to restore from backup occasionally.


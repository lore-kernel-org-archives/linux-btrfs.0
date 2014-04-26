Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43898 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaDZV2G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 17:28:06 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Confusing output of btrfs fi df
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140426181827.GA14687@mars>
Date: Sat, 26 Apr 2014 15:28:03 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-Id: <A666D949-AB49-4A9B-9BD8-2D1206F5CCB0@colorremedies.com>
References: <20140426140915.GA12958@mars> <20140426143023.GK2391@carfax.org.uk> <20140426181827.GA14687@mars>
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 26, 2014, at 12:18 PM, Stefan Malte Schumacher <s.schumacher@netcologne.de> wrote:

>> 
>>   They're harmless -- it's a side-effect of the way that mkfs works.
>> They'll go away if you balance them:
>> 
>>   btrfs balance start -dprofiles=single -mprofiles=single -sprofiles=single /mountpoint
> 
> btrfs refused this command, I had to pass --force to execute it.
> It exited with this:Done, had to relocate 2 out of 2710 chunks.
> 
> After that btrfs fi df shows the following:
> 
> Data, RAID1: total=2.64TiB, used=2.22TiB
> System, RAID1: total=8.00MiB, used=380.00KiB
>> System, single: total=4.00MiB, used=0.00<
> Metadata, RAID1: total=4.00GiB, used=2.94GiB

Hmm, seems like a bug. What about 

btrfs balance start -sconvert=raid1,soft -f -v



> 
> 
>>   btrfs fi label should do this.
> 
> I was mainly asking because of this:
> https://btrfs.wiki.kernel.org/index.php/UseCases: You can also use
> btrfs command.There are currently few limitations: the filesystem has
> to be unmounted the filesystem should not have more than one device 
> 
> Is this information outdated?

btfs fi label is done when the system is mounted; for the change to visibly take effect in /dev/ it has to be umounted then mounted. I don't even think it takes effect with a remount, but I could be mistaken. This seems to be a btrfs limitation, if I relabel ext4 volumes while mounted, their label is changed immediately, so the behavior may change down the road.


Chris Murphy


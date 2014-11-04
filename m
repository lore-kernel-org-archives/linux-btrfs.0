Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47260 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751073AbaKDS2p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 13:28:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: filesystem corruption
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20141104043130.GN17395@hungrycats.org>
Date: Tue, 4 Nov 2014 11:28:39 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com> <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com> <20141103034337.GM17395@hungrycats.org> <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com> <20141104043130.GN17395@hungrycats.org>
To: Zygo Blaxell <zblaxell@furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 3, 2014, at 9:31 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:

> On Mon, Nov 03, 2014 at 10:11:18AM -0700, Chris Murphy wrote:
>> 
>> On Nov 2, 2014, at 8:43 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
>>> btrfs seems to assume the data is correct on both disks (the generation
>>> numbers and checksums are OK) but gets confused by equally plausible but
>>> different metadata on each disk.  It doesn't take long before the
>>> filesystem becomes data soup or crashes the kernel.
>> 
>> This is a pretty significant problem to still be present, honestly. I
>> can understand the "catchup" mechanism is probably not built yet,
>> but clearly the two devices don't have the same generation. The lower
>> generation device should probably be booted/ignored or declared missing
>> in the meantime to prevent trashing the file system.
> 
> The problem with generation numbers is when both devices get divergent
> generation numbers but we can't tell them apart, e.g.
> 
> 	1.  sda generation = 5, sdb generation = 5
> 
> 	2.  sdb temporarily disconnects, so we are degraded on just sda
> 
> 	3.  sda gets more generations 6..9
> 
> 	4.  sda temporarily disconnects, so we have no disks at all.
> 
> 	5.  the machine reboots, gets sdb back but not sda
> 
> If we allow degraded here, then:
> 
> 	6.  sdb gets more generations 6..9
> 
> 	7.  sdb disconnects, no disks so no filesystem
> 
> 	8.  the machine reboots again, this time with sda and sdb present
> 
> Now we have two disks with equal generation numbers.  Generations 6..9
> on sda are not the same as generations 6..9 on sdb, so if we mix the
> two disks' metadata we get bad confusion.
> 
> It needs to be more than a sequential number.  If one of the disks
> disappears we need to record this fact on the surviving disks, and also
> cope with _both_ disks claiming to be the "surviving" one.

I agree this is also a problem. But the most common case is where we know that sda generation is newer (larger value) and most recently modified, and sdb has not since been modified but needs to be caught up. As far as I know the only way to do that on Btrfs right now is a full balance, it doesn't catch up just be being reconnected with a normal mount.


Chris Murphy
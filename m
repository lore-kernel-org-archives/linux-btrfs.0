Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:32831 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3ACQjE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 11:39:04 -0500
Date: 03 Jan 2013 17:29:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8i$PzPCXB@helmut.hullen.de>
In-Reply-To: <20130103160853.GA19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>> please delete the option "-L" (for labelling) in "mkfs.btrfs", in
>> some configurations it doesn't work as expected.
>>
>> My usual way:
>>
>>         mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...
>>
>> One call for some devices.
>> Wenn I add the option "-L mylabel" then each device gets the same
>> label, and therefore some other programs can't find the (one) device
>> with the defined label.

>    I'm sure we've been over this territory before. Devices are not
> labelled; filesystems are labelled. You are labelling the whole
> filesystem, which exists over several devices, so the same label will
> be attached to every device in the filesystem.

But for what purpose offers "mkfs.btrfs" this option?


>> Especially
>>
>>      blkid
>>      findfs LABEL=mylabel
>>
>> don't work.

>    How do you mean, "don't work"? What are they showing, and what do
> you think should they be showing?

Without this double-labelled (?) devices "blkid" shows all devices with  
(if defined) their labels. When I define the same label for more than 1  
device (btrfs or ext2fs or ...) then "blkid" shows nothing. No output  
for any of the devices.

"findfs": with double-labelled devices "findfs" doesn't find any label.


> It looks like both of them print an
> arbitrary device node of the devices that the FS lives on. Given that
> both of these tools probably expect a one-to-one relationship between
> a block device and a filesystem, this is not unreasonable.

May be that "this is not unreasonable". But when "mkfs.btrfs" offers the  
"label" option I don't expect this behaviour.

I had mentioned this problem more than a year ago, it still exists.

Viele Gruesse!
Helmut

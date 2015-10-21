Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s8.hotmail.com ([65.55.116.19]:62831 "EHLO
	BLU004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbJUQkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 12:40:55 -0400
Message-ID: <BLU437-SMTP269660A7643A578F783372A9380@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <562760DC.1050904@gmail.com>
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
	<pan$55e2$eeada9c5$c7289131$4f093ca1@cox.net>
	<CAM9fjH6pcwZKWryNrJay_N98wmXWVXXqo3HJuupbJRE3MC9YKQ@mail.gmail.com>
	<BLU436-SMTP11853633E0AF118E66934D6A9390@phx.gbl>
	<562760DC.1050904@gmail.com>
Date: Wed, 21 Oct 2015 18:40:50 +0200
Subject: Re: How to remove missing device on RAID1?
From: Henk Slager <hslager@hotmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2015 at 11:54 AM, Dmitry Katsubo
<dmitry.katsubo@gmail.com> wrote:
> On 2015-10-21 00:40, Henk Slager wrote:
>> I had a similar issue some time ago, around the time kernel 4.1.6 was
>> just there.
>> In case you don't want to wait for new disk or decide to just run the
>> filesystem with 1 disk less or maybe later on replace 1 of the still
>> healthy disks with a double/bigger sized one and use current/older
>> kernel+tools, you could do this (assuming the filesystem is not too
>> full of course):
>> - mount degraded
>> - btrfs balance start -f -v -sdevid=1 -mdevid=1 -ddevid=1 <mountpoint>
>>   (where missing disk has devid 1)
>
> Am I right that one can "btrfs dev delete 1" after balance succeeded?
If the patch that Ducan decribes is applied, then yes, this is then
the way to remove (delete) the missing device from the filesystem.

>> After completion the (virtual/missing) device shall be fully unallocated
>> - create /dev/loopX with sparse file of same size as missing disk on
>> some other filesystem
>> - btrfs replace start 1 /dev/loopX <mountpoint>
>> - remove /dev/loopX from the filesystem
>> - remount filesystyem without degraded
>> And remove /dev/loopX
>
> If would be nice if btrfs allows to delete device and perform rebalance
> automatically (provided that left devices still have enough space to
> sustain raidX prerequisite).
This would indeed be nice, but I guess it should be working already,
looking at older (3.x) btrfs-tools documentation. It's just that it
could not be used for some time. Anyhow, once this patch is more
commonly available, people can test/use it and see if still a manual
extra specific balance is needed in order to get rid of or work-around
issues. It is actually the functionality of the '-r' option of 'btrfs
replace' that is then applied.

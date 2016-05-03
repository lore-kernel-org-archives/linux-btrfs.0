Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:56014
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbcECSHH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 14:07:07 -0400
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
To: Hugo Mills <hugo@carfax.org.uk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
 <20160503095515.GM7228@carfax.org.uk>
 <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
 <20160503102746.GN7228@carfax.org.uk>
 <DF5803A5-7C03-461B-B72C-A374FE57ABBF@hagenjohansen.dk>
Cc: linux-btrfs@vger.kernel.org
From: hasse@hagenjohansen.dk
Message-ID: <1f7be96f-1f87-51bd-f9bc-cf3fb95d582e@hagenjohansen.dk>
Date: Tue, 3 May 2016 20:06:57 +0200
MIME-Version: 1.0
In-Reply-To: <DF5803A5-7C03-461B-B72C-A374FE57ABBF@hagenjohansen.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Den 03/05/16 kl. 13:13 skrev Hasse Hagen Johansen:

>>>
>>> The exact thing I did was having the subvols mounted. Then mounted
>> top-level volume on /mbt/temp. And then ran balance to convert to
>> raid1.. When finished I umounted /mnt/temp (the top-level) and then my
>> 3 subvolumes was unmounted and a cannot mount them at the same
>> mountpoints again... No errors and it says that it is not mounted when
>> trying to umount them. So it seems they don't get mounted at all and
>> without throwing an error
>>>
>>> I will look into it more thoroughly now that I can at least mount the
>> subvols on other mountpoints than the original 
>>
>>   Given those symptoms (mount doesn't report errors, but no mount
>> happens), I would guess that your problem is with systemd. It has a
>> bug where it sometimes unmounts things immediately after you've
>> mounted them.
>>

You were right. Looking more into it (home at my computer and not my
phone) I found this in /var/log/syslog:

May  3 19:57:23 pris systemd[1]: books.mount: Unit is bound to inactive
unit dev-Data\x2dVG-books.
device. Stopping, too.
May  3 19:57:23 pris systemd[1]: Unmounting /books...
May  3 19:57:25 pris systemd[1]: Unmounted /books.
May  3 19:57:25 pris systemd[1]: books.mount: Unit entered failed state.

So it is indeed systemd...great...seems it is confused because the
mountpoints which I have now moved to btrfs was earlier using lvm. I
will try telling systemd to forget that old unit

Thanks for the help


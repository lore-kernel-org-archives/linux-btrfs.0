Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45030 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaLaKYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 05:24:36 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: How to handle remove media (was: Re: What about not warn on some abort_transaction() case whose reason is known?)
Date: Wed, 31 Dec 2014 11:24:32 +0100
Message-ID: <1433170.itgjFWUuZD@merkaba>
In-Reply-To: <54A351C9.7070504@cn.fujitsu.com>
References: <54A351C9.7070504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am cc´ing this to fsdevel as I think how to handle a disconnected usb device 
may be of broader interest. Well free to drop Cc again in case you see it as 
only BTRFS specific issue.

Am Mittwoch, 31. Dezember 2014, 09:30:49 schrieb Qu Wenruo:
> Hi all,

Hi Qu,

> While surfing the Redhat BZ, a lot(at least 5 I found in one month) 
> users report "bugs" in btrfs about
> kernel warning in btrfs_abort_transaction().
> And most of them (about 3 or more) are caused by disconnected usb device.
> 
> So I'm considering not to warn on some cases if we know its reason, like 
> the above device disconnected
> case, but still warn on other cases.
> This should reduce many unneeded bug report for the usb disconnected case.
> 
> Any advice is welcomed.

How about warning, but also mentioned the *reason*?

Disconnecting an USB device without unmounting is still not so nice and a 
warning, well, any unwritten data has been lost then already, so, but still. I 
know with esata disks you have a grace time, if you replug it quickly enough 
while libata driver is still retrying it will continue the write.


I for a long time thought about a feature request for the Linux kernel to 
handle removable media in the very sane way AmigaOS does. I never did so in 
all the years, but heck, why not today?

If you remove it while writing, you get a nice dialog saying

"You MUST insert volume xyz again"

You do it, and it continues writing. Now how cute is that? Its the best way to 
handle this kind of situation for the user in my point of view. (On the other 
hand, if you didn´t, and it was a floppy disk with original Amiga filesystem, 
the disk was broke, so the "MUST" was no joke).

I remember that this has been topic of a summer of code project for NetBSD, 
but I don´t know what came out of it.

I know the difficulties with this. The kernel will need to pile up I/O to the 
device and at some point halt processes to prevent memory exhaustion. And then 
you need to route the request to reinsert the medium to the user, to the 
desktop. And what do you do on a server? Where do you ask then? On the command 
line? And if so, how do to that in a non annoying way? Maybe that is just 
something to opt in for a desktop system.

So this would be quite some work, but I always thought: How AmigaOS handles 
this is the *only* sane way to do it for any media that you cannot prevent 
accidental removal on a hardware level – at least for the desktop case. At 
least from a users point of view. Just discarding data on that accident is 
just plain unfriendly to the user and an invitation for data loss (if the user 
chose to move files instead of copying them).

And I found it that for some users I can tell them to safely remove the USB 
stick before unplugging it again and again, but they still won´t do it, it 
just doesn´t sink in. Meanwhile I usually say: Wait 30 seconds after last 
write and then unplug and then hope for the best.

I still think AmigaOS goes beyond all the other operation systems I know with 
this feature. But well, I am not exactly sure how MS-DOS or Windows handle 
this. I vaguely remember some retry prompt from MS-DOS, but it may have been 
for another case.


But well, so yes, a warning in the log may just be completely useless, cause 
its too late then, for the data that was about to be safed. And if there is no 
data to be saved anymore, a warning does not make any sense either, cause 
there isn´t a problem. Yet, an aborted transaction means there was data to be 
saved, so.

So or so, this may be something to handle on the block or VFS layer anyway?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

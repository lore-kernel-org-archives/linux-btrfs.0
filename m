Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50107 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbaKTKfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 05:35:37 -0500
Received: from venus.xundeenergie.ssh22.net ([213.47.207.20]) by mail.gmx.com
 (mrgmx001) with ESMTPSA (Nemesis) id 0MTBLi-1XQQGe4Bks-00S4PN for
 <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 11:35:35 +0100
Received: from localhost ([127.0.0.1])
	by venus.xundeenergie.ssh22.net with esmtp (Exim 4.84)
	(envelope-from <wertstoffe@nurfuerspam.de>)
	id 1XrP5B-0004iU-A3
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 11:35:25 +0100
Received: from venus.xundeenergie.ssh22.net ([IPv6:::1])
	by localhost (localhost [IPv6:::1]) (amavisd-new, port 10024)
	with ESMTP id DhkgOMJZ044m for <linux-btrfs@vger.kernel.org>;
	Thu, 20 Nov 2014 11:35:25 +0100 (CET)
Received: from Debian-exim by venus.xundeenergie.ssh22.net with spam-scanned (Exim 4.84)
	(envelope-from <wertstoffe@nurfuerspam.de>)
	id 1XrP5A-0004i3-Pm
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 11:35:24 +0100
Received: from venus.xundeenergie.ssh22.net ([192.168.0.14])
	by venus.xundeenergie.ssh22.net with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <wertstoffe@nurfuerspam.de>)
	id 1XrP5A-0004hj-FZ
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 11:35:24 +0100
Message-ID: <546DC3EC.1020903@nurfuerspam.de>
Date: Thu, 20 Nov 2014 11:35:24 +0100
From: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: systemd.setenv and a mount.unit
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net> <546DBFCB.4090506@inwind.it>
In-Reply-To: <546DBFCB.4090506@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2014-11-20 um 11:17 schrieb Goffredo Baroncelli:
> On 2014-11-19 23:48, Jakob Schürz wrote:
>> Hi there!
>>
>> Another challenge... I'm using btrfs. So i make snapshots from my
>> system. And in a script, I make a symlink (for example:
>> @system.CURRENT and @system.LAST) for the current and the last
>> snapshot.
>
> Interesting, I was unaware that I could mount a subvolume passing
> a "soft" link.

Fortunately Yes, that works. :)
So i came on this idea, to create 2 (or more) stable links on the 
current, last and so on snapshot. The Problem is the fstab...

>
>>
>> So i want to add 2 entries in grub2 from which i can boot into the
>> current and the last snapshot.
>>
>> I tried to pass an environmental variable with
>> systemd.setenv=BOOTSNAP=@system.CURRENT, and i have a mount-unit
>> containing the option
>>
>> Options=defaults,nofail,subvol=archive-local/@system.$BOOTSNAP
>>
>> but it doesn't work. If i change $BOOTSNAP to CURRENT, the mount
>> works. So i made a test.service, containing only StartExec=/bin/echo
>> $BOOTSNAP I get the value @system.CURRENT in the logs...
>
> This is more a systemd related question. However it seems that ExecStart
> supports "...basic environment variable substitution..."; but the mount unit
> doesn't. This explain your difficulties. Anyway I suggest you to contact the
> systemd developers to get further support; maybe that this could be a add as
> TODO item.

I hope so... and i found out, that this is not a btrfs-challenge.
On the grub-devel-list i saw a discussion to make dynamically entries 
for all snapshots in a certain directory according to this challenge.

But this also didn't solve the fstab-challenge.

So i think i have to place it on a systemd-devel-list...

>
>> How can I do this mounts?
>
> For the boot, I used the "rootflags=" command line options. This
> usually is interpreted by the initrd/initramfs as option to pass
> to the mount command. In my case I have:
>
> 	rootflags=subvol=debian
>
> so, the subvol=debian option is passed to mount. When grub-mkconfig
> generates the grub menu entries, does so.

This I also have in my grub-config, and it works. But it doesn't solve 
the challenge. Mounting more subvolumes according to the 
root-subvolume... :-)

regards
Jakob


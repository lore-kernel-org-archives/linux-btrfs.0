Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39334 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbcCON3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:29:34 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afp2S-0002G3-BZ
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 14:29:32 +0100
Date: Tue, 15 Mar 2016 14:29:32 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315132932.GO2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
 <20160314200546.GG2334@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160314200546.GG2334@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:05:46PM +0100, Marc Haber wrote:
> [10/509]mh@fan:~$ sudo btrfs check /media/tempdisk/
> Superblock bytenr is larger than device size
> Couldn't open file system
> [11/509]mh@fan:~$

After umounting and btrfs check the block device, things seem to be
fine now:

[34/532]mh@fan:~$ sudo btrfs check /dev/mapper/ofanbtr
Checking filesystem on /dev/mapper/ofanbtr
UUID: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 86554574954 bytes used err is 0
total csum bytes: 81815012
total tree bytes: 2476670976
total fs tree bytes: 2246311936
total extent tree bytes: 133201920
btree space waste bytes: 452859567
file data blocks allocated: 292994375680
 referenced 132664688640
[35/533]mh@fan:~$ sudo btrfs check /dev/mapper/ofanbtr
Checking filesystem on /dev/mapper/ofanbtr
UUID: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 86554574954 bytes used err is 0
total csum bytes: 81815012
total tree bytes: 2476670976
total fs tree bytes: 2246311936
total extent tree bytes: 133201920
btree space waste bytes: 452859567
file data blocks allocated: 292994375680
 referenced 132664688640
[36/533]mh@fan:~$

This does not indicate an error, does it?

Greetings
Marc, who would like to the tools a bit more explicit and consistent
in whether they want the fs mounted, umounted, the mountpoint or the
device on their command line

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

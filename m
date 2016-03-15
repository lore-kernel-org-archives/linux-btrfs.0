Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49478 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbcCOKwd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 06:52:33 -0400
Subject: Re: New file system with same issue
To: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de> <56E6B312.30903@googlemail.com>
 <20160314201306.GH2334@torres.zugschlus.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56E7E96E.6080301@googlemail.com>
Date: Tue, 15 Mar 2016 11:52:30 +0100
MIME-Version: 1.0
In-Reply-To: <20160314201306.GH2334@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/16 21:13, Marc Haber wrote:
> On Mon, Mar 14, 2016 at 01:48:18PM +0100, Holger Hoffstätte wrote:
>> did you ever try to clear the free-space cache via -o clear_cache
>> on mount?
> 
> This was not asked, and I didn't try. Since this is an encrypted root
> filesystem, is it a workable way to add clear_cache to /etc/fstab,
> rebuild initramfs and reboot? Or do you recommend using a rescue system?

If you can do it via a rescue system that might be easiest, but adding
it to fstab and rebooting once has the same effect. Whatever you know
how to do safely.

>> Give it a try, let it run for a while and then try balancing
>> again.
> 
> Do I need to wait for clear_cache to finish, like until I see disk
> usage dropping?

The cache isn't that big, so you won't see a huge drop. Just use the
disk normally for a few minutes, after some time the cache will be
written out again.

>> _Someone_ is lying to btrfs in terms of device size and/or allocated
>> chunks, otherwise you wouldn't get the ENOSPC.
> 
> Which properties does a block device report other than size?

Well..at least all you can find in /sys/block/sdX/*. However, reading
the other subthread about the mismatching image size I'm now none the
wiser what else to suggest. :/

-h

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:36790 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbcCNUNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 16:13:09 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afYrT-0005I6-3P
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 21:13:07 +0100
Date: Mon, 14 Mar 2016 21:13:06 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue
Message-ID: <20160314201306.GH2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <56E6B312.30903@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56E6B312.30903@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 01:48:18PM +0100, Holger Hoffstätte wrote:
> On 03/14/16 13:07, Marc Haber wrote:
> >> And btrfs balance runs into the same ENOSPC issues as the old one:
> > 
> > ... with Qu's patch, I now get a reproducible kernel trace:
> 
> <snip>
> 
> That is interesting and useful. Sorry if this was asked before, but
> did you ever try to clear the free-space cache via -o clear_cache
> on mount?

This was not asked, and I didn't try. Since this is an encrypted root
filesystem, is it a workable way to add clear_cache to /etc/fstab,
rebuild initramfs and reboot? Or do you recommend using a rescue system?

> Give it a try, let it run for a while and then try balancing
> again.

Do I need to wait for clear_cache to finish, like until I see disk
usage dropping?

> Uncle Occam's razor also suggests that the involvement of dm
> doesn't help. Why not just use the device/partition directly?

I need the dm intermediate since I don't want to repartition the
expensive SSD and the entire system is crypted.

> _Someone_ is lying to btrfs in terms of device size and/or allocated
> chunks, otherwise you wouldn't get the ENOSPC.

Which properties does a block device report other than size?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

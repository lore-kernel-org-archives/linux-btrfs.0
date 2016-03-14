Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:48333 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbcCNMsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:48:21 -0400
Subject: Re: New file system with same issue
To: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56E6B312.30903@googlemail.com>
Date: Mon, 14 Mar 2016 13:48:18 +0100
MIME-Version: 1.0
In-Reply-To: <20160314120703.GD2334@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/16 13:07, Marc Haber wrote:
>> And btrfs balance runs into the same ENOSPC issues as the old one:
> 
> ... with Qu's patch, I now get a reproducible kernel trace:

<snip>

That is interesting and useful. Sorry if this was asked before, but
did you ever try to clear the free-space cache via -o clear_cache
on mount?

Give it a try, let it run for a while and then try balancing
again. There is definitely something wrong with the chunk
allocation on your system since you still have allegedly
~100G free, so it's not the notorious (and a lot less common these
days) edge case of sparsely populated chunks that would require
a 'compaction'.

IMHO you are also looking at two different, possibly unrelated
problems: failure to allocate more chunks vs. metadata bloat,
so let's not confuse the two.

Uncle Occam's razor also suggests that the involvement of dm
doesn't help. Why not just use the device/partition directly?
_Someone_ is lying to btrfs in terms of device size and/or allocated
chunks, otherwise you wouldn't get the ENOSPC.

-h


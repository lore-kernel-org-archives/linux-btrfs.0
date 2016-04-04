Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41946 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbcDDUHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 16:07:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anAmG-0001kQ-0P
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 22:07:12 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:07:11 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:07:11 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Mon, 4 Apr 2016 22:07:02 +0200
Message-ID: <20160404220702.77518a86@jupiter.sol.kaishome.de>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
	<20160404020043.47ad35bf@jupiter.sol.kaishome.de>
	<5702076B.3050108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 14:19:23 +0800
schrieb Anand Jain <anand.jain@oracle.com>:

> > Otherwise, I find "hot spare" misleading and it should be renamed.  
> 
>   I never thought hot spare would be narrowed to such a specifics.
[...]
>   About the naming.. the progs called it 'global spare' (device),
>   kernel calls is 'spare'. Sorry this email thread called it
>   hot spare. I should have paid little more attention here to maintain
>   consistency.
> 
>   Thanks for the note.

I think that's okay. Maybe man pages / doc should put a note that
there's no copy-back and that the spare takes a permanent replacement
role.

Side note: When I started managing hardware RAIDs a few years back,
"hot spare" wasn't very clear to me, and I didn't understand why there
is a copy-back operation (given that "useless" +1x IO). But in the long
term it keeps drive arrangement at expectations - which is good.

RAID board manufacturers seem to differentiate between those two
replacement strategies - and "hot spare" always involved copy-back for
me: The spare drive automatically returns to its hot spare role. I
learned to like this strategy. It has some advantages.

You could instead assign a replacement drive - then drives will become
rearranged in the array. This is usually done by just onlining one
spare disk, start a replace action, then offline the old drive and pull
it from the array. It's not "hot" in that sense. It's been unconfigured
good. Not sure if this could be automated - I did it this way only when
the array hasn't been equipped with a spare inside the enclosure but
the drive being still in its original box. Other than that, I always
used the hot spare method.

That's why I stumbled across...

-- 
Regards,
Kai

Replies to list-only preferred.


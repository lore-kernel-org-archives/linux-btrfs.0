Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752829AbdAZIIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 03:08:34 -0500
Subject: Re: btrfs rescue chunk-recover segfaults
To: Duncan <1i5t5.duncan@cox.net>
References: <ef832bd4-bf83-50da-cdbe-07050cf9aff4@gmx.net>
 <pan$5491e$d66176cb$30506251$23903084@cox.net>
Cc: linux-btrfs@vger.kernel.org
From: Simon Waid <simon_waid@gmx.net>
Message-ID: <e8185d01-fbc0-7276-36e0-05e5a28814a4@gmx.net>
Date: Thu, 26 Jan 2017 09:08:26 +0100
MIME-Version: 1.0
In-Reply-To: <pan$5491e$d66176cb$30506251$23903084@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Am 24.01.2017 um 11:05 schrieb Duncan:
> Simon Waid posted on Mon, 23 Jan 2017 09:42:28 +0100 as excerpted:
>
>
>> I have a btrfs raid5 array that has become unmountable.
> [As a list regular and btrfs user myself, not a dev, but I try to help
> with replies where I can in ordered to allow the devs and real experts to
> put their time to better use where I can't help.]
>
> As stated on the btrfs wiki and in the mkfs.btrfs manpage, btrfs raid56
> hasn't stabilized and is now known to have critical defects as originally
> implemented, that make it unfit for the purposes most people normally use
> parity-raid for.  It's not recommended except for testing with purely
> sacrificial data that might potentially be eaten by the test.
>
> Thus, anyone on btrfs raid56 mode should only been testing with
> effectively throw-away data, either because it's backed up and can be
> easily retrieved from that backup, or because it really /is/ throw-away
> data, making the damage from losing that testing filesystem minimal.
>
> As such, if you're done with testing, the fastest and most efficient way
> back to production is to forget about the broken filesystem, and blow it
> away with a mkfs to a new filesystem, either some other btrfs mode or
> something other than the still maturing btrfs entirely, your choice.
> Then you can restore from backups if the data was worth having them.
>
> Tho of course blowing it away does mean it can't be used as a lab
> specimen to perhaps help find and fix some of the problems that do affect
> raid56 mode at this time.
>
> Qu Wenruo in particular, and others, have been gradually working thru at
> least some of the raid56 mode bugs, tho it's still possible the current
> code is beyond hope and may need entirely rewritten to properly
> stabilize.  If you don't have to get the space the filesystem was taking
> directly back in service and can build and work with the newest code
> possibly including patches they ask you to apply, you may be able to use
> your deployment as a lab specimen to help them test their newest recovery
> code and possibly help fix additional bugs in the process.
>
> However, even then, don't expect that you'll necessarily recover most of
> what was on the filesystem, as raid56 mode really is seriously bugged
> ATM, and it's quite possible that the data has already been wiped out by
> those bugs.  Mostly, you're simply continuing to use the filesystem as an
> in-the-wild test deployment gone bad, now testing diagnostics and
> possible recovery, not necessarily with a good chance of recovering the
> data, but that's OK, since btrfs raid56 mode was never out of unstable
> testing-only mode in the first place, so any data put on it always was
> effectively sacrificial data, known to be potentially eaten by the
> testing itself.
>
Thank you Ducan for the information.

Before wiping the filesystem, is there anything I should do to help 
fixing the segfault in chunk-recover?

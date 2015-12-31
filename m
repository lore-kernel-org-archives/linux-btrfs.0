Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37071 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbLaK0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 05:26:09 -0500
Received: by mail-wm0-f53.google.com with SMTP id f206so106944322wmf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 02:26:08 -0800 (PST)
Received: from orione.localnet (183.Red-83-50-202.dynamicIP.rima-tde.net. [83.50.202.183])
        by smtp.gmail.com with ESMTPSA id c26sm40588758wmi.21.2015.12.31.02.26.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Dec 2015 02:26:06 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS - Write Barriers
Date: Thu, 31 Dec 2015 10:26:05 +0000
Message-ID: <1992638.mRFHBd1orl@orione>
In-Reply-To: <pan$a3e98$17648899$36c99b28$62a3ab29@cox.net>
References: <4794805.EoAJ2iVUQK@orione> <pan$a3e98$17648899$36c99b28$62a3ab29@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Duncan for your answer.

Yes, I read that part of the wiki and since I saw the "system crash" just 
wanted to be sure because always only the power loss part is mentioned 
regarding barriers by other fs such as for example XFS.

The fact is that since the barrier stuff was removed from the elevator and put 
into the file system layer in the form of flush, FUA, etc I doubted that now 
it is no more safe to disable write barrier even if you have a battery backed 
HD hardware cache.

It could be that since the fs is no more issuing flush command to the elevator 
(barrier disable case) and the elevator barrier code was removed now, it could 
reorder also that precious writes and in doing so destroying the atomic order 
of the fs and as a consequence destroying the integrity of it also in the case 
where no power loss is experienced by the HD hardware cache.

That said it was my guessing that now it could be no more safe to disable 
write barriers in any filesystem regardless of its age and supposed stability.

The interaction between the kernel disk scheduler and the filesystem without 
barriers enabled could be unpredictable because the disk scheduler would now 
be authorized to change the order of any write to the underling hardware and 
not only of those not connected with the write barriers. Do I understood it 
correctly?

Regards.

On Thursday, December 31, 2015 9:34:24 AM WET Duncan wrote:
> fugazzi® posted on Thu, 31 Dec 2015 09:01:51 +0000 as excerpted:
> > Just one question for the gurus here.
> > 
> > I was wondering: if I disable write barriers in btrfs with the mount
> > option nobarrier I just disable the periodic flushes of the hardware
> > disk cache or I'm disabling also the order of the writes directed to the
> > hard disk?
> > 
> > What I mean is: is it safe to disable write barrier with a UPS with
> > which I will likely have the hardware always powered even in the event
> > of a kernel crash, freeze, etc?
> > 
> > I'm asking because if also the ordering of the write is no more
> > guaranteed I guess it would not be safe to disable write barrier even if
> > the possibility of an unexpected power down of the HD was remote because
> > in the case of a crash the order of the write would be messed up anyway
> > and we could boot up with a completely corrupted fs.
> 
> From the wiki mount options page:
> 
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> 
> 
> 
> nobarrier
> 
> Do not use device barriers. NOTE: Using this option greatly increases the
> chances of you experiencing data corruption during a system crash or a
> power failure. This means full file-system corruption, and not just
> losing or corrupting data that was being written during the event.
> 
> <<<<<
> 
> IOW, use at your own risk.
> 
> In theory you should be fine if you *NEVER* have a system crash (it's not
> just loss of power!), but as btrfs itself is still "stabilizING, not yet
> fully stable and mature", it can itself crash the system occasionally,
> and while that's normally OK as the atomic transaction nature of btrfs
> and the fact that it crashes or at minimum forces itself to read-only if
> it thinks something's wrong will normally save the filesystem from too
> much damage, if it happens to get into that state with nobarrier set,
> then all bets are off, because the normally atomic transactions that
> would either all be there or not be there at all are no onger atomic, and
> who knows /what/ sort of state you'll be in when you reboot.
> 
> So while it's there for the foolish, and perhaps the slightly less
> foolish once the filesystem fully stabilizes and matures, right now, you
> really /are/ playing Russian roulette with your data if you turn it on.
> 
> I'd personally recommend staying about as far away from it as you do the
> uninsulated live service mains coming into your building... on the SUPPLY
> side of the voltage stepdown transformer!  And for those that don't do
> that, well, there's Darwin awards.


From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Updating RAID[56] support
Date: Fri, 30 Apr 2010 21:23:33 +0200 (CEST)
Message-ID: <28824133.321.1272655413702.JavaMail.root@zimbra>
References: <1272564366.3367.4143.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1272564366.3367.4143.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

----- "David Woodhouse" <dwmw2@infradead.org> skrev:

> I've been looking again at the RAID5/RAID6 support, and updated the
> tree
> at git://git.infradead.org/users/dwmw2/btrfs-raid56.git#merged
> 
> At the moment, we limit writes to a single disk's worth at a time,
> which
> means we _always_ do the read-calculateparity-write cycle and suffer
> the
> traditional RAID 'write hole' problem.

Out of curiosity, will Btrfs allow for variable block sizes such as with ZFS?

roy

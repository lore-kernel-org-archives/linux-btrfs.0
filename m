Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab3EGXYZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 19:24:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZrFA-0000Dy-GO
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 01:24:24 +0200
Received: from dyndsl-178-142-088-157.ewe-ip-backbone.de ([178.142.88.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 01:24:24 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-088-157.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 01:24:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient backups
Date: Wed, 08 May 2013 01:22:05 +0200
Message-ID: <steo5a-lpe.ln1@hurikhan.ath.cx>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <km5ksq$p15$1@ger.gmane.org> <64hi5a-9rq.ln1@hurikhan.ath.cx> <kmbtvb$all$1@ger.gmane.org> <9tdo5a-hde.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

> Gabriel de Perthuis <g2p.code@gmail.com> schrieb:
> 
>> It sounds simple, and was sort-of prompted by the new syscall taking
>> short ranges, but it is tricky figuring out a sane heuristic (when to
>> hash, when to bail, when to submit without comparing, what should be the
>> source in the last case), and it's not something I have an immediate
>> need for.  It is also possible to use 9p (with standard cow and/or
>> small-file dedup) and trade a bit of configuration for much more
>> space-efficient VMs.
>> 
>> Finer-grained tracking of which ranges have changed, and maybe some
>> caching of range hashes, would be a good first step before doing any
>> crazy large-file heuristics.  The hash caching would actually benefit
>> all use cases.
> 
> Looking back to good old peer-2-peer days (I think we all got in touch
> with that the one or the other way), one title pops back into my mind:
> tiger- tree-hash...
> 
> I'm not really into it, but would it be possible to use tiger-tree-hashes
> to find identical blocks? Even accross different sized files...

While thinking about it: That hash was probably invented for the purpose of 
distributing the same content to multiple peers in as small deltas as 
possible. Well, deduplication is somehow the other way around: Coalescing 
all those wild distribution back into a single source of content. So some 
"inverse" of tiger-tree would probably work better / more efficient.

Regards,
Kai


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39166 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab3EGWH4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 18:07:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZq38-00012w-UR
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 00:07:54 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 00:07:54 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 00:07:54 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient
 backups
Date: Tue, 7 May 2013 22:07:39 +0000 (UTC)
Message-ID: <kmbtvb$all$1@ger.gmane.org>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <km5ksq$p15$1@ger.gmane.org>
	<64hi5a-9rq.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Do you plan to support deduplication on a finer grained basis than file 
> level? As an example, in the end it could be interesting to deduplicate 1M 
> blocks of huge files. Backups of VM images come to my mind as a good 
> candidate. While my current backup script[1] takes care of this by using 
> "rsync --inplace" it won't consider files moved between two backup cycles. 
> This is the main purpose I'm using bedup for on my backup drive.
> 
> Maybe you could define another cutoff value to consider huge files for 
> block-level deduplication?

I'm considering deduplicating aligned blocks of large files sharing the
same size (VMs with the same baseline.  Those would ideally come
pre-cowed, but rsync or scp could have broken that).

It sounds simple, and was sort-of prompted by the new syscall taking
short ranges, but it is tricky figuring out a sane heuristic (when to
hash, when to bail, when to submit without comparing, what should be the
source in the last case), and it's not something I have an immediate
need for.  It is also possible to use 9p (with standard cow and/or
small-file dedup) and trade a bit of configuration for much more
space-efficient VMs.

Finer-grained tracking of which ranges have changed, and maybe some
caching of range hashes, would be a good first step before doing any
crazy large-file heuristics.  The hash caching would actually benefit
all use cases.

> Regards,
> Kai
> 
> [1]: https://gist.github.com/kakra/5520370



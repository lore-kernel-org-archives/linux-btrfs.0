Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaFDJZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 05:25:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ws7RP-0003L2-N1
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 11:25:03 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 11:25:03 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 11:25:03 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: What to do about snapshot-aware defrag
Date: Wed, 04 Jun 2014 12:19:05 +0300
Message-ID: <m49fvjlghh2.fsf@coffee.modeemi.fi>
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org>
	<538C7A79.8070407@fb.com> <lmln77$ee0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin <m_btrfs@ml1.co.uk> writes:

> The *ONLY* application that I know of that uses atime is Mutt and then
> *only* for mbox files!...

However, users, such as myself :), can be interested in when a certain
file has been last accessed. With snapshots I can even get an idea of
all the times the file has been accessed.

> *And go KISS and move on faster* better?

Well, it in uncertain to me if it truly is better that btrfs would after
that point no longer truly even support atime, if using it results in
blowing up snapshot sizes. They might at that point even consider just
using LVM2 snapshots (shudder) ;).

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/


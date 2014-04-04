Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56204 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaDDMsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 08:48:09 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Fri, 04 Apr 2014 14:48:09 +0200
Message-ID: <1847185.lRc2jIirHz@fnix>
In-Reply-To: <533EA686.5030909@gmail.com>
References: <2692878.dRG1K49eOP@fnix> <533EA686.5030909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 4 avril 2014 08:33:10 Austin S Hemmelgarn a écrit :
> > However I'm still concerned with chronic BTRFS dreadful performance and
> > still  find that BRTFS degrades much over time even with periodic defrag
> > and "best practices" etc.
> 
> I keep hearing this from people, but i personally don't see this to be
> the case at all.  I'm pretty sure the 'big' performance degradation that
> people are seeing is due to how they are using snapshots, not a result
> using BTRFS itself (I don't use them for anything other than ensuring a
> stable system image for rsync and/or tar based backups).

Maybe I was wrong to suppose that if a feature exists, it is supposed to be 
usable... I have used ZFS for years, and on ZFS having *hundreds* of snapshots 
of any given FS have exactly zero impact on performance...

With BTRFS, some time ago I tried to use SuSE "snapper" that passes its time 
doing and releasing snapshots, but it soon made my systems unusable...

Now, I only keep 2-3 manually made snapshots just for keeping a "stable and OK 
archive of my machine in a known state" just in case...

But if even this has a noticeable negative impact on BTRFS performance, then 
what the hell are BTRFS snapshots good at ??

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E



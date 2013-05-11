Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42587 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3EKR32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 13:29:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Tim Eggleston <lists@timeggleston.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Defragmentation of large files
Date: Sat, 11 May 2013 19:29:23 +0200
Message-ID: <12672097.Q0ZsnGvI0N@merkaba>
In-Reply-To: <fa5698cdba14a3164f014a8c386bc837@mail.39.gs>
References: <7f41ae131c619b653da281429fcead79@mail.39.gs> <2041896.zZaOgtZsWg@merkaba> <fa5698cdba14a3164f014a8c386bc837@mail.39.gs>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 11. Mai 2013, 17:57:11 schrieb Tim Eggleston:
> > Yes. The command just triggers the defragmentation which takes place
> > in the
> > background. Try a "sync" afterwards :)
> 
> Sorry Martin, I should have specified that I wondered if it was like
> the scrub operation in that respect, so I left it several hours before
> running filefrag again (and seeing that the number of extents was
> unchanged). Top and iostat also don't report any particular activity
> immediately after running the defrag command, so it doesn't look like
> much if anything is happening.

Hmmm, thats strange. Last time I tried it here, it worked.
 
> By the way, this is on a filesystem mounted with -o autodefrag,
> although per the docs I wasn't expecting the auto defragmentation to
> work with the big VM images.

This worked here to some extent with Virtualbox images which quickly got up to 
several ten thousands extents.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

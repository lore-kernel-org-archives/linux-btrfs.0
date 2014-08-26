Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53273 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaHZMCP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 08:02:15 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Most recent stable enough btrfs-tools?
Date: Tue, 26 Aug 2014 14:02:09 +0200
Message-ID: <1633965.0Bemk8PY0Z@merkaba>
In-Reply-To: <8E53FA87-B774-44B0-83D0-EF651FB21BD4@colorremedies.com>
References: <2350809.UalJ0KWvmX@merkaba> <8E53FA87-B774-44B0-83D0-EF651FB21BD4@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 25. August 2014, 14:45:39 schrieb Chris Murphy:
> On Aug 25, 2014, at 6:00 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > What is the latest stuff that stills supposed to work okay?
> 
> I'm new to git so take this with a grain of salt, but this returns no
> differences:
> 
> git diff mason/master sterba/v3.16.x
> 
> So I'd say we're about to see a btrfs-progs released.
> 
> mason=git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> sterba=git://repo.or.cz/btrfs-progs-unstable/devel.git

Thanks, mason repo got updated since I last checked. I think I will try its 
current master.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

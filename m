Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33751 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933500AbaHYUpm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 16:45:42 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Most recent stable enough btrfs-tools?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2350809.UalJ0KWvmX@merkaba>
Date: Mon, 25 Aug 2014 14:45:39 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8E53FA87-B774-44B0-83D0-EF651FB21BD4@colorremedies.com>
References: <2350809.UalJ0KWvmX@merkaba>
To: Martin Steigerwald <Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2014, at 6:00 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> What is the latest stuff that stills supposed to work okay?

I'm new to git so take this with a grain of salt, but this returns no differences:

git diff mason/master sterba/v3.16.x

So I'd say we're about to see a btrfs-progs released.

mason=git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
sterba=git://repo.or.cz/btrfs-progs-unstable/devel.git


Chris Murphy
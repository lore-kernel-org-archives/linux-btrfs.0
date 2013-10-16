Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761299Ab3JPSaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 14:30:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VWVrA-00085S-4w
	for linux-btrfs@vger.kernel.org; Wed, 16 Oct 2013 20:30:04 +0200
Received: from g224090064.adsl.alicedsl.de ([92.224.90.64])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 20:30:04 +0200
Received: from tim by g224090064.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 20:30:04 +0200
To: linux-btrfs@vger.kernel.org
From: Tim Landscheidt <tim@tim-landscheidt.de>
Subject: Re: [PATCH] Btrfs: Don't allocate inode that is already in use
Date: Wed, 16 Oct 2013 17:26:00 +0000
Message-ID: <87k3hdt9ef.fsf@passepartout.tim-landscheidt.de>
References: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de>
	<525D8F79.80708@jan-o-sch.net>
	<20131015204148.GK11338@lenny.home.zabbo.net>
	<525E845D.70901@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:

> [...]

> You don't quote my second argument, which is not "just skip regression testing".
> I'll try again in other words: A regression test only makes sense if it can
> prevent us from making the same mistake again. As far as I see, the reproducer
> script is so specific, that the only thing it can prevent is an exact revert of
> Stefan's patch. If you argue that we should have a test for just this, fair
> enough, then we could use exactly Stefan's script. I don't think that gains us
> anything. We're not normally reverting bugfix patches deliberately, especially
> not for very short patches with very long descriptions.

> [...]

The presence of the bug in the current code indicates that
someone in the past made an error, and that suggests that
this error can be repeated (by someone else) for example in
a rewrite months or years in the future.  The purpose of a
regression test is to spare anyone who touches the code to
go through all the commits to see if they're unintentionally
reverting a bug fix, but give them a nice "FAIL"/"PASS"
traffic light.

Tim


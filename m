Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3JYNld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 09:41:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZhdr-0006PU-JR
	for linux-btrfs@vger.kernel.org; Fri, 25 Oct 2013 15:41:32 +0200
Received: from 63-245-179-205.ip.mtelco.net ([63-245-179-205.ip.mtelco.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 15:41:31 +0200
Received: from jgoerzen by 63-245-179-205.ip.mtelco.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 15:41:31 +0200
To: linux-btrfs@vger.kernel.org
From: John Goerzen <jgoerzen@complete.org>
Subject: rm with quotas can cause panic (was Re: Lots of trouble hanging when rm files with many extents)
Date: Fri, 25 Oct 2013 13:41:11 +0000 (UTC)
Message-ID: <loom.20131025T153858-104@post.gmane.org>
References: <20131020235118.3a918ba3@virtall.com> <5264A221.2020509@complete.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Goerzen <jgoerzen <at> complete.org> writes:

> 
> On 10/20/2013 09:51 AM, Tomasz Chmielewski wrote:
> > I'll do some more tests with lots of extents to see if it's
> > reproducible here as well.
> >
> >
> Interestingly, I've generally had qgroups enabled here as well, possibly 
> on all of these systems.  Could that be the culprit?


Updating the subject here, because it seems increasingly likely that quotas
are the problem causing OOM panics.

I was able to reproduce the problem on a test filesystem with quotas
enabled.  After quotas were disabled and the system was rebooted, the
problem no longer occurred.  The dangerous combination seems to be many
extents plus quotas.

Sadly, quotas are the only way to have btrfs keep track of how much space
subvols are using, so it's very useful to be able to use that feature.

I also noted this at https://bugzilla.kernel.org/show_bug.cgi?id=63071

John




Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767Ab3JOUly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 16:41:54 -0400
Date: Tue, 15 Oct 2013 13:41:48 -0700
From: Zach Brown <zab@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Don't allocate inode that is already in use
Message-ID: <20131015204148.GK11338@lenny.home.zabbo.net>
References: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de>
 <525D8F79.80708@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525D8F79.80708@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Probably a bit too obscure to turn this into  an xfstest? At least nobody
> complained so far, and this reproducer takes me 1m57 to run, so nothing I want
> in each xfstest cycle.

I disagree.  The entire point of regression tests is to trigger bugs
that the usual processes failed to find, like this one.

If you think that two minutes is too long for a test to run then mark it
as "stress" (is that the xfstests group for boring long running tests?)
or take the time to make a tighter test.

Don't just skip regression testing.  Please.

- z

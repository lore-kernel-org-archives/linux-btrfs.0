Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760809Ab3JPQq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 12:46:28 -0400
Date: Wed, 16 Oct 2013 09:46:22 -0700
From: Zach Brown <zab@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Don't allocate inode that is already in use
Message-ID: <20131016164622.GM11338@lenny.home.zabbo.net>
References: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de>
 <525D8F79.80708@jan-o-sch.net>
 <20131015204148.GK11338@lenny.home.zabbo.net>
 <525E845D.70901@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525E845D.70901@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Don't just skip regression testing.  Please.
> 
> You are mixing up my points. The first argument you're quoting is not against
> regression testing in this case, and it deserves the "stress" answer, I agree.

Great, then we're done.

(Yes, I'm very much ignoring your other argument that's based on your
predictions of what bugs will exist in the future and whether or not
tests will find them.)

- z

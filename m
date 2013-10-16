Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:49399 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPMTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 08:19:43 -0400
Message-ID: <525E845D.70901@jan-o-sch.net>
Date: Wed, 16 Oct 2013 14:19:41 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Don't allocate inode that is already in use
References: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de> <525D8F79.80708@jan-o-sch.net> <20131015204148.GK11338@lenny.home.zabbo.net>
In-Reply-To: <20131015204148.GK11338@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, October 15, 2013 at 22:41 (+0200), Zach Brown wrote:
>> Probably a bit too obscure to turn this into  an xfstest? At least nobody
>> complained so far, and this reproducer takes me 1m57 to run, so nothing I want
>> in each xfstest cycle.
> 
> I disagree.  The entire point of regression tests is to trigger bugs
> that the usual processes failed to find, like this one.
> 
> If you think that two minutes is too long for a test to run then mark it
> as "stress" (is that the xfstests group for boring long running tests?)
> or take the time to make a tighter test.
> 
> Don't just skip regression testing.  Please.

You are mixing up my points. The first argument you're quoting is not against
regression testing in this case, and it deserves the "stress" answer, I agree.

You don't quote my second argument, which is not "just skip regression testing".
I'll try again in other words: A regression test only makes sense if it can
prevent us from making the same mistake again. As far as I see, the reproducer
script is so specific, that the only thing it can prevent is an exact revert of
Stefan's patch. If you argue that we should have a test for just this, fair
enough, then we could use exactly Stefan's script. I don't think that gains us
anything. We're not normally reverting bugfix patches deliberately, especially
not for very short patches with very long descriptions.

I'd very much like to see a more generic test to avoid similar regressions, if
that can be created. I don't have a good plan how to trigger such a situation
(i.e. know which inodes are on the free_inode_pinned list) in a more general way.

-Jan

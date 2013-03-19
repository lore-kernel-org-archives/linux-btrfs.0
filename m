Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:45035 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab3CSTSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 15:18:00 -0400
Message-ID: <5148B9E5.5000702@jan-o-sch.net>
Date: Tue, 19 Mar 2013 20:17:57 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: xfs@oss.sgi.com, alex.btrfs@zadarastorage.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: add background noise to test 276 (btrfs backref
 resolving)
References: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net> <51489BD6.6030504@sandeen.net>
In-Reply-To: <51489BD6.6030504@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19.03.2013 18:09, Eric Sandeen wrote:
>> Furthermore, this increases two constants which make the test simply cycle a
>> few seconds longer, increasing the chance to hit on something suspicious in
>> case we broke something.
> 
> Normally we don't change existing tests lest new failures look like regressions
> when they aren't, but hey, "btrfs is an experimental filesystem" so maybe it's
> ok in this case.  ;)  At some point when things are settled down, we wouldn't
> want to make a change like this.  But for now it doesn't bother me.

(justification) I thought about adding this modification as a separate
test - and I have no strict objections against doing so. It's just that
I hate duplicating code and I couldn't think of a good way to share all
that code between two individual tests. Plus: We do need the new
version, because it shows backref walking in fact is currently broken,
while the old version would never fail where the new one wouldn't.

Thanks for taking a look!
-Jan

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35383 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004AbcHDUb5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 16:31:57 -0400
Received: by mail-oi0-f49.google.com with SMTP id 4so127582749oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 13:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57A372F3.5090400@5t9.de>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
 <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
 <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com> <57A372F3.5090400@5t9.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 4 Aug 2016 14:30:31 -0600
Message-ID: <CAJCQCtSFcJd+ac+Awfwuzdhuf8xjf8EgMQNwq_aV3udaZmZ=5A@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Lutz Vieweg <lvml@5t9.de>
Cc: "cheater00 ." <cheater00@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Russell Coker <russell@coker.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 4, 2016 at 10:53 AM, Lutz Vieweg <lvml@5t9.de> wrote:

> The amount of threads on "lost or unused free space" without resolutions
> in the btrfs mailing list archive is really frightening. If these
> symptoms commonly re-appear with no fix in sight, I'm afraid I'll have
> to either resort to using XFS (with ugly block-device based snapshots
> for backup) or try my luck with OpenZFS :-(

Keep in mind the list is rather self-selecting for problems. People
who aren't having problems are unlikely to post their non-problems to
the list.

It'll be interesting to see what other suggestions you get, but I see
it as basically three options in order of increasing risk+effort.

a. Try the clear_cache mount option (one time) and let the file system
stay mounted so the cache is recreated. If the problem happens soon
after again, try nospace_cache. This might buy you time before 4.8 is
out, which has a bunch of new enospc code in it.

b. Recreate the file system. For reasons not well understood, some
file systems just get stuck in this state with bogus enospc claims.

c. Take some risk and use 4.8 rc1 once it's out. Just make sure to
keep backups. I have no idea to what degree the new enospc code can
help well used existing systems already having enospc issues, vs the
code prevents the problem from happening in the first place. So you
may end up at b. anyway.


-- 
Chris Murphy

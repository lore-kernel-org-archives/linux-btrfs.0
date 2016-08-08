Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33922 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbcHHSit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 14:38:49 -0400
Received: by mail-qk0-f196.google.com with SMTP id x67so11728540qke.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 11:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
 <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Mon, 8 Aug 2016 21:38:28 +0300
Message-ID: <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
Subject: Re: Strange behavior after "rm -rf //"
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-08-08 20:13 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> Just a wild guess, the deletions may be in the tree log and haven't
> been applied to the other trees (fs tree, extent tree, etc). So yes
> I'd expect they get deleted on a rw mount.
>
> This is what kernel? Because kernel 4.6 offers mount option
> "nologreplay" which suggests even if you do mount -r that log replay
> happens, so you shouldn't see these deleted files unless you mount ro
> *and* use nologreplay mount option.

Live USB has kernel 4.5.7. Maybe I should try to run "btrfs rescue
zero-log" and then mount RW? Will the files safe in that case?

> Anyway, even 5 seconds of rm -rf damages too much. If you don't have
> recent snapshots then it's not sanely salvageable, just reinstall.

As I could see, almost all the "deleted" files are present. Certainly,
I'll make an rsync diff between two-week-ago snapshot and the current
FS state. But it will better if in-place recover without backup is
possible.

P.S. IMHO, log replay by default is a quite dangerous thing. I didn't
know about that change and I could lose all files if the live USB had
4.6 kernel))

-- 
Ivan Sizov (SIvan)

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lost.in.psyced.org ([188.40.42.221]:42701 "EHLO lo.psyced.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbbH0SoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 14:44:07 -0400
Received: from lo.psyced.org (localhost [127.0.0.1])
	by lo.psyced.org (8.14.3/8.14.3/Debian-9.4) with ESMTP id t7RIiGsm031805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 20:44:17 +0200
Received: (from lynx@localhost)
	by lo.psyced.org (8.14.3/8.14.3/Submit) id t7RIiGoh031804
	for linux-btrfs@vger.kernel.org; Thu, 27 Aug 2015 20:44:16 +0200
Date: Thu, 27 Aug 2015 20:44:15 +0200
From: carlo von lynX <lynX@time.to.get.psyced.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Impossible to mount two different copies of the same btrfs
Message-ID: <20150827184415.GA31439@lo.psyced.org>
References: <20150827173229.GA30068@lo.psyced.org>
 <CAJCQCtQx+L1JauS=cC1crPQDpOO+t5SqHAg8Z8Q6K5KPKPW6TQ@mail.gmail.com>
 <20150827175947.GL23769@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150827175947.GL23769@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the feedback. I thought I had bumped into a totally excentric
use case but really I am making a most average beginner's mistake. I
should have noticed when my thinking was in terms of rsync. btrfs-tune
would be the hack I first thought of, but I realize that is the wimp's
way to go.

So now I'm trying it the btrfs way. I made a fresh snapshot of the
current state, created a send file (one gig! ;)) from the previous
snapshot. Then I unmounted the source fs and mounted the dest copy.
Unfortunately I cannot 'btrfs receive' since I didn't have read-only
snapshots and making them from existing ones does not yield the same
parent ids.

Looks like I have to format a new target btrfs and start anew with
a full snapshot send... then at least I get to use a pipe instead of
storing the send on disk.  ;)



On Thu, Aug 27, 2015 at 05:59:47PM +0000, Hugo Mills wrote:
>    See my other email in this thread. :)

Didn't get that. Should I?


Kind regards for your patience and excellent code!


-- 
  E-mail is public! Talk to me in private using encryption:
         http://loupsycedyglgamf.onion/LynX/
          irc://loupsycedyglgamf.onion:67/lynX
         https://psyced.org:34443/LynX/

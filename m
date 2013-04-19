Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42120 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968179Ab3DSNwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 09:52:18 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BA5BF7C0692
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 07:52:16 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130419133250.GR4816@kernel.dk>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "neilb@suse.de" <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org> <20130419133250.GR4816@kernel.dk>
Message-ID: <20130419135214.30947.96188@localhost.localdomain>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Fri, 19 Apr 2013 09:52:14 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Jens Axboe (2013-04-19 09:32:50)
> > 
> > No wonder this thing crashes.  Chris, can't the original bio carry
> > bbio in bi_private and let end_bio_extent_readpage() free the bbio
> > instead of abusing bi_bdev like this?
> 
> Ugh, wtf.
> 
> Chris, time for a swim in the bay :-)

Yeah, I can't really defend this one.  We needed a space for an int and
I assumed end_io meant the FS was free to do horrible things.

Really though, I'll just take a quick dip in the lake and patch this out
of btrfs. 

Jan is probably right about changing around our endio callbacks to
explicitly pass the mirror, it should be less complex and cleaner.

Many thanks to everyone here that tracked it down.

-chris

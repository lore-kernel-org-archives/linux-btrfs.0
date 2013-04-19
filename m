Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52566
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030254Ab3DSNcH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 09:32:07 -0400
Date: Fri, 19 Apr 2013 06:31:36 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>, namhyung@gmail.com,
        agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130419133016.GQ4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk>
 <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org>
 <20130419061755.GC9691@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130419061755.GC9691@mtj.dyndns.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 18 2013, Tejun Heo wrote:
> On Thu, Apr 18, 2013 at 10:57:54PM -0700, Tejun Heo wrote:
> > No wonder this thing crashes.  Chris, can't the original bio carry
> > bbio in bi_private and let end_bio_extent_readpage() free the bbio
> > instead of abusing bi_bdev like this?
> 
> BTW, I think it's a bit too late to fix this properly from btrfs side
> unless we're gonna do -rc8, so let's revert the TP patch for now and
> sort this out in the next devel cycle.  AFAICS, while disturbingly
> (ha|yu)cky, the bi_bdev trick should be okay without the new TP.

The tracing commit was already backed out yesterday, so no problems
there. I figured it'd be a bit too late to fix something this nasty in a
suitably clean and straight forward fashion.

-- 
Jens Axboe


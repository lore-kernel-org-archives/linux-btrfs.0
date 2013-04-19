Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab3DSG3o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 02:29:44 -0400
Message-ID: <5170E46C.50702@cn.fujitsu.com>
Date: Fri, 19 Apr 2013 14:30:04 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
References: <516E5EF8.9090507@cn.fujitsu.com> <1366209997.8817.12.camel@pippen.local.home> <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com> <20130419055754.GA9691@mtj.dyndns.org> <20130419061755.GC9691@mtj.dyndns.org>
In-Reply-To: <20130419061755.GC9691@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/19/2013 02:17 PM, Tejun Heo wrote:
> On Thu, Apr 18, 2013 at 10:57:54PM -0700, Tejun Heo wrote:
>> No wonder this thing crashes.  Chris, can't the original bio carry
>> bbio in bi_private and let end_bio_extent_readpage() free the bbio
>> instead of abusing bi_bdev like this?
> 
> BTW, I think it's a bit too late to fix this properly from btrfs side
> unless we're gonna do -rc8, so let's revert the TP patch for now and
> sort this out in the next devel cycle.  AFAICS, while disturbingly
> (ha|yu)cky, the bi_bdev trick should be okay without the new TP.

Thank you for investigating this. And sorry for my incompleted panic picture
before that let you detour. :-(

Regards,
Wanlong Gao

> 
> Thanks.
> 


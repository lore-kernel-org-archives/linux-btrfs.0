Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:46881 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab3EGGIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 02:08:15 -0400
Message-ID: <51889A4D.8000201@jan-o-sch.net>
Date: Tue, 07 May 2013 08:08:13 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx>
In-Reply-To: <3egl5a-al5.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 22:29 (+0200), Kai Krakow wrote:
> Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:
> 
>> That one should be fixed in btrfs-next. If you can reliably reproduce the
>> bug I'd be glad to get a confirmation - you can probably even save putting
>> it on bugzilla then ;-)
> 
> I can reliably reproduce it from two different approaches. I'd like to only 
> apply the commits fixing it. Can you name them here?

In git log order:

6ced2666 Btrfs: separate sequence numbers for delayed ref tracking and tree mod log
ef9120b1 Btrfs: fix tree mod log regression on root split operations
2ed098ca Btrfs: fix accessing the root pointer in tree mod log functions
50723551 Btrfs: fix unlock after free on rewinded tree blocks

The commit ids are from josef's master branch
(git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git) which is
known not to be very stable regarding commit ids.

Thanks,
-Jan

>>> [snip]

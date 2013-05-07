Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50335 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759334Ab3EGVSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 17:18:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZpHD-0006lT-NU
	for linux-btrfs@vger.kernel.org; Tue, 07 May 2013 23:18:23 +0200
Received: from dyndsl-178-142-088-157.ewe-ip-backbone.de ([178.142.88.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 23:18:23 +0200
Received: from hurikhan77+btrfs by dyndsl-178-142-088-157.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 May 2013 23:18:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: hard freezes with 3.9.0 during io-intensive loads
Date: Tue, 07 May 2013 23:16:03 +0200
Message-ID: <ch7o5a-g0b.ln1@hurikhan.ath.cx>
References: <6moh5a-knf.ln1@hurikhan.ath.cx> <2sci5a-n8p.ln1@hurikhan.ath.cx> <5187700F.20807@jan-o-sch.net> <3egl5a-al5.ln1@hurikhan.ath.cx> <51889A4D.8000201@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:

>> I can reliably reproduce it from two different approaches. I'd like to
>> only apply the commits fixing it. Can you name them here?
> 
> In git log order:
> 
> 6ced2666 Btrfs: separate sequence numbers for delayed ref tracking and
> tree mod log ef9120b1 Btrfs: fix tree mod log regression on root split
> operations 2ed098ca Btrfs: fix accessing the root pointer in tree mod log
> functions 50723551 Btrfs: fix unlock after free on rewinded tree blocks
> 
> The commit ids are from josef's master branch
> (git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git) which
> is known not to be very stable regarding commit ids.

Thanks, applied almost cleanly to 3.9.0 vanilla with just one reject. And 
that was for some error message. I'm simply ignoring that and currently 
compiling it.

I will get back here with the result (fixed or not fixed for one or both 
situations).

Regards,
Kai


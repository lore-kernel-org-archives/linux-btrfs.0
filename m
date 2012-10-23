Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:19748 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756708Ab2JWStg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 14:49:36 -0400
Received: from 168.139.79.188.dynamic.jazztel.es ([188.79.139.168] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TQjXk-000MRM-0x
	for linux-btrfs@vger.kernel.org; Tue, 23 Oct 2012 18:49:36 +0000
Date: Tue, 23 Oct 2012 20:49:32 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Between single/dup and raid1/raid1
Message-ID: <20121023184932.GK2052@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

today I wanted to remove one drive from raid1, and people at #btrfs advised me
to use '-dconvert=single' before 'btrfs device delete'.

I thought of adding '-mconvert=dup' too, but the kernel does not let me do that.

It looks like 'dup' is disallowed for an array of multiple devices. So, to go
back to a single-drive (single/dup) setup, should I go through having the
metadata with 'single' profile?

I can't use 'btrfs device delete' either, because that wouldn't respesct the
raid1 profile.

Maybe then the easiest I could do is to use the computer degraded, until I get
some new disk in some days? That'd be equivalent to metadata=single, as I
understand.

And having a totally new disk, having removed the broken one, I'd have to:
1) mount degraded
2) btrfs device delete the missing disk (will I be allowed? due to raid1 profile)
3) btrfs device add another disk

Should that work?

Regards,
Lluís.

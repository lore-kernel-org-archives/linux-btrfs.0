Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:60119 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbACQTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 11:19:42 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID lutz.euler@freenet.de) (port 25) (Exim 4.82 #2)
	id 1Y7RQS-000237-3Y
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 17:19:40 +0100
Received: from localhost ([::1]:39267 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.82 #2)
	id 1Y7RQR-0005XM-UR
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 17:19:39 +0100
Received: from mx11.freenet.de ([195.4.92.21]:42445)
	by mjail2.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.82 #2)
	id 1Y7RNr-0005JQ-NK
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 17:16:59 +0100
Received: from p548f9fdd.dip0.t-ipconnect.de ([84.143.159.221]:48004 helo=lutz)
	by mx11.freenet.de with esmtpsa (ID lutz.euler@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.82 #2)
	id 1Y7RNr-0007jP-Hq
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 17:16:59 +0100
Received: from lutz by lutz with local (Exim 4.74)
	(envelope-from <lutz.euler@freenet.de>)
	id 1Y7RNq-0001sL-Pb
	for linux-btrfs@vger.kernel.org; Sat, 03 Jan 2015 17:16:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21672.5626.768161.965976@localhost.localdomain>
Date: Sat, 3 Jan 2015 17:16:58 +0100
From: lutz.euler@freenet.de (Lutz Euler)
To: linux-btrfs@vger.kernel.org
Subject: Re: fstrim not working on one of three BTRFS filesystems
In-Reply-To: <2085969.4UDoZBNBiV@merkaba>
References: <3979684.puYLD8DjTq@merkaba>
	<2085969.4UDoZBNBiV@merkaba>
	<21672.2859.468940.450115@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald wrote:

> I have a 3.19-rc2 with a patch and a working fstrim now:
[...]
> I leave it to the patch author to come up with it on the mailing list :)

That would be me. I have just sent in the patch; please see
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40618.html

For a discussion about the issue that goes into more detail than the
commit message and the code comments please see this thread:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/15597
At that time I had sent in a first version of this patch but it has not
been applied so far. I made the new version as the old one did not apply
any more since about kernel 3.9., and had a flaw (range->minlen was
being ignored).

I am using this patch on my system since two years without problems with
kernel versions ranging from 3.3 to 3.16.

Looking forward to a review,

Lutz Euler

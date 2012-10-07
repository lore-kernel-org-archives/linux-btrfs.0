Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:16730 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2JGNTR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 09:19:17 -0400
Message-ID: <50718151.8090506@petaramesh.org>
Date: Sun, 07 Oct 2012 15:19:13 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Alex <alex@bpmit.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org>
In-Reply-To: <loom.20121007T141248-114@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again ;-)
Le 07/10/2012 14:33, Alex a écrit :
>
> 1. Convert to a 16k or 32k leafsize.
How should I do this ? Can I do this on a live FS, and isn't this going
to double my on-disk used space (I have active snapshots...)
> 2. defragment (each non-trivial file) every now and again
I believed that the "autodefrag" mount option was supposed to avoid the
need for manual defrags...?

Plus, with respect to snapshots, isn't this going to increase a lot my
used disk space ?

> 3. Note that btrfs in kernel 3.6 (vs 3.5) does appear to be quite a bit quicker.
I'm not sure that "a bit" quicker will be enough, when I see my BTRFS is
currently about 8x slower than what ext4 user to...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:40585 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbKKO06 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 09:26:58 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout2.netcologne.de (Postfix) with ESMTP id 8FFE211FF9
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 15:17:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 89EAF11D91
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 15:17:19 +0100 (CET)
Received: from [194.8.193.239] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 56434def-0ac8-7f0000012729-7f000001d2b8-1
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 15:17:19 +0100
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 15:17:19 +0100 (CET)
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
To: linux-btrfs@vger.kernel.org
References: <55E6CF72.5070005@netcologne.de>
 <20150902113021.GD11358@carfax.org.uk> <55E6F51B.3000007@netcologne.de>
 <pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
 <55E95625.2030406@netcologne.de>
 <pan$11297$845af192$4bee50bd$587fb5f7@cox.net>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56434DEF.9070807@netcologne.de>
Date: Wed, 11 Nov 2015 15:17:19 +0100
MIME-Version: 1.0
In-Reply-To: <pan$11297$845af192$4bee50bd$587fb5f7@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the late reply to this list regarding this topic
...

On 09/04/2015 01:04 PM, Duncan wrote:
> And of course, only with 4.1 (nominally 3.19 but there were initial 
> problems) was raid6 mode fully code-complete and functional -- before 
> that, runtime worked, it calculated and wrote the parity stripes as it 
> should, but the code to recover from problems wasn't complete, so you 
> were effectively running a slow raid0 in terms of recovery ability, but 
> one that got "magically" updated to raid6 once the recovery code was 
> actually there and working.

As other who write to this ML, I run into crashes when trying to do a
balance of my filesystem.
I moved through the different kernel versions and btrfs-tools and am
currently running Kernel 4.3 + 4.3rc1 of the tools but still after like
an hour of balancing (and actually moving chunks) the machine crashes
horribly without giving any good stack trace or anything in the kernel
log which I could report here :(

Any ideas on how I could proceed to get some usable debug info for the
devs to look at?


> So I'm guessing you have some 8-strip-stripe chunks at say 20% full or 
> some such.  There's 19.19 data TiB used of 22.85 TiB allocated, a spread 
> of over 3 TiB.  A full nominal-size data stripe allocation, given 12 
> devices in raid6, will be 10x1GiB data plus 2x1GiB parity, so there's 
> about 3.5 TiB / 10 GiB extra stripes worth of chunks, 350 stripes or so, 
> that should be freeable, roughly (the fact that you probably have 8-
> strip, 12-strip, and 4-strip stripes, on the same filesystem, will of 
> course change that a bit, as will the fact that four devices are much 
> smaller than the other eight).

The new devices have been in place for while (> 2 months) now, and are
barely used. Why is there not more data being put onto the new disks?
Even without a balance new data should spread evenly across all devices
right? From the IOPs I can see that only the 8 disks which always have
been in the box are doing any heavy lifting and the new disks are mostly
idle.

Anything I could do to narrow down where a certain file is stored across
the devices?






Regards

Christian

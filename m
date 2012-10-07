Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44344 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2JGMeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Oct 2012 08:34:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TKq3X-0003Vk-FU
	for linux-btrfs@vger.kernel.org; Sun, 07 Oct 2012 14:34:03 +0200
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2012 14:34:03 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2012 14:34:03 +0200
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 12:33:43 +0000 (UTC)
Message-ID: <loom.20121007T141248-114@post.gmane.org>
References: <50714AC8.4010100@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh <swami <at> petaramesh.org> writes:

> 
> Hi,
> 
> I have 4 machines, all converted to BTRFS about 6 months ago, now all
> running Ubuntu Quantal with kernel 3.5.0-17


1. Convert to a 16k or 32k leafsize.
2. defragment (each non-trivial file) every now and again [eg. find / -size +16k
-type f -exec btrfs filesystem defragment -vf '{}' ';' ]
3. Note that btrfs in kernel 3.6 (vs 3.5) does appear to be quite a bit quicker.
I'm running Siduction kernels whilst Debian is on freeze at 3.2. I found 3.5
really quite awful - not sure why.

Make sure you discount other factors.

I'm not sure defrag goes so far as to consolidate files by moving bits out of
the way yet, so you may find that the number of fragments in a file never
reaches one.

Bear with it pls.




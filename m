Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbbAWOiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 09:38:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YEfNH-0004Ca-Vs
	for linux-btrfs@vger.kernel.org; Fri, 23 Jan 2015 15:38:16 +0100
Received: from p4ff584a0.dip0.t-ipconnect.de ([79.245.132.160])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 15:38:15 +0100
Received: from holger.hoffstaette by p4ff584a0.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 15:38:15 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.19-rc5: Bug 91911: [REGRESSION] rm command hangs big time
 with deleting a lot of files at once
Date: Fri, 23 Jan 2015 14:38:09 +0000 (UTC)
Message-ID: <pan.2015.01.23.14.38.09@googlemail.com>
References: <2506104.3YBgc9qdaM@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 23 Jan 2015 15:01:28 +0100, Martin Steigerwald wrote:

> Hi!
> 
> Anyone seen this?
> 
> Reported as:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=91911

You might be interested in:

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?h=evict-softlockup&id=29249e14d6e3379a5c4bb098dd4beddfefbc606f

and

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?h=evict-softlockup&id=e4a58b71ff981b098ac3371f4d573dc6a90006ce

I'm sure everyone would love to hear how this works out for you ;-)

-h


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:60724 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaHUVZR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 17:25:17 -0400
Date: Thu, 21 Aug 2014 14:25:17 -0700
From: Zach Brown <zab@zabbo.net>
To: Klaus Holler <kho@gmx.at>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0 and
 btrfs-progs 3.14.2
Message-ID: <20140821212517.GE7116@lenny.home.zabbo.net>
References: <53F0A3B2.80709@gmx.at>
 <20140819221055.GI429@lenny.home.zabbo.net>
 <20140819222241.GD31558@carfax.org.uk>
 <53F64274.6090008@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F64274.6090008@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 09:03:16PM +0200, Klaus Holler wrote:
> Hello Hugo and Zach!
> 
> a big thanks to both of you!
> 
> Both Hugo's userspace workaround and
> Zach's patch work fine for me - the /boot snapshot can be restored
> completely as expected :-)

Cool, glad to hear it.  I sent a proper patch to the list and added your
reported-by and tested-by, hope that's OK.

- z

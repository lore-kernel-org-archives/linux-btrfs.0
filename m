Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:41766 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaBZKpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 05:45:13 -0500
Date: Wed, 26 Feb 2014 11:38:58 +0100
From: Sander <sander@humilis.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Marcus Sundman <sundman@iki.fi>, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>, Jim Salter <jim@jrs-s.net>
Subject: Re: No space left on device (again)
Message-ID: <20140226103857.GA31173@panda>
Reply-To: sander@humilis.net
References: <530CC9B0.1080703@iki.fi>
 <530CDB7F.9020807@jrs-s.net>
 <20140225201921.GB13899@carfax.org.uk>
 <530CFCCE.5060707@iki.fi>
 <530CFD66.7060006@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530CFD66.7060006@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote (ao):
> The -dusage=<number> is a means to an end, so if that doesn't work try
> a larger number, up to 100.  Really once you pass 50 and it's not
> working then it's time to just do a balance.  The next thing is to use
> compression (too late for this option really) or add another disk.

btrfs filesystem defragment -vrc /home/

would apply compression to all files, no?

	Sander

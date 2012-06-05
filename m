Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2FEWR4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 18:17:56 -0400
Date: Tue, 5 Jun 2012 15:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
Message-Id: <20120605151754.a794ac7c.akpm@linux-foundation.org>
In-Reply-To: <1338934303.5780.8.camel@joe2Laptop>
References: <cover.1338889066.git.joe@perches.com>
	<20120605142826.d92316a0.akpm@linux-foundation.org>
	<1338934303.5780.8.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 05 Jun 2012 15:11:43 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-06-05 at 14:28 -0700, Andrew Morton wrote:
> > Unfortunately the <n> thing is part of the kernel ABI:
> > 
> > 	echo "<4>foo" > /dev/kmsg
> 
> Which works the same way it did before.

I didn't say it didn't.

What I did say is that echo "\0014">/dev/kmsg will subvert the intent
of the new logging code.  Or might.  But you just ignored all that,
forcing me to repeat myself, irritatedly.



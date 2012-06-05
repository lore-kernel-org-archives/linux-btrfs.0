Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:58793 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545Ab2FEWtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jun 2012 18:49:35 -0400
Message-ID: <1338936572.5780.29.camel@joe2Laptop>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 05 Jun 2012 15:49:32 -0700
In-Reply-To: <20120605151754.a794ac7c.akpm@linux-foundation.org>
References: <cover.1338889066.git.joe@perches.com>
	 <20120605142826.d92316a0.akpm@linux-foundation.org>
	 <1338934303.5780.8.camel@joe2Laptop>
	 <20120605151754.a794ac7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-06-05 at 15:17 -0700, Andrew Morton wrote:
> On Tue, 05 Jun 2012 15:11:43 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Tue, 2012-06-05 at 14:28 -0700, Andrew Morton wrote:
> > > Unfortunately the <n> thing is part of the kernel ABI:
> > > 
> > > 	echo "<4>foo" > /dev/kmsg
> > 
> > Which works the same way it did before.
> 
> I didn't say it didn't.
> 
> What I did say is that echo "\0014">/dev/kmsg will subvert the intent
> of the new logging code.  Or might.  But you just ignored all that,
> forcing me to repeat myself, irritatedly.

It works the same way before and after the patch.

Any write to /dev/kmsg without a KERN_<LEVEL>
emits at (1 << 3) + KERN_DEFAULT.

Writes with <n> values >= 8 are emitted at
that level.



Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKYLad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 06:30:33 -0500
Date: Tue, 25 Nov 2014 19:30:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125113023.GD23574@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416859665.3019.6@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
> On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >This brings a strong-but-slow checksum algorithm, sha256.
> >
> >Actually btrfs used sha256 at the early time, but then moved to
> >crc32c for
> >performance purposes.
> >
> >As crc32c is sort of weak due to its hash collision issue, we need
> >a stronger
> >algorithm as an alternative.
> >
> >Users can choose sha256 from mkfs.btrfs via
> >
> >$ mkfs.btrfs -C 256 /device
> 
> Agree with others about -C 256...-C sha256 is only three letters more ;)

That's right, #stupidme

> 
> What's the target for this mode?  Are we trying to find evil people
> scribbling on the drive, or are we trying to find bad hardware?

This is actually inspired by ZFS, who offers checksum functions ranging
from the simple-and-fast fletcher2 to the slower-but-secure sha256.

Back to btrfs, crc32c is the only choice.

And also for the slowness of sha256, Intel has a set of instructions for
it, "Intel SHA Extensions", that may help a lot.

Not insisting on it, I'm always open to any suggestions.

Btw, having played with merkle tree for a while, however, making good use
of our existing scrub looks more promising for implemening the feature
that detects changes between mounts. 

thanks,
-liubo

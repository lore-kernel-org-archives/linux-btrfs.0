Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56519 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2JVUY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:24:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TQOYa-0003N6-4w
	for linux-btrfs@vger.kernel.org; Mon, 22 Oct 2012 22:25:04 +0200
Received: from ip-178-203-145-21.unitymediagroup.de ([178.203.145.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 22:25:04 +0200
Received: from andred by ip-178-203-145-21.unitymediagroup.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 22:25:04 +0200
To: linux-btrfs@vger.kernel.org
From: Andre Diekwisch <andred@mail.upb.de>
Subject: Re: [PATCH v2] Btrfs-progs: fix unaligned accesses
Date: Mon, 22 Oct 2012 20:19:56 +0000 (UTC)
Message-ID: <loom.20121022T201206-609@post.gmane.org>
References: <1350830073-20944-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille <at> gmx.net> writes:

> 
> There are some unaligned accesses in progs that cause malfunction or
> crashes on ARM.
> This patch fixes the ones we stumbled upon.
> 
> Signed-off-by: Arne Jansen <sensille <at> gmx.net>
> ---
> 
> Change v1->v2:
> Somehow sent the wrong patch without the patch to the setget functions.


Hello,

I reported these unaligned accesses originally and tested this patch on an ARMv5
kirkwood device using a 3.6.2 kernel.
I set /proc/cpu/alignment to 5 (signal+warn), and got no signals anymore using
this patch. I tested mkfs.btrfs, sub list and sub find-new (which all signalled
before the patch) and additionally inspect-internal inode-resolve and btrfsck.

None of them signalled or showed any other issues.
tested-by: Andre Diekwisch <andred <at> mail.upb.de>


Thanks a lot Arne, this patch finally renders btrfs-progs usable on an
ARM-machine without enabling unaligned access trapping for userspace.
I'll report back should I run into more issues regarding unaligned accesses.

Hope this patch gets accepted.


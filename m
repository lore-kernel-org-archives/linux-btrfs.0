Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40422 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbbDWNxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 09:53:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlHZJ-0005mb-1A
	for linux-btrfs@vger.kernel.org; Thu, 23 Apr 2015 15:53:29 +0200
Received: from p4ff58852.dip0.t-ipconnect.de ([79.245.136.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 15:53:28 +0200
Received: from holger.hoffstaette by p4ff58852.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 15:53:28 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
Date: Thu, 23 Apr 2015 13:53:22 +0000 (UTC)
Message-ID: <pan.2015.04.23.13.53.22@googlemail.com>
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
	<pan.2015.04.23.12.16.21@googlemail.com> <5538E6C7.9050201@suse.com>
	<pan.2015.04.23.13.22.23@googlemail.com> <5538F70C.5040004@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Apr 2015 14:43:40 +0100, Filipe Manana wrote:

> I don't think a lock followed by unlock without nothing in between (be
> it a spinlock, mutex, or any other kind of lock) will be seen by the
> compiler as a nop. Pretty sure I've seen this pattern being done in the

No, I didn't say they would - that would be wrong. I just found it odd,
that's all.

> kernel and in many other places as mechanism to wait for something.

I also completely forgot that spinlocks disable preemption, since
otherwise nothing would really work. That's the real reason why
any of this works. Well, that and the refcount==2 thing.

Cool! Thanks!
Holger


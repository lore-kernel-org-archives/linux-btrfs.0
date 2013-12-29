Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56193 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037Ab3L2AIi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 19:08:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAELSAVbwcwcQKEjBA6NhYxTRjC3D=pEPF+fJiyz=xfG0w5wBCg@mail.gmail.com>
Date: Sat, 28 Dec 2013 17:08:34 -0700
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F157CCF8-D8E4-473A-9FF6-E3DEFD16235F@colorremedies.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com> <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com> <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com> <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com> <EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com> <CAELSAVbwcwcQKEjBA6NhYxTRjC3D=pEPF+fJiyz=xfG0w5wBCg@mail.gmail.com>
To: Emil Karlson <jekarlson@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 28, 2013, at 4:55 PM, Emil Karlson <jekarlson@gmail.com> wrote:

>> In my case, I'm unable to reproduce the problem. I get the same sha256sum of an existing 16M journal file (in the read only snapshot) as I do in the send/received snapshot. The difference is the original is compromised of 1976 extents, while the received is in a single extent.
> 
> Was the send incremental?

Oops no, and I bet that's the difference. So you are doing an incremental send/receive using -p? I've only done incremental snapshots with send -p while also using -f to write to a file; not through btrfs receive.


Chris Murphy


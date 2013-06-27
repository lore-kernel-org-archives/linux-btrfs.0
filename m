Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51365 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3F0PjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 11:39:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 65A3F9A0697
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 09:39:00 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130627151922.GA1438@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130627145824.GA21540@redhat.com>
 <20130627150130.14981.39849@localhost.localdomain>
 <20130627151922.GA1438@redhat.com>
Message-ID: <20130627153857.14981.14731@localhost.localdomain>
Subject: Re: btrfs triggered lockdep WARN.
Date: Thu, 27 Jun 2013 11:38:57 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Jones (2013-06-27 11:19:22)
> On Thu, Jun 27, 2013 at 11:01:30AM -0400, Chris Mason wrote:
>  > Quoting Dave Jones (2013-06-27 10:58:24)
>  > > Another bug caused by this script. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
>  > 
>  > I'm still struggling to reproduce that one here.  I've tried every
>  > variation I can think of but I'll try again.
>  
> Note that this is a different trace to the other post about that script.

Yeah, but I haven't hit anything unusual at all yet.

> 
>  > I really hope you don't already have CONFIG_DEBUG_PAGE_ALLOC turned on,
>  > maybe it will catch this?
> 
> I do. Though given this is lockdep complaining about what looks like
> memory corruption, it's probably not related.

Ok, could you please try this with some heavy memory pressure?  I'm
hoping to trigger a use-after-free that points us in the right
direction.

-chris


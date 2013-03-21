Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46617 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CUR6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 13:58:22 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D812C7C0645
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 11:58:21 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: "dsterba@suse.cz" <dsterba@suse.cz>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <JBacik@fusionio.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130321134950.GI31559@twin.jikos.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Simon Kirby <sim@hostway.ca>
References: <20130319224123.GA4779@hostway.ca> <20130321134950.GI31559@twin.jikos.cz>
Message-ID: <20130321175819.30044.75697@localhost.localdomain>
Subject: Re: [PATCH v2] Btrfs: Include the device in most error printk()s
Date: Thu, 21 Mar 2013 13:58:19 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-03-21 09:49:50)
> On Tue, Mar 19, 2013 at 03:41:23PM -0700, Simon Kirby wrote:
> > Use btrfs_printk(fs_info, format, ...) rather than writing the device
> > string every time, and introduce macro wrappers ala XFS for brevity.
> > Since the function already cannot be used for continuations, print a
> > newline as part of the btrfs_printk() message rather than at each caller.
> 
> Josef, some the patches I've sent yestreday are in conflict with this
> patch, please drop them and I'll resend when this patch is merged.

I really like this patch, but we're going to have to sit on it until the
next merge window.  It's fairly large and we need to stick with things
that are more clearly bug fixes for now.

But, I don't have a problem with queuing it into linux-next.  After the
next rc we can get Josef's tree into the full linux-next for more
testing.

-chris


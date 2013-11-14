Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59944 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3KNR2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 12:28:15 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 407897C0425
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 10:28:15 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.cz>
From: Chris Mason <chris.mason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Message-ID: <20131114172808.3802.43967@localhost.localdomain>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Thu, 14 Nov 2013 12:28:08 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-11-14 07:41:21)
> On Fri, Nov 08, 2013 at 05:01:35PM -0500, Chris Mason wrote:
> > The patch below switches our default mkfs leafsize up to 16K.  This
> > should be a better choice in almost every workload, but now is your
> > chance to complain if it causes trouble.
> 
> We should also turn the extended refs on by default now, it's been
> around since 3.7, I'm not expecting backward compatibility issues in
> general.

[ Sorry for the empty reply on the patch itself, fat fingered the quit
when I decided to reply here instead ]

This is pushed out now, thanks Dave!

-chris


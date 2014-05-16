Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366AbaEPPR3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 11:17:29 -0400
Date: Fri, 16 May 2014 17:17:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/3] btrfs-progs: add quota group verify to btrfsck
Message-ID: <20140516151728.GY6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 01:07:14PM -0700, Mark Fasheh wrote:
> The first two patches set up for qgroups:
> 
> - The change in patch #1 is optional. It corrects the print of qgroup bytes
> to be %llu as they are unsigned values.  This means however that corrupted
> groups will no longer show a negative value but instead an unrealistically
> large one.  It's my opinion that '-1' and '18446744073709551615' both look
> pretty obviously broken when put in 'qgroup show' output so I'm going for
> correctness. Here's the difference in output:

> 0/257    4109430784 -1429504             
> 0/257    4109430784 18446744073708122112 

Fair enough.

> There's a minor issue in that we'll also print out qgroups for deleted
> subvolumes as they still persist on disk (not shown here). I'm pretty sure
> we can fix that with a followup patch to just check them against existing
> subvolumes when we initially read our qgroup info from disk.

I think the report from deleted subvols can help debugging, keep it
there. We may decide to move it under its own option.

Patches added to integration, thanks.

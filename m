Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbaKRRXY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 12:23:24 -0500
Date: Tue, 18 Nov 2014 18:23:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org, Christian Hesse <mail@eworm.de>
Subject: Re: [btrfs-progs] cmds-restore.c:182:20: warning: array subscript is
 above array bounds [-Warray-bounds]
Message-ID: <20141118172323.GB7166@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan$7e207$ad1fefbf$2a4c2d19$75d64f5f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$7e207$ad1fefbf$2a4c2d19$75d64f5f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 09, 2014 at 03:54:56AM +0000, Duncan wrote:
> A bit more context:
> 
> cmds-restore.c: In function 'next_leaf':
> cmds-restore.c:182:20: warning: array subscript is above array bounds
> [-Warray-bounds]
>   slot = path->slots[level] + 1;
>                     ^

Thanks. We've seen that before and were not able to find why the
compiler thinks it could overflow, see the dicussion here:

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34338.html

I'll probably merge Christian's patch so the warning goes away.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbaD3NBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 09:01:36 -0400
Date: Wed, 30 Apr 2014 15:01:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14] Enhanced df - followup
Message-ID: <20140430130134.GL5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
> To users familiar with Unix/POSIX/Linux CLI, "usage" (as --usage) is most 
> often seen as a rather less common and generally briefer form of --help, 
> usually with the distinction being that --help may be a screen or more of 
> output, while --usage is much shorter, perhaps a single line.

I did a quick check of ~20 randomly chosen binaries in /usr/bin and none
of them had --usage among options, unlike --help.

> While I had seen it listed in manpages and --help output often enough, 
> once I actually went looking for real examples I had a hard time finding 
> some, but eventually found some in the grub (grub2) command set.

We can put usage examples to the man pages, following git here.

> OTOH, for CLI veterans anyway, standard old "du" (btrfs fi du) should be 
> as immediately understood as "df".

> Given that confusion, I'd suggest either simply making it du, or making 
> it "device_usage" but with "du" a documented alias printing exactly the 
> same output, thus giving folks an easy way to avoid the _.

Though adding a command alias is trivial, I'd rather not do that right
now. Let's see if we can live with 'btrfs fi us'. I worked for me during
developing the patch series.

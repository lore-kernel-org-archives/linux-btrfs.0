Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbaFCQw1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 12:52:27 -0400
Date: Tue, 3 Jun 2014 18:52:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Hesse <mail@eworm.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140603165225.GR22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401794959-25907-1-git-send-email-mail@eworm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 01:29:19PM +0200, Christian Hesse wrote:
> gcc 4.9.0 gives a warning: array subscript is above array bounds
> 
> Checking for "greater or equal" instead of just "equal" fixes this.

That fixes the warning, but I don't see the code path that leads to
 level >= BTRFS_MAX_LEVEL

On the first pass, when level = 1 and the first while() reaches at most
BTRFS_MAX_LEVEL, the equality test is enough. So it has to go through
the second while() where level is decremented and in the range
[1..BTRFS_MAX_LEVEL-1] before 'goto again' jumps to the first while
again.

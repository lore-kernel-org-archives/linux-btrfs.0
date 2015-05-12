Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467AbbELNEG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 09:04:06 -0400
Date: Tue, 12 May 2015 15:04:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
Message-ID: <20150512130404.GY23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
 <pan.2015.04.23.12.16.21@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2015.04.23.12.16.21@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 12:16:21PM +0000, Holger Hoffstätte wrote:
> After staring at this (and the Lovecraftian horrors of free_extent_buffer())
> for over an hour and trying to understand how and why this could even remotely
> work, I cannot help but think that this fix would shift the race to the much
> smaller window between the test_bit and the first spin_lock.

Btw, I had exactly the same concerns, as this is close to the classical
example of a shared resource check outside of the critical section. But
the extent buffers are protected by more than just the spinlock and if
the race mentioned above happens, the lifted reference counts will
prevent to drop the last one.

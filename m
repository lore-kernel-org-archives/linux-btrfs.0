Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab3GCVMC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 17:12:02 -0400
Date: Wed, 3 Jul 2013 23:12:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs-progs: add missing write check for mkfs
Message-ID: <20130703211200.GS18204@suse.cz>
Reply-To: dsterba@suse.cz
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
 <1372593106-6593-2-git-send-email-fdmanana@gmail.com>
 <20130703170959.GQ18204@twin.jikos.cz>
 <CAL3q7H6s-7Qk_CFXeSpb94YZUuDOTSDOBh6CjUcAUMYc4smtMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6s-7Qk_CFXeSpb94YZUuDOTSDOBh6CjUcAUMYc4smtMA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 03, 2013 at 06:25:59PM +0100, Filipe David Manana wrote:
> > Also, replacing the BUG_ON with something else would be nice of course.
> 
> If you don't mind, I would prefer to do that as a different patch,
> since the BUG_ON() use is what is currently done everywhere in this
> function at least.

Yes, separate patch.

thanks,
david

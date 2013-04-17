Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3DQQ5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 12:57:04 -0400
Date: Wed, 17 Apr 2013 18:57:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix lockdep warning
Message-ID: <20130417165701.GA16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366215556-8586-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366215556-8586-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 17, 2013 at 12:19:16PM -0400, Josef Bacik wrote:
> The locking order for stuff is
> 
> __sb_start_write
> ordered_mutex
> 
> but with sync() we don't do __sb_start_write for some strange reason, which
> means that our iput in wait_ordered_extents could start a transaction which does
> the __sb_start_write while we're holding the ordered_mutex.  Fix this by using
> delayed iput in sync.  Thanks,

No lockdep warning anymore.

david

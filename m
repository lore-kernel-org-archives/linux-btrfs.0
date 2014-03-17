Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbaCQMov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 08:44:51 -0400
Date: Mon, 17 Mar 2014 13:44:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: scrub: don't call unlock if
 pthread_mutex_lock fails
Message-ID: <20140317124449.GC29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140314234943.GA28451@localhost.localdomain>
 <20140315002933.GA29539@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140315002933.GA29539@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 15, 2014 at 02:29:33AM +0200, Rakesh Pandit wrote:
> Forgot to mention the reason for change. If accepted this can be
> included in commit message:
> 
> Rationale being that if pthread_mutex_lock fails pthread_mutex_unlock
> will always fail and overwrite actual error value in err.

Thanks, updated.

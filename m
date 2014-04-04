Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaDDN7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 09:59:24 -0400
Date: Fri, 4 Apr 2014 15:59:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linuxpatches@star.c10r.facebook.com
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
Message-ID: <20140404135922.GV29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 01, 2014 at 11:53:19PM +0100, Filipe David Borba Manana wrote:
> This implements the tmpfile callback of struct inode_operations, introduced
> in the linux kernel 3.11 [1], and implemented already by some filesystems.

Nice!

Btw, would be good to mention 'O_TMPFILE' at lest in the changelog.

> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

 CC: linuxpatches@star.c10r.facebook.com

how many likes so far?

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53479 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753107AbeDKNTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 09:19:22 -0400
Date: Wed, 11 Apr 2018 15:16:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: configure: check if xmlto exists at
 configure time
Message-ID: <20180411131651.GB21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <29b3fdcb-afbc-b3b3-41c3-825f778ccecd@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <29b3fdcb-afbc-b3b3-41c3-825f778ccecd@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 05:29:00PM +0900, Misono Tomohiro wrote:
> AC_PATH_PROG won't fail even if it fails to find command path.
> xmlto is required for document build and we should report error
> if it doesn't exist at configure time.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied, thanks.

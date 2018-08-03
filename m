Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbeHCRED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 13:04:03 -0400
Date: Fri, 3 Aug 2018 17:07:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: ins: logical-resolve: Set correct error
 value
Message-ID: <20180803150714.GB3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
 <1447450b84429a439316493340c0c82a605f6539.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447450b84429a439316493340c0c82a605f6539.1532501096.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2018 at 05:20:16PM +0900, Misono Tomohiro wrote:
> Reset ret value to zero after snprintf(), which returns the number
> of written chars. Otherwise non-zero value returns after command
> success with -P option. Also set return value from __ino_to_path_fd() to
> reflect the final status for default behavior.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Applied, thanks.

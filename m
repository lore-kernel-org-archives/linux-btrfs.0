Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35571 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbeC3RX5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 13:23:57 -0400
Date: Fri, 30 Mar 2018 19:21:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] btrfs-progs: fi usage: cleanup unnecessary
 permission error check
Message-ID: <20180330172129.GT30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
 <a7a4f704-f2bc-1231-dec2-de5524f3bbdd@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a7a4f704-f2bc-1231-dec2-de5524f3bbdd@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 05:23:39PM +0900, Misono Tomohiro wrote:
> Since BTRFS_IOC_FS_INFO does not require root privilege, there is no
> need to check EPERM error.

Well, this has been changed in 3.16, but there's still 3.2 longterm
kernel. It does not hurt to have the check and verbose message so we may
need to keep it for a few more years.

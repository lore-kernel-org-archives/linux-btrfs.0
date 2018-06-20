Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60091 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753202AbeFTOjs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:39:48 -0400
Date: Wed, 20 Jun 2018 16:36:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, y2038@lists.linaro.org,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: use 64-bit timestamps for struct
 btrfs_dev_replace_item
Message-ID: <20180620143655.GD24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620143448.44388-1-arnd@arndb.de>
 <20180620143448.44388-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620143448.44388-2-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 04:34:33PM +0200, Arnd Bergmann wrote:
> The structure already has 64-bit fields for the timestamps, but
> calling get_seconds() may truncate and risk overflow on 32-bit
> architectures.
> 
> This changes the dev-replace code to use ktime_get_real_seconds()
> instead, which always returns 64-bit timestamps.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks but there's a patch already fixng that, sent a few days ago

https://patchwork.kernel.org/patch/10473195/

and added to patch queue for the next dev cycle as it does not appear to
urgent for 4.18.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40731 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbeFTQk5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 12:40:57 -0400
Date: Wed, 20 Jun 2018 18:38:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, y2038@lists.linaro.org,
        Nikolay Borisov <nborisov@suse.com>, Omar Sandoval <osandov@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: use timespec64 for i_otime
Message-ID: <20180620163804.GE24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620143448.44388-1-arnd@arndb.de>
 <20180620143448.44388-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620143448.44388-3-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 04:34:34PM +0200, Arnd Bergmann wrote:
> While the regular inode timestamps all use timespec64 now, the
> i_otime field is btrfs specific and still needs to be converted
> to correctly represent times beyond 2038.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This patch addresses the remaining type conversions, so I'm going to
merge it, thanks.

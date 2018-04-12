Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751819AbeDLOM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 10:12:57 -0400
Date: Thu, 12 Apr 2018 16:10:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Ilan Schwarts <ilan84@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: error: redefinition of 'struct btrfs_ioctl_defrag_range_args
Message-ID: <20180412141027.GL21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJUuSvEgV0NU8Gu89eM=pM4mnYtKZgyNG31BASeHkiuH6Xj_nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJUuSvEgV0NU8Gu89eM=pM4mnYtKZgyNG31BASeHkiuH6Xj_nA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 01:22:23PM +0300, Ilan Schwarts wrote:
> Hi
> While trying to compile my kernel module on suse 12.2 kernel
> 4.4.103-92.53-default
> I recieve the following warning: error: redefinition of 'struct
> btrfs_ioctl_defrag_range_args
> I see that struct is defined in 2 places:
> /lib/modules/4.4.103-92.53-default/source/fs/btrfs/ctree.h:1985:8
> /usr/src/linux-4.4.103-92.53/include/uapi/linux/btrfs.h:497:8

Some of the defintions were moved from fs/btrfs/ to uapi, so the sources
seem to be in a half-state where it exists in both places.

> Why is it defined in 2 places ?
> No one else is getting that warning (which treated as error for me) ?

I've never seen the warning, but I don't compile the 4.4 distro kernel.

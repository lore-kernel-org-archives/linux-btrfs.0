Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50973 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752332AbdILREf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:04:35 -0400
Date: Tue, 12 Sep 2017 19:03:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 7/7] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
Message-ID: <20170912170304.GD29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
 <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170911063612.32114-8-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 03:36:12PM +0900, Qu Wenruo wrote:
> Add extra limitation explained for --rootdir option, including:
> 1) Size limitation
>    Now I decide to follow "mkfs.ext4 -d" behavior, so we user is
>    responsible to make sure the block device/file is large enough.

That's fine and I'm ok for changing that to be the default now. But the
shrinking could be still useful, if I read the usecase that Austin
mentioned in the previous thread correctly.

Say I want to prepare a minimal image but will provide a large file at
the beginning because I don't know what's the resulting size going to
be. In this case, something like

$ mkfs.btrfs --rootdir dir/ --minimize image

would make it possible. I'm not sure if somebody hasn't proposed that
already, but this sounds good to me and I think it's a valid usecase.
This means adding back the patch from V1 and then making it optional.

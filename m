Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932390AbdKFRPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 12:15:31 -0500
Date: Mon, 6 Nov 2017 18:13:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add __init macro to btrfs init function
Message-ID: <20171106171338.GT28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171102232150.20522-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171102232150.20522-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 02, 2017 at 05:21:50PM -0600, Liu Bo wrote:
> Adding __init macro gives kernel a hint that this function is only
> used during the initialization phase and its memory resources can be
> freed up after.

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Would be good to add the __exit annotations as well (separate patch
please).

I haven't found any instances suitable for __initdata and the like.

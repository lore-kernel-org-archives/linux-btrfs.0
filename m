Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39439 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932720AbcLSR5e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 12:57:34 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35641AC74
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 17:57:33 +0000 (UTC)
Date: Mon, 19 Dec 2016 18:57:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: drop unused extent_op arg from
 btrfs_add_delayed_data_ref
Message-ID: <20161219175718.GG3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1d914e77-1f5e-47ec-1858-50f0a4dc9023@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1d914e77-1f5e-47ec-1858-50f0a4dc9023@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 13, 2016 at 02:39:34PM -0500, Jeff Mahoney wrote:
> btrfs_add_delayed_data_ref is always called with a NULL extent_op,
> so let's drop the argument.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>

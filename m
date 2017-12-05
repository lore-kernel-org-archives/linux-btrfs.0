Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57225 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdLESWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:22:20 -0500
Date: Tue, 5 Dec 2017 19:20:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: remove redundant check in rbio_can_merge
Message-ID: <20171205182020.GP3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171204224037.7556-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 03:40:35PM -0700, Liu Bo wrote:
> Given the above
> '
> if (last->operation != cur->operation)
> 	return 0;
> ',
> it's guaranteed that two operations are same.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51989 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751471AbdHPN7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:59:10 -0400
Date: Wed, 16 Aug 2017 15:57:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/4] btrfs: remove unused BTRFS_COMPRESS_LAST
Message-ID: <20170816135746.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170813040244.18841-1-anand.jain@oracle.com>
 <20170813040244.18841-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170813040244.18841-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 12:02:41PM +0800, Anand Jain wrote:
> We aren't using this define, so removing it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

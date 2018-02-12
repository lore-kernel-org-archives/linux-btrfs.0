Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbeBLRAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 12:00:36 -0500
Date: Mon, 12 Feb 2018 17:58:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] cleanup btrfs_dev_replace_cancel()
Message-ID: <20180212165820.GK3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153331.18440-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212153331.18440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:33:28PM +0800, Anand Jain wrote:
> Anand Jain (3):
>   btrfs: open code btrfs_dev_replace_cancel()
>   btrfs: rename __btrfs_dev_replace_cancel()
>   btrfs: change the return arg type for btrfs_dev_replace_cancel()

1-3 look good,

Reviewed-by: David Sterba <dsterba@suse.com>

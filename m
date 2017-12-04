Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751961AbdLDUal (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 15:30:41 -0500
Date: Mon, 4 Dec 2017 21:28:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] define BTRFS_DEV_STATE
Message-ID: <20171204202842.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204045456.8602-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171204045456.8602-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 12:54:51PM +0800, Anand Jain wrote:
> As of now device properties and states are being represented as int
> variable. So clean that up using bitwise operations. Also patches in
> the ML such as device failed state needs this cleanup as well.
> 
> V2:
>  Accepts all comments from Nikolay.
>  Drops can_discard.
>  Adds BTRFS_DEV_STATE_REPLACE_TGT and BTRFS_DEV_STATE_FLUSH_SENT
>     patches.
> 
> Anand Jain (5):
>   btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
>   btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
>   btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
>   btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
>   btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT

1-5 added to next. I had to tweak the whitespace in the conditions.

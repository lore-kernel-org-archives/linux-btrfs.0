Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46507 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755813AbeAIRAm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 12:00:42 -0500
Date: Tue, 9 Jan 2018 17:58:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH 2/3] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
Message-ID: <20180109165834.GR13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180109010543.16053-1-anand.jain@oracle.com>
 <20180109010543.16053-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109010543.16053-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:05:42AM +0800, Anand Jain wrote:
> Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changing
> fsid is complete. Its not a good idea to mount the device anything in
> between.
> This patch doesn't add SUPER_FLAG_CHANGING_FSID into BTRFS_SUPER_FLAG_SUPP
> list, so mount would fail (along with the fix in the next patch) when
> SUPER_FLAG_CHANGING_FSID is set.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>  cc: wqu@suse.com
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

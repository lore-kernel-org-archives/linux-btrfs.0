Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751036AbeCGJTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:19:35 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 55F23AE63
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Mar 2018 09:19:34 +0000 (UTC)
Subject: Re: [PATCH 5/8] btrfs-progs: qgroups: introduce and use info and
 limit structures
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-6-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <052cbfbc-a91f-f361-95cf-c13fdfd3378a@suse.com>
Date: Wed, 7 Mar 2018 11:19:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-6-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.03.2018 20:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> We use structures to pass the info and limit from the kernel as items
> but store the individual values separately in btrfs_qgroup.  We already
> have a btrfs_qgroup_limit structure that's used for setting the limit.
> 
> This patch introduces a btrfs_qgroup_info structure and uses that and
> btrfs_qgroup_limit in btrfs_qgroup.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


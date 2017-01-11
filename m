Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758381AbdAKQSq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 11:18:46 -0500
Date: Wed, 11 Jan 2017 17:18:42 +0100
From: Michal Hocko <mhocko@kernel.org>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] etrfs: fix up misleading GFP_NOFS usage in
 btrfs_releasepage
Message-ID: <20170111161842.GG16365@dhcp22.suse.cz>
References: <20170109143903.32280-1-mhocko@kernel.org>
 <20170111135550.GJ12081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170111135550.GJ12081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 11-01-17 14:55:50, David Sterba wrote:
[...]
> But otherwise looks ok to me, I'm going to merge the patch. Thanks.

I have only now noticed typo in the subject. s@etrfs:@btrfs:@

-- 
Michal Hocko
SUSE Labs

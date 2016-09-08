Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932443AbcIHRCq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 13:02:46 -0400
Date: Thu, 8 Sep 2016 19:01:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/7] Btrfs: add a flags field to btrfs_fs_info
Message-ID: <20160908170110.GM16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
 <1472845206-22870-4-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472845206-22870-4-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:40:02PM -0400, Josef Bacik wrote:
> We have a lot of random ints in btrfs_fs_info that can be put into flags.  This
> is mostly equivalent with the exception of how we deal with quota going on or
> off, now instead we set a flag when we are turning it on or off and deal with
> that appropriately, rather than just having a pending state that the current
> quota_enabled gets set to.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'm picking this patch independently to 4.9, but feel free to include it
in the patch series if you send more revisions.

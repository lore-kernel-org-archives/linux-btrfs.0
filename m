Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965152AbcIHRIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 13:08:38 -0400
Date: Thu, 8 Sep 2016 19:07:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 7/7] Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written
Message-ID: <20160908170701.GO16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
 <1472845206-22870-8-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472845206-22870-8-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:40:06PM -0400, Josef Bacik wrote:
> No reason to bug on in here, fs corruption could easily cause these things to
> happen.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Also on the way to 4.9.

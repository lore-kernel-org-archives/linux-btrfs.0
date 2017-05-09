Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52299 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752541AbdEIPAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 11:00:12 -0400
Date: Tue, 9 May 2017 17:00:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/3] btrfs: remove inode argument from repair_io_failure
Message-ID: <20170509150004.GC5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
 <1493999835-26731-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493999835-26731-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 11:57:14AM -0400, Josef Bacik wrote:
> Once we remove the btree_inode we won't have an inode to pass anymore, just pass
> the fs_info directly and the inum since we use that to print out the repair
> message.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

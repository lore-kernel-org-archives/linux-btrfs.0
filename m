Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754188AbdJMO7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 10:59:03 -0400
Date: Fri, 13 Oct 2017 16:57:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/21] btrfs: breakout empty head cleanup to a helper
Message-ID: <20171013145717.GV3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-11-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-11-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:54PM -0400, Josef Bacik wrote:
> Move this code out to a helper function to further simplivy
> __btrfs_run_delayed_refs.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

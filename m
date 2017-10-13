Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdJNQsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:48:38 -0400
Date: Fri, 13 Oct 2017 19:20:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/21] Btrfs: only check delayed ref usage in
 should_end_transaction
Message-ID: <20171013172020.GD3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-8-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-8-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:51PM -0400, Josef Bacik wrote:
> We were only doing btrfs_check_space_for_delayed_refs() if the metadata
> space was full, ie we couldn't allocate chunks.  This assumes we'll be
> able to allocate chunks during transaction commit, but since nothing
> does a LIMIT flush during the transaction commit this won't actually
> happen unless we happen to run shy of actual space.  We already take
> into account a full fs in btrfs_check_space_for_delayed_refs() so just
> kill this extra check to make sure we're ending the transaction when we
> need to.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

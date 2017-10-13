Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758559AbdJMPlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 11:41:17 -0400
Date: Fri, 13 Oct 2017 17:39:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/21] btrfs: move all ref head cleanup to the helper
 function
Message-ID: <20171013153930.GX3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-13-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-13-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:56PM -0400, Josef Bacik wrote:
> We do a couple different cleanup operations on the ref head.  We adjust
> counters, we'll free any reserved space if we didn't end up using the
> ref, and we clear the pending csum bytes.  Move all these disparate
> things into cleanup_ref_head and clean up the logic in
> __btrfs_run_delayed_refs so that it handles the !ref case a lot cleaner,
> as well as making run_one_delayed_ref() only deal with real refs and not
> the ref head.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

This one was tough.

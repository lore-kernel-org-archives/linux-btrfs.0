Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753576AbeBLSAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 13:00:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D96FFAE90
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 18:00:34 +0000 (UTC)
Date: Mon, 12 Feb 2018 18:58:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14] Misc transaction cleanups
Message-ID: <20180212175819.GN3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 07, 2018 at 05:55:36PM +0200, Nikolay Borisov wrote:
> Here are a bunch of transaction-related cleanups all of them present no 
> functional changes. The first 2 patches could be more interesting - the first
> one moves trans_release_metadata to transaction.c and makes it static and the 
> second one opencodes btrfs_write_and_wait_marked_extents in its sole caller
> to make the chall chain shorter. The rest of the patches just kill the 
> extraneous fs_info argument since they also take either a btrfs_trans_handle or
> btrfs_transaction pointer which already contain fs_info. 
> 
> The modified functions are all called from btrfs_commit_transaction. With this
> series applied the only function which remain that still take fs_info and 
> some type of transaction reference are: 
> 
> btrfs_finish_extent_commit
> btrfs_qgroup_account_extents
> btrfs_run_delayed_refs
> 
> 
> The reason I haven't touched them is that David expressed some reservation 
> about mass cleaning of functions which are more or less public interface. And 
> the above 3 are such functions. David if you don't objec to converting those 3
> I will keep them in mind when doing further cleanups in the transaction area. 

I think all 3 functions don't need the explicit fs_info parameter, the
main object for the functions is the transaction. I don't have a good
example for the API function that should keep both parameters, nothing
in transaction.h and nothing after a few quick greps. For functions like
add_delayed_ref_head, removing the fs_info would be a welcome change as
the number of parameters is high already (more than 10).

The patchset has been added to misc-next, briefly checking the effects
on stack consumption, there are several -8 deltas. Which is good.

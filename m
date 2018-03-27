Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753195AbeC0Qce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 12:32:34 -0400
Date: Tue, 27 Mar 2018 18:30:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        jeffm@suse.com
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
Message-ID: <20180327163007.GB30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171212073436.16447-1-wqu@suse.com>
 <20171212211209.GB3553@twin.jikos.cz>
 <645e99a8-67ee-b3ce-89cc-e60a481f4bc5@gmx.com>
 <20180326141008.GO6955@twin.jikos.cz>
 <521fafd5-a927-b68d-8b6d-6c29ca5c34e5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <521fafd5-a927-b68d-8b6d-6c29ca5c34e5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2018 at 07:49:02AM +0800, Qu Wenruo wrote:
> > As there's going to be one more rc, this gives us one more week to
> > decide if its' ok-ish to merge this patch and fix the fallouts during
> > the normal cycle.
> > 
> > Given that this patchset has been in for-next for a long time, I'd do
> > the merge now and focus on testing for that patchset as the rest of
> > devel patches looks good.
> > 
> > Please let me know if you have objections.
> 
> I'm completely fine with the decision.

So, I've merged the patchset, updated a few comments or changelogs.

There was one fixup for btrfs_delalloc_release_space, one more call was
added meanwhile (765f3cebff0023d05 "btrfs: Handle
btrfs_set_extent_delalloc failure in relocate_file_extent_cluster"), the
new parameter was set to true as it's an error handling kind of use.

The folloing types of patches will be accepted during the 4.17
development cycle that are related to this patchset: improved error
handling, better reporting, tracpoint updates or fixes of bugs triggered
by the reservation type split. Ie. no unnecessary cleanups or new
functionality.

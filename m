Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbcGHMuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 08:50:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EB44CAC72
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 12:50:38 +0000 (UTC)
Date: Fri, 8 Jul 2016 14:50:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <DSterba@suse.com>
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
Message-ID: <20160708125057.GF13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
 <27f7d3ef-3537-0f27-f485-8e52f79d22d0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <27f7d3ef-3537-0f27-f485-8e52f79d22d0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 07, 2016 at 10:19:37PM -0400, Jeff Mahoney wrote:
> On 7/7/16 9:48 PM, Jeff Mahoney wrote:
> > On 6/24/16 6:14 PM, jeffm@suse.com wrote:
> >> From: Jeff Mahoney <jeffm@suse.com>
> >>
> >> One of the common complaints I've heard from new and experienced
> >> developers alike about the btrfs code is the ubiquity of
> >> struct btrfs_root.  There is one for every tree on disk and it's not
> >> always obvious which root is needed in a particular call path.  It can
> >> be frustrating to spend time figuring out which root is required only
> >> to discover that it's not actually used for anything other than
> >> getting the fs-global struct btrfs_fs_info.
> >>
> >> The patchset contains several sections.
> >>
> >> 1) The fsid trace event patchset I posted earlier; I can rebase without this
> >>    but I'd prefer not to.
> >>
> >> 2) Converting btrfs_test_opt and friends to use an fs_info.
> >>
> >> 3) Converting tests to use an fs_info pointer whenever a root is used.
> >>
> >> 4) Moving sectorsize and nodesize to fs_info and cleaning up the
> >>    macros used to access them.
> > 
> > This change was a little overzealous in free-space-cache.c, which hit
> > block_group->sectorsize as well as root->sectorsize by accident.  While
> > the change is fine for general btrfs usage, it breaks the sanity tests
> > since dummy block groups now depend on a dummy fs_info as well.
> 
> There's also another error in btrfs_alloc_dummy_fs_info that doesn't
> initialize sectorsize.
> 
> Clearly my test config got CONFIG_BTRFS_FS_RUN_SANITY_TESTS disabled at
> some point. :(

I've tried to fix that but the tests still failed so for sake of getting
for-next out, I've verified that commits up to

"btrfs: btrfs_abort_transaction, drop root parameter"

do boot so please send updates only to the following patches. My fixup
attempts are in the branch for-4.8-fixups-buggy.

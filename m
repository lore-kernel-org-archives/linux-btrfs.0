From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 00/35] btrfs: Error Handling Patchset
Date: Wed, 21 Mar 2012 21:11:04 -0400
Message-ID: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This is the error handling patchset for btrfs.

  The series is comprised of several groups of patches:
  - Adding new btrfs_panic and btrfs_error routines
  - Adding the ability to abort transactions
  - Converting functions that don't have error conditions to
    return void
  - Eliminating the gfp_t argument to lock_ and unlock_extent,
    as they are always called with GFP_NOFS
  - Pushing up errors to handle them and eliminate BUG_ON sites
  - Several other bug fixes for issues we encountered during testing

 I'd like to thank David Sterba for a putting a ton of effort into testing
 and review.

 -Jeff


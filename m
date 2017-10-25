Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38190 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdJYCzG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 22:55:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/6] btrfs: qgroup: Separate qgroup reservation types
Date: Wed, 25 Oct 2017 10:54:39 +0800
Message-Id: <20171025025445.16617-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will separate original qgroup->reserved into a new
structure, btrfs_qgroup_rsv, which has different reservation for
different types.

Currently it will only includes data and meta type.

The main advantage is:

1) Better underflow detection
   Now it can detection which reservation type is causing the underflow.

2) Easier to expend
   All interface is updated to access reservation type, it will get
   super easy to be expended, especially for later delalloc reservation.

3) Better encapsulation
   No longer need to manually trace underflow or add trace events, all
   encapsulated into 2 functions.

Despite of the qgroup reservation refactor, also fix a bug where qgroup
relationship update modifies parent qgroup reservation wrongly.

Although I tend to agree with Jeff's idea to remove support of
multi-level qgroup, at least fix what I exposed during coding.

Changelog:
v2:
  Use _MAX naming, as _TYPES naming reusing the last type makes it quite
  easier to screw up space allocation, since we need +1 to handle
  _TYPES. Suggested by Nikolay, Edmund, Jeff and already experienced
  such problem by myself.

  Rename the qgroup_rsv_increase/decrease() to qgroup_rsv_add/release(),
  to follow the block_rsv API, suggested by Nikolay, Jeff and Edmund.

  Better description for the bug in __qgroup_excl_accounting(),
  suggested by Nikolay.

Qu Wenruo (6):
  btrfs: qgroup: Skeleton to support separate qgroup reservation type
  btrfs: qgroup: Introduce helpers to update and access new qgroup rsv
  btrfs: qgroup: Make qgroup_reserve and its callers to use separate
    reservation type
  btrfs: qgroup: Fix wrong qgroup reservation update for relationship
    modification
  btrfs: qgroup: Update trace events to use new separate rsv types
  btrfs: qgroup: Cleanup the remaining old reservation counters

 fs/btrfs/qgroup.c            | 169 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/qgroup.h            |  28 ++++++-
 include/trace/events/btrfs.h |  17 +++--
 3 files changed, 154 insertions(+), 60 deletions(-)

-- 
2.14.2


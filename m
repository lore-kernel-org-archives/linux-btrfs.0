Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751649AbdF3N62 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 09:58:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D3ABAB46
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 13:58:27 +0000 (UTC)
Date: Fri, 30 Jun 2017 15:57:17 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Branch for 4.13 pull request has been updated
Message-ID: <20170630135717.GT2866@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the branch for 4.13 pull request has been updated, now contains a better fix
for the dir item validation, though that still failed generic/066. Will be
fixed.

Newly added fixes for the intended 1st batch:

Jan Kara (1):
      btrfs: Don't clear SGID when inheriting ACLs

Qu Wenruo (1):
      btrfs: Remove false alert when fiemap range is smaller than on-disk extent

Patch "btrfs: fix validation of XATTR_ITEM dir items" has been updated
in-place, the base of the branch is still v4.12-rc6 and will not move.

top commit: 848c23b78fafdcd3270b06a30737f8dbd70c347f
branch name: for-4.13-part1

The branch name needs to stay, that might be confusing temporarily for
development patches, so if you don't know how to rebase your patchset on top of
rebased head, use the previous one. Or learn how 'git rebase --onto' works.

d.

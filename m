Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbcDZOc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:32:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E5FFCACCA
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:32:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Minor updates to sysfs
Date: Tue, 26 Apr 2016 16:32:45 +0200
Message-Id: <cover.1461681045.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a less-than-handful set of fixes to sysfs, two sanity checks and one additional
locking preventing a pretty rare race.

David Sterba (3):
  btrfs: add read-only check to sysfs handler of features
  btrfs: add check to sysfs handler of label
  btrfs: sysfs: protect reading label by lock

 fs/btrfs/sysfs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
2.7.1


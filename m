Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab3HFMZL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 08:25:11 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 286E0A51B7
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2013 14:25:10 +0200 (CEST)
Date: Tue, 6 Aug 2013 14:25:09 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: Introduce devel namespace
Message-ID: <cover.1375791411.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add namespace for features under development and the first user.

David Sterba (2):
  btrfs-progs: introduce command namespace for development features
  btrfs-progs: move chunk-recover command to devel namespace

 btrfs.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

-- 
1.8.3.1


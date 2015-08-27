Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lost.in.psyced.org ([188.40.42.221]:42638 "EHLO lo.psyced.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbbH0RnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 13:43:19 -0400
Received: from lo.psyced.org (localhost [127.0.0.1])
	by lo.psyced.org (8.14.3/8.14.3/Debian-9.4) with ESMTP id t7RHWUsk030205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 19:32:30 +0200
Received: (from lynx@localhost)
	by lo.psyced.org (8.14.3/8.14.3/Submit) id t7RHWTUp030204
	for linux-btrfs@vger.kernel.org; Thu, 27 Aug 2015 19:32:29 +0200
Date: Thu, 27 Aug 2015 19:32:29 +0200
From: carlo von lynX <lynX@time.to.get.psyced.org>
To: linux-btrfs@vger.kernel.org
Subject: Impossible to mount two different copies of the same btrfs
Message-ID: <20150827173229.GA30068@lo.psyced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there. Excuse me if I didn't subscribe the list. Just wanted to
let you know of this behavior assuming you haven't noticed it yet.

When mounting two copies of the same file system from two different
hard disks with the intention of syncing the older with the newer
one, btrfs behaves differently from ext4: it will mount the first
one twice rather than mounting each. I assume it has something to
do with all UUIDs being identical, which doesn't disturb ext4 though.

This only happens with btrfs - I cannot mount two file systems that
happen to have the same UUID (or are deemed identical by some other
criterion I cannot determine). I presume this is not intended
behavior. I tried relabeling one of the copies, but it didn't have
any effect. Now I'm looking into ways to change the UUID.

Thanks for the great snapshots however!


-- 
  E-mail is public! Talk to me in private using encryption:
         http://loupsycedyglgamf.onion/LynX/
          irc://loupsycedyglgamf.onion:67/lynX
         https://psyced.org:34443/LynX/

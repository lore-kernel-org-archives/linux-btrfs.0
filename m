Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46505 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJZSH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 14:07:28 -0400
Received: by mail-pa0-f43.google.com with SMTP id eu11so4023437pac.30
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 11:07:27 -0700 (PDT)
Date: Sun, 26 Oct 2014 11:07:24 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Race condition in btrfs_releasepage?
Message-ID: <20141026180724.GA16926@mew.home.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I may be completely wrong here and someone might come in and tell me why
this doesn't matter, but I'm just trying to understand the BTRFS code and I
came across something that confused me.

try_release_extent_mapping appears to access page->mapping->host->i_size
without any sort of serialization. It's used in the implementation of
btrfs_releasepage, and aops->releasepage, as far as I can tell, isn't called
with any locks held. Should we be grabbing i_mutex or using i_size_read here
instead? I'm not too familiar with the locking rules for inodes or releasepage.

Thanks!
-- 
Omar

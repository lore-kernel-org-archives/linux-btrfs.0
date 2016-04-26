Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcDZKoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 06:44:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2E9A8ABF6
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 10:44:02 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Fixups for pending branches after PAGE_CACHE_/page_cache_ removal
Date: Tue, 26 Apr 2016 12:43:53 +0200
Message-Id: <cover.1461666892.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

merge tests of current for-next to master lead to build failures, because some
of the branches still used the PAGE_CACHE_ macros. As I don't want to do
rebases, there are fixups committed on top of the respective branches.

These are:

* device delete by id, from Anand Jain
* enospc rework, from Josef Bacik

David Sterba (2):
  btrfs: btrfs_read_disk_super: PAGE_CACHE_ removal related fixups
  btrfs: __btrfs_buffered_write: PAGE_CACHE_ removal related fixups

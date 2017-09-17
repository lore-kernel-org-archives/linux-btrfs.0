Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:36711 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751807AbdIQTuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 15:50:35 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: load_chunk_info() wrong set search key 'type'
Date: Sun, 17 Sep 2017 21:50:27 +0200
Message-Id: <20170917195028.3124-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function load_chunk_info() doesn't initialize correctly the
sk->min/max_type when it calls the TREE_SEARCH ioctl: these keys are swapped.
Moreover this function assumes that all the items contained in the tree
BTRFS_CHUNK_TREE_OBJECTID are of type BTRFS_CHUNK_ITEM_KEY, however some
items are of type DEV_ITEM. Add an if( ) to pick only the right ones.



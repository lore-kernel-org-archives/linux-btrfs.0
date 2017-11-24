Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0046.outbound.protection.outlook.com ([104.47.2.46]:45664
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751981AbdKXTQK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 14:16:10 -0500
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: About 'key type for persistent [...] items'
Message-ID: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
Date: Fri, 24 Nov 2017 20:16:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Last week, when implementing the automatic classifier to dynamically
create tree item data objects by key type in python-btrfs, I ran into
the following commits in btrfs-progs:

  commit 8609c8bad68528f668d9ce564b868aa4828107a0
  btrfs-progs: print-tree: factor out temporary_item dump
and
  commit a4b65f00d53deb1b495728dd58253af44fcf70df
  btrfs-progs: print-tree: factor out persistent_item dump

...which are related to kernel...

  commit 50c2d5abe64c1726b48d292a2ab04f60e8238933
  btrfs: introduce key type for persistent permanent items
and
  commit 0bbbccb17fea86818e1a058faf5903aefd20b31a
  btrfs: introduce key type for persistent temporary items

Afaics the goal is to overload types because there can be only 256 in
total. However, I'm missing the design decisions behind the
implementation of it. It's not in the commit messages, and it hasn't
been on the mailing list.

Before, there was an 1:1 mapping from key types to data structures. Now,
with the new PERSISTENT_ITEM_KEY and TEMPORARY_ITEM_KEY, it seems items
which use this type can be using any data structure they want, so it's
some kind of YOLO_ITEM_KEY.

The print-tree code in progs 8609c8b and a4b65f0 seems incomplete. For
example, for the PERSISTENT_ITEM_KEY, there's a switch (objectid) with
case BTRFS_DEV_STATS_OBJECTID.

However, BTRFS_DEV_STATS_OBJECTID is just the value 0. So, that means
that if I want to have another tree where BTRFS_MOUTON_OBJECTID is also
0, and I'm storing a btrfs_kebab_item struct indexed at
(BTRFS_MOUTON_OBJECTID, PERSISTENT_ITEM_KEY, 31337), then print_tree.c
will try to parse the data by calling print_dev_stats?

What's the idea behind that? Instead of having the key type field define
the struct and meaning, we now suddenly need the tuple (tree, objectid,
type), and we need all three to determine what's inside the item data?
So, the code in print_tree.c would also need to know about the tree
number and pass that into the different functions.

Am I missing something, or is my observation correct?

Thanks,--
Hans van Kranenburg

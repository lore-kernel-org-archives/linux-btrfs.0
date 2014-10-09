Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:55009 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaJIN6E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 09:58:04 -0400
Received: by mail-ig0-f176.google.com with SMTP id hn15so12793185igb.15
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 06:58:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Oct 2014 09:58:04 -0400
Message-ID: <CAJtFHUStCfWvk9QqjYbYrHzZm44RfAScdf-neKD7S_T0SdY9hQ@mail.gmail.com>
Subject: deadlock with 3.16.3
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

running wheezy Debian 3.16.3-2~bpo70+1 system has locked up 2 nights
in a row running rsync copying from remote to a ~100TB btrfs. Only job
running on the server, no interactive users or anything. soft locks
showed up in kern.log across many CPUs shortly before system became
non-responsive. First lines of the call traces via: grep '8 17:12'
/var/log/kern.log | cut -d" " --complement -f 1,2,3,4,5,6 | grep -A1
'Call Trace:' | egrep -v '\-\-|Call Trace:'

I've gone back to 3.14, which I've never had issues with. sar report
from 5 minutes prior looked pretty normal, no swap depletion. Let me
know if you want more info

[30328.735511]  [<ffffffffa0227df8>] ?
btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[30328.747283]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.759289]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.775303]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.787311]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.799324]  [<ffffffffa026cfaf>] ? btrfs_tree_read_lock+0x3f/0x110 [btrfs]
[30328.839351]  [<ffffffffa026cfaf>] ? btrfs_tree_read_lock+0x3f/0x110 [btrfs]
[30328.855363]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.867373]  [<ffffffffa026cecc>] ?
btrfs_clear_lock_blocking_rw+0x4c/0xf0 [btrfs]
[30328.879384]  [<ffffffffa026cfaf>] ? btrfs_tree_read_lock+0x3f/0x110 [btrfs]
[30328.891394]  [<ffffffffa026cecc>] ?
btrfs_clear_lock_blocking_rw+0x4c/0xf0 [btrfs]
[30328.907407]  [<ffffffffa026d353>] ? btrfs_tree_lock+0xd3/0x1e0 [btrfs]
[30328.919396]  [<ffffffffa026cfaf>] ? btrfs_tree_read_lock+0x3f/0x110 [btrfs]

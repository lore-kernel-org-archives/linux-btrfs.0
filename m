From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: [weird] High CPU usage caused by btrfs-transaction thread busy
 doing find_next_zero_bit()
Date: Wed, 22 Feb 2012 11:20:21 -0500
Message-ID: <20120222112021.2c8c4d4b@Malcolm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dear devs,

My filesystem is super-sluggish since about a week, and perf top tells me
that find_next_bit(), find_next_zero_bit() is eating my netbook's CPU.

The kernel is 3.3-rc3+188 (g3ec1e88) and I don't use this laptop a lot,
so I'm ready to cooperate.

In the btrfs-transaction thread, in descending order of CPU usage:
find_next_zero_bit, find_next_bit, rb_next, setup_cluster_bitmap,
setup_cluster_no_bitmap, tree_search_offset.

I'm on #btrfs (Zougloub)

Regards,

-- 
cJ

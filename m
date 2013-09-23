Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3IWRTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 13:19:09 -0400
Date: Mon, 23 Sep 2013 19:19:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: qgroup scan failed with -12
Message-ID: <20130923171905.GR6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130923074344.60f629d7@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130923074344.60f629d7@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 07:43:44AM +0700, Tomasz Chmielewski wrote:
> Not sure if it's anything interesting - I had the following entry in
> dmesg a few days ago, on a server with 32 GB RAM. The system is still working fine.

Yes this is interesting of course.
> 
> [1878432.675210] btrfs-qgroup-re: page allocation failure: order:5, mode:0x104050

Order 5 allocation, not guaranteed to succeed.

> [1878432.675319] CPU: 5 PID: 22251 Comm: btrfs-qgroup-re Not tainted 3.11.0-rc7 #2
> [1878432.676204]  [<ffffffff810bde12>] krealloc+0x52/0x8c
> [1878432.676324]  [<ffffffffa036bcf0>] find_parent_nodes+0x49c/0x5a5 [btrfs]
> [1878432.676383]  [<ffffffffa036be75>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
> [1878432.676441]  [<ffffffffa036d6e1>] ? qgroup_account_ref_step1+0xea/0x102 [btrfs]
> [1878432.676542]  [<ffffffffa036d915>] btrfs_qgroup_rescan_worker+0x21c/0x516 [btrfs]

220                 new_nodes = krealloc(old, sizeof(*new_nodes) * new_alloced,
221                                      gfp_mask);
222                 if (!new_nodes)
223                         return -ENOMEM;

The requested size is between 64k and 128k, with 40 bytes of ulist_node
it's 1638 to 3276 elements. So, lots of things going on during the
rescan, quite expectable.

I don't know if krealloc can be replaced with something more friendly to
allocator, eg. a list of page-sized blocks instead of one contiguous
array.

david

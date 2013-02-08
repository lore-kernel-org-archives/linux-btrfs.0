Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946518Ab3BHQau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 11:30:50 -0500
Date: Fri, 8 Feb 2013 17:30:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Subject: Re: System unmountable RW
Message-ID: <20130208163048.GJ12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359756678.6019.30.camel@boolette.noo>
 <CAE5mzvgyOqw4ddd-jsW=QxLFqb8deB5d_jiB+WOj9t5hcq8_8A@mail.gmail.com>
 <1359803076.6019.39.camel@boolette.noo>
 <1359809062.6019.42.camel@boolette.noo>
 <1359810923.6019.44.camel@boolette.noo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359810923.6019.44.camel@boolette.noo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 02, 2013 at 02:15:23PM +0100, Olivier Bonvalet wrote:
> Then, 30 minutes later there is no change, so I suppose it's "frozen".
> I hope it can help :

If in doubt, look if the disk is active.

> [ 8081.557304] mount           D ffff8802bfc12080     0  2642   2595 0x00000000
> [ 8081.557355]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
> [ 8081.557376]  [<ffffffffa0066660>] ? btrfs_tree_lock+0xcf/0x224 [btrfs]
> [ 8081.557399]  [<ffffffffa0057941>] ? alloc_extent_buffer+0x6f/0x2d6 [btrfs]
> [ 8081.557408]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
> [ 8081.557426]  [<ffffffffa00338c4>] ? btrfs_init_new_buffer+0x5a/0xe2 [btrfs]
> [ 8081.557443]  [<ffffffffa0033aeb>] ? btrfs_alloc_free_block+0x19f/0x29d [btrfs]
> [ 8081.557454]  [<ffffffff810a7e26>] ? __set_page_dirty_nobuffers+0xc4/0xe0
> [ 8081.557468]  [<ffffffffa00261a8>] ? __btrfs_cow_block+0xf2/0x372 [btrfs]
> [ 8081.557483]  [<ffffffffa0026551>] ? btrfs_cow_block+0xee/0xfd [btrfs]
> [ 8081.557498]  [<ffffffffa00290e8>] ? btrfs_search_slot+0x234/0x660 [btrfs]
> [ 8081.557513]  [<ffffffffa002a475>] ? btrfs_insert_empty_items+0x5d/0xae [btrfs]
> [ 8081.557531]  [<ffffffffa0032b0a>] ? run_clustered_refs+0x4b1/0x81d [btrfs]
> [ 8081.557540]  [<ffffffff8107ba5f>] ? arch_local_irq_restore+0x7/0x8
> [ 8081.557557]  [<ffffffffa00350eb>] ? btrfs_run_delayed_refs+0xea/0x22e [btrfs]
> [ 8081.557577]  [<ffffffffa00418c8>] ? btrfs_commit_transaction+0x3e8/0x927 [btrfs]
> [ 8081.557587]  [<ffffffff8106051a>] ? abort_exclusive_wait+0x79/0x79
> [ 8081.557605]  [<ffffffffa0041f8e>] ? __btrfs_end_transaction+0x158/0x2c4 [btrfs]
> [ 8081.557621]  [<ffffffffa002ba70>] ? spin_unlock+0x5/0x8 [btrfs]
> [ 8081.557638]  [<ffffffffa0033f34>] ? btrfs_drop_snapshot+0x34b/0x4b5 [btrfs]
> [ 8081.557659]  [<ffffffffa0077b95>] ? merge_reloc_roots+0xe0/0x113 [btrfs]
> [ 8081.557679]  [<ffffffffa007874f>] ? btrfs_recover_relocation+0x26c/0x32b [btrfs]

This means that there was an interrupted balance in progress before, and
now it tries to continue. You may optionally avoid restarting balance
with 'skip_balance' mount option and then cancel the balance.

david

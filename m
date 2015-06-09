Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbbFITIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 15:08:10 -0400
Date: Tue, 9 Jun 2015 21:08:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.1-rc6 - kernel crash after doing chattr +C
Message-ID: <20150609190808.GB6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a0a89c2461696c66da9b453d39967493@admin.virtall.com>
 <5575B966.6050200@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5575B966.6050200@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 08, 2015 at 11:48:54AM -0400, Chris Mason wrote:
> On 06/06/2015 02:07 AM, Tomasz Chmielewski wrote:
> > 4.1-rc6, busy filesystem.
> > 
> > I was running mongo import which made quite a lot of IO.
> > During the import, I did "chattr +C /var/lib/mongodb" - shortly after I
> > saw this in dmesg and server died:
> > 
> > [57860.149839] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000008
> > [57860.149877] IP: [<ffffffffc0158b8e>]
> > btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
> 
> Sorry, it's not obvious where the 0000000000000008 is coming from, can
> you turn btrfs_wait_pending_ordered+0x5e/0x110 into a line number?
> 
> Use list *btrfs_wait_pending_ordered+0x5e at the gdb prompt, after you
> gdb btrfs.ko

Guesswork, but doing that on my sources points to __list_del

(gdb) l *(btrfs_wait_pending_ordered+0x5e)
0x333fe is in btrfs_wait_pending_ordered (include/linux/list.h:89).
84       * This is only for internal list manipulation where we know
85       * the prev/next entries already!
86       */
87      static inline void __list_del(struct list_head * prev, struct list_head * next)
88      {
89              next->prev = prev;
90              prev->next = next;
91      }

that is called from btrfs_wait_pending_ordered. The off 8 corresponds to 'prev'
of list_head, so the 'next' poiinter is NULL.

If we go from the list_del_init(ordered->trans_list) we find that it's called as

list_del(entry->prev, entry->next)

(ie entry === ordered->trans_list).

1755         while (!list_empty(&cur_trans->pending_ordered)) {
1756                 ordered = list_first_entry(&cur_trans->pending_ordered,
1757                                            struct btrfs_ordered_extent,
1758                                            trans_list);
1759                 list_del_init(&ordered->trans_list);
1760                 spin_unlock(&fs_info->trans_lock);
1761
1762                 wait_event(ordered->wait, test_bit(BTRFS_ORDERED_COMPLETE,
1763                                                    &ordered->flags));
1764                 btrfs_put_ordered_extent(ordered);                                                                                                               1765                 spin_lock(&fs_info->trans_lock);
1766         }

So we probably got bogus data from cur_trans->pending_ordered. I don't know if
ordered is zeroed or if just the list_head got corrupted. The way the list_head
pointer magic works it's possible to get there both ways (I think).

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3ARA4h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 19:56:37 -0500
Date: Fri, 18 Jan 2013 08:53:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
Message-ID: <20130118005355.GB6768@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 17, 2013 at 08:42:46AM -0600, Mitch Harder wrote:
> On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > This comes from one of btrfs's project ideas,
> > As we defragment files, we break any sharing from other snapshots.
> > The balancing code will preserve the sharing, and defrag needs to grow this
> > as well.
> >
> > Now we're able to fill the blank with this patch, in which we make full use of
> > backref walking stuff.
> >
> > Here is the basic idea,
> > o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> > o  at endio, after we finish updating fs tree, we use backref walking to find
> >    all parents of the ranges and re-link them with the new COWed file layout by
> >    adding corresponding backrefs.
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v4->v5:
> >       - Clarify the comments for duplicated refs.
> >       - Clear defrag flag after we're ready to defrag.
> >       - Fix a bug on HOLE extent.
> > v3->v4:
> >       - Fix duplicated refs bugs detected by mounting with autodefrag, thanks
> >         for the bug report from Mitch and Chris.
> > v2->v3:
> >       - Rebase
> > v1->v2:
> >       - Address comments from David.
> >
> 
> I've been testing this patch on a 3.7.2 kernel merged with the
> for-linus branch for the 3.8_rc kernels, and I'm seeing the following
> error:

Hi Mitch,

Insteresting!  I don't even change the snapshot code ever.

Is it reproducable stably from your side?  Still with the
snapshot-test-pub scripts?

thanks,
liubo

> 
> [16028.159400] general protection fault: 0000 [#1] SMP
> [16028.159461] Modules linked in: ipv6 snd_hda_codec_analog
> snd_hda_intel snd_hda_codec tg3 snd_hwdep snd_pcm snd_page_alloc
> snd_timer snd sr_mod ppdev parport_pc parport microcode iTCO_wdt
> iTCO_vendor_support floppy lpc_ich i2c_i801 serio_raw pcspkr
> ablk_helper cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs
> nfs lockd sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2
> mbcache sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
> [16028.159952] CPU 0
> [16028.159975] Pid: 4420, comm: btrfs-cleaner Not tainted 3.7.2-sad+
> #4 Dell Inc.                 OptiPlex 745                 /0WF810
> [16028.160002] RIP: 0010:[<ffffffffa017b4f2>]  [<ffffffffa017b4f2>]
> btrfs_clean_old_snapshots+0xa6/0x12c [btrfs]
> [16028.160002] RSP: 0000:ffff880078609e38  EFLAGS: 00010282
> [16028.160002] RAX: dead000000200200 RBX: ffff880000000000 RCX: 0000000000018e20
> [16028.160002] RDX: dead000000100100 RSI: 000000000000001b RDI: 000000000000001b
> [16028.160002] RBP: ffff880078609e78 R08: 00000000001c001b R09: ffffffffa015aa01
> [16028.160002] R10: ffffffffa016bbbd R11: ffff8800183a4800 R12: 0000160000000000
> [16028.160002] R13: ffff880078609e38 R14: ffff8800183a4800 R15: ffff8800183a4c38
> [16028.160002] FS:  0000000000000000(0000) GS:ffff88007f200000(0000)
> knlGS:0000000000000000
> [16028.160002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [16028.160002] CR2: 00007f64f5214d96 CR3: 0000000011ef2000 CR4: 00000000000007f0
> [16028.160002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [16028.160002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [16028.160002] Process btrfs-cleaner (pid: 4420, threadinfo
> ffff880078608000, task ffff88007ca62120)
> [16028.160002] Stack:
> [16028.160002]  ffff8800183a4c38 ffff8800020e3c38 ffff880078609e48
> ffff88007921b800
> [16028.160002]  ffff88007ca62120 ffff88007ca62120 ffff88007ca62120
> 0000000000000000
> [16028.160002]  ffff880078609eb8 ffffffffa0173f68 ffff88007921b800
> 0000000000000000
> [16028.160002] Call Trace:
> [16028.160002]  [<ffffffffa0173f68>] cleaner_kthread+0x5a/0xe6 [btrfs]
> [16028.160002]  [<ffffffffa0173f0e>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
> [16028.160002]  [<ffffffff8104c9c3>] kthread+0xba/0xc2
> [16028.160002]  [<ffffffff8104c909>] ? kthread_freezable_should_stop+0x52/0x52
> [16028.160002]  [<ffffffff815f9d9c>] ret_from_fork+0x7c/0xb0
> [16028.160002]  [<ffffffff8104c909>] ? kthread_freezable_should_stop+0x52/0x52
> [16028.160002] Code: 49 bc 00 00 00 00 00 16 00 00 48 bb 00 00 00 00
> 00 88 ff ff eb 7d 4d 8d b7 c8 fb ff ff 4d 85 ff 75 02 0f 0b 49 8b 17
> 49 8b 47 08 <48> 89 42 08 48 89 10 48 be 00 01 10 00 00 00 ad de 49 89
> 37 48
> [16028.160002] RIP  [<ffffffffa017b4f2>]
> btrfs_clean_old_snapshots+0xa6/0x12c [btrfs]
> [16028.160002]  RSP <ffff880078609e38>
> [16028.170584] ---[ end trace 4034e68ac40e6c2b ]---
> 
> Using gdb to identify the location of the GPF gives me the following:
> 
> (gdb) list *(btrfs_clean_old_snapshots+0xa6)
> 0x2a4f2 is in btrfs_clean_old_snapshots (include/linux/list.h:88).
> 83       * This is only for internal list manipulation where we know
> 84       * the prev/next entries already!
> 85       */
> 86      static inline void __list_del(struct list_head * prev, struct
> list_head * next)
> 87      {
> 88              next->prev = prev;
> 89              prev->next = next;
> 90      }
> 91
> 92      /**
> 
> I've tried to trap the error with a BUG_ON prior to deleting the list,
> but my attempt isn't catching the error:
> 
> @@ -1769,6 +1769,7 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
>                 int ret;
> 
>                 root = list_entry(list.next, struct btrfs_root, root_list);
> +               BUG_ON(&root->root_list == NULL);
>                 list_del(&root->root_list);
> 
>                 btrfs_kill_all_delayed_nodes(root);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

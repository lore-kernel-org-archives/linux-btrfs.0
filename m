Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA83C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C385120779
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHC5vcvQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C385120779
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbeJVRad (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 13:30:33 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36615 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeJVRad (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 13:30:33 -0400
Received: by mail-ua1-f67.google.com with SMTP id b3so9671592uak.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Zo2xu7ig5C7BdQJou15m3fFK781dI6xLlZ9EJGBSkfM=;
        b=eHC5vcvQXYuRcEFSQShftRB8t7Bz3DZ19if2A8X3dPpZGcBooVhGo0VkPqzj9o5gM8
         Pb4KukXFI5mrzo5SgHXIMfNU8qbzL4eTQwIxpuNN0DZwyJB0ngamQcVB7gasv1i6YVS/
         ez+qkWpR7x2VQvgJVs2d66+WF36TiaxPDmf7AKoRkg1P6S9+AOOFX0fJv8YQpGV3JcX9
         SW/uwgM3Gn4YMFuJG6iLmkwahCqkUzfWcFa9FwDe97iQmCGKtk7NLweObWnNzWif1gSr
         L+IqrA1Ay92ip4X5/qg3J+jpGKZ60SGfoRB1SF45messO20CmzevRTAQeDTenvkNySWb
         HNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Zo2xu7ig5C7BdQJou15m3fFK781dI6xLlZ9EJGBSkfM=;
        b=gK7F/BpNIAh+SkatKLwSmuXqE3cdKSAry1LYFWVxZEWK9uMFeDwRC9s2YgucTVIPpI
         6ESDS/W/fRMgKZBobqmj7PdyKdxcvHRBUQ2RfX1XU5YbMpvm6nGAmlDp4o6bi8BhvKe9
         JFLfmo1hTWvQRKbzBGiv1md1CDINygXIw0YyBE7eaWwbwA3SCje1p3GENP4HHvY7MVK4
         HNKcu8RBfOOcTbR0qRRFoy69LN6J5+b/Z7QoJ2POh/lNgsPwJ9WRRuTWDWCXg+BydlFZ
         DZt9UK2fhPv+T0heYjANp0+yy90pT3SOqHqenZ+hgS569abNtHrwdasNuIbhEuZjw1zD
         zw0w==
X-Gm-Message-State: ABuFfoiBzbisZfUrcBNPWwjpNIfhCiW3eSHMnit65X9d8hIaK1eTJbhL
        zcZuvCdxp4F0pL6LTnLPojN62onqTsDZLhEp4m4=
X-Google-Smtp-Source: ACcGV63TmNK3sS6zL71RlVn2QkiUoyQl5x14lkA96aKBbTEmtqLAYgMwjVtRoYukSoiObcjeUOniFZS0fPpray3EIQk=
X-Received: by 2002:a9f:2c0b:: with SMTP id r11mr18245266uaj.100.1540199572910;
 Mon, 22 Oct 2018 02:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com>
 <CANQeFDBAxL=BTWjCOVmu8rGP0k2OCipD07my4RQs8vV9NJeraw@mail.gmail.com>
 <CAL3q7H6-06g12Kv1FD30Tii+zoQjDmJj+aM8kCnLeJVVvNad5A@mail.gmail.com>
 <CAPTELen29rS9ZoECxf7kBvDDRGFUcB=TQn2o=T+cmV=a-x9N2Q@mail.gmail.com>
 <CAPTELe=ObC4gbjB+vjuYCHyqPxr4rakWYksN8p1P=UL8BsU_wg@mail.gmail.com>
 <CAL3q7H6EOMj+-4wwAo3KaRxG=MtJcYVxdpLjPMRa-n5OpGYO1w@mail.gmail.com> <CAPTELen2iKt928nGtnr2J7s+rwi5-v_yygV_VWrtr_G6dkwRkw@mail.gmail.com>
In-Reply-To: <CAPTELen2iKt928nGtnr2J7s+rwi5-v_yygV_VWrtr_G6dkwRkw@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 22 Oct 2018 10:12:41 +0100
Message-ID: <CAL3q7H4VR_Wcmm-XFvuDUbWKM_q5Hj2W17qsz9StgQsJ7MFojQ@mail.gmail.com>
Subject: Re: Btrfs resize seems to deadlock
To:     andrew.s.nelson@gmail.com
Cc:     Liu Bo <obuil.liubo@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 10:06 AM Andrew Nelson
<andrew.s.nelson@gmail.com> wrote:
>
> OK, an update: After unmouting and running btrfs check, the drive
> reverted to reporting the old size. Not sure if this was due to
> unmounting / mounting or doing btrfs check. Btrfs check should have
> been running in readonly mode.

It reverted to the old size because the transaction used for the
resize operation never got committed due to the deadlock, not because
of 'btrfs check'.

>  Since it looked like something was
> wrong with the resize process, I patched my kernel with the posted
> patch. This time the resize operation finished successfully.

Great, thanks for testing!

> On Sun, Oct 21, 2018 at 1:56 AM Filipe Manana <fdmanana@gmail.com> wrote:
> >
> > On Sun, Oct 21, 2018 at 6:05 AM Andrew Nelson <andrew.s.nelson@gmail.co=
m> wrote:
> > >
> > > Also, is the drive in a safe state to use? Is there anything I should
> > > run on the drive to check consistency?
> >
> > It should be in a safe state. You can verify it running "btrfs check
> > /dev/<your device>" (it's a readonly operation).
> >
> > If you are able to patch and build a kernel, you can also try the
> > patch. I left it running tests overnight and haven't got any
> > regressions.
> >
> > Thanks.
> >
> > > On Sat, Oct 20, 2018 at 10:02 PM Andrew Nelson
> > > <andrew.s.nelson@gmail.com> wrote:
> > > >
> > > > I have ran the "btrfs inspect-internal dump-tree -t 1" command, but
> > > > the output is ~55mb. Is there something in particular you are looki=
ng
> > > > for in this?
> > > > On Sat, Oct 20, 2018 at 1:34 PM Filipe Manana <fdmanana@gmail.com> =
wrote:
> > > > >
> > > > > On Sat, Oct 20, 2018 at 9:27 PM Liu Bo <obuil.liubo@gmail.com> wr=
ote:
> > > > > >
> > > > > > On Fri, Oct 19, 2018 at 7:09 PM Andrew Nelson <andrew.s.nelson@=
gmail.com> wrote:
> > > > > > >
> > > > > > > I am having an issue with btrfs resize in Fedora 28. I am att=
empting
> > > > > > > to enlarge my Btrfs partition. Every time I run "btrfs filesy=
stem
> > > > > > > resize max $MOUNT", the command runs for a few minutes and th=
en hangs
> > > > > > > forcing the system to be reset. I am not sure what the state =
of the
> > > > > > > filesystem really is at this point. Btrfs usage does report t=
he
> > > > > > > correct size for after resizing. Details below:
> > > > > > >
> > > > > >
> > > > > > Thanks for the report, the stack is helpful, but this needs a f=
ew
> > > > > > deeper debugging, may I ask you to post "btrfs inspect-internal
> > > > > > dump-tree -t 1 /dev/your_btrfs_disk"?
> > > > >
> > > > > I believe it's actually easy to understand from the trace alone a=
nd
> > > > > it's kind of a bad luck scenario.
> > > > > I made this fix a few hours ago:
> > > > >
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.gi=
t/commit/?h=3Dfix_find_free_extent_deadlock
> > > > >
> > > > > But haven't done full testing yet and might have missed something=
.
> > > > > Bo, can you take a look and let me know what you think?
> > > > >
> > > > > Thanks.
> > > > >
> > > > > >
> > > > > > So I'd like to know what's the height of your tree "1" which re=
fers to
> > > > > > root tree in btrfs.
> > > > > >
> > > > > > thanks,
> > > > > > liubo
> > > > > >
> > > > > > > $ sudo btrfs filesystem usage $MOUNT
> > > > > > > Overall:
> > > > > > >     Device size:                  90.96TiB
> > > > > > >     Device allocated:             72.62TiB
> > > > > > >     Device unallocated:           18.33TiB
> > > > > > >     Device missing:                  0.00B
> > > > > > >     Used:                         72.62TiB
> > > > > > >     Free (estimated):             18.34TiB      (min: 9.17TiB=
)
> > > > > > >     Data ratio:                       1.00
> > > > > > >     Metadata ratio:                   2.00
> > > > > > >     Global reserve:              512.00MiB      (used: 24.11M=
iB)
> > > > > > >
> > > > > > > Data,single: Size:72.46TiB, Used:72.45TiB
> > > > > > >     $MOUNT        72.46TiB
> > > > > > >
> > > > > > > Metadata,DUP: Size:86.00GiB, Used:84.96GiB
> > > > > > >     $MOUNT       172.00GiB
> > > > > > >
> > > > > > > System,DUP: Size:40.00MiB, Used:7.53MiB
> > > > > > >    $MOUNT        80.00MiB
> > > > > > >
> > > > > > > Unallocated:
> > > > > > >     $MOUNT        18.33TiB
> > > > > > >
> > > > > > > $ uname -a
> > > > > > > Linux localhost.localdomain 4.18.14-200.fc28.x86_64 #1 SMP Mo=
n Oct 15
> > > > > > > 13:16:27 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> > > > > > >
> > > > > > > btrfs-transacti D    0  2501      2 0x80000000
> > > > > > > Call Trace:
> > > > > > >  ? __schedule+0x253/0x860
> > > > > > >  schedule+0x28/0x80
> > > > > > >  btrfs_commit_transaction+0x7aa/0x8b0 [btrfs]
> > > > > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > > > > >  ? join_transaction+0x22/0x3e0 [btrfs]
> > > > > > >  ? finish_wait+0x80/0x80
> > > > > > >  transaction_kthread+0x155/0x170 [btrfs]
> > > > > > >  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> > > > > > >  kthread+0x112/0x130
> > > > > > >  ? kthread_create_worker_on_cpu+0x70/0x70
> > > > > > >  ret_from_fork+0x35/0x40
> > > > > > > btrfs           D    0  2504   2502 0x00000002
> > > > > > > Call Trace:
> > > > > > >  ? __schedule+0x253/0x860
> > > > > > >  schedule+0x28/0x80
> > > > > > >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> > > > > > >  ? finish_wait+0x80/0x80
> > > > > > >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > > > > > >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> > > > > > >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> > > > > > >  ? inode_insert5+0x119/0x190
> > > > > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > > > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > > > > >  btrfs_iget+0x113/0x690 [btrfs]
> > > > > > >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> > > > > > >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> > > > > > >  load_free_space_cache+0x7c/0x170 [btrfs]
> > > > > > >  ? cache_block_group+0x72/0x3b0 [btrfs]
> > > > > > >  cache_block_group+0x1b3/0x3b0 [btrfs]
> > > > > > >  ? finish_wait+0x80/0x80
> > > > > > >  find_free_extent+0x799/0x1010 [btrfs]
> > > > > > >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > > > > > >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> > > > > > >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> > > > > > >  btrfs_cow_block+0xdc/0x180 [btrfs]
> > > > > > >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> > > > > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > > > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > > > > >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> > > > > > >  cache_save_setup+0xe4/0x3a0 [btrfs]
> > > > > > >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> > > > > > >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> > > > > > >  ? btrfs_release_path+0x13/0x80 [btrfs]
> > > > > > >  ? btrfs_update_device+0x8d/0x1c0 [btrfs]
> > > > > > >  btrfs_ioctl_resize.cold.46+0xf4/0xf9 [btrfs]
> > > > > > >  btrfs_ioctl+0xa25/0x2cf0 [btrfs]
> > > > > > >  ? tty_write+0x1fc/0x330
> > > > > > >  ? do_vfs_ioctl+0xa4/0x620
> > > > > > >  do_vfs_ioctl+0xa4/0x620
> > > > > > >  ksys_ioctl+0x60/0x90
> > > > > > >  ? ksys_write+0x4f/0xb0
> > > > > > >  __x64_sys_ioctl+0x16/0x20
> > > > > > >  do_syscall_64+0x5b/0x160
> > > > > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > > > RIP: 0033:0x7fcdc0d78c57
> > > > > > > Code: Bad RIP value.
> > > > > > > RSP: 002b:00007ffdd1ee6cf8 EFLAGS: 00000246 ORIG_RAX: 0000000=
000000010
> > > > > > > RAX: ffffffffffffffda RBX: 00007ffdd1ee888a RCX: 00007fcdc0d7=
8c57
> > > > > > > RDX: 00007ffdd1ee6da0 RSI: 0000000050009403 RDI: 000000000000=
0003
> > > > > > > RBP: 00007ffdd1ee6da0 R08: 0000000000000000 R09: 00007ffdd1ee=
67e0
> > > > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdd1ee=
888e
> > > > > > > R13: 0000000000000003 R14: 0000000000000000 R15: 000000000000=
0000
> > > > > > > kworker/u48:1   D    0  2505      2 0x80000000
> > > > > > > Workqueue: btrfs-freespace-write btrfs_freespace_write_helper=
 [btrfs]
> > > > > > > Call Trace:
> > > > > > >  ? __schedule+0x253/0x860
> > > > > > >  schedule+0x28/0x80
> > > > > > >  btrfs_tree_lock+0x130/0x210 [btrfs]
> > > > > > >  ? finish_wait+0x80/0x80
> > > > > > >  btrfs_search_slot+0x775/0x9f0 [btrfs]
> > > > > > >  btrfs_mark_extent_written+0xb0/0xb20 [btrfs]
> > > > > > >  ? join_transaction+0x22/0x3e0 [btrfs]
> > > > > > >  btrfs_finish_ordered_io+0x2e0/0x7e0 [btrfs]
> > > > > > >  ? syscall_return_via_sysret+0x13/0x83
> > > > > > >  ? __switch_to_asm+0x34/0x70
> > > > > > >  normal_work_helper+0xd3/0x2f0 [btrfs]
> > > > > > >  process_one_work+0x1a1/0x350
> > > > > > >  worker_thread+0x30/0x380
> > > > > > >  ? pwq_unbound_release_workfn+0xd0/0xd0
> > > > > > >  kthread+0x112/0x130
> > > > > > >  ? kthread_create_worker_on_cpu+0x70/0x70
> > > > > > >  ret_from_fork+0x35/0x40
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Filipe David Manana,
> > > > >
> > > > > =E2=80=9CWhether you think you can, or you think you can't =E2=80=
=94 you're right.=E2=80=9D
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D

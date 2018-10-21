Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B4EECDE3D
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 05:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9619520838
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 05:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hup5B5QJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9619520838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJUNSq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 09:18:46 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44949 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbeJUNSq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 09:18:46 -0400
Received: by mail-ot1-f66.google.com with SMTP id p23so36922142otf.11
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Oct 2018 22:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5oU0d+v1lMSB64P3MkOqxpeZn6iOSnOKzZwX0kidTOU=;
        b=Hup5B5QJAnwWYvhoN0by6ClBSL1uaITg6fvbGzNmj587Ewdr/F+UaeIjBW/POvfuh0
         ZgXRcgJyDixr1hBduxkiuhCQj5BD5tB/pficdNjZrGMepi2a/UFEuvZuJnIVijVwOeOH
         vQorzZp4dskPerQgTcrYKdA6UF1INslpUkzr/1A93/5aHI+BnV11lZ08tYs8ApoYhBTz
         gFuydW9LfsyMrwYN9xKQHk77WIvf6ZGvSIYe7HqpPOXWRIrhhwSxhV/C9pGIzlU8ECvm
         PH03Lb/I1XN0dpCzvlxvoWjoHa5EIVM2C1xw2VP1MCmnDGVRO0qM2eViTvcFt0hJ441N
         gavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5oU0d+v1lMSB64P3MkOqxpeZn6iOSnOKzZwX0kidTOU=;
        b=XeB09iT7TUqMrqaAFFFdDcr6H/QB1jCGIS6dt+7J9+3+z069Rnqy0p7kP5miDZB1hQ
         SdFu95FiF/DG8xBQDACu7IMalFKQCRlqxLrpX9hTCZtLwodwDtGpBjVYHQ64EMd54cgb
         YsO0yXnHsIFtt3f9V8x6aUqt5frmspo1RcXlFRX+/YyWJTA+1qocpYjC5tOFtOZ57sUP
         rrn1jYJVxfc+ugh753FBFKF/+e1TlsZAoTQMRRvHxQCOUflKFHmRkxpeXRxslr5oJbHD
         wwhAi98KAcH/FqPGJ7l0AcVCeoBxjoKjlWZJCE9+CSvT1gzbcp4P3smgnAkFSihG2GQY
         Pyew==
X-Gm-Message-State: ABuFfojjVMpU258K5uZPrEfuRU/VXphk/zM9nH5g3GKL4ZPXgnW35e/g
        oiXV/eOVKNTig5BwNAX2XMywlZt/NwdKzPavQJM=
X-Google-Smtp-Source: ACcGV60jmjWh0sNkCOJnhLqwONrnMnQf5kQvvCC/rw7/3Jg6NHJJpov6UMIvTjyebIPwEZhTsqQq7XS+x6ShmXN4d+k=
X-Received: by 2002:a9d:541d:: with SMTP id j29mr24578386oth.329.1540098343678;
 Sat, 20 Oct 2018 22:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com>
 <CANQeFDBAxL=BTWjCOVmu8rGP0k2OCipD07my4RQs8vV9NJeraw@mail.gmail.com>
 <CAL3q7H6-06g12Kv1FD30Tii+zoQjDmJj+aM8kCnLeJVVvNad5A@mail.gmail.com> <CAPTELen29rS9ZoECxf7kBvDDRGFUcB=TQn2o=T+cmV=a-x9N2Q@mail.gmail.com>
In-Reply-To: <CAPTELen29rS9ZoECxf7kBvDDRGFUcB=TQn2o=T+cmV=a-x9N2Q@mail.gmail.com>
From:   Andrew Nelson <andrew.s.nelson@gmail.com>
Date:   Sat, 20 Oct 2018 22:05:24 -0700
Message-ID: <CAPTELe=ObC4gbjB+vjuYCHyqPxr4rakWYksN8p1P=UL8BsU_wg@mail.gmail.com>
Subject: Re: Btrfs resize seems to deadlock
To:     fdmanana@gmail.com
Cc:     obuil.liubo@gmail.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Also, is the drive in a safe state to use? Is there anything I should
run on the drive to check consistency?
On Sat, Oct 20, 2018 at 10:02 PM Andrew Nelson
<andrew.s.nelson@gmail.com> wrote:
>
> I have ran the "btrfs inspect-internal dump-tree -t 1" command, but
> the output is ~55mb. Is there something in particular you are looking
> for in this?
> On Sat, Oct 20, 2018 at 1:34 PM Filipe Manana <fdmanana@gmail.com> wrote:
> >
> > On Sat, Oct 20, 2018 at 9:27 PM Liu Bo <obuil.liubo@gmail.com> wrote:
> > >
> > > On Fri, Oct 19, 2018 at 7:09 PM Andrew Nelson <andrew.s.nelson@gmail.=
com> wrote:
> > > >
> > > > I am having an issue with btrfs resize in Fedora 28. I am attemptin=
g
> > > > to enlarge my Btrfs partition. Every time I run "btrfs filesystem
> > > > resize max $MOUNT", the command runs for a few minutes and then han=
gs
> > > > forcing the system to be reset. I am not sure what the state of the
> > > > filesystem really is at this point. Btrfs usage does report the
> > > > correct size for after resizing. Details below:
> > > >
> > >
> > > Thanks for the report, the stack is helpful, but this needs a few
> > > deeper debugging, may I ask you to post "btrfs inspect-internal
> > > dump-tree -t 1 /dev/your_btrfs_disk"?
> >
> > I believe it's actually easy to understand from the trace alone and
> > it's kind of a bad luck scenario.
> > I made this fix a few hours ago:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git/comm=
it/?h=3Dfix_find_free_extent_deadlock
> >
> > But haven't done full testing yet and might have missed something.
> > Bo, can you take a look and let me know what you think?
> >
> > Thanks.
> >
> > >
> > > So I'd like to know what's the height of your tree "1" which refers t=
o
> > > root tree in btrfs.
> > >
> > > thanks,
> > > liubo
> > >
> > > > $ sudo btrfs filesystem usage $MOUNT
> > > > Overall:
> > > >     Device size:                  90.96TiB
> > > >     Device allocated:             72.62TiB
> > > >     Device unallocated:           18.33TiB
> > > >     Device missing:                  0.00B
> > > >     Used:                         72.62TiB
> > > >     Free (estimated):             18.34TiB      (min: 9.17TiB)
> > > >     Data ratio:                       1.00
> > > >     Metadata ratio:                   2.00
> > > >     Global reserve:              512.00MiB      (used: 24.11MiB)
> > > >
> > > > Data,single: Size:72.46TiB, Used:72.45TiB
> > > >     $MOUNT        72.46TiB
> > > >
> > > > Metadata,DUP: Size:86.00GiB, Used:84.96GiB
> > > >     $MOUNT       172.00GiB
> > > >
> > > > System,DUP: Size:40.00MiB, Used:7.53MiB
> > > >    $MOUNT        80.00MiB
> > > >
> > > > Unallocated:
> > > >     $MOUNT        18.33TiB
> > > >
> > > > $ uname -a
> > > > Linux localhost.localdomain 4.18.14-200.fc28.x86_64 #1 SMP Mon Oct =
15
> > > > 13:16:27 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> > > >
> > > > btrfs-transacti D    0  2501      2 0x80000000
> > > > Call Trace:
> > > >  ? __schedule+0x253/0x860
> > > >  schedule+0x28/0x80
> > > >  btrfs_commit_transaction+0x7aa/0x8b0 [btrfs]
> > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > >  ? join_transaction+0x22/0x3e0 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  transaction_kthread+0x155/0x170 [btrfs]
> > > >  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> > > >  kthread+0x112/0x130
> > > >  ? kthread_create_worker_on_cpu+0x70/0x70
> > > >  ret_from_fork+0x35/0x40
> > > > btrfs           D    0  2504   2502 0x00000002
> > > > Call Trace:
> > > >  ? __schedule+0x253/0x860
> > > >  schedule+0x28/0x80
> > > >  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > > >  btrfs_search_slot+0xf6/0x9f0 [btrfs]
> > > >  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
> > > >  ? inode_insert5+0x119/0x190
> > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > >  btrfs_iget+0x113/0x690 [btrfs]
> > > >  __lookup_free_space_inode+0xd8/0x150 [btrfs]
> > > >  lookup_free_space_inode+0x5b/0xb0 [btrfs]
> > > >  load_free_space_cache+0x7c/0x170 [btrfs]
> > > >  ? cache_block_group+0x72/0x3b0 [btrfs]
> > > >  cache_block_group+0x1b3/0x3b0 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  find_free_extent+0x799/0x1010 [btrfs]
> > > >  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > > >  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
> > > >  __btrfs_cow_block+0x11d/0x500 [btrfs]
> > > >  btrfs_cow_block+0xdc/0x180 [btrfs]
> > > >  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
> > > >  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > > >  ? kmem_cache_alloc+0x166/0x1d0
> > > >  btrfs_update_inode_item+0x46/0x100 [btrfs]
> > > >  cache_save_setup+0xe4/0x3a0 [btrfs]
> > > >  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
> > > >  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> > > >  ? btrfs_release_path+0x13/0x80 [btrfs]
> > > >  ? btrfs_update_device+0x8d/0x1c0 [btrfs]
> > > >  btrfs_ioctl_resize.cold.46+0xf4/0xf9 [btrfs]
> > > >  btrfs_ioctl+0xa25/0x2cf0 [btrfs]
> > > >  ? tty_write+0x1fc/0x330
> > > >  ? do_vfs_ioctl+0xa4/0x620
> > > >  do_vfs_ioctl+0xa4/0x620
> > > >  ksys_ioctl+0x60/0x90
> > > >  ? ksys_write+0x4f/0xb0
> > > >  __x64_sys_ioctl+0x16/0x20
> > > >  do_syscall_64+0x5b/0x160
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > RIP: 0033:0x7fcdc0d78c57
> > > > Code: Bad RIP value.
> > > > RSP: 002b:00007ffdd1ee6cf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
010
> > > > RAX: ffffffffffffffda RBX: 00007ffdd1ee888a RCX: 00007fcdc0d78c57
> > > > RDX: 00007ffdd1ee6da0 RSI: 0000000050009403 RDI: 0000000000000003
> > > > RBP: 00007ffdd1ee6da0 R08: 0000000000000000 R09: 00007ffdd1ee67e0
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdd1ee888e
> > > > R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
> > > > kworker/u48:1   D    0  2505      2 0x80000000
> > > > Workqueue: btrfs-freespace-write btrfs_freespace_write_helper [btrf=
s]
> > > > Call Trace:
> > > >  ? __schedule+0x253/0x860
> > > >  schedule+0x28/0x80
> > > >  btrfs_tree_lock+0x130/0x210 [btrfs]
> > > >  ? finish_wait+0x80/0x80
> > > >  btrfs_search_slot+0x775/0x9f0 [btrfs]
> > > >  btrfs_mark_extent_written+0xb0/0xb20 [btrfs]
> > > >  ? join_transaction+0x22/0x3e0 [btrfs]
> > > >  btrfs_finish_ordered_io+0x2e0/0x7e0 [btrfs]
> > > >  ? syscall_return_via_sysret+0x13/0x83
> > > >  ? __switch_to_asm+0x34/0x70
> > > >  normal_work_helper+0xd3/0x2f0 [btrfs]
> > > >  process_one_work+0x1a1/0x350
> > > >  worker_thread+0x30/0x380
> > > >  ? pwq_unbound_release_workfn+0xd0/0xd0
> > > >  kthread+0x112/0x130
> > > >  ? kthread_create_worker_on_cpu+0x70/0x70
> > > >  ret_from_fork+0x35/0x40
> >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D

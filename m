Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0D9C10F11
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 02:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F3B2075A
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 02:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="KPilGPX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbfDWCjE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 22:39:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44039 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbfDWCjD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 22:39:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id h16so11988765ljg.11
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 19:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UpWc5yc4j0yZdIZcPIcR+559ZCWvAp7H6Y+TTw6Px34=;
        b=KPilGPX626JNee68tEz5kvBiYkNyTYJgWrsSQqtEpo/lmNGZZ48Gyq3SdpCmODLTbF
         wsZc+r7mW5NOMYIo7WGKNmZy86n1oc7iMT3qXSg8NWkeLbVOEoJUp+f7QGdKIPtWP4xy
         22OjrvA/lGoYrQGgCtpbOaiKZ2WD3jOKWWjXDWqugq87xSjWh5aXaB8cKZwV4FCuJ4rW
         P/eXQFO1RuKdjf+B/57g203bUhjcjWx77mivSXmpv6f/7SeVrWvuofua5E5ucdGfaGHK
         w3kYfXPmxo7CkqeaZVEAAqLScFEj7k5fc37oKm3kC8eCgMjEg+tqBKN1O64iuwEEltbK
         FQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UpWc5yc4j0yZdIZcPIcR+559ZCWvAp7H6Y+TTw6Px34=;
        b=R+OgFRwBMkWj8SmBLD65n9YKvwgpJAVu5080Vte66ZEyinnyeay7ioSVwlLWVcQbgT
         zCCLcYagFtN4ply/pWFvXii7Of38exHKnYN2LkCS/amur0uGZdK5iSLDpbVxTLyMxzyG
         6fHbsBBdwDcNbQyNHrdnLTphfxSVd+NuB0Abktkm2apwt87xNEGRNINoskiGqY4GFOpf
         O629T34U5s9+dWEq5AkluwXXHbWOkRHAxoEM8LHiAZdLs+m8Mx8o5BX3HWgZyLfQVBeH
         5c0dl/bzY2Q00+4xfmepO3NR3ggF6C16t6wGKrYvN+r9m4HAij3g/9oXomZ1Evgqv1Tm
         /Qdw==
X-Gm-Message-State: APjAAAUB7ST5lwaibyW1tpAPpQPoNyRtKM8nGO9ItV2ZNGS7ovENEDUo
        mx05bMBW9CAK1TOXQNuy/rIOa7qv6O4RW8mUronHiH0kHqg=
X-Google-Smtp-Source: APXvYqynmJ27+ce0056JOC6Euo6k5/5hrwWWlPi1NqY5+dHZCN1jlVMrGu7NvrxffYu77xY6iTGQjIDa058QRLvc7ZY=
X-Received: by 2002:a2e:8582:: with SMTP id b2mr11849840lji.24.1555987140929;
 Mon, 22 Apr 2019 19:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
In-Reply-To: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 22 Apr 2019 20:38:49 -0600
Message-ID: <CAJCQCtQcpmWAnXrRQdMytvOhZ6eO2P=o1K4Hr5R2C-iWKudh3Q@mail.gmail.com>
Subject: Re: reading/writing btrfs volume regularly freezes system
To:     Nathan Dehnel <ncdehnel@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 22, 2019 at 2:38 PM Nathan Dehnel <ncdehnel@gmail.com> wrote:
>
> I have a raid10 volume that frequently locks up when I try to write to
> it or delete things. Any command that touches it will hang (and can't
> be killed) and I have to start a new ssh session to get into the
> computer again. Nothing fixes it besides a reboot, and the volume will
> fail to unmount while the computer is shutting down.
>
> [  302.360912] sysrq: SysRq : Show Blocked State
> [  302.360951]   task                        PC stack   pid father
> [  302.360987] btrfs-transacti D    0  2187      2 0x80000000
> [  302.360993] Call Trace:
> [  302.361007]  ? __schedule+0x59d/0x5f1
> [  302.361012]  schedule+0x6a/0x85
> [  302.361019]  btrfs_commit_transaction+0x219/0x7ac
> [  302.361027]  ? wait_woken+0x6d/0x6d
> [  302.361031]  transaction_kthread+0xc9/0x135
> [  302.361036]  ? btrfs_cleanup_transaction+0x4c7/0x4c7
> [  302.361041]  kthread+0x115/0x11d
> [  302.361046]  ? kthread_park+0x76/0x76
> [  302.361050]  ret_from_fork+0x35/0x40
> [  302.361064] nfsd            D    0  2292      2 0x80000000
> [  302.361067] Call Trace:
> [  302.361072]  ? __schedule+0x59d/0x5f1
> [  302.361077]  schedule+0x6a/0x85
> [  302.361120]  wait_current_trans+0x9b/0xd8
> [  302.361126]  ? wait_woken+0x6d/0x6d
> [  302.361131]  start_transaction+0x1ae/0x38e
> [  302.361135]  btrfs_create+0x59/0x1d0
> [  302.361142]  vfs_create+0xbf/0xef
> [  302.361160]  do_nfsd_create+0x2be/0x41d [nfsd]
> [  302.361214]  nfsd4_open+0x223/0x578 [nfsd]
> [  302.361229]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
> [  302.361240]  nfsd_dispatch+0xb9/0x16e [nfsd]
> [  302.361258]  svc_process+0x524/0x6e2 [sunrpc]
> [  302.361270]  ? nfsd_destroy+0x5f/0x5f [nfsd]
> [  302.361278]  nfsd+0xf9/0x150 [nfsd]
> [  302.361284]  kthread+0x115/0x11d
> [  302.361289]  ? kthread_park+0x76/0x76
> [  302.361292]  ret_from_fork+0x35/0x40
> [  302.361297] nfsd            D    0  2293      2 0x80000000
> [  302.361300] Call Trace:
> [  302.361305]  ? __schedule+0x59d/0x5f1
> [  302.361309]  schedule+0x6a/0x85
> [  302.361314]  rwsem_down_write_failed+0x1af/0x210
> [  302.361325]  ? nfsd_permission+0xa3/0xe8 [nfsd]
> [  302.361330]  call_rwsem_down_write_failed+0x13/0x20
> [  302.361335]  down_write+0x20/0x2e
> [  302.361345]  nfsd_unlink+0xb1/0x16b [nfsd]
> [  302.361359]  nfsd4_remove+0x4e/0x10a [nfsd]
> [  302.361371]  nfsd4_proc_compound+0x44a/0x562 [nfsd]
> [  302.361381]  nfsd_dispatch+0xb9/0x16e [nfsd]
> [  302.361395]  svc_process+0x524/0x6e2 [sunrpc]
> [  302.361401]  ? __mutex_unlock_slowpath.isra.6+0x1e8/0x20a
> [  302.361410]  ? nfsd_destroy+0x5f/0x5f [nfsd]
> [  302.361419]  nfsd+0xf9/0x150 [nfsd]
> [  302.361424]  kthread+0x115/0x11d
> [  302.361428]  ? kthread_park+0x76/0x76
> [  302.361434]  ret_from_fork+0x35/0x40
> [  302.361441] rm              D    0  2388   2334 0x00000004
> [  302.361444] Call Trace:
> [  302.361449]  ? __schedule+0x59d/0x5f1
> [  302.361453]  schedule+0x6a/0x85
> [  302.361457]  wait_current_trans+0x9b/0xd8
> [  302.361462]  ? wait_woken+0x6d/0x6d
> [  302.361466]  start_transaction+0x1ae/0x38e
> [  302.361471]  btrfs_start_transaction_fallback_global_rsv+0x32/0x127
> [  302.361475]  btrfs_unlink+0x30/0xc0
> [  302.361478]  vfs_unlink+0xd2/0x147
> [  302.361482]  do_unlinkat+0x112/0x223
> [  302.361488]  do_syscall_64+0x7e/0x133
> [  302.361492]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  302.361496] RIP: 0033:0x7f681509b5d7
> [  302.361504] Code: Bad RIP value.
> [  302.361506] RSP: 002b:00007fffb1aed668 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000107
> [  302.361510] RAX: ffffffffffffffda RBX: 000055672760c6c0 RCX: 00007f681509b5d7
> [  302.361512] RDX: 0000000000000000 RSI: 000055672760b490 RDI: 00000000ffffff9c
> [  302.361514] RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> [  302.361516] R10: fffffffffffff12b R11: 0000000000000202 R12: 00007fffb1aed848
> [  302.361518] R13: 000055672760b400 R14: 0000000000000002 R15: 0000000000000000


What kernel version? Is it reproducible with something current? i.e.
5.0.6 or ideally 5.1rc6?

And is this actually writes/deletes to NFS as an intermediate to the
Btrfs volume? I can't really tell from the call trace if this is an
issue in nfsd or use case specific problem with NFS on Btrfs. You're
able to directly write/delete with this Btrfs volume?

Since you're getting some information out of the system when this
happens (call trace) I'm wondering if you can issue sysrq+t during the
hang? I find setting up sysrq and writing out the trigger command in a
console (either a tty if you have physical access, or netconsole),
then reproduce the hang, and then hit return on the console with the
pre-typed sysrq command. Sometimes the sysrq output is quite a lot for
the kernel buffer and will overflow dmesg,  so you'll either need to
use  `log_buf_len=1M` boot parameter, or you can get sysrq output from
journalctl if it's a system system.


-- 
Chris Murphy

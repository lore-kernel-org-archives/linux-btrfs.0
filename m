Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAEBC004D2
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 13:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9858B2089A
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 13:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rarcoa.com header.i=@rarcoa.com header.b="OS4CRlqx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9858B2089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rarcoa.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbeJBUPC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 16:15:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39346 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731103AbeJBUPB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 16:15:01 -0400
Received: by mail-lf1-f68.google.com with SMTP id w21-v6so1409766lff.6
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rarcoa.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=HSxIaskcG5Frw1/5tkoxcFuR8dFIvYs9khtePZolymg=;
        b=OS4CRlqxmqTAWQoNrQNEFRzSCzfzYqFK8Yz5a6RwXw1q+eRx3J62FMiH9mdcqSA6vO
         r7/YKC40l5OxSMhQOqUsTcDNqoEhzCofXyDUWahe6ANb09jZY8t/fKE5lZSFs8E2myee
         QZ2YtpUrCuSHV4y/3LO72IMtEQb6LoaZbzXfOF8ebv0zwWWonu03yQARI9wT/QsDOUO2
         rGyCPWVq/KOyHwJ7bCsJVOINZsVtgWTC8bYcvYW+lgJKf+a3TJRZ+KzrcLmerq7A6huB
         abQWNzVaazRExk5OIuISr9niEGd0pnu2stF7UFS5sslvKG/4ETdmditi6aDOxdpp83x1
         pgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HSxIaskcG5Frw1/5tkoxcFuR8dFIvYs9khtePZolymg=;
        b=AyoYltcE6wbBeMUvnPE6PSjRifvuIDdBwDhEW06KMQcIj2ZQ9ZEDuozj5sWlYsGq8t
         LigcarNcXcHq7OfRuLYuacjmE2HItqjTJXyk+vA9DCZ1BHZ6cywEYJvs6ormn5j9FAEh
         DYARmWsXHH8x8fbet8DxF+0bhHlbEjx+mqSQHHQOAObBS99lcSC6mipchdLoHtuLucjh
         Racf/YCSJ/4/DpIy1+XmBlU4b9+cDwXQLwkwe4xpb5l0U9bWMCrCBs/VgxTPUbmNZVCO
         j53ggfyq2eoPEPcB+aPpF5rGs5x64RfuiyVz1ChMi0YF7oyEjhrDJciBJR4kidve0YHt
         y6/Q==
X-Gm-Message-State: ABuFfoiKtVyYH4QNhKBObpIWyUzfdw3Awy+guedy3bzhNKRXN/WihGXH
        w2+Ei+cqHB98KsCpc9CAAKzLxiLak+tBaEn1WrHM6E3pNwdb9g==
X-Google-Smtp-Source: ACcGV62yDq5QjFIm6afxECmdLvrA7F4JqfpfD4Lxc+xBh9/VZ9JwLGdWvNtomPScpw7EMvJzrmePBAgitPwfJzSGPBU=
X-Received: by 2002:ac2:5082:: with SMTP id f2-v6mr8103879lfm.47.1538487095955;
 Tue, 02 Oct 2018 06:31:35 -0700 (PDT)
MIME-Version: 1.0
From:   Gerard Saraber <gsaraber@rarcoa.com>
Date:   Tue, 2 Oct 2018 08:31:25 -0500
Message-ID: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
Subject: Writing a large file causes odd freeze
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a 25TB mirrored filesystem that I'm able to consistently freeze
by ungzipping a large file.
The filesystem scrubs complete without errors and smartd reports no
errors at the moment.

The command is:
gzip -dc /btrfsarray/largefile.gz > /btrfs/db/output.sql
At around 31GB it quits writing to the output file, and I start
getting the 'hung task' messages in my kernel log.
They are 3.0GB gzipped SQL dumps, that uncompress into about 42GB SQL
dump files.

after that 'ps auwx' completely hangs and I can't write to the
filesystem anymore, no errors, the processes just hang. I can still
read from the FS as far as I can tell.
I'm not sure how to diagnose it, or if i've simply ran into some kind
of bug (may not even be BTRFS related)

Linux cloud1 4.18.10 #1 SMP Fri Sep 28 07:44:06 CDT 2018 x86_64 x86_64
x86_64 GNU/Linux
[ I think It used to work on 4.18.0-rcX ]

Hardware specs:
 AMD Ryzen Threadripper 1950X 16-Core Processor
128GB ram
A bunch of 3-8TB SATA drives connected to the motherboard and a pair
of LSI cards

root@cloud1:~# btrfs fi usage /btrfsarray
Overall:
    Device size:                  79.14TiB
    Device allocated:             55.38TiB
    Device unallocated:           23.76TiB
    Device missing:                  0.00B
    Used:                         55.30TiB
    Free (estimated):             11.91TiB      (min: 11.91TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:27.61TiB, Used:27.58TiB
   /dev/sda        1.64TiB
   /dev/sdb        1.64TiB
   /dev/sdc        1.87TiB
   /dev/sdd        4.37TiB
   /dev/sde        2.55TiB
   /dev/sdf        2.55TiB
   /dev/sdg        4.37TiB
   /dev/sdh        4.36TiB
   /dev/sdi        2.55TiB
   /dev/sdj        4.36TiB
   /dev/sdk        4.37TiB
   /dev/sdl        1.64TiB
   /dev/sdm        4.37TiB
   /dev/sdn        2.54TiB
   /dev/sdo        2.55TiB
   /dev/sdp        2.55TiB
   /dev/sdq        2.55TiB
   /dev/sdr        4.37TiB

Metadata,RAID1: Size:87.00GiB, Used:77.46GiB
   /dev/sda        5.00GiB
   /dev/sdb        5.00GiB
   /dev/sdd       14.00GiB
   /dev/sde       12.00GiB
   /dev/sdf        8.00GiB
   /dev/sdg        6.00GiB
   /dev/sdh       20.00GiB
   /dev/sdi       11.00GiB
   /dev/sdj       19.00GiB
   /dev/sdk        5.00GiB
   /dev/sdl        6.00GiB
   /dev/sdm        7.00GiB
   /dev/sdn       17.00GiB
   /dev/sdo        7.00GiB
   /dev/sdp       13.00GiB
   /dev/sdq       12.00GiB
   /dev/sdr        7.00GiB

System,RAID1: Size:32.00MiB, Used:5.19MiB
   /dev/sdc       32.00MiB
   /dev/sdr       32.00MiB

Unallocated:
   /dev/sda        1.08TiB
   /dev/sdb        1.08TiB
   /dev/sdc        5.40TiB
   /dev/sdd        1.08TiB
   /dev/sde        1.08TiB
   /dev/sdf        1.08TiB
   /dev/sdg        1.08TiB
   /dev/sdh        1.08TiB
   /dev/sdi        1.08TiB
   /dev/sdj        1.08TiB
   /dev/sdk        1.08TiB
   /dev/sdl        1.08TiB
   /dev/sdm        1.08TiB
   /dev/sdn        1.08TiB
   /dev/sdo        1.08TiB
   /dev/sdp        1.08TiB
   /dev/sdq        1.08TiB
   /dev/sdr        1.08TiB


Oct  2 08:02:25 cloud1 kernel: [165537.793055] INFO: task smbd:47578
blocked for more than 120 seconds.
Oct  2 08:02:25 cloud1 kernel: [165537.793068]       Not tainted 4.18.10 #1
Oct  2 08:02:25 cloud1 kernel: [165537.793079] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 08:02:25 cloud1 kernel: [165537.793094] smbd            D    0
47578   3375 0x00000000
Oct  2 08:02:25 cloud1 kernel: [165537.793096] Call Trace:
Oct  2 08:02:25 cloud1 kernel: [165537.793098]  ? __schedule+0x299/0x880
Oct  2 08:02:25 cloud1 kernel: [165537.793100]  schedule+0x28/0x80
Oct  2 08:02:25 cloud1 kernel: [165537.793102]  wait_current_trans+0xad/0xe0
Oct  2 08:02:25 cloud1 kernel: [165537.793104]  ? wait_woken+0x80/0x80
Oct  2 08:02:25 cloud1 kernel: [165537.793106]  start_transaction+0x2ee/0x3c0
Oct  2 08:02:25 cloud1 kernel: [165537.793108]  btrfs_sync_file+0x279/0x400
Oct  2 08:02:25 cloud1 kernel: [165537.793110]
btrfs_file_write_iter+0x461/0x576
Oct  2 08:02:25 cloud1 kernel: [165537.793111]  __vfs_write+0x114/0x1a0
Oct  2 08:02:25 cloud1 kernel: [165537.793113]  vfs_write+0xad/0x1a0
Oct  2 08:02:25 cloud1 kernel: [165537.793115]  ksys_pwrite64+0x71/0x90
Oct  2 08:02:25 cloud1 kernel: [165537.793116]  ? __switch_to_asm+0x34/0x70
Oct  2 08:02:25 cloud1 kernel: [165537.793117]  do_syscall_64+0x4f/0x100
Oct  2 08:02:25 cloud1 kernel: [165537.793119]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Oct  2 08:02:25 cloud1 kernel: [165537.793120] RIP: 0033:0x7f82af38104f
Oct  2 08:02:25 cloud1 kernel: [165537.793120] Code: Bad RIP value.
Oct  2 08:02:25 cloud1 kernel: [165537.793122] RSP:
002b:00007f8296b4fd70 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
Oct  2 08:02:25 cloud1 kernel: [165537.793124] RAX: ffffffffffffffda
RBX: 0000000000000009 RCX: 00007f82af38104f
Oct  2 08:02:25 cloud1 kernel: [165537.793124] RDX: 0000000000001000
RSI: 000055e06183fea0 RDI: 0000000000000009
Oct  2 08:02:25 cloud1 kernel: [165537.793125] RBP: 000055e06183fea0
R08: 0000000000000000 R09: 00007fffac636080
Oct  2 08:02:25 cloud1 kernel: [165537.793126] R10: 00000000089c8000
R11: 0000000000000293 R12: 0000000000001000
Oct  2 08:02:25 cloud1 kernel: [165537.793127] R13: 00000000089c8000
R14: 00007f82aa40e090 R15: 000055e0616b5f70


Oct  2 08:04:25 cloud1 kernel: [165658.622345] INFO: task
btrfs-transacti:12370 blocked for more than 120 seconds.
Oct  2 08:04:25 cloud1 kernel: [165658.622366]       Not tainted 4.18.10 #1
Oct  2 08:04:25 cloud1 kernel: [165658.622378] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 08:04:25 cloud1 kernel: [165658.622393] btrfs-transacti D    0
12370      2 0x80000000
Oct  2 08:04:25 cloud1 kernel: [165658.622396] Call Trace:
Oct  2 08:04:25 cloud1 kernel: [165658.622406]  ? __schedule+0x299/0x880
Oct  2 08:04:25 cloud1 kernel: [165658.622408]  ?
_raw_spin_unlock_irqrestore+0xa/0x10
Oct  2 08:04:25 cloud1 kernel: [165658.622410]  schedule+0x28/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622414]
btrfs_commit_transaction+0x760/0x870
Oct  2 08:04:25 cloud1 kernel: [165658.622418]  ? wait_woken+0x80/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622420]  transaction_kthread+0x12e/0x150
Oct  2 08:04:25 cloud1 kernel: [165658.622422]  ?
btrfs_cleanup_transaction+0x520/0x520
Oct  2 08:04:25 cloud1 kernel: [165658.622425]  kthread+0x113/0x130
Oct  2 08:04:25 cloud1 kernel: [165658.622427]  ?
kthread_create_worker_on_cpu+0x70/0x70
Oct  2 08:04:25 cloud1 kernel: [165658.622428]  ret_from_fork+0x22/0x40
Oct  2 08:04:25 cloud1 kernel: [165658.622487] INFO: task jsvc:15530
blocked for more than 120 seconds.
Oct  2 08:04:25 cloud1 kernel: [165658.622501]       Not tainted 4.18.10 #1
Oct  2 08:04:25 cloud1 kernel: [165658.622512] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 08:04:25 cloud1 kernel: [165658.622527] jsvc            D    0
15530  15312 0x00000120
Oct  2 08:04:25 cloud1 kernel: [165658.622529] Call Trace:
Oct  2 08:04:25 cloud1 kernel: [165658.622531]  ? __schedule+0x299/0x880
Oct  2 08:04:25 cloud1 kernel: [165658.622533]  schedule+0x28/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622536]
btrfs_start_ordered_extent+0xea/0x120
Oct  2 08:04:25 cloud1 kernel: [165658.622538]  ? wait_woken+0x80/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622540]  btrfs_page_mkwrite+0x1f3/0x500
Oct  2 08:04:25 cloud1 kernel: [165658.622544]  do_page_mkwrite+0x31/0x90
Oct  2 08:04:25 cloud1 kernel: [165658.622546]  do_wp_page+0x214/0x5a0
Oct  2 08:04:25 cloud1 kernel: [165658.622548]  __handle_mm_fault+0xb6a/0x1260
Oct  2 08:04:25 cloud1 kernel: [165658.622551]  ? __seccomp_filter+0x44/0x4c0
Oct  2 08:04:25 cloud1 kernel: [165658.622553]  handle_mm_fault+0xc6/0x200
Oct  2 08:04:25 cloud1 kernel: [165658.622556]  __do_page_fault+0x24c/0x4d0
Oct  2 08:04:25 cloud1 kernel: [165658.622558]  ? page_fault+0x8/0x30
Oct  2 08:04:25 cloud1 kernel: [165658.622559]  page_fault+0x1e/0x30
Oct  2 08:04:25 cloud1 kernel: [165658.622562] RIP: 0033:0x7f9b5aadb47e
Oct  2 08:04:25 cloud1 kernel: [165658.622563] Code: Bad RIP value.
Oct  2 08:04:25 cloud1 kernel: [165658.622569] RSP:
002b:00007f92dccced60 EFLAGS: 00010246
Oct  2 08:04:25 cloud1 kernel: [165658.622571] RAX: 00009606c50d609c
RBX: 00007f9b5c5a1c30 RCX: 0000000000000018
Oct  2 08:04:25 cloud1 kernel: [165658.622572] RDX: 0000000000000000
RSI: 00007f92dccced30 RDI: 0000000000000001
Oct  2 08:04:25 cloud1 kernel: [165658.622572] RBP: 00007f92dccced70
R08: 001f9c207abaa2b8 R09: 00007fff9f29c080
Oct  2 08:04:25 cloud1 kernel: [165658.622573] R10: 00000000048732ba
R11: 0000000000000001 R12: 0000000000000028
Oct  2 08:04:25 cloud1 kernel: [165658.622574] R13: 0000561d92af6950
R14: 0000000000000002 R15: 0000000000000001
Oct  2 08:04:25 cloud1 kernel: [165658.622613] INFO: task mongod:23344
blocked for more than 120 seconds.
Oct  2 08:04:25 cloud1 kernel: [165658.622628]       Not tainted 4.18.10 #1
Oct  2 08:04:25 cloud1 kernel: [165658.622638] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 08:04:25 cloud1 kernel: [165658.622653] mongod          D    0
23344  15560 0x00000120
Oct  2 08:04:25 cloud1 kernel: [165658.622655] Call Trace:
Oct  2 08:04:25 cloud1 kernel: [165658.622657]  ? __schedule+0x299/0x880
Oct  2 08:04:25 cloud1 kernel: [165658.622659]  schedule+0x28/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622661]
btrfs_start_ordered_extent+0xea/0x120
Oct  2 08:04:25 cloud1 kernel: [165658.622663]  ? wait_woken+0x80/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622665]
btrfs_wait_ordered_range+0xbb/0x100
Oct  2 08:04:25 cloud1 kernel: [165658.622667]  btrfs_sync_file+0x30c/0x400
Oct  2 08:04:25 cloud1 kernel: [165658.622671]  do_fsync+0x38/0x60
Oct  2 08:04:25 cloud1 kernel: [165658.622673]  __x64_sys_fdatasync+0x13/0x20
Oct  2 08:04:25 cloud1 kernel: [165658.622675]  do_syscall_64+0x4f/0x100
Oct  2 08:04:25 cloud1 kernel: [165658.622677]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Oct  2 08:04:25 cloud1 kernel: [165658.622678] RIP: 0033:0x7f3d36c122e7
Oct  2 08:04:25 cloud1 kernel: [165658.622679] Code: Bad RIP value.
Oct  2 08:04:25 cloud1 kernel: [165658.622681] RSP:
002b:00007f3d31aef560 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
Oct  2 08:04:25 cloud1 kernel: [165658.622683] RAX: ffffffffffffffda
RBX: 000000000000000c RCX: 00007f3d36c122e7
Oct  2 08:04:25 cloud1 kernel: [165658.622683] RDX: 0000000000000000
RSI: 000000000000000c RDI: 000000000000000c
Oct  2 08:04:25 cloud1 kernel: [165658.622684] RBP: 00007f3d31aef5a0
R08: 00005633b3ab9c00 R09: 00007ffeef7a3080
Oct  2 08:04:25 cloud1 kernel: [165658.622685] R10: 0000000004873546
R11: 0000000000000293 R12: 00005633b3ab9cc0
Oct  2 08:04:25 cloud1 kernel: [165658.622686] R13: 00005633b1075d90
R14: 0000000000000000 R15: 00005633b39a20f8
Oct  2 08:04:25 cloud1 kernel: [165658.622688] INFO: task ftdc:23347
blocked for more than 120 seconds.
Oct  2 08:04:25 cloud1 kernel: [165658.622702]       Not tainted 4.18.10 #1
Oct  2 08:04:25 cloud1 kernel: [165658.622713] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 08:04:25 cloud1 kernel: [165658.622728] ftdc            D    0
23347  15560 0x00000120
Oct  2 08:04:25 cloud1 kernel: [165658.622729] Call Trace:
Oct  2 08:04:25 cloud1 kernel: [165658.622731]  ? __schedule+0x299/0x880
Oct  2 08:04:25 cloud1 kernel: [165658.622733]  schedule+0x28/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622735]  wait_current_trans+0xad/0xe0
Oct  2 08:04:25 cloud1 kernel: [165658.622737]  ? wait_woken+0x80/0x80
Oct  2 08:04:25 cloud1 kernel: [165658.622738]  start_transaction+0x2ee/0x3c0
Oct  2 08:04:25 cloud1 kernel: [165658.622740]  btrfs_create+0x57/0x1f0
Oct  2 08:04:25 cloud1 kernel: [165658.622743]  path_openat+0x13c1/0x16a0
Oct  2 08:04:25 cloud1 kernel: [165658.622746]  do_filp_open+0x9b/0x110
Oct  2 08:04:25 cloud1 kernel: [165658.622748]  ? try_lookup_one_len+0x70/0x70
Oct  2 08:04:25 cloud1 kernel: [165658.622751]  ? close_pdeo+0x93/0xf0
Oct  2 08:04:25 cloud1 kernel: [165658.622753]  ? __check_object_size+0xa7/0x1a0
Oct  2 08:04:25 cloud1 kernel: [165658.622756]  ? __alloc_fd+0x3d/0x160
Oct  2 08:04:25 cloud1 kernel: [165658.622758]  ? do_sys_open+0x1bd/0x250
Oct  2 08:04:25 cloud1 kernel: [165658.622760]  do_sys_open+0x1bd/0x250
Oct  2 08:04:25 cloud1 kernel: [165658.622762]  do_syscall_64+0x4f/0x100
Oct  2 08:04:25 cloud1 kernel: [165658.622763]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Oct  2 08:04:25 cloud1 kernel: [165658.622764] RIP: 0033:0x7f3d36c0ad19
Oct  2 08:04:25 cloud1 kernel: [165658.622765] Code: Bad RIP value.
Oct  2 08:04:25 cloud1 kernel: [165658.622767] RSP:
002b:00007f3d302ec200 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
Oct  2 08:04:25 cloud1 kernel: [165658.622769] RAX: ffffffffffffffda
RBX: 00005633b7197d80 RCX: 00007f3d36c0ad19
Oct  2 08:04:25 cloud1 kernel: [165658.622769] RDX: 0000000000000241
RSI: 00005633b7106740 RDI: 00000000ffffff9c
Oct  2 08:04:25 cloud1 kernel: [165658.622770] RBP: 00005633b1077b13
R08: 0000000000000000 R09: 00005633b1077b14
Oct  2 08:04:25 cloud1 kernel: [165658.622771] R10: 00000000000001b6
R11: 0000000000000293 R12: 0000000000000004
Oct  2 08:04:25 cloud1 kernel: [165658.622771] R13: 00005633b1077b12
R14: 00007f3d302ec720 R15: 00005633b9942004

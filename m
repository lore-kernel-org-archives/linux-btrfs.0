Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350E8C43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5E08206B2
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:50:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rarcoa.com header.i=@rarcoa.com header.b="XoXjyrpW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5E08206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rarcoa.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbeJBWe6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 18:34:58 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38633 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbeJBWe6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 18:34:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id g89-v6so1804925lfl.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rarcoa.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tg9Juu811cBD+q7cNlUnF7KC5YbEZiwnNOtSRxN497A=;
        b=XoXjyrpW96hBfztaA3+E6qJ9v0PUvotfq4AaM3QtHyg5joMDPuJvqJR76sXrgwm2ZA
         My3PSfpco+kTXm7cAJSFM/fSCv3pFpyI5SNqkMBpfYODLuNcjgJXBGTauqgm1roVAySk
         hXipOQqIo351KIHZPHzHQER96vETXAmZJcI5hDy1ZgzpCUTEO6+VH7+8FYMsfwYZ5VaK
         B5WPGtKyjQXUdh7pw83yeCabrrggFevUZ+QZZFDm8ZsEJ1gu46oAwIubhQFPRoifTSjf
         lPA5jNmbhQiA9CAIa7Vsas0UuMWnT2VkoWLXvCDMBrJ3cVygiovl0mH9udlz3QoQTOnE
         QWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tg9Juu811cBD+q7cNlUnF7KC5YbEZiwnNOtSRxN497A=;
        b=OiP1fHVwdVpxO4E1Be+m9JKA+1WHeSyyLJ1hYL1AJ33gMHpn/AwjlZrnk5z9J4pska
         zDvB3eTCwXJbW0GBViAJFVIkYlMjoO3wpP1s8sGYF4hTT2BkrjAldhPwb+B+zX9CR3Ku
         Vh7t5drbdmLZs9gp0e2pWL3WKMZun1fPq3uqBAws0ILrplccj1lY00I1lX6fzogpDdcF
         SRcvDGmneRke2WKMTRscRWz5SiA63KA48hoLudRme7CH9i1EqMrg0pSNegTyFOuEOC3x
         qXKMFbP1ySBVpJ7HAO5UmChTqDMTKDnkMLefci4zpK0moQ2qZ3KY8GKIDB1BidBpURA+
         88VQ==
X-Gm-Message-State: ABuFfogUL2zHqkHOu8PONft26BRqDoEnUVQFrV1CIJ6vtPr4StLZwBv7
        VHe96ihwvOxgDAgsbbOOIuSGE1jD/c2TBZJ5RoV6tDh/cEQ=
X-Google-Smtp-Source: ACcGV628nnKSkmTx6GED3Y8HpP16/Mq46tZebpzX1dWkR6R+lvP2p0KJ76UoFvr3e/bVoeQrO1m40o1+vLj8qIq8W+o=
X-Received: by 2002:a19:2583:: with SMTP id l125-v6mr5294628lfl.73.1538495453630;
 Tue, 02 Oct 2018 08:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
 <621563d3b15818fd9fc4134c70392079@mailmag.net>
In-Reply-To: <621563d3b15818fd9fc4134c70392079@mailmag.net>
From:   Gerard Saraber <gsaraber@rarcoa.com>
Date:   Tue, 2 Oct 2018 10:50:42 -0500
Message-ID: <CAPsdh33uGNci2LCT70k95D38y4JX1vF8KSAexx+Z3YtVYQePUA@mail.gmail.com>
Subject: Re: Writing a large file causes odd freeze
To:     joshua@mailmag.net
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'll give that a shot! thank you!

-Gerard
On Tue, Oct 2, 2018 at 10:24 AM <joshua@mailmag.net> wrote:
>
> > I have a 25TB mirrored filesystem that I'm able to consistently freeze
> > by ungzipping a large file.
> > The filesystem scrubs complete without errors and smartd reports no
> > errors at the moment.
> >
> > The command is:
> > gzip -dc /btrfsarray/largefile.gz > /btrfs/db/output.sql
> > At around 31GB it quits writing to the output file, and I start
> > getting the 'hung task' messages in my kernel log.
> > They are 3.0GB gzipped SQL dumps, that uncompress into about 42GB SQL
> > dump files.
> >
> > after that 'ps auwx' completely hangs and I can't write to the
> > filesystem anymore, no errors, the processes just hang. I can still
> > read from the FS as far as I can tell.
> > I'm not sure how to diagnose it, or if i've simply ran into some kind
> > of bug (may not even be BTRFS related)
> >
> > Linux cloud1 4.18.10 #1 SMP Fri Sep 28 07:44:06 CDT 2018 x86_64 x86_64
> > x86_64 GNU/Linux
> > [ I think It used to work on 4.18.0-rcX ]
> >
> > Hardware specs:
> > AMD Ryzen Threadripper 1950X 16-Core Processor
> > 128GB ram
> > A bunch of 3-8TB SATA drives connected to the motherboard and a pair
> > of LSI cards
> >
> > root@cloud1:~# btrfs fi usage /btrfsarray
> > Overall:
> > Device size: 79.14TiB
> > Device allocated: 55.38TiB
> > Device unallocated: 23.76TiB
> > Device missing: 0.00B
> > Used: 55.30TiB
> > Free (estimated): 11.91TiB (min: 11.91TiB)
> > Data ratio: 2.00
> > Metadata ratio: 2.00
> > Global reserve: 512.00MiB (used: 0.00B)
> >
> > Data,RAID1: Size:27.61TiB, Used:27.58TiB
> > /dev/sda 1.64TiB
> > /dev/sdb 1.64TiB
> > /dev/sdc 1.87TiB
> > /dev/sdd 4.37TiB
> > /dev/sde 2.55TiB
> > /dev/sdf 2.55TiB
> > /dev/sdg 4.37TiB
> > /dev/sdh 4.36TiB
> > /dev/sdi 2.55TiB
> > /dev/sdj 4.36TiB
> > /dev/sdk 4.37TiB
> > /dev/sdl 1.64TiB
> > /dev/sdm 4.37TiB
> > /dev/sdn 2.54TiB
> > /dev/sdo 2.55TiB
> > /dev/sdp 2.55TiB
> > /dev/sdq 2.55TiB
> > /dev/sdr 4.37TiB
> >
> > Metadata,RAID1: Size:87.00GiB, Used:77.46GiB
> > /dev/sda 5.00GiB
> > /dev/sdb 5.00GiB
> > /dev/sdd 14.00GiB
> > /dev/sde 12.00GiB
> > /dev/sdf 8.00GiB
> > /dev/sdg 6.00GiB
> > /dev/sdh 20.00GiB
> > /dev/sdi 11.00GiB
> > /dev/sdj 19.00GiB
> > /dev/sdk 5.00GiB
> > /dev/sdl 6.00GiB
> > /dev/sdm 7.00GiB
> > /dev/sdn 17.00GiB
> > /dev/sdo 7.00GiB
> > /dev/sdp 13.00GiB
> > /dev/sdq 12.00GiB
> > /dev/sdr 7.00GiB
> >
> > System,RAID1: Size:32.00MiB, Used:5.19MiB
> > /dev/sdc 32.00MiB
> > /dev/sdr 32.00MiB
> >
> > Unallocated:
> > /dev/sda 1.08TiB
> > /dev/sdb 1.08TiB
> > /dev/sdc 5.40TiB
> > /dev/sdd 1.08TiB
> > /dev/sde 1.08TiB
> > /dev/sdf 1.08TiB
> > /dev/sdg 1.08TiB
> > /dev/sdh 1.08TiB
> > /dev/sdi 1.08TiB
> > /dev/sdj 1.08TiB
> > /dev/sdk 1.08TiB
> > /dev/sdl 1.08TiB
> > /dev/sdm 1.08TiB
> > /dev/sdn 1.08TiB
> > /dev/sdo 1.08TiB
> > /dev/sdp 1.08TiB
> > /dev/sdq 1.08TiB
> > /dev/sdr 1.08TiB
> >
> > Oct 2 08:02:25 cloud1 kernel: [165537.793055] INFO: task smbd:47578
> > blocked for more than 120 seconds.
> > Oct 2 08:02:25 cloud1 kernel: [165537.793068] Not tainted 4.18.10 #1
> > Oct 2 08:02:25 cloud1 kernel: [165537.793079] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Oct 2 08:02:25 cloud1 kernel: [165537.793094] smbd D 0
> > 47578 3375 0x00000000
> > Oct 2 08:02:25 cloud1 kernel: [165537.793096] Call Trace:
> > Oct 2 08:02:25 cloud1 kernel: [165537.793098] ? __schedule+0x299/0x880
> > Oct 2 08:02:25 cloud1 kernel: [165537.793100] schedule+0x28/0x80
> > Oct 2 08:02:25 cloud1 kernel: [165537.793102] wait_current_trans+0xad/0=
xe0
> > Oct 2 08:02:25 cloud1 kernel: [165537.793104] ? wait_woken+0x80/0x80
> > Oct 2 08:02:25 cloud1 kernel: [165537.793106] start_transaction+0x2ee/0=
x3c0
> > Oct 2 08:02:25 cloud1 kernel: [165537.793108] btrfs_sync_file+0x279/0x4=
00
> > Oct 2 08:02:25 cloud1 kernel: [165537.793110]
> > btrfs_file_write_iter+0x461/0x576
> > Oct 2 08:02:25 cloud1 kernel: [165537.793111] __vfs_write+0x114/0x1a0
> > Oct 2 08:02:25 cloud1 kernel: [165537.793113] vfs_write+0xad/0x1a0
> > Oct 2 08:02:25 cloud1 kernel: [165537.793115] ksys_pwrite64+0x71/0x90
> > Oct 2 08:02:25 cloud1 kernel: [165537.793116] ? __switch_to_asm+0x34/0x=
70
> > Oct 2 08:02:25 cloud1 kernel: [165537.793117] do_syscall_64+0x4f/0x100
> > Oct 2 08:02:25 cloud1 kernel: [165537.793119]
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > Oct 2 08:02:25 cloud1 kernel: [165537.793120] RIP: 0033:0x7f82af38104f
> > Oct 2 08:02:25 cloud1 kernel: [165537.793120] Code: Bad RIP value.
> > Oct 2 08:02:25 cloud1 kernel: [165537.793122] RSP:
> > 002b:00007f8296b4fd70 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
> > Oct 2 08:02:25 cloud1 kernel: [165537.793124] RAX: ffffffffffffffda
> > RBX: 0000000000000009 RCX: 00007f82af38104f
> > Oct 2 08:02:25 cloud1 kernel: [165537.793124] RDX: 0000000000001000
> > RSI: 000055e06183fea0 RDI: 0000000000000009
> > Oct 2 08:02:25 cloud1 kernel: [165537.793125] RBP: 000055e06183fea0
> > R08: 0000000000000000 R09: 00007fffac636080
> > Oct 2 08:02:25 cloud1 kernel: [165537.793126] R10: 00000000089c8000
> > R11: 0000000000000293 R12: 0000000000001000
> > Oct 2 08:02:25 cloud1 kernel: [165537.793127] R13: 00000000089c8000
> > R14: 00007f82aa40e090 R15: 000055e0616b5f70
> >
> > Oct 2 08:04:25 cloud1 kernel: [165658.622345] INFO: task
> > btrfs-transacti:12370 blocked for more than 120 seconds.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622366] Not tainted 4.18.10 #1
> > Oct 2 08:04:25 cloud1 kernel: [165658.622378] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622393] btrfs-transacti D 0
> > 12370 2 0x80000000
> > Oct 2 08:04:25 cloud1 kernel: [165658.622396] Call Trace:
> > Oct 2 08:04:25 cloud1 kernel: [165658.622406] ? __schedule+0x299/0x880
> > Oct 2 08:04:25 cloud1 kernel: [165658.622408] ?
> > _raw_spin_unlock_irqrestore+0xa/0x10
> > Oct 2 08:04:25 cloud1 kernel: [165658.622410] schedule+0x28/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622414]
> > btrfs_commit_transaction+0x760/0x870
> > Oct 2 08:04:25 cloud1 kernel: [165658.622418] ? wait_woken+0x80/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622420] transaction_kthread+0x12e=
/0x150
> > Oct 2 08:04:25 cloud1 kernel: [165658.622422] ?
> > btrfs_cleanup_transaction+0x520/0x520
> > Oct 2 08:04:25 cloud1 kernel: [165658.622425] kthread+0x113/0x130
> > Oct 2 08:04:25 cloud1 kernel: [165658.622427] ?
> > kthread_create_worker_on_cpu+0x70/0x70
> > Oct 2 08:04:25 cloud1 kernel: [165658.622428] ret_from_fork+0x22/0x40
> > Oct 2 08:04:25 cloud1 kernel: [165658.622487] INFO: task jsvc:15530
> > blocked for more than 120 seconds.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622501] Not tainted 4.18.10 #1
> > Oct 2 08:04:25 cloud1 kernel: [165658.622512] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622527] jsvc D 0
> > 15530 15312 0x00000120
> > Oct 2 08:04:25 cloud1 kernel: [165658.622529] Call Trace:
> > Oct 2 08:04:25 cloud1 kernel: [165658.622531] ? __schedule+0x299/0x880
> > Oct 2 08:04:25 cloud1 kernel: [165658.622533] schedule+0x28/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622536]
> > btrfs_start_ordered_extent+0xea/0x120
> > Oct 2 08:04:25 cloud1 kernel: [165658.622538] ? wait_woken+0x80/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622540] btrfs_page_mkwrite+0x1f3/=
0x500
> > Oct 2 08:04:25 cloud1 kernel: [165658.622544] do_page_mkwrite+0x31/0x90
> > Oct 2 08:04:25 cloud1 kernel: [165658.622546] do_wp_page+0x214/0x5a0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622548] __handle_mm_fault+0xb6a/0=
x1260
> > Oct 2 08:04:25 cloud1 kernel: [165658.622551] ? __seccomp_filter+0x44/0=
x4c0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622553] handle_mm_fault+0xc6/0x20=
0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622556] __do_page_fault+0x24c/0x4=
d0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622558] ? page_fault+0x8/0x30
> > Oct 2 08:04:25 cloud1 kernel: [165658.622559] page_fault+0x1e/0x30
> > Oct 2 08:04:25 cloud1 kernel: [165658.622562] RIP: 0033:0x7f9b5aadb47e
> > Oct 2 08:04:25 cloud1 kernel: [165658.622563] Code: Bad RIP value.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622569] RSP:
> > 002b:00007f92dccced60 EFLAGS: 00010246
> > Oct 2 08:04:25 cloud1 kernel: [165658.622571] RAX: 00009606c50d609c
> > RBX: 00007f9b5c5a1c30 RCX: 0000000000000018
> > Oct 2 08:04:25 cloud1 kernel: [165658.622572] RDX: 0000000000000000
> > RSI: 00007f92dccced30 RDI: 0000000000000001
> > Oct 2 08:04:25 cloud1 kernel: [165658.622572] RBP: 00007f92dccced70
> > R08: 001f9c207abaa2b8 R09: 00007fff9f29c080
> > Oct 2 08:04:25 cloud1 kernel: [165658.622573] R10: 00000000048732ba
> > R11: 0000000000000001 R12: 0000000000000028
> > Oct 2 08:04:25 cloud1 kernel: [165658.622574] R13: 0000561d92af6950
> > R14: 0000000000000002 R15: 0000000000000001
> > Oct 2 08:04:25 cloud1 kernel: [165658.622613] INFO: task mongod:23344
> > blocked for more than 120 seconds.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622628] Not tainted 4.18.10 #1
> > Oct 2 08:04:25 cloud1 kernel: [165658.622638] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622653] mongod D 0
> > 23344 15560 0x00000120
> > Oct 2 08:04:25 cloud1 kernel: [165658.622655] Call Trace:
> > Oct 2 08:04:25 cloud1 kernel: [165658.622657] ? __schedule+0x299/0x880
> > Oct 2 08:04:25 cloud1 kernel: [165658.622659] schedule+0x28/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622661]
> > btrfs_start_ordered_extent+0xea/0x120
> > Oct 2 08:04:25 cloud1 kernel: [165658.622663] ? wait_woken+0x80/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622665]
> > btrfs_wait_ordered_range+0xbb/0x100
> > Oct 2 08:04:25 cloud1 kernel: [165658.622667] btrfs_sync_file+0x30c/0x4=
00
> > Oct 2 08:04:25 cloud1 kernel: [165658.622671] do_fsync+0x38/0x60
> > Oct 2 08:04:25 cloud1 kernel: [165658.622673] __x64_sys_fdatasync+0x13/=
0x20
> > Oct 2 08:04:25 cloud1 kernel: [165658.622675] do_syscall_64+0x4f/0x100
> > Oct 2 08:04:25 cloud1 kernel: [165658.622677]
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > Oct 2 08:04:25 cloud1 kernel: [165658.622678] RIP: 0033:0x7f3d36c122e7
> > Oct 2 08:04:25 cloud1 kernel: [165658.622679] Code: Bad RIP value.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622681] RSP:
> > 002b:00007f3d31aef560 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> > Oct 2 08:04:25 cloud1 kernel: [165658.622683] RAX: ffffffffffffffda
> > RBX: 000000000000000c RCX: 00007f3d36c122e7
> > Oct 2 08:04:25 cloud1 kernel: [165658.622683] RDX: 0000000000000000
> > RSI: 000000000000000c RDI: 000000000000000c
> > Oct 2 08:04:25 cloud1 kernel: [165658.622684] RBP: 00007f3d31aef5a0
> > R08: 00005633b3ab9c00 R09: 00007ffeef7a3080
> > Oct 2 08:04:25 cloud1 kernel: [165658.622685] R10: 0000000004873546
> > R11: 0000000000000293 R12: 00005633b3ab9cc0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622686] R13: 00005633b1075d90
> > R14: 0000000000000000 R15: 00005633b39a20f8
> > Oct 2 08:04:25 cloud1 kernel: [165658.622688] INFO: task ftdc:23347
> > blocked for more than 120 seconds.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622702] Not tainted 4.18.10 #1
> > Oct 2 08:04:25 cloud1 kernel: [165658.622713] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622728] ftdc D 0
> > 23347 15560 0x00000120
> > Oct 2 08:04:25 cloud1 kernel: [165658.622729] Call Trace:
> > Oct 2 08:04:25 cloud1 kernel: [165658.622731] ? __schedule+0x299/0x880
> > Oct 2 08:04:25 cloud1 kernel: [165658.622733] schedule+0x28/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622735] wait_current_trans+0xad/0=
xe0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622737] ? wait_woken+0x80/0x80
> > Oct 2 08:04:25 cloud1 kernel: [165658.622738] start_transaction+0x2ee/0=
x3c0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622740] btrfs_create+0x57/0x1f0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622743] path_openat+0x13c1/0x16a0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622746] do_filp_open+0x9b/0x110
> > Oct 2 08:04:25 cloud1 kernel: [165658.622748] ? try_lookup_one_len+0x70=
/0x70
> > Oct 2 08:04:25 cloud1 kernel: [165658.622751] ? close_pdeo+0x93/0xf0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622753] ? __check_object_size+0xa=
7/0x1a0
> > Oct 2 08:04:25 cloud1 kernel: [165658.622756] ? __alloc_fd+0x3d/0x160
> > Oct 2 08:04:25 cloud1 kernel: [165658.622758] ? do_sys_open+0x1bd/0x250
> > Oct 2 08:04:25 cloud1 kernel: [165658.622760] do_sys_open+0x1bd/0x250
> > Oct 2 08:04:25 cloud1 kernel: [165658.622762] do_syscall_64+0x4f/0x100
> > Oct 2 08:04:25 cloud1 kernel: [165658.622763]
> > entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > Oct 2 08:04:25 cloud1 kernel: [165658.622764] RIP: 0033:0x7f3d36c0ad19
> > Oct 2 08:04:25 cloud1 kernel: [165658.622765] Code: Bad RIP value.
> > Oct 2 08:04:25 cloud1 kernel: [165658.622767] RSP:
> > 002b:00007f3d302ec200 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
> > Oct 2 08:04:25 cloud1 kernel: [165658.622769] RAX: ffffffffffffffda
> > RBX: 00005633b7197d80 RCX: 00007f3d36c0ad19
> > Oct 2 08:04:25 cloud1 kernel: [165658.622769] RDX: 0000000000000241
> > RSI: 00005633b7106740 RDI: 00000000ffffff9c
> > Oct 2 08:04:25 cloud1 kernel: [165658.622770] RBP: 00005633b1077b13
> > R08: 0000000000000000 R09: 00005633b1077b14
> > Oct 2 08:04:25 cloud1 kernel: [165658.622771] R10: 00000000000001b6
> > R11: 0000000000000293 R12: 0000000000000004
> > Oct 2 08:04:25 cloud1 kernel: [165658.622771] R13: 00005633b1077b12
> > R14: 00007f3d302ec720 R15: 00005633b9942004
>
> Are you using mount option space_cache=3Dv2?
>
> If not, you should enable that and see if you experience the same behavio=
r.  I believe it's highly recommended on all large BTRFS arrays, and I had =
intermittent freezing problems on large writes before I enabled it.  I do n=
ot appear to have those problems any more...

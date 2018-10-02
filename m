Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1687AC43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F7820666
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 15:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mailmag.net header.i=@mailmag.net header.b="FMzcNCtB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7F7820666
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mailmag.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbeJBWPk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 18:15:40 -0400
Received: from mail.mailmag.net ([5.135.159.181]:53416 "EHLO mail.mailmag.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbeJBWPk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Oct 2018 18:15:40 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2018 18:15:39 EDT
Received: from authenticated-user (mail.mailmag.net [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mailmag.net (Postfix) with ESMTPSA id 7FD19EC1C06;
        Tue,  2 Oct 2018 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net; s=mail;
        t=1538493850; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ouqp6jbwY3ABmBPy2VR2qPaN9e0Nq0BB+B3ameA7K0=;
        b=FMzcNCtBiFRQK/qiGGq2UzDm1nWbm1H9vrsJ1PrBBYNZKX5yGw4W+pXGJhNMOchcjhvIWH
        djwTWM+BnuqidipasGF9KYcTUGBiUkZ2EixDVhDYgSpBZwjnN9XaA358VYun765Rrnu/0o
        jsxO0s4HGgyM5rSctal5KLWWlx4JLXo=
MIME-Version: 1.0
Date:   Tue, 02 Oct 2018 15:24:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From:   joshua@mailmag.net
Message-ID: <621563d3b15818fd9fc4134c70392079@mailmag.net>
Subject: Re: Writing a large file causes odd freeze
To:     "Gerard Saraber" <gsaraber@rarcoa.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
In-Reply-To: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
References: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net;
        s=mail; t=1538493850; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ouqp6jbwY3ABmBPy2VR2qPaN9e0Nq0BB+B3ameA7K0=;
        b=eMz9nUs+DhMhrZffdW2fWVlPecQxQJp5Yk5K0s72db6glE3xATpUDr9GgYeZ2OI62iaL6z
        z5X3laUFKgplUkqUtITr012OjZuqLxd40TOYY7QeUotooP9lPXNWU9nmQAD0Zncxbd7nDX
        bAdXcnUEvUycba2HRjWl4ihfsFrXMug=
ARC-Seal: i=1; s=mail; d=mailmag.net; t=1538493850; a=rsa-sha256; cv=none;
        b=130TL51BfZfOtSbOTww+MiPSn0w7HJgiZ7GFXjpZSqoo/EdiYk5SMxA4js2P/dJfi/sQPP//M+TYj24x53Iu0X5zY3s4QqLBswM22tgZ4j3xG2uEBkR+C5/hLQlgvqT2ME15WFTEDULNEnD98F8pospffgQrPFcX4PEaBYFArHQ=
ARC-Authentication-Results: i=1; mail.mailmag.net;
        auth=pass smtp.auth=joshua@mailmag.net smtp.mailfrom=joshua@mailmag.net
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> I have a 25TB mirrored filesystem that I'm able to consistently freeze=
=0A> by ungzipping a large file.=0A> The filesystem scrubs complete witho=
ut errors and smartd reports no=0A> errors at the moment.=0A> =0A> The co=
mmand is:=0A> gzip -dc /btrfsarray/largefile.gz > /btrfs/db/output.sql=0A=
> At around 31GB it quits writing to the output file, and I start=0A> get=
ting the 'hung task' messages in my kernel log.=0A> They are 3.0GB gzippe=
d SQL dumps, that uncompress into about 42GB SQL=0A> dump files.=0A> =0A>=
 after that 'ps auwx' completely hangs and I can't write to the=0A> files=
ystem anymore, no errors, the processes just hang. I can still=0A> read f=
rom the FS as far as I can tell.=0A> I'm not sure how to diagnose it, or =
if i've simply ran into some kind=0A> of bug (may not even be BTRFS relat=
ed)=0A> =0A> Linux cloud1 4.18.10 #1 SMP Fri Sep 28 07:44:06 CDT 2018 x86=
_64 x86_64=0A> x86_64 GNU/Linux=0A> [ I think It used to work on 4.18.0-r=
cX ]=0A> =0A> Hardware specs:=0A> AMD Ryzen Threadripper 1950X 16-Core Pr=
ocessor=0A> 128GB ram=0A> A bunch of 3-8TB SATA drives connected to the m=
otherboard and a pair=0A> of LSI cards=0A> =0A> root@cloud1:~# btrfs fi u=
sage /btrfsarray=0A> Overall:=0A> Device size: 79.14TiB=0A> Device alloca=
ted: 55.38TiB=0A> Device unallocated: 23.76TiB=0A> Device missing: 0.00B=
=0A> Used: 55.30TiB=0A> Free (estimated): 11.91TiB (min: 11.91TiB)=0A> Da=
ta ratio: 2.00=0A> Metadata ratio: 2.00=0A> Global reserve: 512.00MiB (us=
ed: 0.00B)=0A> =0A> Data,RAID1: Size:27.61TiB, Used:27.58TiB=0A> /dev/sda=
 1.64TiB=0A> /dev/sdb 1.64TiB=0A> /dev/sdc 1.87TiB=0A> /dev/sdd 4.37TiB=
=0A> /dev/sde 2.55TiB=0A> /dev/sdf 2.55TiB=0A> /dev/sdg 4.37TiB=0A> /dev/=
sdh 4.36TiB=0A> /dev/sdi 2.55TiB=0A> /dev/sdj 4.36TiB=0A> /dev/sdk 4.37Ti=
B=0A> /dev/sdl 1.64TiB=0A> /dev/sdm 4.37TiB=0A> /dev/sdn 2.54TiB=0A> /dev=
/sdo 2.55TiB=0A> /dev/sdp 2.55TiB=0A> /dev/sdq 2.55TiB=0A> /dev/sdr 4.37T=
iB=0A> =0A> Metadata,RAID1: Size:87.00GiB, Used:77.46GiB=0A> /dev/sda 5.0=
0GiB=0A> /dev/sdb 5.00GiB=0A> /dev/sdd 14.00GiB=0A> /dev/sde 12.00GiB=0A>=
 /dev/sdf 8.00GiB=0A> /dev/sdg 6.00GiB=0A> /dev/sdh 20.00GiB=0A> /dev/sdi=
 11.00GiB=0A> /dev/sdj 19.00GiB=0A> /dev/sdk 5.00GiB=0A> /dev/sdl 6.00GiB=
=0A> /dev/sdm 7.00GiB=0A> /dev/sdn 17.00GiB=0A> /dev/sdo 7.00GiB=0A> /dev=
/sdp 13.00GiB=0A> /dev/sdq 12.00GiB=0A> /dev/sdr 7.00GiB=0A> =0A> System,=
RAID1: Size:32.00MiB, Used:5.19MiB=0A> /dev/sdc 32.00MiB=0A> /dev/sdr 32.=
00MiB=0A> =0A> Unallocated:=0A> /dev/sda 1.08TiB=0A> /dev/sdb 1.08TiB=0A>=
 /dev/sdc 5.40TiB=0A> /dev/sdd 1.08TiB=0A> /dev/sde 1.08TiB=0A> /dev/sdf =
1.08TiB=0A> /dev/sdg 1.08TiB=0A> /dev/sdh 1.08TiB=0A> /dev/sdi 1.08TiB=0A=
> /dev/sdj 1.08TiB=0A> /dev/sdk 1.08TiB=0A> /dev/sdl 1.08TiB=0A> /dev/sdm=
 1.08TiB=0A> /dev/sdn 1.08TiB=0A> /dev/sdo 1.08TiB=0A> /dev/sdp 1.08TiB=
=0A> /dev/sdq 1.08TiB=0A> /dev/sdr 1.08TiB=0A> =0A> Oct 2 08:02:25 cloud1=
 kernel: [165537.793055] INFO: task smbd:47578=0A> blocked for more than =
120 seconds.=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793068] Not tainte=
d 4.18.10 #1=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793079] "echo 0 >=
=0A> /proc/sys/kernel/hung_task_timeout_secs" disables this message.=0A> =
Oct 2 08:02:25 cloud1 kernel: [165537.793094] smbd D 0=0A> 47578 3375 0x0=
0000000=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793096] Call Trace:=0A>=
 Oct 2 08:02:25 cloud1 kernel: [165537.793098] ? __schedule+0x299/0x880=
=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793100] schedule+0x28/0x80=0A>=
 Oct 2 08:02:25 cloud1 kernel: [165537.793102] wait_current_trans+0xad/0x=
e0=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793104] ? wait_woken+0x80/0x=
80=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793106] start_transaction+0x=
2ee/0x3c0=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793108] btrfs_sync_fi=
le+0x279/0x400=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793110]=0A> btrf=
s_file_write_iter+0x461/0x576=0A> Oct 2 08:02:25 cloud1 kernel: [165537.7=
93111] __vfs_write+0x114/0x1a0=0A> Oct 2 08:02:25 cloud1 kernel: [165537.=
793113] vfs_write+0xad/0x1a0=0A> Oct 2 08:02:25 cloud1 kernel: [165537.79=
3115] ksys_pwrite64+0x71/0x90=0A> Oct 2 08:02:25 cloud1 kernel: [165537.7=
93116] ? __switch_to_asm+0x34/0x70=0A> Oct 2 08:02:25 cloud1 kernel: [165=
537.793117] do_syscall_64+0x4f/0x100=0A> Oct 2 08:02:25 cloud1 kernel: [1=
65537.793119]=0A> entry_SYSCALL_64_after_hwframe+0x44/0xa9=0A> Oct 2 08:0=
2:25 cloud1 kernel: [165537.793120] RIP: 0033:0x7f82af38104f=0A> Oct 2 08=
:02:25 cloud1 kernel: [165537.793120] Code: Bad RIP value.=0A> Oct 2 08:0=
2:25 cloud1 kernel: [165537.793122] RSP:=0A> 002b:00007f8296b4fd70 EFLAGS=
: 00000293 ORIG_RAX: 0000000000000012=0A> Oct 2 08:02:25 cloud1 kernel: [=
165537.793124] RAX: ffffffffffffffda=0A> RBX: 0000000000000009 RCX: 00007=
f82af38104f=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793124] RDX: 000000=
0000001000=0A> RSI: 000055e06183fea0 RDI: 0000000000000009=0A> Oct 2 08:0=
2:25 cloud1 kernel: [165537.793125] RBP: 000055e06183fea0=0A> R08: 000000=
0000000000 R09: 00007fffac636080=0A> Oct 2 08:02:25 cloud1 kernel: [16553=
7.793126] R10: 00000000089c8000=0A> R11: 0000000000000293 R12: 0000000000=
001000=0A> Oct 2 08:02:25 cloud1 kernel: [165537.793127] R13: 00000000089=
c8000=0A> R14: 00007f82aa40e090 R15: 000055e0616b5f70=0A> =0A> Oct 2 08:0=
4:25 cloud1 kernel: [165658.622345] INFO: task=0A> btrfs-transacti:12370 =
blocked for more than 120 seconds.=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622366] Not tainted 4.18.10 #1=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622378] "echo 0 >=0A> /proc/sys/kernel/hung_task_timeout_secs" disabl=
es this message.=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622393] btrfs-=
transacti D 0=0A> 12370 2 0x80000000=0A> Oct 2 08:04:25 cloud1 kernel: [1=
65658.622396] Call Trace:=0A> Oct 2 08:04:25 cloud1 kernel: [165658.62240=
6] ? __schedule+0x299/0x880=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622=
408] ?=0A> _raw_spin_unlock_irqrestore+0xa/0x10=0A> Oct 2 08:04:25 cloud1=
 kernel: [165658.622410] schedule+0x28/0x80=0A> Oct 2 08:04:25 cloud1 ker=
nel: [165658.622414]=0A> btrfs_commit_transaction+0x760/0x870=0A> Oct 2 0=
8:04:25 cloud1 kernel: [165658.622418] ? wait_woken+0x80/0x80=0A> Oct 2 0=
8:04:25 cloud1 kernel: [165658.622420] transaction_kthread+0x12e/0x150=0A=
> Oct 2 08:04:25 cloud1 kernel: [165658.622422] ?=0A> btrfs_cleanup_trans=
action+0x520/0x520=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622425] kthr=
ead+0x113/0x130=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622427] ?=0A> k=
thread_create_worker_on_cpu+0x70/0x70=0A> Oct 2 08:04:25 cloud1 kernel: [=
165658.622428] ret_from_fork+0x22/0x40=0A> Oct 2 08:04:25 cloud1 kernel: =
[165658.622487] INFO: task jsvc:15530=0A> blocked for more than 120 secon=
ds.=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622501] Not tainted 4.18.10=
 #1=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622512] "echo 0 >=0A> /proc=
/sys/kernel/hung_task_timeout_secs" disables this message.=0A> Oct 2 08:0=
4:25 cloud1 kernel: [165658.622527] jsvc D 0=0A> 15530 15312 0x00000120=
=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622529] Call Trace:=0A> Oct 2 =
08:04:25 cloud1 kernel: [165658.622531] ? __schedule+0x299/0x880=0A> Oct =
2 08:04:25 cloud1 kernel: [165658.622533] schedule+0x28/0x80=0A> Oct 2 08=
:04:25 cloud1 kernel: [165658.622536]=0A> btrfs_start_ordered_extent+0xea=
/0x120=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622538] ? wait_woken+0x8=
0/0x80=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622540] btrfs_page_mkwri=
te+0x1f3/0x500=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622544] do_page_=
mkwrite+0x31/0x90=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622546] do_wp=
_page+0x214/0x5a0=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622548] __han=
dle_mm_fault+0xb6a/0x1260=0A> Oct 2 08:04:25 cloud1 kernel: [165658.62255=
1] ? __seccomp_filter+0x44/0x4c0=0A> Oct 2 08:04:25 cloud1 kernel: [16565=
8.622553] handle_mm_fault+0xc6/0x200=0A> Oct 2 08:04:25 cloud1 kernel: [1=
65658.622556] __do_page_fault+0x24c/0x4d0=0A> Oct 2 08:04:25 cloud1 kerne=
l: [165658.622558] ? page_fault+0x8/0x30=0A> Oct 2 08:04:25 cloud1 kernel=
: [165658.622559] page_fault+0x1e/0x30=0A> Oct 2 08:04:25 cloud1 kernel: =
[165658.622562] RIP: 0033:0x7f9b5aadb47e=0A> Oct 2 08:04:25 cloud1 kernel=
: [165658.622563] Code: Bad RIP value.=0A> Oct 2 08:04:25 cloud1 kernel: =
[165658.622569] RSP:=0A> 002b:00007f92dccced60 EFLAGS: 00010246=0A> Oct 2=
 08:04:25 cloud1 kernel: [165658.622571] RAX: 00009606c50d609c=0A> RBX: 0=
0007f9b5c5a1c30 RCX: 0000000000000018=0A> Oct 2 08:04:25 cloud1 kernel: [=
165658.622572] RDX: 0000000000000000=0A> RSI: 00007f92dccced30 RDI: 00000=
00000000001=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622572] RBP: 00007f=
92dccced70=0A> R08: 001f9c207abaa2b8 R09: 00007fff9f29c080=0A> Oct 2 08:0=
4:25 cloud1 kernel: [165658.622573] R10: 00000000048732ba=0A> R11: 000000=
0000000001 R12: 0000000000000028=0A> Oct 2 08:04:25 cloud1 kernel: [16565=
8.622574] R13: 0000561d92af6950=0A> R14: 0000000000000002 R15: 0000000000=
000001=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622613] INFO: task mongo=
d:23344=0A> blocked for more than 120 seconds.=0A> Oct 2 08:04:25 cloud1 =
kernel: [165658.622628] Not tainted 4.18.10 #1=0A> Oct 2 08:04:25 cloud1 =
kernel: [165658.622638] "echo 0 >=0A> /proc/sys/kernel/hung_task_timeout_=
secs" disables this message.=0A> Oct 2 08:04:25 cloud1 kernel: [165658.62=
2653] mongod D 0=0A> 23344 15560 0x00000120=0A> Oct 2 08:04:25 cloud1 ker=
nel: [165658.622655] Call Trace:=0A> Oct 2 08:04:25 cloud1 kernel: [16565=
8.622657] ? __schedule+0x299/0x880=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622659] schedule+0x28/0x80=0A> Oct 2 08:04:25 cloud1 kernel: [165658.=
622661]=0A> btrfs_start_ordered_extent+0xea/0x120=0A> Oct 2 08:04:25 clou=
d1 kernel: [165658.622663] ? wait_woken+0x80/0x80=0A> Oct 2 08:04:25 clou=
d1 kernel: [165658.622665]=0A> btrfs_wait_ordered_range+0xbb/0x100=0A> Oc=
t 2 08:04:25 cloud1 kernel: [165658.622667] btrfs_sync_file+0x30c/0x400=
=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622671] do_fsync+0x38/0x60=0A>=
 Oct 2 08:04:25 cloud1 kernel: [165658.622673] __x64_sys_fdatasync+0x13/0=
x20=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622675] do_syscall_64+0x4f/=
0x100=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622677]=0A> entry_SYSCALL=
_64_after_hwframe+0x44/0xa9=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622=
678] RIP: 0033:0x7f3d36c122e7=0A> Oct 2 08:04:25 cloud1 kernel: [165658.6=
22679] Code: Bad RIP value.=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622=
681] RSP:=0A> 002b:00007f3d31aef560 EFLAGS: 00000293 ORIG_RAX: 0000000000=
00004b=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622683] RAX: fffffffffff=
fffda=0A> RBX: 000000000000000c RCX: 00007f3d36c122e7=0A> Oct 2 08:04:25 =
cloud1 kernel: [165658.622683] RDX: 0000000000000000=0A> RSI: 00000000000=
0000c RDI: 000000000000000c=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622=
684] RBP: 00007f3d31aef5a0=0A> R08: 00005633b3ab9c00 R09: 00007ffeef7a308=
0=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622685] R10: 0000000004873546=
=0A> R11: 0000000000000293 R12: 00005633b3ab9cc0=0A> Oct 2 08:04:25 cloud=
1 kernel: [165658.622686] R13: 00005633b1075d90=0A> R14: 0000000000000000=
 R15: 00005633b39a20f8=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622688] =
INFO: task ftdc:23347=0A> blocked for more than 120 seconds.=0A> Oct 2 08=
:04:25 cloud1 kernel: [165658.622702] Not tainted 4.18.10 #1=0A> Oct 2 08=
:04:25 cloud1 kernel: [165658.622713] "echo 0 >=0A> /proc/sys/kernel/hung=
_task_timeout_secs" disables this message.=0A> Oct 2 08:04:25 cloud1 kern=
el: [165658.622728] ftdc D 0=0A> 23347 15560 0x00000120=0A> Oct 2 08:04:2=
5 cloud1 kernel: [165658.622729] Call Trace:=0A> Oct 2 08:04:25 cloud1 ke=
rnel: [165658.622731] ? __schedule+0x299/0x880=0A> Oct 2 08:04:25 cloud1 =
kernel: [165658.622733] schedule+0x28/0x80=0A> Oct 2 08:04:25 cloud1 kern=
el: [165658.622735] wait_current_trans+0xad/0xe0=0A> Oct 2 08:04:25 cloud=
1 kernel: [165658.622737] ? wait_woken+0x80/0x80=0A> Oct 2 08:04:25 cloud=
1 kernel: [165658.622738] start_transaction+0x2ee/0x3c0=0A> Oct 2 08:04:2=
5 cloud1 kernel: [165658.622740] btrfs_create+0x57/0x1f0=0A> Oct 2 08:04:=
25 cloud1 kernel: [165658.622743] path_openat+0x13c1/0x16a0=0A> Oct 2 08:=
04:25 cloud1 kernel: [165658.622746] do_filp_open+0x9b/0x110=0A> Oct 2 08=
:04:25 cloud1 kernel: [165658.622748] ? try_lookup_one_len+0x70/0x70=0A> =
Oct 2 08:04:25 cloud1 kernel: [165658.622751] ? close_pdeo+0x93/0xf0=0A> =
Oct 2 08:04:25 cloud1 kernel: [165658.622753] ? __check_object_size+0xa7/=
0x1a0=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622756] ? __alloc_fd+0x3d=
/0x160=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622758] ? do_sys_open+0x=
1bd/0x250=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622760] do_sys_open+0=
x1bd/0x250=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622762] do_syscall_6=
4+0x4f/0x100=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622763]=0A> entry_=
SYSCALL_64_after_hwframe+0x44/0xa9=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622764] RIP: 0033:0x7f3d36c0ad19=0A> Oct 2 08:04:25 cloud1 kernel: [1=
65658.622765] Code: Bad RIP value.=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622767] RSP:=0A> 002b:00007f3d302ec200 EFLAGS: 00000293 ORIG_RAX: 000=
0000000000101=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622769] RAX: ffff=
ffffffffffda=0A> RBX: 00005633b7197d80 RCX: 00007f3d36c0ad19=0A> Oct 2 08=
:04:25 cloud1 kernel: [165658.622769] RDX: 0000000000000241=0A> RSI: 0000=
5633b7106740 RDI: 00000000ffffff9c=0A> Oct 2 08:04:25 cloud1 kernel: [165=
658.622770] RBP: 00005633b1077b13=0A> R08: 0000000000000000 R09: 00005633=
b1077b14=0A> Oct 2 08:04:25 cloud1 kernel: [165658.622771] R10: 000000000=
00001b6=0A> R11: 0000000000000293 R12: 0000000000000004=0A> Oct 2 08:04:2=
5 cloud1 kernel: [165658.622771] R13: 00005633b1077b12=0A> R14: 00007f3d3=
02ec720 R15: 00005633b9942004=0A=0AAre you using mount option space_cache=
=3Dv2?=0A=0AIf not, you should enable that and see if you experience the =
same behavior.  I believe it's highly recommended on all large BTRFS arra=
ys, and I had intermittent freezing problems on large writes before I ena=
bled it.  I do not appear to have those problems any more...

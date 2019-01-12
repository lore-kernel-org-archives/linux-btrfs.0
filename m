Return-Path: <SRS0=WqnK=PU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C539C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Jan 2019 02:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5803920872
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Jan 2019 02:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="M6OLX2bP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfALCMv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 21:12:51 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37153 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfALCMv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 21:12:51 -0500
Received: by mail-lf1-f65.google.com with SMTP id y11so12158635lfj.4
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 18:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KxfOf6sy3zLqKhPgokc2wLpPb80gLFZq2HWoYotuUEY=;
        b=M6OLX2bPNHVQpPw0rKVPTYfOQflzgKM6DIqgPVgXnIdHbuI1a0ZKvcJhjCimv4JUK9
         af6WHGMpI9u55SejJZW9i1wvrk9vUf+Bs8eV5Ixszo3lZpd/q1nzPX/Z/kLsoI9sT1eE
         Ynvk85a/G4UCTsJRvNxWZL5ifftEkpItGgDrc3PRdLkvnJg+xYSNtuzy1zB5Iyo05m0k
         88HL0PtJmYg2jxkW5RS5vGlUJl6q82BDj4SfyIHi28MpDBuy0n0nYyeCo//7+VoGAmwU
         vDFvnJwA29092Ulfaf09dN1EmyrDbA902IM24zPmOHuNyPWo90I4crfeva0gIQK7VULr
         /2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KxfOf6sy3zLqKhPgokc2wLpPb80gLFZq2HWoYotuUEY=;
        b=MICbJ78eghRpiXn+98VaTRoE8Et+4FxNigHrb1790ziZJNbatuCMLqGqEXRfAXNDFF
         XEN1Q9/Uaa98DsN2oHtERRJR22S20hpGA9kaBJlovQzDJYdfADU7bypddu1hso0tb+Zj
         PwlUnUpWImJJpR6mvFdIb2gl5JlCkEOvMqfSDh/xJ8m2RqZ7JsNjWL2qICAScZCf1p26
         w7tUo/MrjoIGYPzYGawWHrwV32va23YzMv2Kp14yamk9jiQkVouGVxSbdz6lQbriTLKy
         O7BpIFKSVFvNf1LflkswYShLU2SkpLzGIohJXyThfaSzFT6s9EYJt/3rnPkLKuR3imJG
         xRJQ==
X-Gm-Message-State: AJcUukcTRMcv+beNh1/fgQ8MzswfOf+drsB26GPEowujUkF0KsVyx6VX
        c6QLnF7dn8if86cZAeXTMHXLD+4uoWLIhtZOzpzxPLZ1
X-Google-Smtp-Source: ALg8bN5LXdeni5u3qb7hA5pHp6IEkSSGMVgf0KDsFJ46G5s0n1HO94YJaQjtbOEX0IWmXiMDv4sVxQiwJ38tgmEKjXs=
X-Received: by 2002:a19:a40f:: with SMTP id q15mr6874353lfc.4.1547259168903;
 Fri, 11 Jan 2019 18:12:48 -0800 (PST)
MIME-Version: 1.0
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
 <51f6646b-ca38-9b34-7061-8ab5227f00ae@suse.com> <2d2ac67d-3cf5-d147-f57b-785dc633821d@florianstecker.de>
 <936b36f0-bd50-3ce1-5045-69a3604d4bfd@suse.com> <7b4fa64b-e981-52c5-4597-40b5ea2df5b3@florianstecker.de>
In-Reply-To: <7b4fa64b-e981-52c5-4597-40b5ea2df5b3@florianstecker.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 11 Jan 2019 19:12:36 -0700
Message-ID: <CAJCQCtQF0DU+yAH33iSXu2NBk7TCWCUZ4STC2TExW3+dJpK-Hw@mail.gmail.com>
Subject: Re: applications hang on a btrfs spanning two partitions
To:     Florian Stecker <m19@florianstecker.de>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 9, 2019 at 1:10 PM Florian Stecker <m19@florianstecker.de> wrot=
e:
>
>
>
> On 1/9/19 11:03 AM, Nikolay Borisov wrote:
> >
> >
> > On 9.01.19 =D0=B3. 11:16 =D1=87., Florian Stecker wrote:
> >>>
> >>> Provide output of echo w > /proc/sysrq-trigger when the hang occurs
> >>> otherwise it's hard to figure what's going on.
> >>>
> >>
> >> Here's one, again in gajim. This time, fdatasync() took "only" 2 secon=
ds:
> >>
> >> [42481.243491] sysrq: SysRq : Show Blocked State
> >> [42481.243494]   task                        PC stack   pid father
> >> [42481.243566] gajim           D    0 15778  15774 0x00000083
> >> [42481.243569] Call Trace:
> >> [42481.243575]  ? __schedule+0x29b/0x8b0
> >> [42481.243576]  ? bit_wait+0x50/0x50
> >> [42481.243578]  schedule+0x32/0x90
> >> [42481.243580]  io_schedule+0x12/0x40
> >> [42481.243582]  bit_wait_io+0xd/0x50
> >> [42481.243583]  __wait_on_bit+0x6c/0x80
> >> [42481.243585]  out_of_line_wait_on_bit+0x91/0xb0
> >> [42481.243587]  ? init_wait_var_entry+0x40/0x40
> >> [42481.243605]  write_all_supers+0x418/0xa70 [btrfs]
> >> [42481.243622]  btrfs_sync_log+0x695/0x910 [btrfs]
> >> [42481.243625]  ? _raw_spin_lock_irqsave+0x25/0x50
> >> [42481.243641]  ? btrfs_log_dentry_safe+0x54/0x70 [btrfs]
> >> [42481.243655]  btrfs_sync_file+0x3a9/0x3d0 [btrfs]
> >> [42481.243659]  do_fsync+0x38/0x70
> >> [42481.243661]  __x64_sys_fdatasync+0x13/0x20
> >> [42481.243663]  do_syscall_64+0x5b/0x170
> >> [42481.243666]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >> [42481.243667] RIP: 0033:0x7fd4022f873f
> >> [42481.243671] Code: Bad RIP value.
> >> [42481.243672] RSP: 002b:00007ffd3710a300 EFLAGS: 00000293 ORIG_RAX:
> >> 000000000000004b
> >> [42481.243674] RAX: ffffffffffffffda RBX: 0000000000000019 RCX:
> >> 00007fd4022f873f
> >> [42481.243675] RDX: 0000000000000000 RSI: 0000000000000002 RDI:
> >> 0000000000000019
> >> [42481.243675] RBP: 0000000000000000 R08: 000055d8d8649f68 R09:
> >> 00007ffd3710a320
> >> [42481.243676] R10: 0000000000013000 R11: 0000000000000293 R12:
> >> 0000000000000000
> >> [42481.243677] R13: 0000000000000000 R14: 000055d8d8363fa0 R15:
> >> 000055d8d8613040
> >
> > This shows that IO was send to disk to write the supper blocks followin=
g
> > an fsync and it's waiting for IO to finish. This seems like a problem i=
n
> > the storage layer, i.e IOs being stuck. Check your dmesg for any error.
> There are no IO errors in dmesg. Also, I never had any problems with
> this disk, SMART reports nothing, and also btrfs dev stats and btrfs
> scrub say everything's ok.

What do you get for:
mount | grep btrfs
btrfs insp dump-s -f /dev/sda8

I ran in this same configuration for a long time, maybe 5 months, and
never ran into this problem. But it was with much older kernel,
perhaps circa 4.8 era.


--=20
Chris Murphy

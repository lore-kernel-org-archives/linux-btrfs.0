Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC4FC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 09:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9C0F20660
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 09:36:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libpcap-net.20150623.gappssmtp.com header.i=@libpcap-net.20150623.gappssmtp.com header.b="nktMvlki"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9C0F20660
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=libpcap.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbeLCJgl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 04:36:41 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:46785 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbeLCJgl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 04:36:41 -0500
Received: by mail-pf1-f171.google.com with SMTP id c73so6048064pfe.13
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 01:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=libpcap-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cK10XOI7jevq+Gscieq6sTiWQE+PTepGVNWEW9ysz6I=;
        b=nktMvlkiU/WpE7kW166jp3p5A3E/aUeuDpMq9ZhPu25CFhYjXA2db3k4oGzcsU2hOx
         7JQwR8UMWAFMkJmAIjSnhZQUGWmJSLvKPdIkcxuFs852LBxtgwPW398DlX3qO/+9v6EA
         3DOX1SY7xgfQwwfaZuyR9hTmXn6N30lrTKrNj79cKGPgargpYOnYSB332qJa882alCfM
         FxhQTWcyi0tn3pl4vGZDDeaeW+s5XfIBVrVKhTIqYnsu7G5FJGeAKtc15fhoxwmcGv1m
         NayB6FesneVIjHeoz3qzCLssKp1R6u39/mBvmq9FhC9NfePAH2kAExz9i/a0EkVJQ82i
         s+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cK10XOI7jevq+Gscieq6sTiWQE+PTepGVNWEW9ysz6I=;
        b=rcb188ZnWSnn6UN3eyMGojPqwWH5MpqiuNwTpoz9/AMok4MAXvlwSEEmcLX6U4eh06
         QW++jUkujWWGy1DDA5sgDOBp45zSFNM0OHVLHA95S+pELBN/yCKXJtY9iZlNBKDcD/oy
         1Le5akT/NBoG5ST+h0X9HNOfAXFmTZQrPELZqcNTDnM7uFAvm9MUBNfCzS9fiASV9IKY
         JJLKsNDBHL5vUuu7QsHKlaRxXTgMJkdEX4FO65c1bTxaSn12IuZ4wFCbKH0ZAJMDu10N
         /X431d+3ml2GAn+X1I+M0VFkalyUJIjyaZ9t6Tu6+2eEvLs5s/zszBtp1WoNsOGqkeqx
         pjbw==
X-Gm-Message-State: AA+aEWZTiIIONx41SoB6xmd8LUhvqtLgtleFNSDTnoJvRc9Rf0k8feG2
        gjW3JHxsOluxdzRUTr9cJS4SY4xQ3xWNhDbWFvMToA==
X-Google-Smtp-Source: AFSGD/W6+ynfODc37xI9vcgTuvellk3c8ZT8971GsjSBs4bOHIgxG0DE/6FFquxKWEqJRvvw1P/q1r6UmT1MW48XEzI=
X-Received: by 2002:a63:1321:: with SMTP id i33mr12913649pgl.380.1543829785182;
 Mon, 03 Dec 2018 01:36:25 -0800 (PST)
MIME-Version: 1.0
References: <ABEF1951-66FC-48F8-A7C4-0D499F48AF84@gmail.com>
In-Reply-To: <ABEF1951-66FC-48F8-A7C4-0D499F48AF84@gmail.com>
From:   Tony Lambiris <tony@libpcap.net>
Date:   Mon, 3 Dec 2018 04:36:14 -0500
Message-ID: <CAFv=4tESCPF6vo64apw5G=5_EHFxPt1Q2F_tci7JXvD1-_8RvQ@mail.gmail.com>
Subject: Re: Possible deadlock when writing
To:     CANznX5GqHJwx+y6b9kruzYXEP93oEhRtHyG_yuWwHV286+fQdw@mail.gmail.com
Cc:     toth.f.janos@gmail.com, llowrey@nuclearwinter.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've been running into (what I believe) is the same issue ever since
upgrading to 4.19:

[28950.083040] BTRFS error (device dm-0): bad tree block start, want
1815648960512 have 0
[28950.083047] BTRFS: error (device dm-0) in __btrfs_free_extent:6804:
errno=3D-5 IO failure
[28950.083048] BTRFS info (device dm-0): forced readonly
[28950.083050] BTRFS: error (device dm-0) in
btrfs_run_delayed_refs:2935: errno=3D-5 IO failure
[28950.083866] BTRFS error (device dm-0): pending csums is 9564160
[29040.413973] TaskSchedulerFo[17189]: segfault at 0 ip
000056121a2cb73b sp 00007f1cca425b80 error 4 in
chrome[561218101000+6513000]

This has been happening consistently to me on two laptops and a
workstation all running Arch Linux -- all different hardware the only
thing in common is they have SSDs/nvme storage and they all use btrfs.

I initially thought it had something to do with the fstrim.timer unit
kicking off an fstrim run that was somehow causing contention with
btrfs. As luck would have it my btrfs file-system on one laptop just
remounted read-only and I believe that while my physical memory was
not entirely used up (I would guess usage to be ~45% physical). While
I believe the rest of available memory was being utilized by the VFS
buffer cache, I'm not 100% on actual utilization but after reading the
email from mbakiev@ I did make a mental note before initiating a
required reboot.

I came across this comment from Ubuntu's bugtracker:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/159356/comments/62

The author of post #62 notes that this particular behavior happens
when they are running several instances of Chrome. I don't know if
this bug filed or issue is related at all, but an interesting note is
that I also almost always happen to be interacting with Google Chrome
when the read-only remount happens.

Here is the last entry from journald before I rebooted:
Dec 03 00:00:39 tenforward kernel: BTRFS error (device dm-3): bad tree
block start, want 761659392 have 15159222128734632161

Here are the only changes I made that would be relevant:
vm.swappiness =3D 10
vm.overcommit_memory =3D 1
vm.oom_kill_allocating_task =3D 1
vm.panic_on_oom =3D 1

Hope I didn't miss anything, thanks!

On Sat, Dec 1, 2018 at 6:21 PM Martin Bakiev <mbakiev@gmail.com> wrote:
>
> I was having the same issue with kernels 4.19.2 and 4.19.4. I don=E2=80=
=99t appear to have the issue with 4.20.0-0.rc1 on Fedora Server 29.
>
> The issue is very easy to reproduce on my setup, not sure how much of it =
is actually relevant, but here it is:
>
> - 3 drive RAID5 created
> - Some data moved to it
> - Expanded to 7 drives
> - No balancing
>
> The issue is easily reproduced (within 30 mins) by starting multiple tran=
sfers to the volume (several TB in the form of many 30GB+ files). Multiple =
concurrent =E2=80=98rsync=E2=80=99 transfers seems to take a bit longer to =
trigger the issue, but multiple =E2=80=98cp=E2=80=99 commands will do it mu=
ch quicker (again not sure if relevant).
>
> I have not seen the issue occur with a single =E2=80=98rsync=E2=80=99 or =
=E2=80=98cp=E2=80=99 transfer, but I haven=E2=80=99t left one running alone=
 for too long (copying the data from multiple drives, so there is a lot to =
be gained from parallelizing the transfers).
>
> I=E2=80=99m not sure what state the FS is left in after Magic SysRq reboo=
t after it deadlocks, but seemingly it=E2=80=99s fine. No problems mounting=
 and =E2=80=98btrfs check=E2=80=99 passes OK. I=E2=80=99m sure some of the =
data doesn=E2=80=99t get flushed, but it=E2=80=99s no problem for my use ca=
se.
>
> I=E2=80=99ve been running nonstop concurrent transfers with kernel 4.20.0=
-0.rc1 for 24hr nonstop and I haven=E2=80=99t experienced the issue.
>
> Hope this helps.

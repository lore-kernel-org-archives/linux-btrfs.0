Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33650 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbGHUCo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 16:02:44 -0400
Received: by ykeo3 with SMTP id o3so97138579yke.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 13:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSyf+ADvupbAoVi3BPN-TxdYr0n=-6gykWVe-U33rUNAQ@mail.gmail.com>
References: <CAJCQCtSyf+ADvupbAoVi3BPN-TxdYr0n=-6gykWVe-U33rUNAQ@mail.gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 8 Jul 2015 16:02:04 -0400
Message-ID: <CADfjVrhammqPo68TTckaGA8p+=G=zdno_LLiSZQj=9xLq14WVg@mail.gmail.com>
Subject: Re: [BUG] BTRFS: error in btrfs_run_delayed_refs:2821: errno=-5 IO failure
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 8, 2015 at 10:01 AM, Chris Murphy <lists@colorremedies.com> wrote:
> The short version: btrfs convert and subsequent balance will eat an
> ext4 file system. I've reproduced this 6 for 6 times with both kernel
> 4.1 and 4.2rc1, but I get different back traces for the two kernels.
>
> Kernel 4.1.0
> Btrfs-progs 4.1
>
> New ext4 file system populated with several thousand files (Fedora 22
> installation) and a 1.5GB ISO.
>

Standard disclaimer: Not a developer, just a user.
The 1.5 GB ISO on a fresh ext4 system made me think of
http://thread.gmane.org/gmane.comp.file-systems.btrfs/36955
(ext4 extents over 1 GB causing ENOSPC).

Did the "btrfs filesystem balance" specify a "-t 900G" or similar?

Or has that issue been fixed?

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36822 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdIDKxU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 06:53:20 -0400
Received: by mail-qk0-f169.google.com with SMTP id z143so439027qkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 03:53:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 4 Sep 2017 12:53:18 +0200
Message-ID: <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
Subject: Re: speed up big btrfs volumes with ssds
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 3, 2017 at 8:32 PM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> Hello,
>
> i'm trying to speed up big btrfs volumes.
>
> Some facts:
> - Kernel will be 4.13-rc7
> - needed volume size is 60TB
>
> Currently without any ssds i get the best speed with:
> - 4x HW Raid 5 with 1GB controller memory of 4TB 3,5" devices
>
> and using btrfs as raid 0 for data and metadata on top of those 4 raid 5.
>
> I can live with a data loss every now and and than ;-) so a raid 0 on
> top of the 4x radi5 is acceptable for me.
>
> Currently the write speed is not as good as i would like - especially
> for random 8k-16k I/O.
>
> My current idea is to use a pcie flash card with bcache on top of each
> raid 5.

If it can speed up depends quite a lot on what the use-case is, for
some not-so-much-parallel-access it might work. So this 60TB is then
20 4TB disks or so and the 4x 1GB cache is simply not very helpful I
think. The working set doesn't fit in it I guess. If there is mostly
single or a few users of the fs, a single pcie based bcacheing 4
devices can work, but for SATA SSD, I would use 1 SSD per HWraid5.

Then roughly make sure the complete set of metadata blocks fits in the
cache. For an fs of this size let's say/estimate 150G. Then maybe same
of double for data, so an SSD of 500G would be a first try.

You give the impression that reliability for this fs is not the
highest prio, so if you go full risk, then put bcache in write-back
mode, then you will have your desired random 8k-16k I/O speedup after
the cache is warmed up. But any SW or HW failure wil result in total
fs loss normally if SSD and HDD get out of sync somehow. Bcache
write-through might also be acceptable, you will need extensive
monitoring and tuning of all (bcache) parameters etc to be sure of the
right choice of size and setup etc.

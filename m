Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f48.google.com ([209.85.167.48]:45548 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbeH2EKR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 00:10:17 -0400
Received: by mail-lf1-f48.google.com with SMTP id r4-v6so2810489lff.12
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 17:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dpfQghX+cCo=LkqZMAtFfCMKtq+XHpNGb6wH8z8eMcQA@mail.gmail.com>
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
 <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
 <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com>
 <d46b344f-6d03-5425-188d-88e823caa074@gmail.com> <CADfjVrgUEpuSg_DSUBUL+cXhokx+f_r7XDChr1Pnc1cdsj00uQ@mail.gmail.com>
 <a8189a49-856b-9989-5a3a-3867bf5128f9@gmail.com> <CAJVZm6dcsuUZEnFncOmu6C7AVOpi6K4k=8rrOO=82yEqkY5UGA@mail.gmail.com>
 <CADfjVrhAcPE4L2o=m8LmbLQJ6LbRtRsJVZ6WWhRfcUC=AOL4tA@mail.gmail.com> <CAJVZm6dpfQghX+cCo=LkqZMAtFfCMKtq+XHpNGb6wH8z8eMcQA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Aug 2018 18:16:08 -0600
Message-ID: <CAJCQCtSSEQ8oCTbcu6ciRxim_fQYxrvSOU9bQkPdiZ-OtyMa8g@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Menion <menion@gmail.com>
Cc: Noah Massey <noah.massey@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 1:14 PM, Menion <menion@gmail.com> wrote:
> You are correct, indeed in order to cleanup you need
>
> 1) someone realize that snapshots have been created
> 2) apt-brtfs-snapshot is manually installed on the system
>
> Assuming also that the snapshots created during do-release-upgrade are
> managed for auto cleanup

Ha! I should have read all the emails.

Anyway, good sleuthing. I think it's a good idea to file a bug report
on it, so at the least other people can fix it manually.


-- 
Chris Murphy

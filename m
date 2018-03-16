Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:39045 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754325AbeCPQAq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:00:46 -0400
Received: by mail-ot0-f175.google.com with SMTP id h8-v6so10842438oti.6
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Mar 2018 09:00:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com> <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 16 Mar 2018 10:00:44 -0600
Message-ID: <CAJCQCtS+PsWLmSq_UWTaBd8gikumtQaO16dX6HCz_RdGp-grJg@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also, in the meantime, maybe the problem can be prevented by
preventing the balance from resuming when mounting. First umount then
mount with -o skip_balance.


Chris Murphy

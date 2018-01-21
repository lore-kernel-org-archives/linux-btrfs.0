Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41574 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAUWFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 17:05:16 -0500
Received: by mail-oi0-f67.google.com with SMTP id m83so2232973oik.8
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 14:05:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com> <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 21 Jan 2018 15:05:15 -0700
Message-ID: <CAJCQCtQjbyFCCBt3Q3NcuGA9J5Wi9iq-gJcJAgrBd_25oJtV2g@mail.gmail.com>
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 8:27 AM, Sebastian Ochmann
<ochmann@cs.uni-bonn.de> wrote:
> On 21.01.2018 11:04, Qu Wenruo wrote:

> The output of "mount" after setting 10 seconds commit interval:
>
> /dev/sdc1 on /mnt/rec type btrfs
> (rw,relatime,space_cache,commit=10,subvolid=5,subvol=/)

I wonder if it gets stuck updating v1 space cache. Instead of trying
v2, you could try nospace_cache mount option and see if there's a
change in behavior.


---
Chris Murphy
